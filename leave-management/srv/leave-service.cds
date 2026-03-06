using { leave as db } from '../db/schema';

service LeaveService {

    entity Employees      as projection on db.Employees;
    entity Departments    as projection on db.Departments;
    entity LeaveRequests  as projection on db.LeaveRequests;

}