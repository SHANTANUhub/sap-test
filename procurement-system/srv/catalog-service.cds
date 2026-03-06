using { db } from '../db/schema';

service CatalogService {

    entity Departments as projection on db.Departments;
    entity Employees as projection on db.Employees;
    entity Suppliers as projection on db.Suppliers;
    entity Products as projection on db.Products;
    entity ProcurementRequests as projection on db.ProcurementRequests;
    entity RequestItems as projection on db.RequestItems;
    entity Comments as projection on db.Comments;

}