using CatalogService as service from '../../srv/catalog-service';

annotate service.Products with @(
    UI.DeleteHidden                    : true,
    UI.UpdateHidden                    : false,
    UI.FieldGroup #GeneratedGroup      : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type            : 'UI.DataField',
                Label            : '{i18n>ProductName}',
                Value            : name,
                ![@UI.Importance]: #High,
            },
            {
                $Type            : 'UI.DataField',
                Label            : '{i18n>Category}',
                Value            : category,
                ![@UI.Importance]: #High,
            },
            {
                $Type            : 'UI.DataField',
                Label            : '{i18n>Price}',
                Value            : price,
                ![@UI.Importance]: #High,
            },
            {
                $Type            : 'UI.DataField',
                Label            : '{i18n>Stock}',
                Value            : stock,
                ![@UI.Importance]: #High,
            },
            {
                $Type            : 'UI.DataField',
                Label            : '{i18n>Supplier}',
                Value            : supplier_ID,
                ![@UI.Importance]: #High,
            },
        ],
    },
    UI.FieldGroup #BasicInfo           : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: '{i18n>ProductName}',
                Value: name,
            },
            {
                $Type: 'UI.DataField',
                Label: '{i18n>Category}',
                Value: category,
            },
            {
                $Type: 'UI.DataField',
                Label: '{i18n>Price}',
                Value: price,
            },
        ],
    },
    UI.FieldGroup #SupplierInfo        : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: '{i18n>Supplier}',
                Value: supplier_ID,
            },
            {
                $Type: 'UI.DataField',
                Label: '{i18n>Stock}',
                Value: stock,
            },
        ],
    },
    UI.DataPoint #stockLevel           : {
        $Type        : 'UI.DataPointType',
        Value        : stock,
        Title        : '{i18n>StockLevel}',
        Criticality  : stockCriticality,
    },
    UI.DataPoint #pricePoint           : {
        $Type      : 'UI.DataPointType',
        Value      : price,
        Title      : '{i18n>Price}',
        Criticality: 3,
    },
    UI.Chart #stockChart               : {
        $Type            : 'UI.ChartDefinitionType',
        Title            : '{i18n>StockLevel}',
        Description      : '{i18n>StockChart}',
        ChartType        : #Bullet,
        Measures         : [stock],
        MeasureAttributes: [{
            $Type    : 'UI.ChartMeasureAttributeType',
            Measure  : stock,
            Role     : #Axis1,
            DataPoint: '@UI.DataPoint#stockLevel',
        }]
    },
    UI.HeaderFacets                    : [{
        $Type : 'UI.ReferenceFacet',
        ID    : 'HeaderFacetIdentifier1',
        Target: '@UI.FieldGroup#HeaderGeneralInfo',
    }],
    UI.FieldGroup #HeaderGeneralInfo   : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: name,
                Label: '{i18n>ProductName}',
            },
            {
                $Type: 'UI.DataField',
                Value: stock,
                Label: '{i18n>Stock}',
            },
        ],
    },
    UI.Facets                          : [
        {
            $Type : 'UI.CollectionFacet',
            ID    : 'GeneralInformationFacet',
            Label : '{i18n>GeneralInformation}',
            Facets: [
                {
                    $Type : 'UI.ReferenceFacet',
                    ID    : 'BasicInfoFacet',
                    Label : '{i18n>BasicInformation}',
                    Target: '@UI.FieldGroup#BasicInfo',
                },
                {
                    $Type               : 'UI.ReferenceFacet',
                    ID                  : 'SupplierInfoFacet',
                    Label               : '{i18n>SupplierInformation}',
                    Target              : '@UI.FieldGroup#SupplierInfo',
                    ![@UI.PartOfPreview]: false,
                },
            ],
        },
    ],
    UI.LineItem                        : [
        {
            $Type: 'UI.DataField',
            Label: '{i18n>ProductId}',
            Value: ID,
        },
        {
            $Type: 'UI.DataField',
            Label: '{i18n>ProductName}',
            Value: name,
        },
        {
            $Type: 'UI.DataField',
            Value: stock,
            Label: '{i18n>Stock}',
        },
        {
            $Type : 'UI.DataFieldForAnnotation',
            Target: '@UI.Chart#stockChart',
            Label : '{i18n>StockChart}',
        },
        {
            $Type: 'UI.DataField',
            Value: category,
            Label: '{i18n>Category}',
        },
        {
            $Type: 'UI.DataField',
            Value: price,
            Label: '{i18n>Price}',
        },
        {
            $Type: 'UI.DataField',
            Value: supplier.name,
            Label: '{i18n>Supplier}',
        },
    ],
    UI.SelectionFields                 : [category, supplier_ID],
    UI.HeaderInfo                      : {
        Title         : {
            $Type: 'UI.DataField',
            Value: name,
        },
        TypeName      : '{i18n>Product}',
        TypeNamePlural: '{i18n>Products}',
        Description   : {
            $Type: 'UI.DataField',
            Value: category,
        },
    },
    UI.Identification                  : [
        {
            $Type            : 'UI.DataField',
            Label            : '{i18n>ProductName}',
            Value            : name,
            ![@UI.Importance]: #High,
        },
        {
            $Type               : 'UI.DataField',
            Label               : '{i18n>Price}',
            Value               : price,
            ![@UI.PartOfPreview]: false,
        },
        {
            $Type               : 'UI.DataField',
            Label               : '{i18n>Category}',
            Value               : category,
            ![@UI.PartOfPreview]: false,
        },
    ],
);

