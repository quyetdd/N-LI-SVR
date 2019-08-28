public class CompanyBatchProcessController
{ 
  public boolean isEnglish {get; set;}  
  public boolean showResults {set;get;}  
  public date PresentInsuranceShiki{set;get;}   
  public List<Account> results {set;get;}
  public List<Account> searchResults {set;get;}
  public List<UpdateTable> newSearchResults {set;get;}
  public Account inputLookUp{set;get;}
  public String CountryName{set;get;}
  public String Jurisdiction{set;get;}
  public String ShozokuArea{set;get;}
  public String EigyoTanto{set;get;}
  public String NaimuTanto{set;get;}
  public String BlEigyoTanto{set;get;}  
  public Account cs;
  Account inputData = new Account();
    
  // 20160920
  public String Region_and_Area{set;get;}
  public String SelectedRegion_and_Area{set;get;}
  public String SelectedCountryName{set;get;}
  public String SelectedJurisdiction{set;get;}
  public String SelectedShozokuArea{set;get;}
  //20170207
  public String SelectedEigyoTanto{set;get;}
  public SelectOption[] EigyoTantoOptions {get;set;}
  public String SelectedNaimuTanto{set;get;}
  public SelectOption[] NaimuTantoOptions {get;set;}
  public String SelectedBlEigyoTanto{set;get;}
  public SelectOption[] BlEigyoTantoOptions {get;set;}
      
    public CompanyBatchProcessController(ApexPages.StandardController con)
    {  
        isEnglish = 'en_US'.equals(UserInfo.getLanguage()); //check profile language
        this.cs = (Account) con.getRecord();
        showResults = false;
        inputLookUp = new Account();
        newSearchResults = new List<UpdateTable>(); 
        //20160920
        Region_and_AreaOptions = new SelectOption[]{}; 
          getRegion_and_AreaOptions();
        CountryNameOptions = new SelectOption[]{}; 
            getCountryNameOptions();
        JurisdictionOptions = new SelectOption[]{}; 
            getJurisdictionOptions();
        ShozokuAreaOptions = new SelectOption[]{}; 
            getShozokuAreaOptions();
        EigyoTantoOptions = getEigyoTantoOptions();
        NaimuTantoOptions = getNaimuTantoOptions();
        BlEigyoTantoOptions = getBlEigyoTantoOptions();
    }
     
      
    public CompanyBatchProcessController(ApexPages.StandardSetController controller) {
 
        isEnglish = 'en_US'.equals(UserInfo.getLanguage()); //check profile language
       // this.cs = (Account) controller.getRecord();
        showResults = false;
        inputLookUp = new Account();
        newSearchResults = new List<UpdateTable>(); 
        Region_and_AreaOptions = new SelectOption[]{}; 
          getRegion_and_AreaOptions();
        CountryNameOptions = new SelectOption[]{}; 
            getCountryNameOptions();
        JurisdictionOptions = new SelectOption[]{}; 
            getJurisdictionOptions();
        ShozokuAreaOptions = new SelectOption[]{}; 
            getShozokuAreaOptions();
        EigyoTantoOptions = getEigyoTantoOptions();
        NaimuTantoOptions = getNaimuTantoOptions();
        BlEigyoTantoOptions = getBlEigyoTantoOptions();
    }
    
    public void fetchEigyoTantoOptions(){
        EigyoTantoOptions=getEigyoTantoOptions();
        fetchBlEigyoTantoOptions();
        fetchNaimuTantoOptions();
    }
    
    public SelectOption[] getEigyoTantoOptions(){
        List<SelectOption>  opt = new  List<SelectOption>();
        opt.add(new SelectOption('','-None-'));  
        if (! String.isBlank(SelectedShozokuArea)){
            for (AggregateResult l : [ select  EigyoTanto__c,EigyoTanto__r.name,  count(id)
                                      from account 
                                      where EigyoTanto__c != null  and Region_and_Area__c =:SelectedRegion_and_Area  
                                      and  CountryName__c =:SelectedCountryName
                                      and Jurisdiction__c =:SelectedJurisdiction
                                      and ShozokuArea__c =:SelectedShozokuArea
                                      group by  EigyoTanto__c, EigyoTanto__r.name ]) {
                                          opt.add(new SelectOption(String.valueOf(l.get('EigyoTanto__c')), String.valueOf(l.get('name')) ));  
                                      }       
        }
        
        return opt;
    }
    
    public void fetchBlEigyoTantoOptions(){
        BlEigyoTantoOptions=getBlEigyoTantoOptions();
    }
    
    public SelectOption[] getBlEigyoTantoOptions(){
        List<SelectOption>  opt = new  List<SelectOption>();
        opt.add(new SelectOption('','-None-'));  
        if (! String.isBlank(SelectedShozokuArea)){
            for (AggregateResult l : [ select  BlEigyoTanto__c,BlEigyoTanto__r.name,  count(id)
                                      from account 
                                      where BlEigyoTanto__c != null  and Region_and_Area__c =:SelectedRegion_and_Area  
                                      and  CountryName__c =:SelectedCountryName
                                      and Jurisdiction__c =:SelectedJurisdiction
                                      and ShozokuArea__c =:SelectedShozokuArea
                                      group by  BlEigyoTanto__c, BlEigyoTanto__r.name ]) {
                                          opt.add(new SelectOption(String.valueOf(l.get('BlEigyoTanto__c')), String.valueOf(l.get('name')) ));  
                                      }       
        }
        
        return opt;
    }
    
    public void fetchNaimuTantoOptions(){
        NaimuTantoOptions=getNaimuTantoOptions();
    }
    
    public SelectOption[] getNaimuTantoOptions(){
        List<SelectOption>  opt = new  List<SelectOption>();
        opt.add(new SelectOption('','-None-'));  
        if (! String.isBlank(SelectedShozokuArea)){
            for (AggregateResult l : [ select  NaimuTanto__c,NaimuTanto__r.name,  count(id)
                                      from account 
                                      where NaimuTanto__c != null  and Region_and_Area__c =:SelectedRegion_and_Area  
                                      and  CountryName__c =:SelectedCountryName
                                      and Jurisdiction__c =:SelectedJurisdiction
                                      and ShozokuArea__c =:SelectedShozokuArea
                                      group by  NaimuTanto__c, NaimuTanto__r.name ]) {
                                          opt.add(new SelectOption(String.valueOf(l.get('NaimuTanto__c')), String.valueOf(l.get('name')) ));  
                                      }       
        }
        
        return opt;
    }

    public SelectOption[] Region_and_AreaOptions{get;set;}
    public SelectOption[] getRegion_and_AreaOptions() {  
        // 20160920
        Region_and_AreaOptions.clear();
        Region_and_AreaOptions.add(new SelectOption('','--None--'));  
        for (AggregateResult l : [ select Region_and_Area__c, count(id)
                                   from account
                                  where Region_and_Area__c != null
                                  group by Region_and_Area__c ]) {  
                                      Region_and_AreaOptions.add(new SelectOption(String.valueOf(l.get('Region_and_Area__c')), String.valueOf(l.get('Region_and_Area__c')) ));  
                                  }                           
        return Region_and_AreaOptions;  
    } 

    public void fetchCountryNameOptions(){
        
        // JurisdictionOptions = new SelectOption[]{};  
        getCountryNameOptions();
        fetchJurisdictionOptions();
    }    
    
    public SelectOption[] CountryNameOptions{get;set;}
    public SelectOption[] getCountryNameOptions() {  
        // 20160920
        CountryNameOptions.clear();
        CountryNameOptions.add(new SelectOption('','--None--'));  
        for (AggregateResult l : [ select CountryName__c, count(id)
                                    from account
                                  	where CountryName__c != null and Region_and_Area__c =:SelectedRegion_and_Area
                                    group by CountryName__c 	]) {  
                                      CountryNameOptions.add(new SelectOption(String.valueOf(l.get('CountryName__c')), String.valueOf(l.get('CountryName__c')) ));  
                                  }                           
        return CountryNameOptions;  
    } 
    
    public void fetchJurisdictionOptions(){
        
        getJurisdictionOptions();
        fetchShozokuAreaOptions();
    }    
    
    public SelectOption[] JurisdictionOptions{get;set;}
    public SelectOption[] getJurisdictionOptions() {  
        // 20160920
        JurisdictionOptions.clear();
        JurisdictionOptions.add(new SelectOption('','--None--'));  
        for (AggregateResult l : [ select Jurisdiction__c, count(id)
                                  from account 
                                  where Jurisdiction__c != null  
                                  and Region_and_Area__c =:SelectedRegion_and_Area
                                  and CountryName__c =:SelectedCountryName
                                  group by Jurisdiction__c ]) {  
                                      JurisdictionOptions.add(new SelectOption(String.valueOf(l.get('Jurisdiction__c')), String.valueOf(l.get('Jurisdiction__c')) ));  
                                  }                           
        return JurisdictionOptions;  
    } 
    
    public void fetchShozokuAreaOptions(){
        getShozokuAreaOptions();
        EigyoTantoOptions = getEigyoTantoOptions();
        NaimuTantoOptions = getNaimuTantoOptions();
        BlEigyoTantoOptions = getBlEigyoTantoOptions();
    }    

    public SelectOption[] ShozokuAreaOptions{get;set;}
    public SelectOption[] getShozokuAreaOptions() {  
        // 20160920
        ShozokuAreaOptions.clear();
        ShozokuAreaOptions.add(new SelectOption('','--None--'));  
        for (AggregateResult l : [ select ShozokuArea__c, count(id)
                                  from account 
                                  where ShozokuArea__c != null and 
                                  Region_and_Area__c =:SelectedRegion_and_Area and 
                                  CountryName__c =:SelectedCountryName and Jurisdiction__c =:SelectedJurisdiction
                                  group by ShozokuArea__c ]) {  
                                      ShozokuAreaOptions.add(new SelectOption(String.valueOf(l.get('ShozokuArea__c')), String.valueOf(l.get('ShozokuArea__c')) ));  
                                  }                           
        return ShozokuAreaOptions;  
    } 
    
    public void search(){
        //get input date from look up fields
       // CountryName= cs.CountryName__c; 
       // Jurisdiction= cs.Jurisdiction__c;
       // ShozokuArea= cs.ShozokuArea__c;   
       // 20160920 
       	Region_and_Area = SelectedRegion_and_Area;
        CountryName= SelectedCountryName; 
        Jurisdiction= SelectedJurisdiction;
        ShozokuArea= SelectedShozokuArea;   
        
        //EigyoTanto= cs.EigyoTanto__c;
        //NaimuTanto= cs.NaimuTanto__c;
        //BlEigyoTanto= cs.BlEigyoTanto__c;
        
        EigyoTanto= SelectedEigyoTanto;
        NaimuTanto= SelectedNaimuTanto;
        BlEigyoTanto= SelectedBlEigyoTanto;
        //run soql query 
        query(EigyoTanto,NaimuTanto,BlEigyoTanto);
    }
    
   public void query(String EigyoTanto,String NaimuTanto,String BlEigyoTanto){
            //if(CountryName!=null && Jurisdiction!=null && ShozokuArea!=null && EigyoTanto!=null && NaimuTanto!=null && BlEigyoTanto!=null){
            String ShozokuAreaSql ='';
            String EigyoTantoSql ='';
            String NaimuTantoSql ='';
            String BlEigyoTantoSql ='';
            
            if(CountryName!=null && Jurisdiction!=null){            
            showResults = true; //tag to show the results 
                    
            if(ShozokuArea!=null){
                ShozokuAreaSql = ' and ShozokuArea__c =: ShozokuArea ';
            }    
   
            if(EigyoTanto!=null){
                EigyoTantoSql = ' and EigyoTanto__c =: EigyoTanto ';
            }      

            if(NaimuTanto!=null){
                NaimuTantoSql = ' and NaimuTanto__c =: NaimuTanto ';
            }    

            if(BlEigyoTanto!=null){
               BlEigyoTantoSql = ' and BlEigyoTanto__c =: BlEigyoTanto ';
            }      
                       
                    
            //searchResults = [select id,EigyoTanto__r.SeiMeiRoma__c,NaimuTanto__r.SeiMeiRoma__c,BlEigyoTanto__r.SeiMeiRoma__c,CompanyNameEng__c ,CountryName__c,Jurisdiction__c,ShozokuArea__c,EigyoTanto__c,NaimuTanto__c,BlEigyoTanto__c,CompanyCd__c,name,OfficeAdd__c from Account where CountryName__c =: CountryName and Jurisdiction__c =:Jurisdiction and ShozokuArea__c =:ShozokuArea and EigyoTanto__c =:EigyoTanto and NaimuTanto__c =: NaimuTanto and BlEigyoTanto__c =: BlEigyoTanto and (not name like '%退会%' )  order By ShozokuArea__c,EigyoTanto__c,NaimuTanto__c,BlEigyoTanto__c,CompanyCd__c];
            // String searchResultString = 'select id,EigyoTanto__r.SeiMeiRoma__c,NaimuTanto__r.SeiMeiRoma__c,BlEigyoTanto__r.SeiMeiRoma__c,CompanyNameEng__c ,CountryName__c,Jurisdiction__c,ShozokuArea__c,EigyoTanto__c,NaimuTanto__c,BlEigyoTanto__c,CompanyCd__c,name,OfficeAdd__c from Account where CountryName__c = \''+CountryName+'\' and Jurisdiction__c = ' + ' \''+Jurisdiction +'\''+ ShozokuAreaSql + EigyoTantoSql + NaimuTantoSql + BlEigyoTantoSql +' '+' and (not name like \''+'%'+'退会'+'%'+'\') order By ShozokuArea__c,EigyoTanto__c,NaimuTanto__c,BlEigyoTanto__c,CompanyCd__c';
			// 20160921
                String Region_and_AreaSql ='';
                
                if(Region_and_Area !=null) {
                    Region_and_AreaSql = ' and Region_and_Area__c =:Region_and_Area ';
                }   
            String searchResultString = 'select id,EigyoTanto__r.SeiMeiRoma__c,NaimuTanto__r.SeiMeiRoma__c,BlEigyoTanto__r.SeiMeiRoma__c,CompanyNameEng__c ,CountryName__c,Jurisdiction__c,ShozokuArea__c,EigyoTanto__c,NaimuTanto__c,BlEigyoTanto__c,CompanyCd__c,name,OfficeAdd__c from Account where  CountryName__c = \''+CountryName+'\' and Jurisdiction__c = ' + ' \''+Jurisdiction +'\''+ Region_and_AreaSql + ShozokuAreaSql + EigyoTantoSql + NaimuTantoSql + BlEigyoTantoSql +' '+' and (not name like \''+'%'+'退会'+'%'+'\') order By ShozokuArea__c,EigyoTanto__c,NaimuTanto__c,BlEigyoTanto__c,CompanyCd__c';
            system.debug(searchResultString);
            searchResults = Database.query(searchResultString);
            system.debug(searchResults);
            
            newSearchResults = new List<UpdateTable>();   // clear all old search data in the search tabl            
             // add records to the newSearchResults list (search result table display in page)
              for(Account a:searchResults){
                UpdateTable records = new UpdateTable();           
                records.accountData= a;        
                newSearchResults.add(records);  
              }        
        }
        else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.ErrorMessageSearch);  
            ApexPages.addMessage(myMsg);       
        } 
    }
      
    public void updateRecord(){
      List<Account> updateList = new List<Account>();
      for(UpdateTable c:newSearchResults ){
          if(c.InchargeCheckbox){           
            if (inputLookUp.EigyoTanto__c!=null){
                c.accountData.EigyoTanto__c = inputLookUp.EigyoTanto__c;
            }
            if(inputLookUp.NaimuTanto__c!=null){
                c.accountData.NaimuTanto__c= inputLookUp.NaimuTanto__c;  
            }
            if(inputLookUp.BlEigyoTanto__c!=null){
                c.accountData.BlEigyoTanto__c= inputLookUp.BlEigyoTanto__c;  
            } 
            updateList.add(c.accountData);                    
          }                                    
        }
        if(updateList.size()>0){
            system.debug(updateList);
            update updateList;  
        }
        
        query(inputLookUp.EigyoTanto__c,inputLookUp.NaimuTanto__c,inputLookUp.BlEigyoTanto__c);           
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
     showResults = false;    
    } 
    
    //go back to the view list 
    public PageReference back(){ 
    String id=null;  
     if(ApexPages.currentPage().getParameters().get('retURL')!=null){
         id = ApexPages.currentPage().getParameters().get('retURL').right(15);
     }
     String spaceDelimeted = '/001?fcf='+id;
     PageReference reference = new PageReference(spaceDelimeted );
     reference.setRedirect(true);
     return reference;
    }

    public class UpdateTable {
     public Boolean InchargeCheckbox {set;get;}
     public Account accountData {set;get;}
    } 
}