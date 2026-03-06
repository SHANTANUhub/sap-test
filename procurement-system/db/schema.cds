namespace db;

entity Departments {
    key ID : Integer;
    name : String;
}

entity Employees {
    key ID : Integer;
    name       : String;
    email      : String;
    department : Association to Departments;
}

entity Suppliers {
    key ID : Integer;
    name    : String;
    city    : String;
    country : String;
    rating  : Integer;
}

entity Products {
    key ID : Integer;
    name     : String;
    category : String;
    price    : Decimal(10,2);
    stock    : Integer;
    supplier : Association to Suppliers;
}

entity ProcurementRequests {
    key ID : Integer;
    employee     : Association to Employees;
    department   : Association to Departments;
    status       : String;
    priority     : String;
    totalAmount  : Decimal(10,2);
}

entity RequestItems {
    key ID : Integer;
    request  : Association to ProcurementRequests;
    product  : Association to Products;
    quantity : Integer;
    price    : Decimal(10,2);
}

entity Comments {
    key ID : Integer;  
    request : Association to ProcurementRequests;
    text    : String;
}