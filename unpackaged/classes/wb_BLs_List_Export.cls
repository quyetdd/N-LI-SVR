public class wb_BLs_List_Export {
    ApexPages.StandardController Controller;
    public string myName{get;set;} // The Output file name
    
    public List<BLsList> theBLsList{get;set;} 
    
    public class BLsList {
        
        public List<Header> theHeader{get;set;} 
        public List<wb_bl_Insurance> InsuraceList{get;set;}
        
        BLsList( ){
            theHeader = new  List<Header>();
            InsuraceList = new List<wb_bl_Insurance>();
//            theHeader = H;
//            InsuraceList = D;
        }
        
        public void Fill( string BLid ){
           // system.debug('BLid:' + BLid);
            
            BL__c b = [select KeiyakuCompanyName__r.name, KeiyakuCompanyName__r.OfficeAdd__c,
                       Insurant__r.name, Insurant__r.OfficeAdd__c, 
                       NoticeTanto__c, KeiyakuCompanyName__r.BlShimei__c,
                       InsuranceCompanyName__c, InsuranceShiki__c, InsuranceManki__c, Insurance__c, InsuranceContent__c,  Currency__c, InsuranceAmount__c
                       from BL__c where id =:BLid ];
            theHeader = new List<Header>();
            String type='BL__c';
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType leadSchema = schemaMap.get(type);
            Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
            
            theHeader.add( new Header(fieldMap.get('KeiyakuCompanyName__c').getDescribe().getLabel(),b.KeiyakuCompanyName__r.name));
            
            type='Account';
            
            leadSchema = schemaMap.get(type);
            fieldMap = leadSchema.getDescribe().fields.getMap();
            
            theHeader.add( new Header(fieldMap.get('OfficeAdd__c').getDescribe().getLabel(),b.KeiyakuCompanyName__r.OfficeAdd__c));
            
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
            
              InsuraceList = new list<wb_bl_Insurance>();
            
            InsuraceList.add( new wb_bl_Insurance( b.InsuranceCompanyName__c, b.InsuranceShiki__c, b.InsuranceManki__c,
                                                  b.Insurance__c, b.InsuranceContent__c));
            if ( b.InsuranceAmount__c != null) {
                Decimal input = b.InsuranceAmount__c;
                String output =  String.valueOf(input.format());
                InsuraceList[InsuraceList.size()-1].theContent.add( new wb_bl_InsuranceContent('保険料',  b.Currency__c + ' ' + output));
            } else
                InsuraceList[InsuraceList.size()-1].theContent.add( new wb_bl_InsuranceContent('保険料',  null));
                
        }
        
        
    }
    
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
    
    public wb_BLs_List_Export(ApexPages.StandardController Controller){
        this.Controller = Controller;
        //list <BL__c> bl = [SELECT id FROM BL__c where name ='BL011109' ];
        //  BL__c bl = (BL__c) stdController.getRecord();
        //bl = [select id, name from BL__c where id =:bl.id];
        
        Id[] items = ApexPages.currentPage().getParameters().get('items').split(',');
        
        theBLsList = new  List<BLsList>();
        myName = '';
        for (BL__c bl:[select id, name from BL__c where id=:items] ){
            myName += bl.Name; 
            BLsList r = new BLsList();
            r.fill(bl.id);
             theBLsList.add( r );
              system.debug('BL:' + bl.Name);
        }
        
        
    }
    
    /*
    public void FillHeader( string BLid ){
        system.debug('BLid:' + BLid);
        
        BL__c b = [select KeiyakuCompanyName__r.name, KeiyakuCompanyName__r.OfficeAdd__c,
                   Insurant__r.name, Insurant__r.OfficeAdd__c, 
                   NoticeTanto__c, KeiyakuCompanyName__r.BlShimei__c from BL__c where id =:BLid ];
        theHeader = new List<Header>();
        String type='BL__c';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(type);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        
        theHeader.add( new Header(fieldMap.get('KeiyakuCompanyName__c').getDescribe().getLabel(),b.KeiyakuCompanyName__r.name));
        
        type='Account';
        
        leadSchema = schemaMap.get(type);
        fieldMap = leadSchema.getDescribe().fields.getMap();
        
        theHeader.add( new Header(fieldMap.get('OfficeAdd__c').getDescribe().getLabel(),b.KeiyakuCompanyName__r.OfficeAdd__c));
        
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
        BL__c b  = [select InsuranceCompanyName__c, InsuranceShiki__c, InsuranceManki__c, Insurance__c, InsuranceContent__c 
                    from BL__c where id =: Dtl.id];
        //system.debug('InsuranceContent__c:' + b.InsuranceContent__c);
        InsuraceList.add( new wb_bl_Insurance( b.InsuranceCompanyName__c, b.InsuranceShiki__c, b.InsuranceManki__c,
                                              b.Insurance__c, b.InsuranceContent__c));
        
    }*/
    /*
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
    */
    
    
}