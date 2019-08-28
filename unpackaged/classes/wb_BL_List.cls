public class wb_BL_List {
    ApexPages.StandardController stdController;
    public string myName{get;set;}
    public List<Header> theHeader{get;set;}
    
    public class Header{
        public string Item {get;set;}
        public string value {get;set;}
        
        public Header(string i,string v){
            Item = i;
            value = v;
        }
    }
    
    
    public list<wb_bl_Insurance> InsuraceList{get;set;}
    
    public wb_BL_List(ApexPages.StandardController stdController){
        this.stdController = stdController;
        //list <BL__c> bl = [SELECT id FROM BL__c where name ='BL011109' ];
        BL__c bl = (BL__c) stdController.getRecord();
        bl = [select id, name from BL__c where id =:bl.id];
        myName = bl.name;
        FillHeader(string.valueof(bl.id));
        FillDetail(bl);
        
        for( wb_bl_InsuranceContent c: InsuraceList[0].theContent) {
            system.debug('ItemName:' + c.ItemName);
        }
        
        
    }
/*    
    public wb_BL_List(string Blid){
        
        //list <BL__c> bl = [SELECT id FROM BL__c where name ='BL011109' ];
        BL__c bl = [SELECT id FROM BL__c where id =:Blid];
        FillHeader(string.valueof(bl.id));
        FillDetail(bl);
        
    }
    
    */
    
    public void FillHeader( string BLid ){
        system.debug('BLid:' + BLid);
        
        BL__c b = [select  KeiyakuCompanyName__r.name, KeiyakuCompanyName__r.OfficeAdd__c,
                   Insurant__r.name, Insurant__r.OfficeAdd__c, 
                    KeiyakuCompanyName__r.BlShimei__c,  NoticeTanto__c from BL__c where id =:BLid ];
        theHeader = new List<Header>();
        String type='BL__c';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(type);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        
        theHeader.add( new Header(fieldMap.get('KeiyakuCompanyName__c').getDescribe().getLabel(),b.KeiyakuCompanyName__r.name));
        
        type='Account';
        
        leadSchema = schemaMap.get(type);
        fieldMap = leadSchema.getDescribe().fields.getMap();
        
        theHeader.add( new Header(fieldMap.get('OfficeAdd__c').getDescribe().getLabel(), b.KeiyakuCompanyName__r.OfficeAdd__c));
        
        type='BL__c';
        
        leadSchema = schemaMap.get(type);
        fieldMap = leadSchema.getDescribe().fields.getMap();
        
        theHeader.add( new Header(fieldMap.get('Insurant__c').getDescribe().getLabel(),b.Insurant__r.name));
        
        type='Account';
        
        leadSchema = schemaMap.get(type);
        fieldMap = leadSchema.getDescribe().fields.getMap();
        
        
        theHeader.add( new Header(fieldMap.get('OfficeAdd__c').getDescribe().getLabel(),b.Insurant__r.OfficeAdd__c));
        theHeader.add( new Header(fieldMap.get('BlShimei__c').getDescribe().getLabel(),b.KeiyakuCompanyName__r.BlShimei__c));
        
        type='BL__c';
        
        leadSchema = schemaMap.get(type);
        fieldMap = leadSchema.getDescribe().fields.getMap();
        theHeader.add( new Header(fieldMap.get('NoticeTanto__c').getDescribe().getLabel(),b.NoticeTanto__c));
        
        
        
    }
    public void FillDetail( BL__c Dtl)
    {
        InsuraceList = new list<wb_bl_Insurance>();
        BL__c b  = [select Currency__c, InsuranceAmount__c, InsuranceCompanyName__c, InsuranceShiki__c, InsuranceManki__c, Insurance__c, InsuranceContent__c 
                    from BL__c where id =: Dtl.id];
        system.debug('InsuranceContent__c:' + b.InsuranceContent__c);
        InsuraceList.add( new wb_bl_Insurance( b.InsuranceCompanyName__c, b.InsuranceShiki__c, b.InsuranceManki__c,
                                              b.Insurance__c, b.InsuranceContent__c));
        Decimal input = b.InsuranceAmount__c;
        String output = '$' + String.valueOf(input.format());
        InsuraceList.add( new wb_bl_Insurance( null, null, null,
                                              null,'保険料' +'('+ b.Currency__c + output + ')' ));
        
    }
    
    public void FillDetail( list <BL__c> Dtl) {
        
        string bl_id;
        for ( BL__c b:Dtl){
            if ( bl_id == null)
                bl_id = '\'' +  b.id + '\'';
            else
                bl_id += ',' + '\'' +  b.id + '\'';
        }     
        
        
        
        InsuraceList = new list<wb_bl_Insurance>();
        string Sql = 'select InsuranceCompanyName__c, InsuranceShiki__c, InsuranceManki__c, BranchOfInsurance__c, InsuranceContent__c ';
        Sql +=' from BL__c where id in (' + bl_id +')';
        
        
        
        list<BL__c> BL = Database.query(Sql);
        
        for ( BL__c b: BL){
            
            
            InsuraceList.add( new wb_bl_Insurance( b.InsuranceCompanyName__c, b.InsuranceShiki__c, b.InsuranceManki__c,
                                                  b.BranchOfInsurance__c, b.InsuranceContent__c));
            
        }
    }
    
    
}