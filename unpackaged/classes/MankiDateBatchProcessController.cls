public class MankiDateBatchProcessController
{ 
  public boolean isEnglish {get; set;}  
  //public boolean showResults {set;get;}  
  public boolean showResultsBlock {set;get;}  
  //public List<MemberInfo__c> results {set;get;}
  public List<MemberInfo__c> searchResults {set;get;}   
  //public List<ContractInfo__c> mankiDate {set;get;}
  public List<UpdateTable> newSearchResults {set;get;}
  //public String companyKeiyakuNo {set;get;} 
  public ContractInfo__c outputData {set;get;}
  public ContractInfo__c updateData {set;get;}  
  public Account accountData {set;get;}
  public ContractInfo__c thisRecord;
  public List<String> recordName {set;get;} 
  //public String thisRecordName {set;get;} 

    public MankiDateBatchProcessController(ApexPages.StandardController con){
        this.thisRecord = (ContractInfo__c)con.getRecord();
        isEnglish = 'en_US'.equals(UserInfo.getLanguage()); //check profile language 
        newSearchResults = new List<UpdateTable>(); 
        outputData = new ContractInfo__c();
        updateData = new ContractInfo__c();
        accountData = new Account();
        recordName = new List<String>();
        
        List<ContractInfo__c> thisRecordName = [select name from ContractInfo__c where id =:thisRecord.id];
        for(ContractInfo__c a:thisRecordName){
            recordName.add(a.name);
        }
        query(); 
    }
    
     public void query(){
        List<ContractInfo__c> contractList = [select KeiyakuCompanyName__c,KeiyakuCompanyName__r.name,MankiDate__c from ContractInfo__c where name in: recordName]; 
        List<String> keiyakuCompanyName = new List<String>();
        
        for(ContractInfo__c b:contractList){       
            outputData.MankiDate__c = b.MankiDate__c;
            keiyakuCompanyName.add(b.KeiyakuCompanyName__r.name);
            //outputData.KeiyakuCompanyName__r.CompanyNameEng__c = b.KeiyakuCompanyName__r.CompanyNameEng__c;
        }
        
        List<Account> accountList = [select CompanyNameEng__c,name from Account where name in:keiyakuCompanyName];
        if(isEnglish){
            for(Account a:accountList){
                accountData.CompanyNameEng__c = a.CompanyNameEng__c;
            }        
        }else{
            for(Account a:accountList){
                accountData.name = a.name;
            }
        }

            showResultsBlock = true; //tag to show the results 
            searchResults = [select id,MemberNo__c,Name,CompanyKeiyakuNo__c,MankiDate__c,Commodity__c,SeiMeiRoma__c,KinmuCompany__r.CompanyNameEng__c,KinmuCompany__c from memberInfo__c where CompanyKeiyakuNo__r.Name in: recordName and (TaikaiDate__c = null or TaikaiDate__c >= TODAY) and MemberKubunB__c != '退会者' order by KinmuCompany__c,Name];
           
            newSearchResults = new List<UpdateTable>();   // clear all old search data in the search tabl  
            // add records to the newSearchResults list (search result table display in page)
            for(MemberInfo__c a:searchResults){
                UpdateTable records = new UpdateTable();           
                records.memberData = a;        
                newSearchResults.add(records); 
            } 
        

        selectAll();         
     }
   
    public void updateRecord(){       
          
          Boolean checkBoxClicked = false; 
          list<ContractInfo__c> contractMankiDate = [select id,MankiDate__c from ContractInfo__c where name =:recordName];
          for(ContractInfo__c b:contractMankiDate){
             b.MankiDate__c = updateData.MankiDate__c;
          }
                   
          List<MemberInfo__c> updateList = new List<MemberInfo__c>();
          for(UpdateTable c:newSearchResults){         
            if(c.InchargeCheckbox){                       
                if (updateData.MankiDate__c!=null){
                    c.memberData.MankiDate__c = updateData.MankiDate__c;                 
                }                                   
               updateList.add(c.memberData);
               checkBoxClicked = true;
            }                    
         }  
              if(checkBoxClicked == true){
                  update contractMankiDate;
              }
              update updateList; 
              query();      
              releaseAll();
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
    
    //go back to the view list 
    public PageReference back(){     
    /*
        String id = ApexPages.currentPage().getParameters().get('retURL').right(15);
        String spaceDelimeted = '/a08?fcf='+id; 
        PageReference reference = new PageReference(spaceDelimeted);
        reference.setRedirect(true);
    */
        String id = ApexPages.currentPage().getParameters().get('id');
        String spaceDelimeted = id; 
        PageReference reference = new PageReference('/'+spaceDelimeted);
        reference.setRedirect(true);    
    
        return reference;
    }

     public class UpdateTable {
         public Boolean InchargeCheckbox {set;get;}
         public MemberInfo__c memberData {set;get;}
         public ContractInfo__c contractData {set;get;}
    } 

}