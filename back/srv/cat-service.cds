@odata service CatalogService {
  entity Books { 
    key ID:Integer; title:String; author:String;
  }

  // BPA Workflow Action
  action triggerWorkflow(
    employeeName: String,
    department: String,
    itemName: String,
    quantity: Integer,
    amount: Decimal,
    justification: String
  ) returns String;
}
