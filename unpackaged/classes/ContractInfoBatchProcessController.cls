public class ContractInfoBatchProcessController
{ 
  public boolean isEnglish {get; set;}  
  public boolean showResultsBlock {set;get;}  
  public date PresentInsuranceShiki{set;get;}   
  public List<ContractInfo__c> results {set;get;}
  public List<ContractInfo__c> searchResults {set;get;}
  public List<UpdateTable> newSearchResults {set;get;}
  public ContractInfo__c inputLookUp{set;get;}
  public String KeiyakuArea{set;get;}
  public String EigyoTanto{set;get;}
  public String NaimuTanto{set;get;}
  
  public Account accountDataFromPage{set;get;}
  public ContractInfo__c contractDataFromPage{set;get;}

    public ContractInfoBatchProcessController(ApexPages.StandardController con)
    {  
        showResultsBlock = false;
        isEnglish = 'en_US'.equals(UserInfo.getLanguage()); //check profile language
        this.contractDataFromPage = new ContractInfo__c ();
        this.accountDataFromPage = new Account();
        inputLookUp = new ContractInfo__c();
        newSearchResults = new List<UpdateTable>(); 
    }
    
    public ContractInfoBatchProcessController(ApexPages.StandardSetController controller) {
        showResultsBlock = false;
        isEnglish = 'en_US'.equals(UserInfo.getLanguage()); //check profile language
        this.contractDataFromPage = new ContractInfo__c ();
        this.accountDataFromPage = new Account();
        inputLookUp = new ContractInfo__c();
        newSearchResults = new List<UpdateTable>(); 
    }

    public void search(){
        //get input date from look up fields
        KeiyakuArea = contractDataFromPage.KeiyakuArea__c;
        //20180502 EigyoTanto = accountDataFromPage.EigyoTanto__c;
        //20180502 NaimuTanto = accountDataFromPage.NaimuTanto__c;
        EigyoTanto = contractDataFromPage.EigyoTanto__c;
        NaimuTanto = contractDataFromPage.NaimuTanto__c;
        //run soql query 
        query(EigyoTanto, NaimuTanto);
    }
    //&& EigyoTanto!=null && NaimuTanto!=null
    public void query(String EigyoTanto, String NaimuTanto){
        if(KeiyakuArea != null){
        showResultsBlock = true; //tag to show the results 
        /*
        searchResults = [select KeiyakuCompanyName__r.EigyoTanto__r.SeiRoma__c,KeiyakuCompanyName__r.EigyoTanto__r.MeiRoma__c,KeiyakuCompanyName__r.NaimuTanto__r.SeiRoma__c,KeiyakuCompanyName__r.NaimuTanto__r.MeiRoma__c,KeiyakuCompanyName__r.EigyoTanto__r.SeiMeiRoma__c,KeiyakuCompanyName__r.NaimuTanto__r.SeiMeiRoma__c, NaimuTanto__r.SeiMeiRoma__c,EigyoTanto__r.SeiMeiRoma__c,KeiyakuCompanyName__r.CompanyNameEng__c,KeiyakuArea__c,KeiyakuCompanyName__r.EigyoTanto__c,EigyoTanto__c,KeiyakuCompanyName__r.NaimuTanto__c,NaimuTanto__c,KeiyakuCompanyName__r.Jurisdiction__c,KeiyakuCompanyName__r.CompanyCd__c,KeiyakuCompanyName__c,MankiDate__c,TaikaiDate__c from ContractInfo__c
        where KeiyakuArea__c =:KeiyakuArea and (KeiyakuCompanyName__r.EigyoTanto__c =:EigyoTanto or KeiyakuCompanyName__r.EigyoTanto__c =null) and (KeiyakuCompanyName__r.NaimuTanto__c =:NaimuTanto or KeiyakuCompanyName__r.NaimuTanto__c = null) and TaikaiDate__c = null order by KeiyakuCompanyName__r.Jurisdiction__c,KeiyakuCompanyName__r.EigyoTanto__c,KeiyakuCompanyName__r.NaimuTanto__c,KeiyakuCompanyName__r.CompanyCd__c];
        */
        String soql = 'select id,KeiyakuCompanyName__r.EigyoTanto__r.SeiRoma__c,KeiyakuCompanyName__r.EigyoTanto__r.MeiRoma__c,KeiyakuCompanyName__r.NaimuTanto__r.SeiRoma__c,KeiyakuCompanyName__r.NaimuTanto__r.MeiRoma__c,KeiyakuCompanyName__r.EigyoTanto__r.SeiMeiRoma__c,KeiyakuCompanyName__r.NaimuTanto__r.SeiMeiRoma__c, NaimuTanto__r.SeiMeiRoma__c,EigyoTanto__r.SeiMeiRoma__c,KeiyakuCompanyName__r.CompanyNameEng__c,KeiyakuArea__c,KeiyakuCompanyName__r.EigyoTanto__c,EigyoTanto__c,KeiyakuCompanyName__r.NaimuTanto__c,NaimuTanto__c,KeiyakuCompanyName__r.Jurisdiction__c,KeiyakuCompanyName__r.CompanyCd__c,KeiyakuCompanyName__c,MankiDate__c,TaikaiDate__c from ContractInfo__c where KeiyakuArea__c =\'' +KeiyakuArea+'\' and TaikaiDate__c = null';
        if(EigyoTanto!=null){
            //20180502 soql = soql + ' and KeiyakuCompanyName__r.EigyoTanto__c = '+'\''+EigyoTanto+'\'';
            soql = soql + ' and EigyoTanto__c = '+'\''+EigyoTanto+'\'';
        }
        if(NaimuTanto!=null){
            //20180502 soql = soql + ' and KeiyakuCompanyName__r.NaimuTanto__c = '+'\''+NaimuTanto+'\'';
            soql = soql + ' and NaimuTanto__c = '+'\''+NaimuTanto+'\'';
            }
        
        soql = soql + ' order by KeiyakuCompanyName__r.Jurisdiction__c,KeiyakuCompanyName__r.EigyoTanto__c,KeiyakuCompanyName__r.NaimuTanto__c,KeiyakuCompanyName__r.CompanyCd__c';
        system.debug(soql);
        
        searchResults = Database.query(soql);
        system.debug(searchResults );
        newSearchResults = new List<UpdateTable>();   // clear all old search data in the search tabl
        
          // add records to the newSearchResults list (search result table display in page)
          for(ContractInfo__c a:searchResults){
            UpdateTable records = new UpdateTable();           
            records.ContractInfoData = a;        
            newSearchResults.add(records);  
          }        
        }
        else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.ErrorMessageSearch);  
            ApexPages.addMessage(myMsg);       
        }     
    }
     
    public void updateRecord(){
      List<ContractInfo__c> updateList = new List<ContractInfo__c>();
      List<Id> accountCompanyIdList = new List<Id>();
      List<ContractInfo__c> contractDataList = new List<ContractInfo__c>();
      
      for(UpdateTable c:newSearchResults){   
         if(c.InchargeCheckbox){          
             accountCompanyIdList.add(c.ContractInfoData.Id);     
         }           
      }                                 
        
       //20180502  contractDataList  = [select EigyoTanto__r.SeiMeiRoma__c,NaimuTanto__r.SeiMeiRoma__c from ContractInfo__c where id in: accountCompanyIdList];
        contractDataList  = [select id, EigyoTanto__r.SeiMeiRoma__c,NaimuTanto__r.SeiMeiRoma__c, EigyoTanto__c, NaimuTanto__c from ContractInfo__c where id in: accountCompanyIdList];
        for(ContractInfo__c d:contractDataList){                
            if (inputLookUp.EigyoTanto__c!=null){
                d.EigyoTanto__c = inputLookUp.EigyoTanto__c;
            }           
            if(inputLookUp.NaimuTanto__c!=null){
                d.NaimuTanto__c = inputLookUp.NaimuTanto__c;
            }
        }                
        update contractDataList;    
        search();    
        //query(inputLookUp.EigyoTanto__c, inputLookUp.NaimuTanto__c); //update the newSearchResults list for update the changed result table
    }      
      
    public void selectAll (){
        for(UpdateTable b:newSearchResults){
         b.InchargeCheckbox = true;
        }
    }
    
    public void releaseAll (){
        for(UpdateTable b:newSearchResults){
         b.InchargeCheckbox = false;
        }  
    } 
 
    public void closeSearchTable(){
        showResultsBlock = false;    
    } 
    
    //go back to the view list 
    public PageReference back(){    
        String id= null;
        if(ApexPages.currentPage().getParameters().get('retURL')!=null){
            id = ApexPages.currentPage().getParameters().get('retURL').right(15);
        }
        system.debug(id);
        String spaceDelimeted = '/a0A?fcf='+id;
        PageReference reference = new PageReference(spaceDelimeted );
        system.debug(spaceDelimeted );
        reference.setRedirect(true);
        return reference;
    }

    public class UpdateTable {
        public Boolean InchargeCheckbox {set;get;}
        public ContractInfo__c ContractInfoData {set;get;}
    }
}