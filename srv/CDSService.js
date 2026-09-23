import cds from '@sap/cds'
//import { SELECT } from '@sap/cds/lib/ql/cds-ql'

export class CDSService extends cds.ApplicationService { init() {

  const { ProductSet, ItemSet } = cds.entities('CDSService')

  this.before (['CREATE', 'UPDATE'], ProductSet, async (req) => {
    console.log('Before CREATE/UPDATE ProductSet', req.data)
  })
  this.after ('READ', ProductSet, async (productSet, req) => {
   console.log('After READ ProductSet', productSet)
   
   let aIds = productSet.map( record => record.ProductId);
   // CQL - CDS Query Language
   const orderCount = await SELECT.from(ItemSet)
                            .columns('ProductKey',{func:'count', as: 'purchCount'})
                            .where({'ProductKey':{in:aIds}})
                            .groupBy('ProductKey');

   for (let index = 0; index < productSet.length; index++) {
    const element = productSet[index];
    const foundRecord = orderCount.find(wa => wa.ProductKey === element.ProductId) ;
    if(foundRecord){
      element.purchCount = foundRecord.purchCount;
    }
       
   }
  })
  this.before (['CREATE', 'UPDATE'], ItemSet, async (req) => {
    console.log('Before CREATE/UPDATE ItemSet', req.data)
  })
  this.after ('READ', ItemSet, async (itemSet, req) => {
    console.log('After READ ItemSet', itemSet)
  })


  return super.init()
}}
