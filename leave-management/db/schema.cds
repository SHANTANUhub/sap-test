namespace leave;

using { cuid, managed } from '@sap/cds/common';

entity Departments : cuid, managed {
    departmentName : String(100);
}

entity Employees : cuid, managed {
    name        : String(100);
    email       : String(100);
    department  : Association to Departments;
    manager     : Association to Employees;
}

entity LeaveRequests : cuid, managed {
    employee    : Association to Employees;
    leaveType   : String(50);
    startDate   : Date;
    endDate     : Date;
    reason      : String(500);
    status      : String(20);
    manager     : Association to Employees;
}