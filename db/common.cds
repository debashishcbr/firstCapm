
using { Currency } from '@sap/cds/common';

namespace debashish.common ;

//my own data type .. domain in abap
type guid:String(32);
type name:String(256);
type initials:String(40);
type phone:String(30);
type email:String(250);
//CURR type field - reference field CUKY
//QUANY - UNIT
type amount: Decimal(10,2) @(
 Semantic.amount.currencyCode: 'Currency'
 ) ;
type gender:String(1) enum {
    male = 'M';
    Female = 'F';
    Undisclosed = 'U';
};

aspect Amount {
    GROSS_AMOUNT : Decimal(15,2) @(Semantic.amount.currency: 'CURRENCY_code') @title : '{i18n>GROSS_AMOUNT}';
    NET_AMOUNT   : Decimal(15,2) @(Semantic.amount.currency: 'CURRENCY_code') @title : '{i18n>NET_AMOUNT}';
    TAX_AMOUNT   : Decimal(15,2) @(Semantic.amount.currency: 'CURRENCY_code') @title : '{i18n>TAX_AMOUNT}';
    CURRENCY     : Currency @title : '{i18n>CURRENCY_CODE}';
}