public class wb_BLs_List {
    ApexPages.StandardController stdController;
    ApexPages.StandardSetController Controller;
    public List<BL__c> BLs {get;set;}
    
    public boolean openPopup {get;set;} // To open  window in Java
    public PageReference myTargetUrl {get;set;}
    public List<BLRow> BLList {get;set;}
    
    public class BLRow {
        public Boolean isSelected { get; set; }
        public BL__c theBL { get; set; }
        public BLRow( BL__c bl) {
            theBL = bl;
            isSelected = false;
        }
    }
    
    public SelectOption[] ShozokuAreaOption {get;set;}
    
    public string selectedShozokuAreaOption {get;set;}
    
    public wb_BLs_List(ApexPages.StandardController stdController){
        this.stdController = stdController;
        ShozokuAreaOption = getShozokuAreaOption();
    }
    
    public wb_BLs_List(ApexPages.StandardSetController stdSetController) {
        // if you wish, do something with stdSetController.getSelected()
        this.Controller = stdSetController;
        ShozokuAreaOption = getShozokuAreaOption();
        openPopup = false;
    }
    
    public SelectOption[] getShozokuAreaOption() {  
        List<SelectOption>  opt = new  List<SelectOption>();
        opt.add(new SelectOption('','--None--'));  
        
        for (AggregateResult l : [ SELECT ShozokuArea__c, count(id) 
                                  FROM BL__c
                                  where ShozokuArea__c <> null
                                  group by ShozokuArea__c	]) {  
                                      opt.add(new SelectOption(String.valueOf(l.get('ShozokuArea__c')), String.valueOf(l.get('ShozokuArea__c')) ));  
                                  }        
        
        return opt;  
    } 
    
    public void getBLs(){
        BLList = new List<BLRow>();
        for(BL__c bl:[select id, name from BL__c where ShozokuArea__c=:selectedShozokuAreaOption  ]){
            BLList.add( new BLRow(bl) );
        }
    }
    
    public void BLsList(){
       // PageReference acctPage = Page.wb_BLs_List_Export;
        // PageReference acctPage = new  Page.wb_BLs_List_Export;
       // ApexPages.StandardSetcontroller ctl = new ApexPages.StandardSetcontroller(BLs);
       //   wb_BLs_List_Export BLsExport = new wb_BLs_List_Export(ctl);
        //BLsExport.setRedirect(true);
        //acctPage = BLsExport;
      //  return acctPage;
        Id[] items;
        items = new List<Id>();
        for ( BLRow b:BLList){
            if (b.isSelected==true){
                items.add(b.theBL.id);
            }
        }
        PageReference pr = new PageReference('/apex/wb_BLs_List_Export');
        pr.getParameters().put('items', String.join(items, ','));
        // pr.getParameters().put('key','value');
       // pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
       openPopup = true;
        myTargetUrl = pr;

    }
    
}