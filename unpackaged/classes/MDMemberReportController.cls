public with SHARING class MDMemberReportController {
  public DataModel dm {get;set;}
  public String body {set;get;}
  public boolean isEnglish {get; set;}
  
  public MDMemberReportController(){
  
        //check profile language
        isEnglish = 'en_US'.equals(UserInfo.getLanguage()); 
        System.debug('isEnglish:' + isEnglish);
        
        List<String> fieldNameList = getHeadernameApiList('fieldName');
        List<String> labelList = getHeaderLabelList();
        List<String> modelHeadersAffiliationList = new List<String>();
        Map<String,String> mapFieldNameToLabelMap = new Map<String,String>();
        
        // map fields name in a label map
         mapFieldNameToLabelMap.put(System.Label.AffiliationArea,System.Label.AffiliationArea);
         mapFieldNameToLabelMap.put(System.Label.EntrainedFamily,System.Label.EntrainedFamily);
         mapFieldNameToLabelMap.put(System.Label.MemberCompany,System.Label.MemberCompany);
         mapFieldNameToLabelMap.put(System.Label.Contract,System.Label.Contract);
               
         system.debug(mapFieldNameToLabelMap);      
               
        for(String fieldName:fieldNameList){
            mapFieldNameToLabelMap.put(fieldName,mapFieldNameToLabel(fieldName));
        }  
        
        system.debug(mapFieldNameToLabelMap);

        dm = new DataModel();
        dm.data = new list<DataModel.Model>();       
        DataModel.Model model = new DataModel.Model();
        model.sheetname = System.Label.AggregateSheetAffiliation;
        //model.sheetname = '集計シート（所属）';
        //model.headers = new list<string>{'所属地区','帯同家族','会員企業','S','F','M','H','SC','FC','MC','SCV','FCV','MCV','SA','FA','MA','SX','FX','MX'};
        model.data = new list<map<string,string>>();
        modelHeadersAffiliationList.add(System.Label.AffiliationArea);
        modelHeadersAffiliationList.add(System.Label.EntrainedFamily);
        modelHeadersAffiliationList.add(System.Label.MemberCompany);   


        
        for(String mcodeType:fieldNameList){
            modelHeadersAffiliationList.add(mcodeType);
        }        
        
        model.headers = modelHeadersAffiliationList;        
             
        //get all fields' string in Summary_of_members__c object     
        String allSummaryMemberFields = getAllSummaryMemberFields();  
 
        //List<Summary_of_members__c> LSummaryList = [select Area__c,Company__c,Contract__c,F__c,FA__c,Family__c,FC__c,FCV__c,H__c,M__c,MA__c,MC__c,MCV__c,S__c,SA__c,SC__c,SCV__c from Summary_of_members__c where recordtype.id ='012N00000004dx5IAA'];
        List<Summary_of_members__c> LSummaryList =  Database.query('SELECT '+allSummaryMemberFields+' FROM Summary_of_members__c where recordtype.developername =\'Aggregate_Sheet_Affiliation\'');
               
        for(Summary_of_members__c m:LSummaryList){
            map<string,string> rowdata = new map<string,string>();
            
            if(isEnglish){
                rowdata.put(System.Label.AffiliationArea,m.AreaEng__c);
            }
            else{
                rowdata.put(System.Label.AffiliationArea,m.Area__c);
            }
            rowdata.put(System.Label.EntrainedFamily,m.Family__c);
            rowdata.put(System.Label.MemberCompany,m.Company__c);            
                     
            for(String fieldName:fieldNameList){             
                //rowdata.put(mapFieldNameToLabelMap.get(fieldName),String.valueOf(m.get('data_'+fieldName+'__c')));
                rowdata.put(fieldName,String.valueOf(m.get('data_'+fieldName+'__c')));
            }
            
            /*
            rowdata.put('Single',m.data_S__c);
            rowdata.put('F',m.data_F__c);
            rowdata.put('M',m.data_M__c);
            rowdata.put('H',m.data_H__c);
            rowdata.put('SC',m.data_SC__c);
            rowdata.put('FC',m.data_FC__c);
            rowdata.put('MC',m.data_MC__c);
            rowdata.put('SCV',m.data_SCV__c);
            rowdata.put('FCV',m.data_FCV__c);
            rowdata.put('MCV',m.data_MCV__c);
            rowdata.put('SA',m.data_SA__c);
            rowdata.put('FA',m.data_FA__c);
            rowdata.put('MA',m.data_MA__c);
            rowdata.put('SX','0');
            rowdata.put('FX','0');
            rowdata.put('MX','0');            
            */
            model.data.add(rowdata);
        }        
        dm.data.add(model);
    
        List<String> modelHeadersContractList = new List<String>(); 
        model = new DataModel.Model();
        model.sheetname = System.Label.AggregateSheetContract;
        //model.sheetname = '集計シート（契約）';
        //model.headers = new list<string>{'契約','帯同家族','会員企業','S','F','M','H','SC','FC','MC','SCV','FCV','MCV','SA','FA','MA','SX','FX','MX'};

        
        modelHeadersContractList.add(System.Label.Contract);
        modelHeadersContractList.add(System.Label.EntrainedFamily);
        modelHeadersContractList.add(System.Label.MemberCompany);
        /*
        for(String mcodeType:labelList){
            modelHeadersContractList.add(mcodeType);
        }       
        */
        
        for(String mcodeType:fieldNameList){
            modelHeadersContractList.add(mcodeType);
        }               
        
        
        model.headers = modelHeadersContractList;
         
        allSummaryMemberFields = getAllSummaryMemberFields();  //get all fiels string in Summary_of_members__c object
        model.data = new list<map<string,string>>();
        //List<Summary_of_members__c> LSummaryList2 = [select Area__c,Company__c,Contract__c,F__c,FA__c,Family__c,FC__c,FCV__c,H__c,M__c,MA__c,MC__c,MCV__c,S__c,SA__c,SC__c,SCV__c from Summary_of_members__c where recordtype.id ='012N00000004dx0IAA'];
        
        List<Summary_of_members__c> LSummaryList2 =  Database.query('SELECT '+allSummaryMemberFields+' FROM Summary_of_members__c where recordtype.developername =\'Aggregate_Sheet_Contract\'');
       
        for(Summary_of_members__c m:LSummaryList2){
            map<string,string> rowdata = new map<string,string>();
            
            if(isEnglish){
                rowdata.put(System.Label.Contract,m.ContractEng__c);
            }
            else{
                rowdata.put(System.Label.Contract,m.Contract__c);
            }
            rowdata.put(System.Label.EntrainedFamily,m.Family__c);
            rowdata.put(System.Label.MemberCompany,m.Company__c);            
            
            for(String fieldName:fieldNameList){                
                //rowdata.put(mapFieldNameToLabelMap.get(fieldName),String.valueOf(m.get('data_'+fieldName+'__c')));
                rowdata.put(fieldName,String.valueOf(m.get('data_'+fieldName+'__c')));
            }
            
            
            /*
            rowdata.put('Single',m.data_S__c);
            rowdata.put('Family',m.data_F__c);
            rowdata.put('M',m.data_M__c);
            rowdata.put('H',m.data_H__c);
            rowdata.put('SC',m.data_SC__c);
            rowdata.put('FC',m.data_FC__c);
            rowdata.put('MC',m.data_MC__c);
            rowdata.put('SCV',m.data_SCV__c);
            rowdata.put('FCV',m.data_FCV__c);
            rowdata.put('MCV',m.data_MCV__c);
            rowdata.put('SA',m.data_SA__c);
            rowdata.put('FA',m.data_FA__c);
            rowdata.put('MA',m.data_MA__c);
            rowdata.put('SX','0');
            rowdata.put('FX','0');
            rowdata.put('MX','0');  
            rowdata.put('XXX',m.data_XXX__c);   
            */   
            model.data.add(rowdata);          
        }          
        dm.data.add(model);
    
        Document src = null; 
        List<Document> srcList = new List<Document>();         
        if(isEnglish){       
            srcList = [Select name, body from document where DeveloperName = 'MD_Member_Template_English' limit 1];      
        }
        else{
            srcList = [Select name, body from document where DeveloperName = 'MD_Member_Template' limit 1];
        }
        
        if(srcList.size() != 0){
            src = srcList[0];
            Body = src.body.toString();          
        }
    
        src = null;
                
        if(Body==null) Body = ' {%DUMMY%}<Row>{%REPEAT-START:DUMMY%}</Row> <Row>{%REPEAT-END:DUMMY%}</Row> ';
        
        if(Test.isRunningTest()){
            Body = '{%DUMMY%}<Row>{%REPEAT-START:DUMMY%}</Row> <Row>{%REPEAT-END:DUMMY%}{%DUMMY%}<Row>{%REPEAT-START:DUMMY%}</Row> <Row>{%REPEAT-END:DUMMY%}{%DUMMY%}<Row>{%REPEAT-START:DUMMY%}</Row> <Row>{%REPEAT-END:DUMMY%}{%DUMMY%}<Row>{%REPEAT-START:DUMMY%}</Row> <Row>{%REPEAT-END:DUMMY%}';
        }
        
        Integer WSNum = 3;
        if(Body != null){     
        }
        
        for(DataModel.Model m : dm.data){          
          FindMergeResult r = FindMerge(body,m.sheetname);
 
        if(Test.isRunningTest()){
           r = FindMerge('12345678901"s234"><Data ss:Type="String">"><Data ss:Type="DateTime"><Worksheet ss:Name="123">{%DUMMY%}<Row>{%REPEAT-START:DUMMY%}</Row> <Row>{%REPEAT-END:DUMMY%}</Worksheet>','123');
        } 
                 
          if(r!=null){
            String s ='\r\n <Table ss:ExpandedColumnCount="'+ String.valueof(m.headers.size()) +
              '" ss:ExpandedRowCount="' + String.valueof(m.data.size()+2) +'" x:FullColumns="1" x:FullRows="1">\r\n';
            s += '  <Column ss:Index="'+ m.headers.size() +'" ss:AutoFitWidth="0" ss:Width="154"/>\r\n';
            s += '  <Row ss:AutoFitHeight="0" ss:Height="15">\r\n';
            //Enter Date
            if(r.dateStyle != -1){
            s += '   <Cell ss:MergeAcross="1" ss:StyleID="s'+ r.dateStyle +'"><Data ss:Type="DateTime">'+
               String.valueof(date.today().year()) +'-';
            if(date.today().month()<10)
              s+= '0';
            s += String.valueof(date.today().month())+ '-';
            if(date.today().day()<10)
              s+='0'; 
            s += String.valueof(date.today().day()) +'T00:00:00.000</Data></Cell>\r\n';
            }
            s += '  </Row>\r\n';
            // Enter header
            s += '  <Row ss:StyleID="s'+ r.headerStyle +'">\r\n';
            for(string header : m.headers){
              s += '   <Cell><Data ss:Type="String">'+ mapFieldNameToLabelMap.get(header) +'</Data></Cell>\r\n';
            }
            s += '  </Row>\r\n';
            // Enter value by row
            for(map<string,string> row : m.data){
              s += '  <Row>\r\n';
              for(string header : m.headers){
                s += '   <Cell><Data ss:Type="';
                if(header == System.Label.AffiliationArea || header == System.Label.Contract)
                  s += 'String';
                else
                  s += 'Number';
                s += '">' + row.get(header) +'</Data></Cell>\r\n';           
              }
              s += '  </Row>\r\n';
            }
            
            //Enter Remaining Setting
            s += ' </Table>\r\n';
          s += ' <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">\r\n';
          s += '  <Print>\r\n';
          s += '   <ValidPrinterInfo/>\r\n';
          s += '   <HorizontalResolution>300</HorizontalResolution>\r\n';
          s += '   <VerticalResolution>300</VerticalResolution>\r\n';
          s += '  </Print>\r\n';
          s += '  <ProtectObjects>False</ProtectObjects>\r\n';
          s += '  <ProtectScenarios>False</ProtectScenarios>\r\n';
          s += ' </WorksheetOptions>\r\n';
          system.debug('r.istart:'+r.istart);
          system.debug('r.iend:'+r.iend);
          system.debug('Body:'+Body);
            Body = Body.substring(0, r.istart) + s + Body.substring(r.iend);           
          }
          WSNum++;
        }              
    }
    
    private FindMergeResult FindMerge(string s, string sheetName)
    {
        string startTag = '<Worksheet ss:Name="' + sheetName + '">'; 
        
        integer p1 = s.indexOf(startTag);
        if(p1<0) return null;
        
        integer temp = s.indexOf('"><Data ss:Type="DateTime">',p1);
        integer stemp = s.indexOf('"s',temp-10);
        integer etemp = s.indexOf('">',temp-10);
        //system.assertEquals(stemp+2,etemp);
        system.debug('temp : '+temp );
        system.debug('stemp: '+stemp );
        system.debug('etemp: '+etemp );        
        integer ds = -1;
        if(stemp+2<etemp)
          /*integer*/ ds = Integer.valueof(s.substring(stemp+2,etemp));
        /*else
          integer ds = -1;
        */
        temp = s.indexOf('"><Data ss:Type="String">',p1);
        stemp = s.indexOf('"s',temp-10);
        etemp = s.indexOf('">',temp-10);
        
        system.debug('temp : '+temp );
        system.debug('stemp: '+stemp );
        system.debug('etemp: '+etemp );   
        
        integer hs = Integer.valueof(s.substring(stemp+2,etemp));
        
        //if(ds == -1)
        //  ds = hs;
        system.debug('P1:'+p1);
        
        integer p2 = s.indexOf('</Worksheet>', p1);
        
        system.debug('P2:'+p2);
        if(p2<0) return null;

        //string mergeName = s.substring(p1+2, p2);
        
        return new FindMergeResult(p1+startTag.length(), p2, hs, ds);
    } 
    
    private class FindMergeResult
    {
        public integer istart;
        public integer iend;
        public integer headerStyle;
        public integer DateStyle;
        public FindMergeResult(integer istart, integer iend, integer hs, integer ds)
        {
            this.istart = istart;
            this.iend = iend;
            this.headerStyle = hs;
            this.DateStyle = ds;
        }
    }
   
    public String mapFieldNameToLabel(String fieldname){
       //get the api name in the Summary_of_members__c object
        Map<String,Schema.SObjectField> summaryObjMap 
           = Summary_of_members__c.SObjectType.getDescribe().fields.getMap();
               
            String labelString = null;
            for(String s :summaryObjMap.keySet()){
                if(String.valueOf(s).right(3) == '__c' && String.valueOf(s).left(5) == 'data_'){
                      string cutLast = s.Substring(0,s.length()-3);
                      string cutFirstLast = cutLast.Substring(5,cutLast.length());
                        if (cutFirstLast == fieldname){
                            labelString = summaryObjMap.get(s).getDescribe().getLabel();  
                        }      
                }
            }
        return labelString;
    }
 
   //function to get the label list in Summary_of_members__c object
   public List<String> getHeaderLabelList(){
        List<String> sortednameApiList = getHeadernameApiList('fieldApiName');
                       
        //get the api name in the Summary_of_members__c object
        Map<String,Schema.SObjectField> summaryObjMap 
           = Summary_of_members__c.SObjectType.getDescribe().fields.getMap();
        
        //get all label
        List<String> labelList = new List<String>();
            for(String s :summaryObjMap.keySet()){
                if(String.valueOf(s).right(3) == '__c' && String.valueOf(s).left(5) =='data_'){
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
            return sortedlabelList;     
   }
   
   public List<String> getHeadernameApiList(string ListType){
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
        system.debug(sortednameList);
        system.debug(sortednameApiList);
        
            if (ListType == 'fieldName'){
                return sortednameList;
            }
            else{
                return sortednameApiList;    
            }                  
   }   
   
    public String getAllSummaryMemberFields(){
        //get object fields
        List<String> fieldList = new List<String>(Schema.getGlobalDescribe().get('Summary_of_members__c').getDescribe().fields.getMap().keySet());
      
        List<String> cuttedfieldList = new List<String>();
        for(String k:fieldList){
            if(k.right(3)=='__c'){
                cuttedfieldList.add(k);
            }
        }

        String fields = String.join(cuttedfieldList,',');
        return fields;
    }         
/*
  @isTest
  static void testController(){
    test.startTest();
    PageReference testpage = page.MDMemberReport;
    MDMemberReportController cont1 = new MDMemberReportController();
    test.stopTest();
  }
*/

}