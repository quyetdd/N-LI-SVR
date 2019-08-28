global class MDMemberReportBatch implements Database.Batchable<sObject>, Database.Stateful{

    public DataModel dm {get;set;}
    public List<SummaryRec> LSummary {set;get;}
    public Map<String, Integer> MArea {set;get;}
    public List<SummaryRec> LSummary2 {set;get;}
    public Map<String, Integer> MArea2 {set;get;}
    public Summary_of_members__c summaryDataAffiliation = new Summary_of_members__c();
    public Summary_of_members__c summaryDataContract = new Summary_of_members__c();
    public Map<String,Summary_of_members__c> oldSummaryOfMemberAffiliationMap = new Map<String,Summary_of_members__c>();
    public Map<String,Summary_of_members__c> oldSummaryOfMemberContractMap = new Map<String,Summary_of_members__c>();    
    public List<Summary_of_members__c> summaryAffiliationList;
    public List<Summary_of_members__c> summaryContractList;
    public Map<string,integer> MCode = new Map<string,integer>();  
    public List<String> areaEngList =  new List<String>();
    public List<String> labelList = new List<String>();
    public List<String> fieldNameList = new List<String>();
    public Map<String,String> recordTypeNameIdMap = new Map<String,String>();

    global MDMemberReportBatch (){
        
        // get record type developername and id
        List<RecordType> recordTypeList =  [select id,developerName from recordType where SobjectType = 'Summary_of_members__c'];
        recordTypeNameIdMap = new Map<String,String>();
        for(RecordType recordType:recordTypeList){
            recordTypeNameIdMap.put(recordType.developerName,recordType.id);  
        }  
        system.debug(recordTypeNameIdMap);
             
        // get the old data to update by area key      
        List<Summary_of_members__c> summaryOfMemberList = [select id,Area__c,Contract__c,recordTypeId from Summary_of_members__c];
        if(summaryOfMemberList.size()>0){
            for(Summary_of_members__c summaryOfMember:summaryOfMemberList ){
                if(summaryOfMember.recordTypeId == recordTypeNameIdMap.get('Aggregate_Sheet_Affiliation')){
                    oldSummaryOfMemberAffiliationMap.put(summaryOfMember.Area__c,summaryOfMember);
                }
                if(summaryOfMember.recordTypeId == recordTypeNameIdMap.get('Aggregate_Sheet_Contract')){
                    oldSummaryOfMemberContractMap.put(summaryOfMember.Contract__c,summaryOfMember);
                }
            } 
        }
        system.debug(oldSummaryOfMemberAffiliationMap);
        system.debug(oldSummaryOfMemberContractMap);
        
        labelList = getHeaderLabelList('LabelList');
        fieldNameList = getHeaderLabelList('fieldName');
        
        Schema.DescribeFieldResult fieldResult = MemberInfo__c.ShozokuArea__c.getDescribe();
        List<Schema.PicklistEntry> LPicklistValue = fieldResult.getPicklistValues();
        
        List<String> areaEngList = new List<String>(); 
        for(Schema.PicklistEntry f:LPicklistValue){
          areaEngList.add(f.getLabel()); 
          system.debug(f.getLabel());
        }  

        LSummary = new List<SummaryRec>();
        MArea = new Map<String, Integer>();
        
        for(Schema.PicklistEntry picklist: LPicklistValue){
            //LSummary.add(new SummaryRec(picklist.getValue(),picklist.getLabel()));
            SummaryRec summaryRec = new SummaryRec(picklist.getValue(),picklist.getLabel());
            for(Integer num=0; num < fieldNameList.size()+3; num++){
                summaryRec.LMemNum.add(0); 
            }
            LSummary.add(summaryRec);
            MArea.put(picklist.getValue(),LSummary.size()-1);
        }
                
        Schema.DescribeFieldResult fieldResult2 = ContractInfo__c.KeiyakuArea__c.getDescribe();
        List<Schema.PicklistEntry> LPicklistValue2 = fieldResult2.getPicklistValues();
        
        LSummary2 = new List<SummaryRec>();
        MArea2 = new Map<String, Integer>();
        for(Schema.PicklistEntry picklist: LPicklistValue2){
            //LSummary2.add(new SummaryRec(picklist.getValue(),picklist.getLabel()));
            SummaryRec summaryRec2 = new SummaryRec(picklist.getValue(),picklist.getLabel());
            for(Integer num=0; num < fieldNameList.size()+3; num++){
                summaryRec2.LMemNum.add(0); 
            }
            LSummary2.add(summaryRec2);                    
            MArea2.put(picklist.getValue(),LSummary2.size()-1);
        }    
         
        //get excel header label 
        //List<String> fieldNameList = getHeaderLabelList('fieldName');
        //Loop over member info to get numbers between col D to P    
        Integer sequence = 0;
        for(String mcodeType:fieldNameList){
            MCode.put(mcodeType,sequence++);
        }            
        system.debug(MCode);
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(
        'SELECT KinmuCompany__c,ShozokuArea__c,ServiceKeitaiCd__c,CompanyKeiyakuNo__r.KeiyakuArea__c,KeiyakuCompanyName__c FROM MemberInfo__c where (TaikaiDate__c = null or TaikaiDate__c >= today) and (Commodity__c = \'メディック\' or Commodity__c = \'チャイナボウル\')');
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
    Set<string> ComAff = new Set<string>();
    Set<string> ComCon = new Set<string>();    
     
        for(MemberInfo__c Mem :(List<MemberInfo__c >)scope){
        //Function for counting area
            if(!ComAff.contains(Mem.KinmuCompany__c+Mem.ShozokuArea__c)){
                ComAff.add(Mem.KinmuCompany__c+Mem.ShozokuArea__c);
                if(MArea.get(Mem.ShozokuArea__c) != null){
                    LSummary[MArea.get(Mem.ShozokuArea__c)].company++;
                }
            }
            
            if(!ComCon.contains(Mem.KeiyakuCompanyName__c+Mem.CompanyKeiyakuNo__r.KeiyakuArea__c)){
                ComCon.add(Mem.KeiyakuCompanyName__c+Mem.CompanyKeiyakuNo__r.KeiyakuArea__c);
                if(MArea2.get(Mem.CompanyKeiyakuNo__r.KeiyakuArea__c) != null){
                    LSummary2[MArea2.get(Mem.CompanyKeiyakuNo__r.KeiyakuArea__c)].company++;
                }
            }
            
            if(MArea.get(Mem.ShozokuArea__c) != null && MCode.get(Mem.ServiceKeitaiCd__c) != null){ 
                LSummary[MArea.get(Mem.ShozokuArea__c)].LMemNum[MCode.get(Mem.ServiceKeitaiCd__c)]++;
            }
                
            if(MArea2.get(Mem.CompanyKeiyakuNo__r.KeiyakuArea__c) != null && MCode.get(Mem.ServiceKeitaiCd__c) != null){ 
                LSummary2[MArea2.get(Mem.CompanyKeiyakuNo__r.KeiyakuArea__c)].LMemNum[MCode.get(Mem.ServiceKeitaiCd__c)]++; 
            }   
        }    
     //update scope;
    }

   global void finish(Database.BatchableContext BC){
        List<String> modelHeadersList = new List<String>();
        Integer LMemNumSequence = 0;
        dm = new DataModel();
        dm.data = new list<DataModel.Model>();       
        DataModel.Model model = new DataModel.Model();
             
        model.data = new list<map<string,string>>();
              
        for(SummaryRec SRec: LSummary){
            map<string,string> rowdata = new map<string,string>();
            rowdata.put(System.Label.AffiliationArea,SRec.area);
            rowdata.put(System.Label.EntrainedFamily,String.valueof(SRec.family));
            rowdata.put(System.Label.MemberCompany,String.valueof(SRec.Company));
            rowdata.put('area_eng',String.valueof(SRec.areaEng));
            
            for(String lmemNum:fieldNameList){
                if(LMemNumSequence == fieldNameList.size()){
                   LMemNumSequence = 0;     
                }            
                rowdata.put(lmemNum,String.valueof(SRec.LMemNum[LMemNumSequence++]));
            }   
            model.data.add(rowdata);
        }
        
          
          summaryAffiliationList = new List<Summary_of_members__c>();
          summaryContractList = new List<Summary_of_members__c>();
          for(Map<String,String> rowdataList:model.data){ 
               summaryDataAffiliation = new Summary_of_members__c();          
               summaryDataAffiliation.Area__c = rowdataList.get(System.Label.AffiliationArea);
               summaryDataAffiliation.Family__c = rowdataList.get(System.Label.EntrainedFamily);
               summaryDataAffiliation.Company__c = rowdataList.get(System.Label.MemberCompany);
               summaryDataAffiliation.AreaEng__c = rowdataList.get('area_eng');
               for(String lmemNum:fieldNameList){
                   summaryDataAffiliation.put('data_'+lmemNum+'__c',rowdataList.get(lmemNum)); 
               }
               summaryDataAffiliation.RecordTypeId = recordTypeNameIdMap.get('Aggregate_Sheet_Affiliation');
               
               if(oldSummaryOfMemberAffiliationMap.size() > 0){
                  summary_of_members__c oldSummaryOfMemberAffiliationObj = oldSummaryOfMemberAffiliationMap.get(summaryDataAffiliation.Area__c); //get data by using area as key
                  if(oldSummaryOfMemberAffiliationMap.get(summaryDataAffiliation.Area__c) != null){
                    oldSummaryOfMemberAffiliationObj.Area__c = rowdataList.get(System.Label.AffiliationArea);
                    oldSummaryOfMemberAffiliationObj.Family__c = rowdataList.get(System.Label.EntrainedFamily);
                    oldSummaryOfMemberAffiliationObj.Company__c = rowdataList.get(System.Label.MemberCompany);
                    oldSummaryOfMemberAffiliationObj.AreaEng__c = rowdataList.get('area_eng');                      
                    for(String lmemNum:fieldNameList){
                       oldSummaryOfMemberAffiliationObj.put('data_'+lmemNum+'__c',rowdataList.get(lmemNum)); 
                    }    
                    oldSummaryOfMemberAffiliationObj.RecordTypeId = recordTypeNameIdMap.get('Aggregate_Sheet_Affiliation');
                    summaryAffiliationList.add(oldSummaryOfMemberAffiliationObj);                  
                  }
                  system.debug(oldSummaryOfMemberAffiliationObj);
               }
               else{
                  // add the data in summary of member as first time
                  summaryAffiliationList.add(summaryDataAffiliation);
                  system.debug(summaryDataAffiliation);
               }  
          }   
          system.debug(summaryAffiliationList);
                   
        dm.data.add(model);
        system.debug(dm.data);
        
        LMemNumSequence = 0;             
        model = new DataModel.Model();
        model.data = new list<map<string,string>>();
        for(SummaryRec SRec: LSummary2){
            map<string,string> rowdata = new map<string,string>();
            rowdata.put(System.Label.Contract,SRec.area);
            rowdata.put(System.Label.EntrainedFamily,String.valueof(SRec.family));
            rowdata.put(System.Label.MemberCompany,String.valueof(SRec.Company));
            rowdata.put('contractAreaEng',String.valueof(SRec.areaEng));
            
            for(String lmemNum:fieldNameList){
                if(LMemNumSequence == fieldNameList.size()){
                   LMemNumSequence = 0;     
                }            
                rowdata.put(lmemNum,String.valueof(SRec.LMemNum[LMemNumSequence++]));
            }          
            model.data.add(rowdata);
        }
        system.debug(model.data);
        dm.data.add(model);
        
           //summaryContractList = new List<Summary_of_members__c>(); 
           if(model.data!=null){
               for(Map<String,String> rowdataList:model.data){ 
                   summaryDataContract = new Summary_of_members__c();          
                   summaryDataContract.Contract__c = rowdataList.get(System.Label.Contract);
                   summaryDataContract.Family__c = rowdataList.get(System.Label.EntrainedFamily);
                   summaryDataContract.Company__c = rowdataList.get(System.Label.MemberCompany);
                   summaryDataContract.ContractEng__c = rowdataList.get('contractAreaEng');
                   for(String lmemNum:fieldNameList){
                       summaryDataContract.put('data_'+lmemNum+'__c' , rowdataList.get(lmemNum));
                   }    
                   summaryDataContract.RecordTypeId = recordTypeNameIdMap.get('Aggregate_Sheet_Contract');
                   
                   if(oldSummaryOfMemberContractMap.size() > 0){ //not the first time to do the batch update
                      if(oldSummaryOfMemberContractMap.get(summaryDataContract.Contract__c) != null){
                        summary_of_members__c oldSummaryOfMemberContractObj = oldSummaryOfMemberContractMap.get(summaryDataContract.Contract__c);
                        oldSummaryOfMemberContractObj.Contract__c = rowdataList.get(System.Label.Contract);
                        oldSummaryOfMemberContractObj.Family__c = rowdataList.get(System.Label.EntrainedFamily);
                        oldSummaryOfMemberContractObj.Company__c = rowdataList.get(System.Label.MemberCompany);
                        oldSummaryOfMemberContractObj.ContractEng__c = rowdataList.get('contractAreaEng');
                        for(String lmemNum:fieldNameList){
                           oldSummaryOfMemberContractObj.put('data_'+lmemNum+'__c' , rowdataList.get(lmemNum));
                        }        
                        oldSummaryOfMemberContractObj.RecordTypeId = recordTypeNameIdMap.get('Aggregate_Sheet_Contract');           
                        summaryContractList.add(oldSummaryOfMemberContractObj);
                      } 
                   }
                   else{
                       summaryContractList.add(summaryDataContract);
                   }         
              } 
          }    

        /*                    
        LSummary = null;
        MArea = null;
        LSummary2 = null;
        MArea2 = null;   
        */     
   
        //insrt date in 'Summary_of_members__c' object            
        system.debug(summaryContractList);
        system.debug(summaryAffiliationList);
        
        if(summaryAffiliationList != null){
            if(oldSummaryOfMemberAffiliationMap.size() == 0){
                insert summaryAffiliationList;
            }
            else{
                update summaryAffiliationList;
            }
        }
        
        if(summaryContractList != null){
            if(oldSummaryOfMemberContractMap.size() == 0){
                insert summaryContractList;
            }
            else{
                update summaryContractList;
            }       
        } 
        Database.executeBatch(new MDMemberReportUpdateFamilyInfoBatch());
   }
    
   public List<String> getHeaderLabelList(string ListType){
        Map<String, MDMemberHeaders__c> customerSettingMap = MDMemberHeaders__c.getall();
        
        //get all sequence number from custom setting and sort it
        List<Decimal> seqNumber = new List<Decimal>();
        for (MDMemberHeaders__c m:customerSettingMap.values()){
            seqNumber.add(m.Sorting__c);  
            seqNumber.sort();
        }
        
        //add all sorted name and name api in list
        List<String> sortednameList = new List<String>();
        List<String> sortednameApiList = new List<String>();
        for(Decimal gg:seqNumber){
            for (MDMemberHeaders__c y:customerSettingMap.values()){
                if(y.Sorting__c.intValue() == gg.intValue()){
                    sortednameList.add(y.name);
                    sortednameApiList.add(y.FieldName__c);
                }
            }
        } 
        
        //get the api name in the Summary_of_members__c object
        Map<String,Schema.SObjectField> summaryObjMap 
           = Summary_of_members__c.SObjectType.getDescribe().fields.getMap();
        
        //get all label
        List<String> labelList = new List<String>();
            for(String s :summaryObjMap.keySet()){
                if(String.valueOf(s).right(3) == '__c'){
                  labelList.add(summaryObjMap.get(s).getDescribe().getLabel()); 
                }
            }
        
        //compare the custom setting api and the Summary_of_members__c api and sort the label
        List<String> sortedlabelList = new List<String>();
        for(String m:sortednameApiList){
            for(string k:summaryObjMap.keySet()){
                if(m == k){
                    sortedlabelList.add(summaryObjMap.get(k).getDescribe().getLabel());
                }
            }  
        }
        
        system.debug(sortedlabelList);
        if (ListType == 'fieldName'){
            return sortednameList;
        }
        else{
           return sortedlabelList;
        }
   }

    public class SummaryRec{
        public string area {set;get;}
        public string areaEng {set;get;}
        public Integer family {set;get;}
        public Integer company {set;get;}
        public List<Integer> LMemNum {set;get;}
        
        public SummaryRec(String inArea, String inAreaEng){
            area = inArea;
            areaEng = inAreaEng;
            family = 0;
            company = 0;
            LMemNum = new list<Integer>();          
        }
    }    
}