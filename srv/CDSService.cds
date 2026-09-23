using { debashish.cds } from '../db/CDSView' ;

service CDSService @(path:'CDSService') {
 
  entity ProductSet as projection on cds.CDSView.ProductView {
    *, 
    //please a virtual field to show no of times this was brought
    virtual purchCount: Int16
 };
 entity ItemSet    as projection on cds.CDSView.ItemView;
}