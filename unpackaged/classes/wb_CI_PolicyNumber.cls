public class wb_CI_PolicyNumber {
    ApexPages.StandardController stdController;
   // public wb_CarInsurance__c CarInsurance {get;set;}
    public List<wb_CIC_Compulsory__c> Compulsories {get;set;}
    public List<wb_CIC_Passenger__c> Passengers {get;set;}
    
    public SelectOption[] ContractCountryOptions {get;set;}
    public string selectedContractCountry {get;set;}
    
    public string StartNo {get;set;}
    public string EndNo {get;set;}
    
    public string RegistryNumber {get;set;}
    
    public SelectOption[] StatusOptions {get;set;}
    public string selectedStatus {get;set;}
    public SelectOption[] Cps_InsuranceCompanyOptions {get;set;}
    public string selectedCps_InsuranceCompany {get;set;}
    public SelectOption[] Vlt_InsuranceCompanyOptions {get;set;}
    public string selectedVlt_InsuranceCompany {get;set;}
    
    public SelectOption[] Psgr_InsuranceCompanyOptions {get;set;}
    public string selectedPsgr_InsuranceCompany {get;set;}
    
    Public String selectedTab {get; set;}
    
    public List<PolicyNumberRow> PolicyNumberList {get;set;}
    public List<PolicyNumberRow> PsgrPolicyNumberList {get;set;}
    
    public class PolicyNumberRow {
        public Boolean isSelected { get; set; }
        public wb_CIC_Compulsory__c theCps { get; set; }
        public wb_CIC_Passenger__c thePsgr { get; set; }
        public PolicyNumberRow( wb_CIC_Compulsory__c ci) {
            theCps = ci;
            isSelected = false;
        }
        public PolicyNumberRow( wb_CIC_Passenger__c ci) {
            thePsgr = ci;
            isSelected = false;
        }
    }
    
    public wb_CI_PolicyNumber(ApexPages.StandardController stdController){
        
        this.stdController = stdController;
        //CarInsurance = new wb_CarInsurance__c();
        ContractCountryOptions = getContractCountryOptions();
        StatusOptions = getStatusOptions();
        
              Cps_InsuranceCompanyOptions = getCps_InsuranceCompanyOptions();
            Vlt_InsuranceCompanyOptions = getVlt_InsuranceCompanyOptions();

        selectedTab = 'one';
  
    }
    
    public SelectOption[] getContractCountryOptions() {  
        List<SelectOption>  opt = new  List<SelectOption>();
        opt.add(new SelectOption('','--None--'));  
        for (AggregateResult l : [ select ContractCountry__c, count(Id)
                                  from wb_CarInsurance__c
                                  where ContractCountry__c <> null
                                  group by ContractCountry__c	]) {  
                                      opt.add(new SelectOption(String.valueOf(l.get('ContractCountry__c')), String.valueOf(l.get('ContractCountry__c')) ));  
                                  }        
        
        return opt;  
    } 
    
    public SelectOption[] getStatusOptions() {  
        List<SelectOption>  opt = new  List<SelectOption>();
        opt.add(new SelectOption('','--None--'));  
        
  
        if (selectedContractCountry <> null ) {
            for (AggregateResult l : [ select Status__c, count(Id)
                                      from wb_CarInsurance__c
                                      where Status__c !='キャンセル' and Status__c != null 
                                      and ContractCountry__c =:selectedContractCountry
                                      group by Status__c	]) {  
                                          opt.add(new SelectOption(String.valueOf(l.get('Status__c')), String.valueOf(l.get('Status__c')) ));  
                                      }     
            
        }
        
        return opt;  
    } 
    public void fetchStatusOptions(){
        StatusOptions = getStatusOptions();
        fetchCompulsoriesList();
    }
    
    public void fetchTab(){
        if ( selectedTab =='one'){
            Cps_InsuranceCompanyOptions = getCps_InsuranceCompanyOptions();
            Vlt_InsuranceCompanyOptions = getVlt_InsuranceCompanyOptions();
            fetchCompulsoriesList();
        }else
        {
            Psgr_InsuranceCompanyOptions = getPsgr_InsuranceCompanyOptions();      
            fetchPassengersList();
        }
    }

    public void fetchTabPsgr(){
        // system.debug('fetchTabPsgr');
        selectedTab = 'two';
        fetchTab();
    }
    
    public void fetchTabCps(){
        // system.debug('fetchTabPsgr');
        selectedTab = 'one';
        fetchTab();
    }
    
    public void fetchCompanies(){
        Cps_InsuranceCompanyOptions = getCps_InsuranceCompanyOptions();
        Vlt_InsuranceCompanyOptions = getVlt_InsuranceCompanyOptions();
        
        fetchCompulsoriesList();
    }
    
    public void fetchCompulsoriesList(){
        
        if (selectedContractCountry!=null && selectedStatus!=null  ){
            Compulsories = new List<wb_CIC_Compulsory__c>();
            
            string Soql = 'SELECT id, CarInsurancedCar__r.RegistryNumber__c ,CarInsurancedCar__r.CarInsurance__r.ContractCountry__c,';
            Soql +=              ' CarInsurancedCar__r.CarInsurance__r.Status__c,';
            Soql +=             ' Vlt_PolicyNumber__c, Cps_PolicyNumber__c, Cps_InsuranceCompany__c,' ;
            Soql +=          ' Vlt_InsuranceCompany__c, CarInsurancedCar__r.CarInsurance__r.name ';
            Soql +=         ' FROM wb_CIC_Compulsory__c ';
            Soql +=        ' where Cps_InsuranceCompany__c <> null';
            
            if ( selectedContractCountry != null )
            {Soql += ' and CarInsurancedCar__r.CarInsurance__r.ContractCountry__c =\'' +selectedContractCountry +'\' ';}
            if (StartNo!=null && StartNo.length() > 0)
            {Soql += ' and CarInsurancedCar__r.CarInsurance__r.name >=\'' +StartNo +'\' ';}
            if (EndNo!=null && EndNo.length() > 0)
            {Soql += ' and CarInsurancedCar__r.CarInsurance__r.name <=\'' +EndNo +'\' ';}
              if (RegistryNumber!=null && RegistryNumber.length() > 0)
            {Soql += ' and CarInsurancedCar__r.RegistryNumber__c like \'%' +RegistryNumber +'%\' ';}
            if ( selectedStatus != null )
            {Soql += ' and CarInsurancedCar__r.CarInsurance__r.Status__c =\'' +selectedStatus +'\' and CarInsurancedCar__r.CarInsurance__r.Status__c != \'キャンセル\' ';}
            else
            {Soql +=' and CarInsurancedCar__r.CarInsurance__r.Status__c != \'キャンセル\' ';}
            if ( selectedCps_InsuranceCompany != null )
            {Soql += ' and Cps_InsuranceCompany__c =\'' +selectedCps_InsuranceCompany +'\' ';}
            if ( selectedVlt_InsuranceCompany != null )
            {Soql += ' and Vlt_InsuranceCompany__c =\'' +selectedVlt_InsuranceCompany +'\' ';}
            system.debug('LIST:' + Soql);
            Compulsories = Database.query(Soql);
            PolicyNumberList = new List<PolicyNumberRow>();
            for (wb_CIC_Compulsory__c cps:Compulsories){
                PolicyNumberList.add( new PolicyNumberRow(cps));
            }
        }
        
    }
    
      public void fetchPassengersList(){
        
        if (selectedContractCountry!=null && selectedStatus!=null  ){
            Passengers = new List<wb_CIC_Passenger__c>();
            
            string Soql = 'SELECT id, CarInsurancedCar__r.RegistryNumber__c ,CarInsurancedCar__r.CarInsurance__r.ContractCountry__c,';
            Soql += 'CarInsurancedCar__r.CarInsurance__r.Status__c,'; 
            Soql += 'Psgr_PolicyNumber__c,  Psgr_InsuranceCompany__c ,CarInsurancedCar__r.CarInsurance__r.name';  
            Soql += ' FROM wb_CIC_Passenger__c';  
            Soql +=        ' where name <> null';
            
            if ( selectedContractCountry != null )
            {Soql += ' and CarInsurancedCar__r.CarInsurance__r.ContractCountry__c =\'' +selectedContractCountry +'\' ';}
            if (StartNo!=null && StartNo.length() > 0)
            {Soql += ' and CarInsurancedCar__r.CarInsurance__r.name >=\'' +StartNo +'\' ';}
            if (EndNo!=null && EndNo.length() > 0)
            {Soql += ' and CarInsurancedCar__r.CarInsurance__r.name <=\'' +EndNo +'\' ';}
              if (RegistryNumber!=null && RegistryNumber.length() > 0)
            {Soql += ' and CarInsurancedCar__r.RegistryNumber__c like \'%' +RegistryNumber +'%\' ';}
            if ( selectedStatus != null )
            {Soql += ' and CarInsurancedCar__r.CarInsurance__r.Status__c =\'' +selectedStatus +'\' and CarInsurancedCar__r.CarInsurance__r.Status__c != \'キャンセル\' ';}
            else
            {Soql +=' and CarInsurancedCar__r.CarInsurance__r.Status__c != \'キャンセル\' ';}
            if ( selectedPsgr_InsuranceCompany != null )
            {Soql += ' and Psgr_InsuranceCompany__c =\'' +selectedPsgr_InsuranceCompany +'\' ';}
           
            system.debug('LIST:' + Soql);
            Passengers = Database.query(Soql);
            PsgrPolicyNumberList = new List<PolicyNumberRow>();
            for (wb_CIC_Passenger__c cps:Passengers){
                PsgrPolicyNumberList.add( new PolicyNumberRow(cps));
            }
        }
        
    }
    
    
    public SelectOption[] getPsgr_InsuranceCompanyOptions() {  
        List<SelectOption>  opt = new  List<SelectOption>();
        opt.add(new SelectOption('','--None--'));  
        
        String SOQLwhere;
        
        if ( selectedContractCountry <> null )
            SOQLwhere = ' and CarInsurancedCar__r.CarInsurance__r.ContractCountry__c =\'' + selectedContractCountry +'\'';
        
        if ( selectedStatus <> null )
            SOQLwhere = ' and CarInsurancedCar__r.CarInsurance__r.Status__c =\'' + selectedStatus +'\'';
        

        if ( SOQLwhere <> null) {
            String SOQL = ' SELECT Psgr_InsuranceCompany__c, count(id)';
            SOQL += ' FROM wb_CIC_Passenger__c ';
            SOQL += ' where CarInsurancedCar__r.CarInsurance__r.Status__c != \'キャンセル\' and Psgr_InsuranceCompany__c <> null ' + SOQLwhere;
            
            SOQL += ' group by Psgr_InsuranceCompany__c ';
            
            system.debug('SOQL:' + SOQL);
            List<AggregateResult> AgR = database.query(SOQL);  
            
            for (AggregateResult l:AgR ){
                opt.add(new SelectOption(String.valueOf(l.get('Psgr_InsuranceCompany__c')), String.valueOf(l.get('Psgr_InsuranceCompany__c')) ));  
            }
        }
        

        
        return opt;  
    } 

    public SelectOption[] getCps_InsuranceCompanyOptions() {  
        
        List<SelectOption>  opt = new  List<SelectOption>();
        opt.add(new SelectOption('','--None--'));  
        
        String SOQLwhere;
        
        if ( selectedContractCountry <> null )
            SOQLwhere = ' and CarInsurancedCar__r.CarInsurance__r.ContractCountry__c =\'' + selectedContractCountry +'\'';
        
        if ( selectedStatus <> null )
            SOQLwhere = ' and CarInsurancedCar__r.CarInsurance__r.Status__c =\'' + selectedStatus +'\'';
        if (StartNo!=null && StartNo.length() > 0)
        {SOQLwhere += ' and CarInsurancedCar__r.CarInsurance__r.name >=\'' +StartNo +'\' ';}
        if (EndNo!=null && EndNo.length() > 0)
        {SOQLwhere += ' and CarInsurancedCar__r.CarInsurance__r.name <=\'' +EndNo +'\' ';}
        if (RegistryNumber!=null && RegistryNumber.length() > 0)
        {SOQLwhere += ' and CarInsurancedCar__r.RegistryNumber__c like \'%' +RegistryNumber +'%\' ';}
        

        if ( SOQLwhere <> null) {
            String SOQL = ' SELECT Cps_InsuranceCompany__c, count(id)';
            SOQL += ' FROM wb_CIC_Compulsory__c ';
            SOQL += ' where CarInsurancedCar__r.CarInsurance__r.Status__c != \'キャンセル\' and Cps_InsuranceCompany__c <> null ' + SOQLwhere;
            
            SOQL += ' group by Cps_InsuranceCompany__c ';
            
            List<AggregateResult> AgR = database.query(SOQL);  
            
            for (AggregateResult l:AgR ){
                opt.add(new SelectOption(String.valueOf(l.get('Cps_InsuranceCompany__c')), String.valueOf(l.get('Cps_InsuranceCompany__c')) ));  
            }
        }
        

        
        return opt;  
    } 
    
    public SelectOption[] getVlt_InsuranceCompanyOptions() {  
        List<SelectOption>  opt = new  List<SelectOption>();
        opt.add(new SelectOption('','--None--'));  
        
         
        String SOQLwhere;
        
        if ( selectedContractCountry <> null )
            SOQLwhere = ' and CarInsurancedCar__r.CarInsurance__r.ContractCountry__c =\'' + selectedContractCountry +'\'';
        
        if ( selectedStatus <> null )
            SOQLwhere = ' and CarInsurancedCar__r.CarInsurance__r.Status__c =\'' + selectedStatus +'\'';
        
        if (StartNo!=null && StartNo.length() > 0)
        {SOQLwhere += ' and CarInsurancedCar__r.CarInsurance__r.name >=\'' +StartNo +'\' ';}
        if (EndNo!=null && EndNo.length() > 0)
        {SOQLwhere += ' and CarInsurancedCar__r.CarInsurance__r.name <=\'' +EndNo +'\' ';}
        if (RegistryNumber!=null && RegistryNumber.length() > 0)
        {SOQLwhere += ' and CarInsurancedCar__r.RegistryNumber__c like \'%' +RegistryNumber +'%\' ';}
        

        if ( SOQLwhere <> null) {
            String SOQL = ' SELECT Vlt_InsuranceCompany__c, count(id)';
            SOQL += ' FROM wb_CIC_Compulsory__c ';
            SOQL += ' where CarInsurancedCar__r.CarInsurance__r.Status__c != \'キャンセル\' and Vlt_InsuranceCompany__c <> null ' + SOQLwhere;
            
            SOQL += ' group by Vlt_InsuranceCompany__c ';
            
            List<AggregateResult> AgR = database.query(SOQL);  
            for (AggregateResult l:AgR ){
            opt.add(new SelectOption(String.valueOf(l.get('Vlt_InsuranceCompany__c')), String.valueOf(l.get('Vlt_InsuranceCompany__c')) ));
            }
        }
      
        
        return opt;  
    } 
    
    public void SavePolicyNumber(){
        for (PolicyNumberRow p:PolicyNumberList){
            if (p.isSelected==true)
                update p.theCps;
        }
    }
    
        public void SavePsgrPolicyNumber(){
        for (PolicyNumberRow p:PsgrPolicyNumberList){
            if (p.isSelected==true)
                update p.thePsgr;
        }
    }
    
        public PageReference Cancel(){
        

            String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
            return new PageReference(sfdcBaseURL+'/a0f');
    
        
        
    }

    
}