global class MDMemberReportUpdateFamilyInfoBatch implements Database.Batchable<sObject>, Database.Stateful{

    public DataModel dm {get;set;}
    public List<SummaryRec> LSummary {set;get;}
    public Map<String, Integer> MArea {set;get;}
    public List<SummaryRec> LSummary2 {set;get;}
    public Map<String, Integer> MArea2 {set;get;}
    public Map<string,integer> MCode = new Map<string,integer>();  
    public Summary_of_members__c summaryDataAffiliation = new Summary_of_members__c();
    public Summary_of_members__c summaryDataContract = new Summary_of_members__c();
    public List<Summary_of_members__c> summaryAffiliationList = new List<Summary_of_members__c>();   
    public List<Summary_of_members__c> summaryContractList = new List<Summary_of_members__c>();  
    public Map<String,String> recordTypeNameIdMap = new Map<String,String>();
    public List<Summary_of_members__c> summaryDataList = new List<Summary_of_members__c>();
    
    global MDMemberReportUpdateFamilyInfoBatch (){
        summaryDataList = [select id,Area__c,Contract__c,recordtype.id from Summary_of_members__c];
    
        List<RecordType> recordTypeList =  [select id,developerName from recordType where SobjectType = 'Summary_of_members__c'];
        recordTypeNameIdMap = new Map<String,String>();
        for(RecordType recordType:recordTypeList){
            recordTypeNameIdMap.put(recordType.developerName,recordType.id);  
        }  
        system.debug(recordTypeNameIdMap);    
    
        Schema.DescribeFieldResult fieldResult = MemberInfo__c.ShozokuArea__c.getDescribe();
        List<Schema.PicklistEntry> LPicklistValue = fieldResult.getPicklistValues();
        
        LSummary = new List<SummaryRec>();
        MArea = new Map<String, Integer>();
        for(Schema.PicklistEntry picklist: LPicklistValue){
            LSummary.add(new SummaryRec(picklist.getValue()));
            MArea.put(picklist.getValue(),LSummary.size()-1);
        }
                
        Schema.DescribeFieldResult fieldResult2 = ContractInfo__c.KeiyakuArea__c.getDescribe();
        List<Schema.PicklistEntry> LPicklistValue2 = fieldResult2.getPicklistValues();
        
        LSummary2 = new List<SummaryRec>();
        MArea2 = new Map<String, Integer>();
        for(Schema.PicklistEntry picklist: LPicklistValue2){
            LSummary2.add(new SummaryRec(picklist.getValue()));
            MArea2.put(picklist.getValue(),LSummary2.size()-1);
        }                

    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(
        'SELECT MemberShimei__r.CompanyKeiyakuNo__r.KeiyakuArea__c, ShozokuArea__c FROM FamilyInfo__c where (TaikaiDate__c = null or TaikaiDate__c >= today) and (Commodity__c = \'メディック\' or Commodity__c = \'チャイナボウル\')');
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
        for(FamilyInfo__c Fam:(List<FamilyInfo__c>)scope){
                if(MArea.get(Fam.ShozokuArea__c) != null){
                    LSummary[MArea.get(Fam.ShozokuArea__c)].family++;
                }
                
                if(MArea2.get(Fam.MemberShimei__r.CompanyKeiyakuNo__r.KeiyakuArea__c) != null){
                    LSummary2[MArea2.get(Fam.MemberShimei__r.CompanyKeiyakuNo__r.KeiyakuArea__c)].family++;
                }    
        }   
    }

   global void finish(Database.BatchableContext BC){
        List<Summary_of_members__c> summaryDataList = [select id,Area__c,Contract__c,recordtype.id from Summary_of_members__c];
        dm = new DataModel();
        dm.data = new list<DataModel.Model>();       
        DataModel.Model model = new DataModel.Model();            
        model.data = new list<map<string,string>>();
        for(SummaryRec SRec: LSummary){
            map<string,string> rowdata = new map<string,string>();
            rowdata.put(System.Label.AffiliationArea,SRec.area);
            rowdata.put(System.Label.EntrainedFamily,String.valueof(SRec.family));
            model.data.add(rowdata);
        }
          
          if(model.data != null){        
              for(Map<String,String> rowdataList:model.data){ 
                   if(summaryDataList != null){   
                       summaryDataAffiliation = new Summary_of_members__c();  
                       for(Summary_of_members__c m:summaryDataList){
                           if(rowdataList.get(System.Label.AffiliationArea) == m.Area__c && m.recordtype.id == recordTypeNameIdMap.get('Aggregate_Sheet_Affiliation')){
                               summaryDataAffiliation.id = m.id;
                               summaryDataAffiliation.Family__c = rowdataList.get(System.Label.EntrainedFamily);
                               summaryDataAffiliation.RecordTypeId = recordTypeNameIdMap.get('Aggregate_Sheet_Affiliation');
                               summaryAffiliationList.add(summaryDataAffiliation);                                   
                           }
                       }  
                   }         
              }   
          }
        dm.data.add(model);
              
        model = new DataModel.Model();
        model.data = new list<map<string,string>>();
        for(SummaryRec SRec: LSummary2){
            map<string,string> rowdata = new map<string,string>();
            rowdata.put(System.Label.Contract,SRec.area);
            rowdata.put(System.Label.EntrainedFamily,String.valueof(SRec.family));
            model.data.add(rowdata);
        }
        
        system.debug(model);
        dm.data.add(model);
        
           if(model.data != null){
               for(Map<String,String> rowdataList:model.data){ 
                    if(summaryDataList!= null){  
                       summaryDataContract = new Summary_of_members__c();     
                       for(Summary_of_members__c m:summaryDataList){
                           if(rowdataList.get(System.Label.Contract) == m.Contract__c && m.recordtype.id == recordTypeNameIdMap.get('Aggregate_Sheet_Contract')){ 
                               summaryDataContract.id = m.id;
                               summaryDataContract.Family__c = rowdataList.get(System.Label.EntrainedFamily);  
                               summaryDataContract.RecordTypeId = recordTypeNameIdMap.get('Aggregate_Sheet_Contract');
                               summaryContractList.add(summaryDataContract);                               
                           }
                       }                        
                    }       
              }     
          }     
         
        /*                    
        LSummary = null;
        MArea = null;
        LSummary2 = null;
        MArea2 = null;   
        */     
        
        //update date in 'Summary_of_members__c' object's family           
        if(summaryContractList !=null){
            update summaryContractList;   
        }
        if(summaryAffiliationList != null){
            update summaryAffiliationList;      
        }  
   }
   
    public class SummaryRec{
        public string area {set;get;}
        public Integer family {set;get;}
        public Integer company {set;get;}
        
        public SummaryRec(String inArea){
            area = inArea;
            family = 0;
            company = 0;     
        }
    }    
}