namespace debashish.cds;
using { debashish.db.master, debashish.db.transaction } from './datamodel';

context CDSView{
    define view ![POWorklist] as
     select from transaction.purchaseorder {
        key PO_ID              as ![PurchaseOrderId],
        key ITEMS.PO_ITEM_POS  as ![ItemPosition],
            PARTNER_GUID.BP_ID as ![SupplierId],
            PARTNER_GUID.COMPANY_NAME    as ![CompanyName],
            ITEMS.GROSS_AMOUNT as ![GrossAmount],
            ITEMS.NET_AMOUNT   as ![NetAmount],
            ITEMS.TAX_AMOUNT   as ![TaxAmount],
            ITEMS.CURRENCY     as ![CurrecyCode],
            OVERALL            as ![Status],
            ITEMS.PRODUCT_GUID.CATEGORY       as ![ProductCategory],
            ITEMS.PRODUCT_GUID.DESCRIPTION    as ![ProductName],
            PARTNER_GUID.ADDRESS_GUID.COUNTRY as ![Country],
     }

     define view ![ItemView] as
         select from transaction.poitems{
            key PARENT_KEY.PARTNER_GUID.NODE_KEY as ![SupplierId],
            key PRODUCT_GUID.NODE_KEY            as ![ProductKey],
                CURRENCY     as ![CurrencyCode],
                GROSS_AMOUNT as ![GrossAmount],
                NET_AMOUNT   as ![NetAmount],
                TAX_AMOUNT   as ![TaxAmount],
                PARENT_KEY.OVERALL as ![Status]
         }
  
    //view on view + lazy loading - mixin

   define view ![ProductView] as select from master.product
    // mixin is keyword in capm to perform lazy loading, on-demand join
    // it will always load data from product table initially
    // when user drills down, that is when it will perform a join to fetch items data
    mixin{
        PO_ORDER : Association to many ItemView on PO_ORDER.ProductKey = $projection.ProductId
    } into
    {
        key NODE_KEY as ![ProductId],
            DESCRIPTION as ![Description],
            CATEGORY as ![Category],
            PRICE as ![Price],
            SUPPLIER_GUID.COMPANY_NAME as ![Vendor],
            SUPPLIER_GUID.ADDRESS_GUID.COUNTRY as ![Country],
            //exposed association = @runtime the data will be loaded
            PO_ORDER as ![To_Items]
    }

    define view CProductView as
       select from ProductView{
        key ProductId,
        key Country,
        round(sum(To_Items.GrossAmount),2) as ![TotalAmount],
        To_Items.CurrencyCode
       } group by ProductId,Country,To_Items.CurrencyCode
}

define view partner as 
  select from  master.businesspartner 
  mixin{ 
         PUR_ORDERS : Association to one transaction.purchaseorder on
         PUR_ORDERS.PARTNER_GUID = $self } into
  {
   // key BP_ID    as ![PartnerId],
     key   NODE_KEY as ![PartnerGuid],
        COMPANY_NAME as ![Company],
        PHONE_NUMBER as ![Phone],
        EMAIL_ADDRESS as ![Email],
        PUR_ORDERS as ![toPurOrd]


}

