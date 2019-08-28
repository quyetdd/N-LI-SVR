public class NewRenewalBatchProcessController
{ 

  public boolean isEnglish {get; set;}
  
  private ApexPages.StandardController m_con;
  
  private string m_selTemplate = '';
  private List<SelectOption> m_options = new List<SelectOption>();
    
  public string SelectedTemplate { get { return m_selTemplate; } set { m_selTemplate = value; } }
  public List<SelectOption> TemplateOptions { get { return m_options; } }
  public string SessionId { get { return UserInfo.getSessionId(); } }    
    
  public ContractInfo__c searchData {set;get;}  
  public ContractInfo__c searchData2 {set;get;}  

  public List<UpdateTable> newSearchResults {set;get;}
  public boolean showResultsBlock {set;get;}

  private integer refreshMode = 0;    
  private integer totalRecs = 0;
  private integer OffsetSize = 0;
  private integer LimitSize = 1000;
  private String sqlCriteria = ''; 
    
  public boolean isShowOverRecordAlert {get; set;}
  
  
  private string m_excelPath = '';
  public string ExcelPath { get { return m_excelPath; } set { m_excelPath = value; } }

  public NewRenewalBatchProcessController(ApexPages.StandardController con)
  {
    m_con = con;
    isEnglish = 'en_US'.equals(UserInfo.getLanguage()); //check profile language
    System.debug('isEnglish:' + isEnglish);
    
    //temp search variable  
    searchData = new ContractInfo__c();  
    searchData2 = new ContractInfo__c();
	newSearchResults = new List<UpdateTable>();
	m_excelPath = Excel_Gen__c.getvalues('Default').Destination_Path__c;
      
    //template option
    List<Document> ls =  new List<Document>();
    if(isEnglish)
    {
        ls = [select Id, Name from Document where Folder.Name='Renewal Notice Template_ENG'];
    }
    else
    {
        ls = [select Id, Name from Document where Folder.Name='Renewal Notice Template_JPN'];
    }
    
    for(integer i=0; i<ls.size(); i++)
    {
      m_options.add(new SelectOption(ls[i].Id, ls[i].Name));
      if(m_selTemplate=='') m_selTemplate = ls[i].Id;
    }
      
  }
  
  public void Init()
  {
  }
  

  
  
  public List<SelectOption> getKeiyakuAreas()
  {
   List<SelectOption> options = new List<SelectOption>();
        
   Schema.DescribeFieldResult fieldResult = ContractInfo__c.KeiyakuArea__c.getDescribe();
   List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
      if(isEnglish){
      	options.add(new SelectOption('','--None--'));
      }else{
      	options.add(new SelectOption('','--なし--'));          
      }
   for( Schema.PicklistEntry f : ple)
   {
      options.add(new SelectOption(f.getValue(), f.getLabel()));
   }       
   return options;
  }  
     
  public class UpdateTable {
  	public Boolean InchargeCheckbox {set;get;}
    public ContractInfo__c contractData {set;get;}
  } 
    
  public void selectAll(){
      for(UpdateTable b:newSearchResults){
          b.InchargeCheckbox = true;
      }         
  }
    
  public void releaseAll(){
      for(UpdateTable b:newSearchResults){
          b.InchargeCheckbox = false;
      }      
  }
    
  public void closeSearchTable(){
        showResultsBlock = false;       
  }   
    
  public void query(){
  
      	ApexPages.getMessages().clear();
      
        isShowOverRecordAlert = false;
    	
        //System.debug('searchData.MankiDate__c:' + searchData.MankiDate__c);
    	//System.debug('searchData.KeiyakuArea__c:' + searchData.KeiyakuArea__c);
    	
    	//System.debug('searchData.ImportCntractNo__c:' + searchData.ImportCntractNo__c);
    	//System.debug('searchData2.ImportCntractNo__c:' + searchData2.ImportCntractNo__c);
    	
    	//System.debug('searchData.EigyoTanto__c:' + searchData.EigyoTanto__c);
    	
    	/*
    	//not check date of expire
    	if(searchData.MankiDate__c==null){
    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.PleaseEnterDateOfExpire));
    		return;
    	}
    	*/
    	
    	String sql = 'select count() from ContractInfo__c';
    	String tmp = '';				
    	if(searchData.MankiDate__c!=null){
    		if(tmp!=''){
    		}else{
    			tmp = tmp +' where ';
    		}
    		Integer y = searchData.MankiDate__c.year();
    		Integer m = searchData.MankiDate__c.month();
    		Integer d = searchData.MankiDate__c.day();
    		DateTime DT = DateTime.newInstance(y, m, d);
    		//tmp = tmp + 'MankiDate__c = '+DT.format('YYYY-MM-dd'); 2018-10-09
            tmp = tmp + 'MankiDate__c = '+DT.format('yyyy-MM-dd');
    	}	
    	if(!String.isEmpty(searchData.KeiyakuArea__c)){
    		if(tmp!=''){
    			tmp = tmp +' and ';
    		}else{
    			tmp = tmp +' where ';
    		}
    		tmp = tmp + 'KeiyakuArea__c = \''+searchData.KeiyakuArea__c+'\'';
    	}
    	if(!String.isEmpty(searchData.EigyoTanto__c)){
    		if(tmp!=''){
    			tmp = tmp +' and ';
    		}else{
    			tmp = tmp +' where ';
    		}
    		tmp = tmp + 'EigyoTanto__c = \''+searchData.EigyoTanto__c+'\'';
    	}
    	
    	if(!String.isEmpty(searchData.ImportCntractNo__c)){
    		if(tmp!=''){
    			tmp = tmp +' and ';
    		}else{
    			tmp = tmp +' where ';
    		}
    		tmp = tmp + 'ContractNumVal__c >= '+searchData.ImportCntractNo__c;
    	}	
    	if(!String.isEmpty(searchData2.ImportCntractNo__c)){
    		if(tmp!=''){
    			tmp = tmp +' and ';
    		}else{
    			tmp = tmp +' where ';
    		}
    		tmp = tmp + 'ContractNumVal__c <= '+searchData2.ImportCntractNo__c;
    	}
    	
    	sqlCriteria = tmp;
		sql = sql + tmp;
		System.debug('sql:' + sql);
    	Integer queryCount = Database.countQuery(sql);
    	System.debug('queryCount:' + queryCount);
		
		totalRecs = queryCount;
		
		refresh();
      
      if(totalRecs>1000){
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, Label.OverRecords));
      }
      
     } 
    
   
  public void refresh(){
      	ApexPages.getMessages().clear();

        List<ContractInfo__c> contractList = null;
        
        String sql = 'select Id,toLabel(KeiyakuArea__c),Name,KeiyakuCompanyName__c,KeiyakuCompanyName__r.CompanyCd__c,KeiyakuCompanyName__r.name,MankiDate__c,KeiyakuCompanyName__r.EigyoTanto__c,KeiyakuCompanyName__r.NaimuTanto__c,EigyoTanto__c,NaimuTanto__c  from ContractInfo__c';
        sql = sql + sqlCriteria; 
        sql = sql + ' LIMIT :LimitSize OFFSET :OffsetSize';
        
        System.debug('sql:' + sql);
        contractList = Database.query(sql);
        System.debug('contractList:' + contractList);

        showResultsBlock = true; //tag to show the results 
      	if(newSearchResults!=null){
          newSearchResults.clear();
      	}
        newSearchResults = new List<UpdateTable>();   // clear all old search data in the search table  
        
        for(ContractInfo__c c:contractList){
    	  UpdateTable records = new UpdateTable();     
	      records.contractData = c;        
		  newSearchResults.add(records);
        }   
      
      
     }  
    
    public void FirstPage()
    {
    	OffsetSize = 0;
        refresh();
    }
    public void previous()
    {
    	OffsetSize = OffsetSize - LimitSize;
        refresh();
    }
    public void next()
    {
    	OffsetSize = OffsetSize + LimitSize;
        refresh();
    }
    public void LastPage()
    {
    	OffsetSize = totalRecs - math.mod(totalRecs,LimitSize);
        refresh();
    }
    public boolean getprev()
    {
        if(OffsetSize == 0)
        	return true;
        else
        	return false;
    }
    public boolean getnxt()
    {
        if((OffsetSize + LimitSize) > totalRecs)
        	return true;
        else
        	return false;
    }
    
public String level {get; set;}
public String message {get; set;}

public void showPageMessage() {
  if(level == 'FATAL') {
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, message));
  } if(level == 'ERROR') {
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, message));
  } if(level == 'WARNING') {
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, message));
  } if(level == 'INFO') {
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
  } if(level == 'CONFIRM') {
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, message));
  }
}
public void clearPageMessage() {
   ApexPages.getMessages().clear();
}
    

}