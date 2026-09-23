
using { debashish.common } from './common';
using { cuid,Currency} from '@sap/cds/common';

//unique name for project
namespace debashish.db;

// //my own data type .. domain in abap
// type guid:String(32);

//grouping of data
context master {
     //debashish_db_master_businesspartner
    entity businesspartner {
        key NODE_KEY     : common.guid @title:'{i18n>PARTNER_KEY}';
            BP_ROLE      : String(2);
            EMAIL_ADDRESS: String(125);
            PHONE_NUMBER : String(32);
            FAX_NUMBER   : String(32);
            WEB_ADDRESS  : String(44);
            COMPANY_NAME : String(250) @title:'{i18n>COMPANY_NAME}';
            BP_ID        : String(32);
            //foreign key relationship
            ADDRESS_GUID : Association to one address;   
    }

    entity address {
        key NODE_KEY     : common.guid;
            CITY         : String(44) @title: '{i18n>CITY}' ;
            POSTAL_CODE  : String(8);
            STREET       : String(44);
            BUILDING     : String(128);
            COUNTRY      : String(44) @title: '{i18n>COUNTRY}' ;
            ADDRESS_TYPE : String(44);
            VAL_START_DATE : Date;
            VAL_END_DATE : Date;
            LATITUDE     : Decimal;
            LONGITUDE    : Decimal;
      //backward relationship to business partner - not mandatory
           businesspartner: Association to one businesspartner on
                      businesspartner.ADDRESS_GUID = $self;
     // $self is a predicate provided by capm to refer current table primary key
    }    

    entity employees : cuid {
      //  key NODE_KEY      : common.guid;
            NAME_FIRST    : common.name;
            NAME_MIDDLE   : common.name;
            NAME_LAST     : common.name;
            NAME_INITIALS : common.initials;
            SEX           : common.gender;
            LANGUAGE      : String(1);
            PHONE_NUMBER  : common.phone;
            EMAIL         : common.email;
            LOGINNAME     : String(12);
            CURRENCY      : Currency;
            SALARYAMOUNT  : common.amount;
            ACCOUNTNUMBER : String(40);
            BANKID        : String(40);
            BANKNAME      : String(64);
            COUNTRY       : String(3); 
    }    


    entity product  {
        key NODE_KEY      : common.guid;
            PRODUCT_ID    : String(28);
            TYPE_CODE     : String(2);
            CATEGORY      : String(32);
// localized - capm will automatically create a text table with this field
            DESCRIPTION   : localized String(255);
            SUPPLIER_GUID : Association to one businesspartner;
            TAX_TARIF_CODE : Integer;
            MEASURE_UNIT   : String(2);
            WEIGHT_MEASURE : Decimal(5,2)  @(Semantic.quantity.unit : 'WEIGHT_UNIT');
            WEIGHT_UNIT    : String(2);
            CURRENCY       : Currency;
            PRICE          : Decimal(5,2) @(Semantic.amount.currencyCode: 'DIM_UNIT');
            WIDTH          : Decimal(5,2) @(Semantic.amount.currencyCode: 'DIM_UNIT');
            HEIGHT         : Decimal(5,2) @(Semantic.amount.currencyCode: 'DIM_UNIT');
            DEPTH          : Decimal(5,2) @(Semantic.amount.currencyCode: 'DIM_UNIT');
            DIM_UNIT       : String(2);
    }  

    entity StatusCode {
        key STATUS : String(1);
            text   : String(10);
    }


}

context transaction {

    entity purchaseorder  : common.Amount ,cuid {
        //key NODE_KEY      : common.guid   @title : '{i18n>PO_KEY}';
            PO_ID         : String(32)    @title : '{i18n>PO_ID}';
            PARTNER_GUID  : Association to one master.businesspartner ;
            LIFECYCLE_STATUS : String(1)  @title : '{i18n>STATUS}';
            OVERALL        : Association to  master.StatusCode    @title : '{i18n>STATUS}';
            NOTE           : String(255) @title : '{i18n>NOTE}';
            ITEMS          : Composition of many poitems on ITEMS.PARENT_KEY = $self;
    }   

    entity poitems        : common.Amount,cuid {
      //  key NODE_KEY      : common.guid;
            PARENT_KEY    : Association to one purchaseorder;
            PO_ITEM_POS   : Integer @title : '{i18n>ITEM_POS}';
            PRODUCT_GUID  : Association to one master.product  ;
    }       

}