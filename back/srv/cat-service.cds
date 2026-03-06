@odata service CatalogService {
  entity Books { 
    key ID:Integer; title:String; author:String;
  }

  // Expose PurchaseRequests for tracking
  entity PurchaseRequests as projection on my.bookshop.PurchaseRequests;

  // BPA Workflow Action
  action triggerWorkflow(
    employeeName: String,
    department: String,
    itemName: String,
    quantity: Integer,
    amount: Decimal,
    justification: String
  ) returns String;

  // Called by BPA after approval process completion
  action updatePurchaseStatus(
    workflowInstanceId: String,
    status: String,
    employeeName: String,
    itemName: String,
    amount: Decimal
  ) returns String;
}
