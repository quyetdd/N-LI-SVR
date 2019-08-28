public class CarInsuranceBatchProcessController
{ 
  public boolean isEnglish {get; set;}  
  public boolean showResults {set;get;}     
  public List<Ichiroheian__c> results {set;get;}
  public List<Ichiroheian__c> searchResults {set;get;}
  public Ichiroheian__c inputText {set;get;}
  public List<UpdateTable> newSearchResults {set;get;}
  public Ichiroheian__c cs {set;get;}
    
  // New Options for searching 20170125
    public String SelectedWOAgency{set;get;}
    public String SelectedKeiyakuCountry{set;get;}
    public String SelectedKeiyakuArea{set;get;}
    public String SelectedWOInsuranceCompany{set;get;}
    public String SelectedWOCommodityName{set;get;}

    public SelectOption[] WOAgencyOptions {get;set;}
    public SelectOption[] KeiyakuCountryOptions {get;set;}
    Public SelectOption[] KeiyakuAreaOptions {get;set;}
    public SelectOption[] WOInsuranceCompanyOptions {get;set;}
    Public SelectOption[] WOCommodityNameOptions {get;set;}
    
    public SelectOption[] getWOAgencyOptions(){
        List<SelectOption>  opt = new  List<SelectOption>();
        opt.add(new SelectOption('','-None-'));  
        for (AggregateResult l : [ SELECT WOAgency__c , count(id)
                                  FROM Ichiroheian__c
                                  where WOAgency__c <> null
                                  group by WOAgency__c	]) {  
                                      opt.add(new SelectOption(String.valueOf(l.get('WOAgency__c')), String.valueOf(l.get('WOAgency__c')) ));  
                                  }       
        return opt;
    }
    public void fetchKeiyakuCountryOptions(){
		KeiyakuCountryOptions = getKeiyakuCountryOptions();  
        KeiyakuAreaOptions = getKeiyakuAreaOptions();
        WOInsuranceCompanyOptions=getWOInsuranceCompanyOptions();
         WOCommodityNameOptions=getWOCommodityNameOptions();
    }
    public SelectOption[] getKeiyakuCountryOptions(){
        List<SelectOption>  opt = new  List<SelectOption>();
        opt.add(new SelectOption('','-None-'));  
        if (! String.isBlank(SelectedWOAgency)){
            for (AggregateResult l : [ SELECT KeiyakuCountry__c , count(id)
                                      FROM Ichiroheian__c
                                      where KeiyakuCountry__c <> null and WOAgency__c =:SelectedWOAgency
                                      group by KeiyakuCountry__c	]) {  
                                          opt.add(new SelectOption(String.valueOf(l.get('KeiyakuCountry__c')), String.valueOf(l.get('KeiyakuCountry__c')) ));  
                                      }       
        }

        return opt;
    }
    public void fetchKeiyakuAreaOptions(){
        KeiyakuAreaOptions = getKeiyakuAreaOptions();
        WOInsuranceCompanyOptions=getWOInsuranceCompanyOptions();
         WOCommodityNameOptions=getWOCommodityNameOptions();
    }
    public SelectOption[] getKeiyakuAreaOptions(){
        List<SelectOption>  opt = new  List<SelectOption>();
        opt.add(new SelectOption('','-None-'));  
        if (! String.isBlank(SelectedWOAgency) && ! String.isBlank(SelectedKeiyakuCountry) ){
            for (AggregateResult l : [ SELECT KeiyakuArea__c , count(id)
                                      FROM Ichiroheian__c
                                      where KeiyakuArea__c <> null and WOAgency__c =:SelectedWOAgency and KeiyakuCountry__c =:SelectedKeiyakuCountry
                                      group by KeiyakuArea__c	]) {  
                                          opt.add(new SelectOption(String.valueOf(l.get('KeiyakuArea__c')), String.valueOf(l.get('KeiyakuArea__c')) ));  
                                      }       
        }
        return opt;
    }
    public void fetchWOInsuranceCompanyOptions(){
        WOInsuranceCompanyOptions=getWOInsuranceCompanyOptions();
         WOCommodityNameOptions=getWOCommodityNameOptions();
    }
    public SelectOption[] getWOInsuranceCompanyOptions (){
        List<SelectOption>  opt = new  List<SelectOption>();
        opt.add(new SelectOption('','-None-'));  
        if (! String.isBlank(SelectedWOAgency) && ! String.isBlank(SelectedKeiyakuCountry) && ! String.isBlank(SelectedKeiyakuArea) ){
            for (AggregateResult l : [ SELECT WOInsuranceCompany__c , count(id)
                                      FROM Ichiroheian__c
                                      where WOInsuranceCompany__c <> null and WOAgency__c =:SelectedWOAgency and KeiyakuCountry__c =:SelectedKeiyakuCountry
                                      and KeiyakuArea__c =:SelectedKeiyakuArea
                                      group by WOInsuranceCompany__c	]) {  
                                          opt.add(new SelectOption(String.valueOf(l.get('WOInsuranceCompany__c')), String.valueOf(l.get('WOInsuranceCompany__c')) ));  
                                      }     
        }
        return opt;
    }
    public void fetchWOCommodityNameOptions(){
        WOCommodityNameOptions=getWOCommodityNameOptions();
    }
    public SelectOption[] getWOCommodityNameOptions (){
        List<SelectOption>  opt = new  List<SelectOption>();
        opt.add(new SelectOption('','-None-'));  
           if (! String.isBlank(SelectedWOAgency) && ! String.isBlank(SelectedKeiyakuCountry) && ! String.isBlank(SelectedKeiyakuArea) && ! String.isBlank(SelectedWOInsuranceCompany)){
        for (AggregateResult l : [ SELECT WOCommodityName__c , count(id)
                                  FROM Ichiroheian__c
                                   where WOCommodityName__c <> null and WOAgency__c =:SelectedWOAgency and KeiyakuCountry__c =:SelectedKeiyakuCountry
                                      and KeiyakuArea__c =:SelectedKeiyakuArea and WOInsuranceCompany__c =:SelectedWOInsuranceCompany
                                  group by WOCommodityName__c	]) {  
                                      opt.add(new SelectOption(String.valueOf(l.get('WOCommodityName__c')), String.valueOf(l.get('WOCommodityName__c')) ));  
                                  }  
           }
        return opt;
    }
  
  public CarInsuranceBatchProcessController(ApexPages.StandardSetController controller) {
      isEnglish = 'en_US'.equals(UserInfo.getLanguage()); //check profile language
      newSearchResults = new List<UpdateTable>();  
      inputText = new Ichiroheian__c();
     // this.cs = (Ichiroheian__c) con.getRecord();
    	this.cs = new Ichiroheian__c();
      showResults = false;
      // Option Initialization 
      WOAgencyOptions = getWOAgencyOptions();
      KeiyakuCountryOptions =getKeiyakuCountryOptions();
      KeiyakuAreaOptions = getKeiyakuAreaOptions();
      WOCommodityNameOptions = getWOCommodityNameOptions(); 
      WOInsuranceCompanyOptions = getWOInsuranceCompanyOptions(); 
    }
    
  public CarInsuranceBatchProcessController (ApexPages.StandardController con)
  {  
    isEnglish = 'en_US'.equals(UserInfo.getLanguage()); //check profile language
    newSearchResults = new List<UpdateTable>();  
    inputText = new Ichiroheian__c();
    this.cs = (Ichiroheian__c) con.getRecord();
    showResults = false;
    // Option Initialization 
      WOAgencyOptions = getWOAgencyOptions();
      KeiyakuCountryOptions =getKeiyakuCountryOptions();
      KeiyakuAreaOptions = getKeiyakuAreaOptions();
      WOCommodityNameOptions = getWOCommodityNameOptions(); 
      WOInsuranceCompanyOptions = getWOInsuranceCompanyOptions(); 
  }
  
  public void search(){
     
     // 20170125 if(cs.WOAgency__c!=null && cs.KeiyakuArea__c!=null && cs.InsuranceShuki__c!=null && cs.WOInsuranceCompany__c!=null && cs.WOCommodityName__c!=null){
       showResults = true; //tag to show the results 
       newSearchResults = new List<UpdateTable>(); // clear all old search data in the search table
      // 20170125
       string searchResultStr;
       searchResultStr = 'select WoAgency__c,Name,PresentInsuranceShiki__c,WOPresentInsuranceShikiAlpha__c,KeiyakuArea__c,KeiyakuCompanyName__r.CompanyNameEng__c,KeiyakuCompanyName__c,IchiroHeianNo__c,ShiyoCompanyName__c,ShiyoCompanyName__r.CompanyNameEng__c,InsuranceShuki__c,Wocommodityname__c,WOInsuranceCompany__c,WOInsuranceShukiAlpha__c ,CancelDate__c from Ichiroheian__c ';
      string conditionStr;  
      if(! String.isBlank(SelectedWOAgency)) {
          conditionStr =  ' WOAgency__c =\'' +SelectedWOAgency + '\'' ;
      }
      if(! String.isBlank(SelectedKeiyakuCountry)) {
          if (conditionStr!=null ) {
		      conditionStr += ' and KeiyakuCountry__c =\'' +SelectedKeiyakuCountry + '\'' ;
          } else {
              conditionStr =  ' KeiyakuCountry__c =\'' +SelectedKeiyakuCountry + '\'' ;
          }
      }
      if(! String.isBlank(SelectedKeiyakuArea)) {
          if (conditionStr!=null ) {
              conditionStr += ' and KeiyakuArea__c =\'' +SelectedKeiyakuArea + '\'' ;
          } else {
              conditionStr =  ' KeiyakuArea__c =\'' +SelectedKeiyakuArea + '\'' ;
          }
      } 
      if (cs != null) {
          if(cs.InsuranceShuki__c!=null) {
              string mm =  String.valueOf(cs.InsuranceShuki__c.month()+100);
              mm = mm.right(2);
              string dd =  String.valueOf(cs.InsuranceShuki__c.day()+100);
              dd = dd.right(2);
              string d = String.valueOf(cs.InsuranceShuki__c.year() ) +'-'+ mm +'-'+ dd;
              if (conditionStr!=null ) {
                  
                  conditionStr += ' and InsuranceShuki__c = '+ d +' ' ;
              } else {
                  conditionStr =  ' InsuranceShuki__c = '+ d +' ' ;
              }
          }      
      }
      if(! String.isBlank(SelectedWOInsuranceCompany)) {
          if (conditionStr!=null ) {
              conditionStr += ' and WOInsuranceCompany__c =\'' +SelectedWOInsuranceCompany + '\'' ;
          } else {
              conditionStr =  ' WOInsuranceCompany__c =\'' +SelectedWOInsuranceCompany + '\'' ;
          }
      }
      if(! String.isBlank(SelectedWOCommodityName)) {
          if (conditionStr!=null ) {
              conditionStr += ' and WOCommodityName__c =\'' +SelectedWOCommodityName + '\'' ;
          } else {
              conditionStr =  ' WOCommodityName__c =\'' +SelectedWOCommodityName + '\'' ;
          }
      }
      
  	/* 20190410
     if (conditionStr==null) {
          searchResultStr += ' where CancelDate__c!=null ORDER BY WoAgency__c '; }
      else {  searchResultStr+=' where ' + conditionStr + ' and CancelDate__c!=null ORDER BY WoAgency__c ';}
      */
      
      if (conditionStr==null) {
          searchResultStr += ' where CancelDate__c=null ORDER BY WoAgency__c '; }
      else {  searchResultStr+=' where ' + conditionStr + ' and CancelDate__c=null ORDER BY WoAgency__c ';}
      
      
     if (conditionStr!= null)
		system.debug(conditionStr);
      
       searchResults = Database.query(searchResultStr);
      // 20170125 searchResults = [select WoAgency__c,Name,PresentInsuranceShiki__c,WOPresentInsuranceShikiAlpha__c,KeiyakuArea__c,KeiyakuCompanyName__r.CompanyNameEng__c,KeiyakuCompanyName__c,IchiroHeianNo__c,ShiyoCompanyName__c,ShiyoCompanyName__r.CompanyNameEng__c,InsuranceShuki__c,Wocommodityname__c,WOInsuranceCompany__c,WOInsuranceShukiAlpha__c ,CancelDate__c from Ichiroheian__c
      // 20170125 where WoAgency__c =:cs.WoAgency__c and KeiyakuArea__c =: cs.KeiyakuArea__c and WOCommodityName__c=: cs.WOCommodityName__c and InsuranceShuki__c =:cs.InsuranceShuki__c and CancelDate__c=null ORDER BY KeiyakuArea__c ,KeiyakuCompanyName__c,ShiyoCompanyName__c,Name ];
       
          for(Ichiroheian__c a:searchResults){
            UpdateTable records = new UpdateTable();           
            records.IchiroheianData = a;    
            records.InchargeCheckbox = true; //the PIC Update checkbox default true     
            newSearchResults.add(records);  
          }
   // 20170125  }
   //   else{
  //           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.ErrorMessageSearch);  
  //           ApexPages.addMessage(myMsg);
  //           newSearchResults = new List<UpdateTable>(); //clear all search data
  //    }
  }

  public void selectAll (){
      for(UpdateTable b:newSearchResults){
         b.InchargeCheckbox = true;
         b.opCheckbox = true;
      }
  }
  
  public void releaseAll (){
      for(UpdateTable b:newSearchResults){
         b.InchargeCheckbox = false;
         b.opCheckbox = false;
      }    
  }  
  
  public void closeSearchTable(){  
     showResults = false;
  }
  
  public PageReference back(){
  
     String id = null;   
     if(ApexPages.currentPage().getParameters().get('retURL')!=null){
         id = ApexPages.currentPage().getParameters().get('retURL').right(15); //get pervious page id
     }
     String spaceDelimeted = '/a0D?fcf='+id;
     PageReference reference = new PageReference(spaceDelimeted);
     system.debug(spaceDelimeted );
     reference.setRedirect(true);
     return reference;
  }

  public void updateRecord(){
      List<Ichiroheian__c> updateList = new List<Ichiroheian__c>();
      List<Ichiroheian__c> updateList2 = new List<Ichiroheian__c>();
      for(UpdateTable c:newSearchResults ){
          // check the PIC Update checkbox click and put the input text data in list for update
          if(c.InchargeCheckbox){
            if (inputText.PresentInsuranceShiki__c!=null){
                c.IchiroheianData.PresentInsuranceShiki__c = inputText.PresentInsuranceShiki__c;
            }
            if(inputText.InsuranceShuki__c!=null){
                c.IchiroheianData.InsuranceShuki__c = inputText.InsuranceShuki__c;  
            }
            updateList.add(c.IchiroheianData);
          }           
          // check the (OP) Update checkbox click and put the input text data in list for update
          if(c.opCheckbox){
            if (inputText.WOPresentInsuranceShikiAlpha__c!=null){
                c.IchiroheianData.WOPresentInsuranceShikiAlpha__c = inputText.WOPresentInsuranceShikiAlpha__c;
            }
            if (inputText.WOInsuranceShukiAlpha__c!=null){
                c.IchiroheianData.WOInsuranceShukiAlpha__c = inputText.WOInsuranceShukiAlpha__c;  
            }
            updateList2.add(c.IchiroheianData);
          }                            
           //updateList.add(c.IchiroheianData);
        }
        
        if(updateList.size()>0){    
            update updateList;    
        }
        if(updateList2.size()>0){
            update updateList2;
        }
  }
  
    public class UpdateTable {
        public Boolean InchargeCheckbox {set;get;}
        public Boolean opCheckbox {set;get;}
        public Ichiroheian__c IchiroheianData {set;get;}
    }
    


}