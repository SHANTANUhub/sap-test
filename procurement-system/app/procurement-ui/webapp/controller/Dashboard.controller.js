sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/model/json/JSONModel",
    "sap/m/MessageToast"
], function (Controller, JSONModel, MessageToast) {
    "use strict";

    return Controller.extend("procurementui.controller.Dashboard", {

        onInit: function () {
            this.loadKPI();
            this.loadCharts();
        },

        onAfterRendering: function () {
    // Delay invalidation until after browser has painted and
    // Grid cells have their real pixel widths assigned
    setTimeout(function () {
        var aChartIds = ["deptChart", "spendChart", "vendorChart"];
        aChartIds.forEach(function (sId) {
            var oChart = this.byId(sId);
            if (oChart) {
                oChart.invalidate();
            }
        }.bind(this));
    }.bind(this), 300);
},

        loadKPI: function () {
            var kpiData = {
                total: 128,
                approved: 85,
                pending: 30,
                rejected: 13
            };
            this.getView().setModel(new JSONModel(kpiData), "kpi");
        },

        loadCharts: function () {
            var chartData = {
                departmentData: [
                    { department: "IT", count: 45 },
                    { department: "Finance", count: 32 },
                    { department: "HR", count: 34 },
                    { department: "Operations", count: 29 }
                ],
                monthlySpend: [
                    { month: "Jan", amount: 15000 },
                    { month: "Feb", amount: 20000 },
                    { month: "Mar", amount: 17000 },
                    { month: "Apr", amount: 19000 },
                    { month: "May", amount: 25000 },
                    { month: "Jun", amount: 21000 }
                ],
                vendorSpend: [
                    { vendor: "Tech Depot", amount: 25000 },
                    { vendor: "Global Duo", amount: 20000 },
                    { vendor: "XYZ Supplies", amount: 20000 },
                    { vendor: "Others", amount: 35000 }
                ]
            };
            this.getView().setModel(new JSONModel(chartData), "chart");
        },

        // ── Navigation Handlers ──────────────────────────────────────────────

        onNavToProcurement: function () {
            this.getOwnerComponent().getRouter().navTo("procurement");
        },

        onNavToVendors: function () {
            this.getOwnerComponent().getRouter().navTo("vendors");
        },

        onNavToCatalog: async function () {
            // Check if running inside Fiori Launchpad
            if (!sap.ushell || !sap.ushell.Container) {
                console.log("Not running inside FLP, using fallback navigation");
                MessageToast.show("Opening Product Catalog in new window...");
                var sProductListUrl = "../product-list/webapp/index.html";
                window.open(sProductListUrl, "_blank");
                return;
            }

            try {
                // Cross-app navigation to product-list application
                var oCrossAppNavigator = await sap.ushell.Container.getServiceAsync("CrossApplicationNavigation");
                
                var hash = oCrossAppNavigator.hrefForExternal({
                    target: {
                        semanticObject: "ProductCatalog",
                        action: "display"
                    }
                }) || "";
                
                if (hash) {
                    oCrossAppNavigator.toExternal({
                        target: {
                            semanticObject: "ProductCatalog",
                            action: "display"
                        }
                    });
                } else {
                    // Fallback if hash generation fails
                    MessageToast.show("Opening Product Catalog in new window...");
                    var sProductListUrl = "../product-list/webapp/index.html";
                    window.open(sProductListUrl, "_blank");
                }
            } catch (error) {
                console.error("Cross-app navigation failed:", error);
                MessageToast.show("Opening Product Catalog in new window...");
                var sProductListUrl = "../product-list/webapp/index.html";
                window.open(sProductListUrl, "_blank");
            }
        },

        onNavToReports: function () {
            this.getOwnerComponent().getRouter().navTo("reports");
        },

        // ── Chart Click Handlers ─────────────────────────────────────────────

        onDeptChartClick: function (oEvent) {
            var oData = oEvent.getParameter("data");
            if (oData && oData.data && oData.data[0]) {
                var sDept = oData.data[0].data.Department;
                sap.m.MessageToast.show("Department selected: " + sDept);
            }
        },

        onVendorChartClick: function (oEvent) {
            var oData = oEvent.getParameter("data");
            if (oData && oData.data && oData.data[0]) {
                var sVendor = oData.data[0].data.Vendor;
                sap.m.MessageToast.show("Vendor selected: " + sVendor);
            }
        },

        // ── KPI Tile Press Handlers ──────────────────────────────────────────

        onTotalTilePress: function () {
            this.getOwnerComponent().getRouter().navTo("procurement");
        },

        onApprovedTilePress: function () {
            this.getOwnerComponent().getRouter().navTo("procurement", {
                query: { status: "approved" }
            });
        },

        onPendingTilePress: function () {
            this.getOwnerComponent().getRouter().navTo("procurement", {
                query: { status: "pending" }
            });
        },

        onRejectedTilePress: function () {
            this.getOwnerComponent().getRouter().navTo("procurement", {
                query: { status: "rejected" }
            });
        },

        // ── Refresh ──────────────────────────────────────────────────────────

        onRefresh: function () {
            this.loadKPI();
            this.loadCharts();
            sap.m.MessageToast.show("Dashboard refreshed");
        }

    });
}); 