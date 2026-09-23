import cds from '@sap/cds'

export class CatalogService extends cds.ApplicationService { init() {

  const { EmployeeSet, ProductSet, BusinessPartnerSet, AddressSet, PurchaseOrderSet, PurchaseOrderItemsSet } = cds.entities('CatalogService')

 this.on('getMostExpOrders', async(req) => {

  const zkas = req.data.zkas;
 
  //get the tx api
    const tx = cds.tx(req);
   //get the top 3 exp product
    const response =  await tx.read(PurchaseOrderSet).orderBy({
       GROSS_AMOUNT: 'desc'
    }).limit(zkas);

    return response;

 })
  
  this.on('getDefaultOrderData', async(req) => { 
     return {
        OVERALL_STATUS : 'P',
        LIFECYCLE_STATUS : 'N'
     }


  })
  this.on('boost', async(req) => {

    try{
    let primaryKey = req.params[0];
    console.log("aaya kya", JSON.stringify(primaryKey));

    //CDS QL   
    //get the transaction api object
    const tx = cds.tx(req);
   
    //CDS QL  to change data in database

    await tx.update(PurchaseOrderSet).with({
        GROSS_AMOUNT: {'+=' : 20000},
        NOTE: 'boosted!!'
    }).where(primaryKey);

    //Query data which is now updated in database

    return await tx.read(PurchaseOrderSet).where(primaryKey);
  }catch (error){ 
     return new Error(error);
  }

  }) 
  this.before (['CREATE', 'UPDATE'], EmployeeSet, async (req) => {
    //console.log('Before CREATE/UPDATE EmployeeSet', req.data);

    if(parseFloat(req.data.SALARYAMOUNT) > 1000000){
      req.error(500, "Hey Amigo !! Nobody gets this high salary");
    }
  })
  this.after ('READ', EmployeeSet, async (employeeSet, req) => {
    console.log('After READ EmployeeSet', employeeSet)
  })
  this.before (['CREATE', 'UPDATE'], ProductSet, async (req) => {
    console.log('Before CREATE/UPDATE ProductSet', req.data)
  })
  this.after ('READ', ProductSet, async (productSet, req) => {
    console.log('After READ ProductSet', productSet)
  })
  this.before (['CREATE', 'UPDATE'], BusinessPartnerSet, async (req) => {
    console.log('Before CREATE/UPDATE BusinessPartnerSet', req.data)
  })
  this.after ('READ', BusinessPartnerSet, async (businessPartnerSet, req) => {
    console.log('After READ BusinessPartnerSet', businessPartnerSet)
  })
  this.before (['CREATE', 'UPDATE'], AddressSet, async (req) => {
    console.log('Before CREATE/UPDATE AddressSet', req.data)
  })
  this.after ('READ', AddressSet, async (addressSet, req) => {
    console.log('After READ AddressSet', addressSet)
  })
  this.before (['CREATE'], PurchaseOrderSet, async (req) => {
    //console.log('Before CREATE/UPDATE PurchaseOrderSet', req.data)
    if(!req.data.PO_ID){
       return req.error(500,"Bro givme the PO id atleast");
    }
  })
  this.after ('READ', PurchaseOrderSet, async (purchaseOrderSet, req) => {
   // console.log('After READ PurchaseOrderSet', purchaseOrderSet)
   for (let index = 0; index < purchaseOrderSet.length; index++) {
    const element = purchaseOrderSet[index];
    if(!element.NOTE){
       element.NOTE = "Not found !!";
    }
   }
  })
  this.before (['CREATE', 'UPDATE'], PurchaseOrderItemsSet, async (req) => {
    console.log('Before CREATE/UPDATE PurchaseOrderItemsSet', req.data)
  })
  this.after ('READ', PurchaseOrderItemsSet, async (purchaseOrderItemsSet, req) => {
    console.log('After READ PurchaseOrderItemsSet', purchaseOrderItemsSet)
  })


  return super.init()
}}
