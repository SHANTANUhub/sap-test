namespace my.bookshop;

entity Books {
  key ID         : Integer;
      title      : String;
      author      : String;
      
}
entity PurchaseRequests {
  key ID              : Integer;
      EmployeeName    : String;
      Department      : String;
      ItemName        : String;
      Quantity        : Integer;
      Amount          : Decimal;
      Justification   : String;
      Status          : String; // PENDING, APPROVED, REJECTED
      WorkflowInstanceId : String;
}