annotate service.Products with {
    supplier @(
        Common.Label                   : '{i18n>Supplier}',
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Suppliers',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: supplier_ID,
                    ValueListProperty: 'ID',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name',
                },
            ],
        },
        Common.ValueListWithFixedValues: true,
        Common.Text                    : supplier.name,
        Common.Text.@UI.TextArrangement: #TextOnly,
    )
};

// Multi-Mode Extensibility: Presentation Variants for different views
annotate service.Products with @(
    UI.PresentationVariant #AllProducts        : {Visualizations: ['@UI.LineItem']},
    UI.PresentationVariant #HighStockProducts  : {Visualizations: ['@UI.LineItem']},
    UI.PresentationVariant #MediumStockProducts: {Visualizations: ['@UI.LineItem']},
    UI.PresentationVariant #LowStockProducts   : {Visualizations: ['@UI.LineItem']}
);

annotate service.Products with @(
    UI.SelectionPresentationVariant #AllProducts        : {
        $Type              : 'UI.SelectionPresentationVariantType',
        Text               : '{i18n>AllProducts}',
        SelectionVariant   : {
            $Type        : 'UI.SelectionVariantType',
            SelectOptions: []
        },
        PresentationVariant: ![@UI.PresentationVariant#AllProducts]
    },
    UI.SelectionPresentationVariant #HighStockProducts  : {
        $Type              : 'UI.SelectionPresentationVariantType',
        Text               : '{i18n>HighStockProducts}',
        SelectionVariant   : {
            $Type        : 'UI.SelectionVariantType',
            SelectOptions: [{
                PropertyName: stock,
                Ranges      : [{
                    Sign  : #I,
                    Option: #GE,
                    Low   : '50'
                }]
            }]
        },
        PresentationVariant: ![@UI.PresentationVariant#HighStockProducts]
    },
    UI.SelectionPresentationVariant #MediumStockProducts: {
        $Type              : 'UI.SelectionPresentationVariantType',
        Text               : '{i18n>MediumStockProducts}',
        SelectionVariant   : {
            $Type        : 'UI.SelectionVariantType',
            SelectOptions: [{
                PropertyName: stock,
                Ranges      : [{
                    Sign  : #I,
                    Option: #BT,
                    Low   : '20',
                    High  : '49'
                }]
            }]
        },
        PresentationVariant: ![@UI.PresentationVariant#MediumStockProducts]
    },
    UI.SelectionPresentationVariant #LowStockProducts   : {
        $Type              : 'UI.SelectionPresentationVariantType',
        Text               : '{i18n>LowStockProducts}',
        SelectionVariant   : {
            $Type        : 'UI.SelectionVariantType',
            SelectOptions: [{
                PropertyName: stock,
                Ranges      : [{
                    Sign  : #I,
                    Option: #LT,
                    Low   : '20'
                }]
            }]
        },
        PresentationVariant: ![@UI.PresentationVariant#LowStockProducts]
    }
);

// Regular SelectionVariants for quick variant selection
annotate service.Products with @(UI.SelectionVariant #AllProducts: {
    $Type        : 'UI.SelectionVariantType',
    Text         : '{i18n>AllProducts}',
    SelectOptions: []
});

// Suppliers annotations
annotate service.Suppliers with @(
    UI.LineItem                   : [
        {
            $Type: 'UI.DataField',
            Value: name,
            Label: '{i18n>CompanyName}',
        },
        {
            $Type: 'UI.DataField',
            Value: city,
            Label: '{i18n>City}',
        },
        {
            $Type: 'UI.DataField',
            Value: country,
            Label: '{i18n>Country}',
        },
        {
            $Type: 'UI.DataField',
            Value: rating,
            Label: '{i18n>Rating}',
        },
    ],
    UI.FieldGroup #SupplierDetails: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: name,
                Label: '{i18n>CompanyName}',
            },
            {
                $Type: 'UI.DataField',
                Value: city,
                Label: '{i18n>City}',
            },
            {
                $Type: 'UI.DataField',
                Value: country,
                Label: '{i18n>Country}',
            },
            {
                $Type: 'UI.DataField',
                Value: rating,
                Label: '{i18n>Rating}',
            },
        ],
    },
    UI.Facets                     : [{
        $Type : 'UI.ReferenceFacet',
        Label : '{i18n>SupplierDetails}',
        Target: '@UI.FieldGroup#SupplierDetails',
    }],
);

// Add dropdown value helps for Country and City  
annotate service.Suppliers with {
    country @(
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Suppliers',
            Parameters    : [{
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: country,
                ValueListProperty: 'country',
            }],
        },
        Common.ValueListWithFixedValues: false,
    );
    city    @(
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Suppliers',
            Parameters    : [{
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: city,
                ValueListProperty: 'city',
            }],
        },
        Common.ValueListWithFixedValues: false,
    );
};