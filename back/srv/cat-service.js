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

      const oPayload = {
        definitionId: 'us10.a3edfe08trial.processlevel.purchase', // Update with your BPA definition ID
        context: {
          employeeName: employeeName || '',
          department: department || '',
          itemName: itemName || '',
          quantity: parseInt(quantity) || 0,
          amount: parseFloat(amount) || 0,
          justification: justification || ''
        }
      };

      console.log('Workflow Payload:', JSON.stringify(oPayload, null, 2));

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

          console.log('Workflow triggered successfully:', JSON.stringify(response.data, null, 2));
          return response.data.id; // workflow instance id
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
        
        return mockInstanceId;
      }
    });

    return super.init();
  }
};