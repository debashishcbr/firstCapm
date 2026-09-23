import cds from '@sap/cds'

export class myservice extends cds.ApplicationService { 
  
  init() {

  this.on ('story', async (req) => {
    console.log('On story', req.data)
    let storyType =  req.data.name ; 
  
    switch (storyType){
     case 'crow' :
     return ("once upon a time there was a thirsty crow, it was looking for water in summer..");
     break;
     case 'king':
     return ("once upon a time there was a kind king, he lived in Awadh..");
     break;     
     default:
     return ("please send parameter as ?name=type e.g. king,crow");
     break;   
    }

  })

   this.on ('employee', async (req) => {

    return 'employees';
   })

  return super.init()
}}
