using LeaveService as service from '../../srv/leave-service';

annotate service.LeaveRequests with @(
    UI.LineItem: [
        {
            $Type: 'UI.DataField',
            Label: 'Employee',
            Value: employee.name
        },
        {
            $Type: 'UI.DataField',
            Label: 'Leave Type',
            Value: leaveType
        },
        {
            $Type: 'UI.DataField',
            Label: 'Start Date',
            Value: startDate
        },
        {
            $Type: 'UI.DataField',
            Label: 'End Date',
            Value: endDate
        },
        {
            $Type: 'UI.DataField',
            Label: 'Status',
            Value: status
        }
    ],

    UI.SelectionFields: [
        leaveType,
        status
    ],

    UI.HeaderInfo: {
        TypeName: 'Leave Request',
        TypeNamePlural: 'Leave Requests',
        Title: {
            $Type: 'UI.DataField',
            Value: employee.name
        },
        Description: {
            $Type: 'UI.DataField',
            Value: leaveType
        },
        ImageUrl : employee.email,
        Initials : status,
        TypeImageUrl : 'sap-icon://customer',
    },

    UI.Facets: [
        {
            $Type: 'UI.ReferenceFacet',
            Label: 'Leave Details',
            Target: '@UI.FieldGroup#LeaveDetails'
        },
    ],
    UI.FieldGroup #leaveform : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : employee.department_ID,
                Label : 'department_ID',
            },
            {
                $Type : 'UI.DataField',
                Value : employee.email,
                Label : 'email',
            },
            {
                $Type : 'UI.DataField',
                Value : employee.name,
                Label : 'name',
            },
            {
                $Type : 'UI.DataField',
                Value : employee.department.departmentName,
                Label : 'departmentName',
            },
            {
                $Type : 'UI.DataField',
                Value : manager.email,
                Label : 'email',
            },
            {
                $Type : 'UI.DataField',
                Value : manager.name,
                Label : 'name',
            },
        ],
    },
);

annotate service.LeaveRequests with @(
    UI.FieldGroup #LeaveDetails: {
        Data: [
            {
                $Type: 'UI.DataField',
                Label: 'Employee',
                Value: employee_ID
            },
            {
                $Type: 'UI.DataField',
                Label: 'Leave Type',
                Value: leaveType
            },
            {
                $Type: 'UI.DataField',
                Label: 'Start Date',
                Value: startDate
            },
            {
                $Type: 'UI.DataField',
                Label: 'End Date',
                Value: endDate
            },
            {
                $Type: 'UI.DataField',
                Label: 'Reason',
                Value: reason
            },
            {
                $Type: 'UI.DataField',
                Label: 'Status',
                Value: status
            }
        ]
    }
);

annotate service.Employees with @(
    UI.LineItem: [
        {
            $Type: 'UI.DataField',
            Label: 'Employee ID',
            Value: ID
        },
        {
            $Type: 'UI.DataField',
            Label: 'Name',
            Value: name
        },
        {
            $Type: 'UI.DataField',
            Label: 'Department',
            Value: department
        },
        {
            $Type: 'UI.DataField',
            Label: 'Email',
            Value: email
        }
    ]
);
annotate service.LeaveRequests with {
    leaveType @(
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'LeaveRequests',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : leaveType,
                    ValueListProperty : 'leaveType',
                },
            ],
            Label : 'leave type',
        },
        Common.ValueListWithFixedValues : true,
)};

annotate service.LeaveRequests with {
    status @(
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'LeaveRequests',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : status,
                    ValueListProperty : 'leaveType',
                },
            ],
            Label : 'status',
        },
        Common.ValueListWithFixedValues : true,
        )};

