global with sharing class wb_bl_Insurance {
    public String Name{get;set;}
    public List<wb_bl_InsuranceContent> theContent{get;set;}
    public List<wb_bl_InsuranceContent> availableContent{get;set;}
    public integer availableContentSize{get;set;}
    public String theCompany{get;set;}
    public datetime DateFr{get;set;}
    public datetime DateTo{get;set;}
    public string sDateFr{get;set;}
    public string sDateTo{get;set;}
    // for exsiting record
    public wb_bl_Insurance(string Insurance, String Item){
        Name =  Insurance;
        theContent = new List<wb_bl_InsuranceContent>();
        while ( Item.indexOf(';',0)>0){
            string i = Item.left(Item.indexOf(';',0));
            Item = Item.mid(Item.indexOf(';',0)+1, Item.length()-Item.indexOf(';',0)-1);
            string v = i.right(i.length() - i.indexOf('(',0) - 1);
            v = v.left( v.length() -1);
            i = i.mid(0, i.indexOf('(',0));
            theContent.add( new wb_bl_InsuranceContent(i,v)); 
        }
        if (Item.length()>0){ // Last Item
            string i = Item;
            string v = i.right(i.length() - i.indexOf('(',0) - 1);
            v = v.left( v.length() -1);
            i = i.mid(0, i.indexOf('(',0));
            theContent.add( new wb_bl_InsuranceContent(i,v)); 
        }
         availableContent = new List<wb_bl_InsuranceContent>();
         availableContentSize = availableContent.size();
    }
    // for new record
    public wb_bl_Insurance(string n, List<wb_Service__c> MainService, List<wb_Service__c> ServiceItem ){
        Name = n;
        theContent = new List<wb_bl_InsuranceContent>();
        
        if (n!='--None--' && n != null){
            
            wb_Service__c ps = [select  id, Service__c from wb_Service__c 
                                      where ServiceCompany__c = 'ALL' 
                                      and ServiceClassification__c ='BL' 
                                      and ParentService__c = null
                                      and Service__c =:n limit 1];
                    
            for ( wb_Service__c i:[select Service__c 
                                   from wb_Service__c 
                                   where ServiceCompany__c = 'ALL' 
                                   and ParentService__c <> null and ParentService__c =:ps.id
                                   and ServiceClassification__c ='BL']){
                                       theContent.add( new wb_bl_InsuranceContent(i.Service__c));     
                                   }
        } 
         availableContent = new List<wb_bl_InsuranceContent>();
		 availableContentSize = availableContent.size();
    }  
    // for new record
    public wb_bl_Insurance(string company, date fr, date to, string Insurance, String Item){
        theCompany = company;
        DateFr = fr;
        if (DateFr!=null)
        sDateFr = DateFr.format('yyyy/MM/dd');
        DateTo = to;
        if (DateTo!=null)
        sDateTo = DateTo.format('yyyy/MM/dd');
        Name =  Insurance;
        theContent = new List<wb_bl_InsuranceContent>();
        if (Item <> null ) {
      //  system.debug('Item:' + Item);
        while ( Item.indexOf(';',0)>0){
            string i = Item.left(Item.indexOf(';',0));
            Item = Item.mid(Item.indexOf(';',0)+1, Item.length()-Item.indexOf(';',0)-1);
            string v = i.right(i.length() - i.indexOf('(',0) - 1);
            v = v.left( v.length() -1);
            i = i.mid(0, i.indexOf('(',0));
            theContent.add( new wb_bl_InsuranceContent(i,v)); 

        }
        if (Item.length()>0){ // Last Item
            string i = Item;
            string v = i.right(i.length() - i.indexOf('(',0) - 1);
            v = v.left( v.length() -1);
            i = i.mid(0, i.indexOf('(',0));
            theContent.add( new wb_bl_InsuranceContent(i,v)); 
        }
        }
        availableContent = new List<wb_bl_InsuranceContent>();
        availableContentSize = availableContent.size();
    }
    // compare and list up new item
    public void InsuranceItem(string Insurance, List<wb_Service__c> MainService, List<wb_Service__c> ServiceItem){
        id InsuranceId;
        
        Name =  Insurance;
        availableContent = new List<wb_bl_InsuranceContent>();
        
       // system.debug('Insurance:'+Insurance);
        // system.debug(' MainService.size():'+ MainService.size());
        
        for (integer i =0; i < MainService.size() ; i++ ){
            if ( MainService[i].Service__c == Insurance) {
                InsuranceId =  MainService[i].id;
                i =  MainService.size();
            }
        }
        
        if ( InsuranceId != null){
            for (integer i =0; i < ServiceItem.size() ; i++){
                if (ServiceItem[i].ParentService__c == InsuranceId )
                {
                    integer j;
                    for(j =0; j < theContent.size() ; j++ ){
                        if ( theContent[j].ItemName ==ServiceItem[i].Service__c)
                            j = theContent.size() + 2;
                    }
                    if ( j == theContent.size() ){
                         availableContent.add( new wb_bl_InsuranceContent(ServiceItem[i].Service__c,null)); 
                    } // New Item
                }
            }
      }
        
        availableContentSize = availableContent.size();
        
    }
    

    public string theItem {get;set;}
    public void AppendItem(){

        
        if (theItem != null){
            for ( integer i = 0; i < availableContent.size(); i++ ){
                if ( availableContent[i].ItemName == theItem){
                    theContent.add(new wb_bl_InsuranceContent(availableContent[i].ItemName));
                    availableContent.remove(i);
                    i = availableContent.size();
                }
            }
        }
        availableContentSize = availableContent.size();
    }
    public void RemoveItem(){

        if (theItem != null){
            for ( integer i = 0; i < theContent.size(); i++ ){
                if ( theContent[i].ItemName == theItem){
                    availableContent.add(new wb_bl_InsuranceContent(theContent[i].ItemName));
                    theContent.remove(i);
                    i = theContent.size();
                }
            }
        }
        availableContentSize = availableContent.size();
    }
}