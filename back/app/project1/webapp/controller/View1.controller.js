sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/model/json/JSONModel",
    "sap/m/MessageToast"
], (Controller, JSONModel, MessageToast) => {
    "use strict";

    return Controller.extend("project1.controller.View1", {
        onInit() {
            // Sample Orders data
            var oOrdersData = {
                Orders: [
                    { OrderNo: "OD-1001", Amount: 1500, Currency: "USD" },
                    { OrderNo: "OD-1002", Amount: 2300, Currency: "EUR" },
                    { OrderNo: "OD-1003", Amount: 890, Currency: "USD" }
                ]
            };
            var oOrdersModel = new JSONModel(oOrdersData);
            this.getView().setModel(oOrdersModel);

            // Sample Employees data
            var oEmployeesData = {
                Employees: [
                    { Name: "John Doe", Role: "Developer", Email: "john.doe@company.com" },
                    { Name: "Jane Smith", Role: "Manager", Email: "jane.smith@company.com" },
                    { Name: "Bob Johnson", Role: "Analyst", Email: "bob.johnson@company.com" }
                ]
            };
            var oEmployeesModel = new JSONModel(oEmployeesData);
            this.getView().setModel(oEmployeesModel, "EMPLOYEES");
        },

        onTriggerWorkflow: function () {
            var oView = this.getView();
            var oResultStrip = oView.byId("workflowResultStrip");

            // Get form values directly from controls
            var sEmployeeName = oView.byId("employeeNameInput").getValue();
            var sDepartment = oView.byId("departmentSelect").getSelectedKey();
            var sItemName = oView.byId("itemNameInput").getValue();
            var sQuantity = oView.byId("quantityInput").getValue();
            var sAmount = oView.byId("amountInput").getValue();
            var sJustification = oView.byId("justificationInput").getValue();

            // Validation
            if (!sEmployeeName || !sDepartment || !sItemName) {
                MessageToast.show("Please fill in Employee Name, Department, and Item Name");
                return;
            }

            // Show loading message
            oResultStrip.setType("Information");
            oResultStrip.setText("Triggering workflow...");
            oResultStrip.setVisible(true);

            // Prepare payload
            var oPayload = {
                employeeName: sEmployeeName,
                department: sDepartment,
                itemName: sItemName,
                quantity: parseInt(sQuantity) || 0,
                amount: parseFloat(sAmount) || 0,
                justification: sJustification || ""
            };

            // Make direct HTTP call to the action
            jQuery.ajax({
                url: "/odata/v4/catalog/triggerWorkflow",
                type: "POST",
                data: JSON.stringify(oPayload),
                contentType: "application/json",
                success: function (oData) {
                    // Show success message
                    oResultStrip.setType("Success");
                    var sWorkflowId = oData.value || oData.workflowInstanceId || oData;
                    if (typeof sWorkflowId === 'object') {
                        sWorkflowId = sWorkflowId.workflowInstanceId || JSON.stringify(sWorkflowId);
                    }
                    oResultStrip.setText("Workflow Instance ID: " + sWorkflowId);
                    MessageToast.show("Workflow Initiated!");
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    // Show error message
                    var sError = "Error triggering workflow";
                    try {
                        var oError = JSON.parse(jqXHR.responseText);
                        sError = oError.error?.message || sError;
                    } catch (e) {
                        sError = errorThrown || textStatus || sError;
                    }
                    
                    oResultStrip.setType("Error");
                    oResultStrip.setText("Error: " + sError);
                    MessageToast.show("Error triggering BPA");
                    console.error("BPA Workflow Error:", jqXHR.responseText);
                }
            });
        },

        onClearForm: function () {
            var oView = this.getView();
            
            // Clear all input fields
            oView.byId("employeeNameInput").setValue("");
            oView.byId("departmentSelect").setSelectedKey("");
            oView.byId("itemNameInput").setValue("");
            oView.byId("quantityInput").setValue("");
            oView.byId("amountInput").setValue("");
            oView.byId("justificationInput").setValue("");

            // Hide result strip
            var oResultStrip = oView.byId("workflowResultStrip");
            oResultStrip.setVisible(false);
        },

        _clearBPAForm: function() {
            this.onClearForm();
        }
    });
});