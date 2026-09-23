using { debashish.db.master, debashish.db.transaction } from '../db/datamodel';

service CatalogService @(path: 'CatalogService'){
   // @readonly
    //@Capabilities.Deletable: false    
 
    entity EmployeeSet as  projection on master.employees;
    entity ProductSet as projection  on master.product;
    entity AddressSet as projection on master.address;
    entity BusinessPartnerSet as projection on master.businesspartner;
    entity StatusCodeSet as projection on master.StatusCode;
    entity PurchaseOrderSet  @(odata.draft.enabled: true,
                         Common.DefaultValuesFunction: 'getDefaultOrderData' ) 
    as projection on transaction.purchaseorder{
        *,
        case when OVERALL.STATUS = 'A' then cast(3 as Integer)
             when OVERALL.STATUS = 'D' then cast(3 as Integer)
             when OVERALL.STATUS = 'X' then cast(1 as Integer)
             when OVERALL.STATUS = 'P' then cast(2 as Integer)
             when OVERALL.STATUS = 'N' then cast(2 as Integer)
             else cast(0 as Integer)
        end as Superman: Integer

    }
    // instance bound action.. the primary key must be passed
    // we will receive the primary key automatically
    actions { 
         // the annotation side effect wiil inform framework there is change in backend data for
         // gross_amount
         @Common: { SideEffects : {
             $Type : 'Common.SideEffectsType',
             TargetProperties: ['in/GROSS_AMOUNT']
             
         },}
    action boost() returns PurchaseOrderSet };
    entity PurchaseOrderItemsSet as projection on transaction.poitems;

   function getDefaultOrderData() returns PurchaseOrderSet;

    //non instance bound function - get top 3 most expensive POs
    function getMostExpOrders(zkas:Integer) returns many PurchaseOrderSet;

}

