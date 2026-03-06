const cds = require('@sap/cds');

module.exports = class CatalogService extends cds.ApplicationService {
  async init() {

    const { Books } = cds.entities('CatalogService');

    this.before(['CREATE', 'UPDATE'], Books, async (req) => {
      console.log('Before CREATE/UPDATE Books', req.data);
    });

    this.after('READ', Books, async (books, req) => {
      console.log('After READ Books', books);
    });

    // =======================
    // TRIGGER BPA WORKFLOW
    // =======================
    this.on('triggerWorkflow', async (req) => {
      const { 
        employeeName, 
        department, 
        itemName, 
        quantity, 
        amount, 
        justification 
      } = req.data;

      if (!employeeName || !department || !itemName) {
        return req.error(400, 'Employee Name, Department, and Item Name are required');
      }

      // Generate unique purchase request ID
      const purchaseRequestId = Date.now();

      // Save purchase request to DB with PENDING status before triggering BPA
      const { PurchaseRequests } = cds.entities('CatalogService');
      const db = await cds.connect.to('db');
      
      await db.run(
        UPSERT.into(PurchaseRequests).entries({
          ID: purchaseRequestId,
          EmployeeName: employeeName || '',
          Department: department || '',
          ItemName: itemName || '',
          Quantity: parseInt(quantity) || 0,
          Amount: parseFloat(amount) || 0,
          Justification: justification || '',
          Status: 'PENDING'
        })
      );
      console.log(`Purchase Request ${purchaseRequestId} saved to DB with status PENDING`);

      const oPayload = {
        definitionId: 'us10.a3edfe08trial.purchaserequestapprovalprocess.purchaseRequest', // Update with your BPA definition ID
        context: {
          purchaseRequestId: purchaseRequestId,
          employeeName: employeeName || '',
          department: department || '',
          itemName: itemName || '',
          quantity: parseInt(quantity) || 0,
          amount: parseFloat(amount) || 0,
          justification: justification || '',
          status: 'Initiated'
        }
      };

      console.log('Triggering BPA Workflow with payload:', JSON.stringify(oPayload, null, 2));

      // Check if running in production (BTP) or local development
      const isProduction = process.env.VCAP_APPLICATION ? true : false;

      if (isProduction) {
        // Production (BTP): Call actual BPA workflow API
        try {
          // Only load the SDK when actually needed in production
          const { executeHttpRequest } = require('@sap-cloud-sdk/http-client');
          
          const response = await executeHttpRequest(
            { destinationName: 'spa_process_destination' }, // Update with your destination name
            {
              method: 'POST',
              url: '/',
              data: oPayload,
              headers: { 'Content-Type': 'application/json' },
              fetchCsrfToken: false
            }
          );

          console.log('Workflow triggered successfully. Instance ID:', response.data?.id);
          
          // Update purchase request with workflow instance ID
          await db.run(
            UPDATE(PurchaseRequests)
              .set({ WorkflowInstanceId: response.data?.id })
              .where({ ID: purchaseRequestId })
          );
          
          return response.data?.id; // workflow instance id
        } catch (error) {
          console.error('Error triggering workflow:', error.response?.data || error.message);
          return req.error(500, `Failed to trigger workflow: ${error.message}`);
        }
      } else {
        // Local Development: Return mock workflow instance ID
        const mockInstanceId = `WF-PURCHASE-${Date.now()}-${Math.floor(Math.random() * 1000)}`;
        console.log('🔶 LOCAL MODE: Returning mock workflow instance:', mockInstanceId);
        console.log('🔶 Deploy to BTP to trigger actual BPA workflow');
        console.log('🔶 Purchase Request Data:', JSON.stringify(oPayload, null, 2));
        
        // Update purchase request with mock workflow instance ID
        await db.run(
          UPDATE(PurchaseRequests)
            .set({ WorkflowInstanceId: mockInstanceId })
            .where({ ID: purchaseRequestId })
        );
        
        return mockInstanceId;
      }
    });

    // =======================
    // UPDATE PURCHASE STATUS
    // Called by BPA after Manager/Finance approval
    // POST /odata/v4/catalog/updatePurchaseStatus
    // Body: { "workflowInstanceId": "string", "status": "APPROVED" }
    // =======================
    this.on('updatePurchaseStatus', async (req) => {
      console.log('req.data    :', JSON.stringify(req.data));
      console.log('req.params  :', JSON.stringify(req.params));
      
      const { workflowInstanceId, status } = req.data;
      
      if (!workflowInstanceId || !status) {
        console.warn('No workflowInstanceId or status found in the request');
        return 'No workflowInstanceId or status received';
      }
      
      console.log(`Updating Purchase Request with Workflow ID ${workflowInstanceId} → status: ${status}`);
      
      const { PurchaseRequests } = cds.entities('CatalogService');
      const db = await cds.connect.to('db');
      
      const updated = await db.run(
        UPDATE(PurchaseRequests)
          .set({ Status: status.toUpperCase() })
          .where({ WorkflowInstanceId: workflowInstanceId })
      );
      
      if (!updated) {
        return req.error(404, `Purchase Request with Workflow ID ${workflowInstanceId} not found`);
      }
      
      console.log(`Purchase Request with Workflow ID ${workflowInstanceId} status updated to ${status}`);
      return `Purchase Request with Workflow ID ${workflowInstanceId} status updated to ${status}`;
    });

    return super.init();
  }
};