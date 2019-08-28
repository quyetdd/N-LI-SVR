public class RenewalNoticeBatchProcessController
{ 
    public boolean isEnglish {get; set;}  
    public ContractInfo__c pageData {set;get;}
    public ContractInfo__c pageData2 {set;get;}
    public List<ContractInfo__c> searchResults {set;get;}
    private List<SelectOption> m_options {set;get;}
    public string m_selTemplate {set;get;}
    
    public RenewalNoticeBatchProcessController(ApexPages.StandardController con){          
          isEnglish = 'en_US'.equals(UserInfo.getLanguage()); //check profile language      
          pageData = new ContractInfo__c();
          pageData2 = new ContractInfo__c();
          m_options = new List<SelectOption>();
          searchResults = new List<ContractInfo__c>(); 
          List<Document> ls =  new List<Document>();
          
            if(isEnglish){
                ls = [select Id, Name from Document where Folder.Name='Renewal Notice Template_ENG'];
            }
            else{
                ls = [select Id, Name from Document where Folder.Name='Renewal Notice Template_JPN'];
            }
            
            for(integer i=0; i<ls.size(); i++){
              m_options.add(new SelectOption(ls[i].Id, ls[i].Name));
              if(m_selTemplate==null) m_selTemplate = ls[i].Id;
            }                                    
      }
        
     public void search(){
       system.debug(pageData.KeiyakuArea__c);
       system.debug(pageData.MankiDate__c);
       system.debug(pageData2.MankiDate__c);
       system.debug(m_selTemplate);
       
       if(pageData.KeiyakuArea__c!=null && pageData.MankiDate__c!=null && pageData2.MankiDate__c!=null && m_selTemplate!=null){
           searchResults = [SELECT id,KeiyakuArea__c,MankiDate__c,TaikaiDate__c FROM ContractInfo__c WHERE KeiyakuArea__c=: pageData.KeiyakuArea__c AND MankiDate__c >=: pageData.MankiDate__c
           AND MankiDate__c <=: pageData2.MankiDate__c AND (TaikaiDate__c = null OR TaikaiDate__c >= Today)
           ];
           
           // show no result message if no result
           if(searchResults.size() == 0 || searchResults.size() == null){            
                   ApexPages.Message myMsg2 = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.No_Result); 
                   ApexPages.addMessage(myMsg2); 
           }
       }
       else{       
           // check all fields must be filled
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.ErrorMessageSearch);  
               ApexPages.addMessage(myMsg);   
       } 
     }

    public PageReference back(){   
        String id = null;
        if(ApexPages.currentPage().getParameters().get('retURL')!=null){
           id = ApexPages.currentPage().getParameters().get('retURL').right(15); //get pervious page id
        }
        String spaceDelimeted = '/a0A?fcf='+id;
        PageReference reference = new PageReference(spaceDelimeted);
        system.debug(spaceDelimeted );
        reference.setRedirect(true);
        return reference;
    }
     
      public string SelectedTemplate { get { return m_selTemplate; } set { m_selTemplate = value; } }
      public List<SelectOption> TemplateOptions { get { return m_options; } }
}