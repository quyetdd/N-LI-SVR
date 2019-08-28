public class wb_CarInsurance {
   
    public string MyHome='/a0R/o'; // Production
    // public string MyHome='/a0f/o'; //Sandbox
    ApexPages.StandardController stdController;
    public wb_CarInsurance__c CarInsurance {get;set;}
    public List<wb_CarInsurancedCars__c> InsurancedCars {get;set;}
    

    public string CarFilter {get;set;}
    List<wb_CarInsurancedCars__c> Cars{get;set;}
    List<wb_CIC_Passenger__c> Passengers{get;set;}
    List<wb_CIC_Compulsory__c> Compulsoris{get;set;}
         
    public List<wb_CI_InsurancedCarRow> InsurancedCarsList {get;set;}
    public List<wb_CI_InsurancedCarRow> InsurancedCarsPendingList {get;set;}
    public List<wb_CI_InsurancedCarRow> InsurancedCarsNoEffList {get;set;}
    //  public integer DataTableCurIndex {get;set;}
    public Boolean ErrAlert {get; set;}
 //   public Boolean ReadOnly {get; set;}
    public string Status{get; set;}
    // Option
    Public SelectOption[] AgentOptions;
    Public SelectOption[] ContractCountryOptions;
    Public SelectOption[] ContractDistrictOptions;
    Public SelectOption[] AffiliationDistrictOptions;
    Public SelectOption[] CurrencyOptions;
    public string selectedAgent{get;set;}
    
    public List<SelectOption> getStatusItems() {
        List<SelectOption> options = new List<SelectOption>();
        if ( CarInsurance.Id != null)
        {
            options.add(new SelectOption('未確定','未確定'));
            
        } else
        {
            options.add(new SelectOption('未確定','未確定'));        
        }
        return options;
    }
    
    public String getStatus() {
        if ( CarInsurance.Status__c != null)
        {
            Status = CarInsurance.Status__c;
        }
        else{
            
            Status = '--None--';
        }
        return Status;
    }
    
    public id theInsurancedCarsId {get;set;}
    public integer theInsurancedCarsIndex {get;set;}
    
    public void InsurancedCars_Remove(){

        if (theInsurancedCarsId != null){
            for ( integer j = 0; j < InsurancedCarsList.size(); j++){
                if( InsurancedCarsList[j].theCar.id ==theInsurancedCarsId && j==theInsurancedCarsIndex-1 ) {
                    try {
                        delete InsurancedCarsList[j].theCar;
                    } catch (DmlException e) {
                        // Process exception here
                    }
                    InsurancedCarsList.remove(j);
                    InsurancedCars.remove(j);
                }

            }

        } else
        {
            InsurancedCars.remove(theInsurancedCarsIndex-1);
            InsurancedCarsList.remove(theInsurancedCarsIndex-1);
        }         
    }
    
   public id thePendingCarsId {get;set;}

    
    public void PendingCars_Remove(){
        if (thePendingCarsId != null){
            for ( integer j = 0; j < InsurancedCarsPendingList.size(); j++){
                if( InsurancedCarsPendingList[j].theCar.id ==thePendingCarsId ) {
                    try {
                        List <wb_CIC_Passenger__c> p = [select id 
                                                        from wb_CIC_Passenger__c 
                                                        where CarInsurancedCar__c =:thePendingCarsId];
                                                       
                        delete p;
                        List <wb_CIC_Compulsory__c> c = [select id 
                                                        from wb_CIC_Compulsory__c 
                                                        where CarInsurancedCar__c =:thePendingCarsId];
                        delete c;                                
                        delete InsurancedCarsPendingList[j].theCar;
                    } catch (DmlException e) {
                    }
                    InsurancedCarsPendingList.remove(j);
                }
                
            }

        } 
      
    }

      public PageReference NewInsurancedCarsofList() {
        // InsurancedCars.add( new wb_CarInsurancedCars__c(CarInsurance__c = CarInsurance.id) );
        validateheader();
        
        if(ApexPages.hasMessages(ApexPages.Severity.Error)){
            ErrAlert = true;
            return null;
        } else ErrAlert = false;
        
        if (  CarInsurance.id == null ) {
            insert CarInsurance;  
            CarInsurance = [select Name, Status__c, Agent__c ,AffiliationDistrict__c,ContractDate__c,
                            ContractCompany__c,ContractCompany__r.name,
                            ContractDistrict__c,ContractCountry__c, Attribute__c, CommissionCurrency__c,AcctPIC__c
                            from wb_CarInsurance__c where id =: CarInsurance.Id];
        }
        
        
        if (CarInsurance.id <> null){
            

			string nm;
            string lastName;
            if ( InsurancedCars.size()>0)
            	lastName = InsurancedCars[InsurancedCars.size()-1].name;
            else
                lastName = 'xxxxxx-0';
            
            if ( lastName.indexOf('-')>0) 
                nm = CarInsurance.name + '-' +String.valueOf( Integer.valueOf(lastName.substring(lastName.indexOf('-')+1, lastName.length())) +1);
            else nm = CarInsurance.name +'-1';
            
            wb_CarInsurancedCars__c icar = new wb_CarInsurancedCars__c(CarInsurance__c = CarInsurance.id, name = nm,Pattern__c='新規');
            upsert icar;
            InsurancedCarsList.add(new wb_CI_InsurancedCarRow( icar));
            InsurancedCars.add(icar);

        }
        
        return null;
    }

    
    public SelectOption[] getCurrencyOptions() {  
        
        boolean IsAmendable;
        if ( CarInsurance.id <> null) {
            if ( [select id from wb_CIC_Passenger__c where CarInsurancedCar__r.CarInsurance__c =:CarInsurance.id].size()>0 ||
                [select id from wb_CIC_Compulsory__c where CarInsurancedCar__r.CarInsurance__c =:CarInsurance.id].size()>0
               ) {
                   IsAmendable = false;
               } else
                   IsAmendable = true;
        } else
             IsAmendable = true;
        
        CurrencyOptions.clear();
        if (IsAmendable == true) {
            CurrencyOptions.add(new SelectOption('','--None--'));  
            for (wb_Currency__c l : [ SELECT CurrencySymbol__c, Name 
                                     FROM wb_Currency__c 	]) {  
                                         CurrencyOptions.add(new SelectOption(String.valueOf(l.CurrencySymbol__c), 
                                                                              String.valueOf(l.CurrencySymbol__c + ' ' + l.Name ) ) 
                                                            );  
                                     }
        } else {
            
            for (wb_Currency__c l : [ SELECT CurrencySymbol__c, Name 
                                     FROM wb_Currency__c where CurrencySymbol__c =:CarInsurance.CommissionCurrency__c]) {  
                                         CurrencyOptions.add(new SelectOption(String.valueOf(l.CurrencySymbol__c), 
                                                                              String.valueOf(l.CurrencySymbol__c + ' ' + l.Name ) ) 
                                                            );  
                                 }
            
        }
        return CurrencyOptions;  
    } 
    
    public void fetchContractCountryOptions(){
        
        ContractCountryOptions=getContractCountryOptions();
        
    }
    
    public SelectOption[] getContractCountryOptions() {  
        
        SelectOption[] opt = new SelectOption[]{};  
            opt.add(new SelectOption('','--None--'));  
      
        if (CarInsurance.Agent__c != null) {
            for (AggregateResult l : [ SELECT  Country__c, count(id)
                                      FROM wb_CountryDistrict__c
                                      where Service__c = '車保険' 
                                      and Agent__c =:CarInsurance.Agent__c
                                      group by Country__c 	]) {  
                                          opt.add(new SelectOption(String.valueOf(l.get('Country__c')), String.valueOf(l.get('Country__c')) ));  
                                      }     
        }
        return opt;  
    } 
    
    public void fetchAgentOptions(){
        
        AgentOptions=getAgentOptions();
        
    }
    
    public SelectOption[] getAgentOptions() {  
        SelectOption[] opt = new SelectOption[]{};  
            
            opt.add(new SelectOption('','--None--'));  
       
            
            
        for (AggregateResult l : [ SELECT  Agent__c, count(Id)
                                  FROM wb_CountryDistrict__c
                                  where Service__c = '車保険' 
                                  // and Country__c =:CarInsurance.ContractCountry__c
                                  group by Agent__c	]) {  
                                      opt.add(new SelectOption(String.valueOf(l.get('Agent__c')), String.valueOf(l.get('Agent__c')) ));  
                                  }       
        
        
        return opt;  
    } 
    
    public void fetchContractDistrictOptions(){
        
        ContractDistrictOptions = getContractDistrictOptions();  
        
    }
    
    
    public SelectOption[] getContractDistrictOptions() {  
        
        SelectOption[] opt = new SelectOption[]{};
            opt.add(new SelectOption('','--None--'));  
        if ( CarInsurance.Agent__c <> null && CarInsurance.ContractCountry__c <> null ) {
            
            
            for (AggregateResult l : [ SELECT  District__c, count(id)
                                      FROM wb_CountryDistrict__c 
                                      where Service__c = '車保険'  
                                      and Agent__c =:CarInsurance.Agent__c and Country__c =:CarInsurance.ContractCountry__c
                                      group by District__c 	]) {  
                                          opt.add(new SelectOption(String.valueOf(l.get('District__c')), String.valueOf(l.get('District__c')) ));  
                                      }               
        }            
        return opt;  
    } 
    
    public void fetchAffiliationDistrictOptions(){
        
        AffiliationDistrictOptions = getAffiliationDistrictOptions();  
        //    fetchInvoicingDistrictOptions();
        
    }        
    
    public SelectOption[] getAffiliationDistrictOptions() {  
        
        SelectOption[] opt = new SelectOption[]{};
            opt.add(new SelectOption('','--None--'));  
        if ( CarInsurance.Agent__c <> null && CarInsurance.ContractCountry__c <> null 
            && CarInsurance.ContractDistrict__c <> null) {
                for (AggregateResult l : [ SELECT  Affiliation__c, count(id)
                                          FROM wb_CountryDistrict__c 
                                          where Service__c = '車保険' 
                                          and Agent__c =:CarInsurance.Agent__c 
                                          and Country__c =:CarInsurance.ContractCountry__c 
                                          and District__c =:CarInsurance.ContractDistrict__c
                                          group by Affiliation__c 	]) {  
                                              opt.add(new SelectOption(String.valueOf(l.get('Affiliation__c')), 
                                                                       String.valueOf(l.get('Affiliation__c')) ));  
                                          }        
            }
        return opt;  
    } 
    
    
    public void fetchAttribute(){
        /*
        if (CarInsurance.ContractCompany__c != null ) {
            Account a = [select Classification__c from Account where id =:CarInsurance.ContractCompany__c ];
            CarInsurance.Attribute__c = a.Classification__c;
        } */
    }
    
    
    
    
    public void RetriveCarInfo(){
        
        if ( InsurancedCarsList[theInsurancedCarsIndex-1].theCar.Car__c != null ) {
            wb_Vehicle__c Car = [SELECT Id, Name, Ownership__c, UsingCompany__c, EngineNumber__c,FrameNo__c, LegalNumberofSeats__c, Model__c 
                                 FROM wb_Vehicle__c where ID =:InsurancedCarsList[theInsurancedCarsIndex-1].theCar.Car__c];
            InsurancedCarsList[theInsurancedCarsIndex-1].theCar.RegistryNumber__c = Car.Name;
            InsurancedCarsList[theInsurancedCarsIndex-1].theCar.Model__c = Car.Model__c;
            // CarInsuranceDetail.CarNo__c = Car.EngineNumber__c;
            InsurancedCarsList[theInsurancedCarsIndex-1].theCar.EngineNo__c = Car.EngineNumber__c;
            InsurancedCarsList[theInsurancedCarsIndex-1].theCar.FrameNo__c= Car.FrameNo__c;
            InsurancedCarsList[theInsurancedCarsIndex-1].theCar.LegalNumberofSeats__c = Car.LegalNumberofSeats__c;
            InsurancedCarsList[theInsurancedCarsIndex-1].theCar.UsingCompany__c = Car.UsingCompany__c;
            InsurancedCarsList[theInsurancedCarsIndex-1].theCar.Ownership__c = Car.Ownership__c;
            update InsurancedCarsList[theInsurancedCarsIndex-1].theCar;
            
        }
        
    }
    
    public PageReference validateHeader()
    {
        
        
        if ( CarInsurance.Agent__c ==''  ) 
            CarInsurance.Agent__c.addError('必須な項目'); 
        if ( CarInsurance.AffiliationDistrict__c == null ) 
            CarInsurance.AffiliationDistrict__c.addError('必須な項目'); 
        if ( CarInsurance.CommissionCurrency__c == '' ) 
            CarInsurance.CommissionCurrency__c.addError('必須な項目');  
        if ( CarInsurance.ContractDate__c == null ) 
            CarInsurance.ContractDate__c.addError('必須な項目');  
        if ( CarInsurance.ContractDistrict__c == null ) 
            CarInsurance.ContractDistrict__c.addError('必須な項目');  
        if ( CarInsurance.ContractCompany__c == null ) 
            CarInsurance.ContractCompany__c.addError('必須な項目');  
        
        if ( CarInsurance.Attribute__c == null ) 
            CarInsurance.Attribute__c.addError('必須な項目');  
        if ( CarInsurance.Status__c == null ) 
            CarInsurance.Status__c.addError('必須な項目');  
        
        return null;
    }
    
        public PageReference validateCars()
    {

        for ( wb_CarInsurancedCars__c cic: InsurancedCars){
              if (  cic.car__c == null ) 
            cic.car__c.addError('必須な項目'); 
        }      
        
        return null;
    }
    
    public wb_CarInsurance(ApexPages.StandardController stdController){
        
        this.stdController = stdController;
        //  if ( stdController.getRecord() <> null)
        CarInsurance = (wb_CarInsurance__c) stdController.getRecord();
        
        
        if ( CarInsurance.id != null ) {
            /*
            CarInsurance = [select Name, Status__c, Agent__c ,AffiliationDistrict__c,ContractDate__c,
                            ContractCompany__c,ContractCompany__r.name,
                            ContractDistrict__c,ContractCountry__c, Attribute__c, CommissionCurrency__c, 
                            AcctPIC__c
                            from wb_CarInsurance__c where id =: CarInsurance.Id];
            
            InsurancedCars = [SELECT id, Name, UsingCompany__c, EngineNo__c, Car__c, CarInsurance__c, Model__c, FrameNo__c,
                              LegalNumberofSeats__c,  Ownership__c,  FirstRegistryDate__c,
                              ReplacedDate__c,// Note__c, f_EffectiveInsurance__c,
                              PendingAction__c,OriginalCar__c 
                              FROM wb_CarInsurancedCars__c 
                              where CarInsurance__c =: CarInsurance.Id];
            
            InsurancedCarsList = new List<wb_CI_InsurancedCarRow>();
            InsurancedCarsPendingList = new List<wb_CI_InsurancedCarRow>();
            InsurancedCarsNoEffList = new List<wb_CI_InsurancedCarRow>();
            
            // Add filtering
            
            List<wb_CI_InsurancedCarRow> theCarsList = GetCarsList(CarInsurance.Id);
            
            for ( wb_CI_InsurancedCarRow car:theCarsList){
                if (car.IsPending == true)
                    InsurancedCarsPendingList.add( car);
                else if (car.IsAmendable == true)
                    InsurancedCarsList.add( car);
                else
                    InsurancedCarsNoEffList.add(car);
            }

            
            
            status = CarInsurance.Status__c;
*/
            RefreshMe();
        } else {
            CarInsurance = new wb_CarInsurance__c();
            CarInsurance.Status__c='未確定';
            InsurancedCars = new List<wb_CarInsurancedCars__c> ();
            InsurancedCarsList = new List<wb_CI_InsurancedCarRow>();
        }
        
        // New Option
        AgentOptions = getAgentOptions();
        ContractCountryOptions = getContractCountryOptions();
        
        ContractDistrictOptions = getContractDistrictOptions();  
        AffiliationDistrictOptions = getAffiliationDistrictOptions();
        
        
        CurrencyOptions = new SelectOption[]{}; 
            }
    
    public void RefreshMe(){
       // system.debug('RefreshMe' +CarInsurance.id );
        
        if ( CarInsurance.id != null ) {
            CarInsurance = [select Name, Status__c, Agent__c ,AffiliationDistrict__c,ContractDate__c,
                            ContractCompany__c,ContractCompany__r.name,
                            ContractDistrict__c,ContractCountry__c, Attribute__c, CommissionCurrency__c, 
                            AcctPIC__c
                            from wb_CarInsurance__c where id =: CarInsurance.Id];
            InsurancedCars = new list<wb_CarInsurancedCars__c>();
            
            InsurancedCars = [SELECT id, Name, UsingCompany__c, EngineNo__c, Car__c, CarInsurance__c, Model__c, FrameNo__c,
                              LegalNumberofSeats__c,  Ownership__c,  FirstRegistryDate__c,
                              ReplacedDate__c,// Note__c, f_EffectiveInsurance__c,
                              PendingAction__c,OriginalCar__c 
                              FROM wb_CarInsurancedCars__c 
                              where CarInsurance__c =: CarInsurance.Id];
            
            InsurancedCarsList = new List<wb_CI_InsurancedCarRow>();
            InsurancedCarsPendingList = new List<wb_CI_InsurancedCarRow>();
            InsurancedCarsNoEffList = new List<wb_CI_InsurancedCarRow>();
            
            // Add filtering
            
            List<wb_CI_InsurancedCarRow> theCarsList = GetCarsList(CarInsurance.Id);
            
            for ( wb_CI_InsurancedCarRow car:theCarsList){
                if (car.IsPending == true)
                    InsurancedCarsPendingList.add( car);
                else if (car.IsAmendable == true)
                    InsurancedCarsList.add( car);
                else
                    InsurancedCarsNoEffList.add(car);
            }

            
            
            status = CarInsurance.Status__c;
        }        
    }

    
    public List<wb_CI_InsurancedCarRow> GetCarsList(string id){
        Cars = new List<wb_CarInsurancedCars__c>();
        
        Cars = [SELECT id, Name, UsingCompany__c, EngineNo__c, Car__c, 
                CarInsurance__c, Model__c, FrameNo__c,
                LegalNumberofSeats__c,  Ownership__c,  FirstRegistryDate__c,
                ReplacedDate__c,// f_EffectiveInsurance__c,
                PendingAction__c,OriginalCar__c , RegistryNumber__c
                FROM wb_CarInsurancedCars__c 
                where CarInsurance__c =: Id
                order by RegistryNumber__c, id];
        Passengers = new List<wb_CIC_Passenger__c>();
        
        Passengers = [select Psgr_InsuranceCompany__c,Psgr_CommodityName__c, Psgr_InsurancePlan__c,
                      OP_CommodityName__c, OP_Plan__c, Psgr_CurrentEndDate__c, OP_CurrentEndDate__c,Psgr_CancelDate__c ,
                      Psgr_CurrentStartDate__c,OP_CancelDate__c,OP_CurrentStartDate__c,CarInsurancedCar__c, CarInsurancedCar__r.id
                      from wb_CIC_Passenger__c 
                      where CarInsurancedCar__r.CarInsurance__c =:id
                      order by CarInsurancedCar__r.id];
        Compulsoris = new  list<wb_CIC_Compulsory__c>();
        
        Compulsoris = [select Cps_InsuranceCompany__c,Vlt_InsuranceCompany__c, Cps_CurrentStartDate__c,
                       Cps_CurrentEndDate__c,Cps_CancelDate__c,Vlt_StartDate__c,Vlt_EndDate__c,Vlt_CancelDate__c, CarInsurancedCar__c , CarInsurancedCar__r.id
                       from wb_CIC_Compulsory__c 
                       where CarInsurancedCar__r.CarInsurance__c =:id
                       order by CarInsurancedCar__r.id];
        
        List<wb_CI_InsurancedCarRow> theCarList = new List<wb_CI_InsurancedCarRow>();
        
        List<wb_CIC_Passenger__c> Ps = new List<wb_CIC_Passenger__c>();
        List<wb_CIC_Compulsory__c> Cs = new List<wb_CIC_Compulsory__c>();
        integer cari=0, psgri=0, cpsi=0;
        integer psgrip, cpsip;
        
        
        for ( cari=0; cari < Cars.size(); cari ++ ){
            
            Ps = new List<wb_CIC_Passenger__c>();
            Cs = new List<wb_CIC_Compulsory__c>();
            
            for (psgri= 0 ; psgri < Passengers.size(); psgri ++ )
            {
                if ( Passengers[psgri].CarInsurancedCar__r.id == cars[cari].id){
                    wb_CIC_Passenger__c newp = new wb_CIC_Passenger__c();
                    newp = Passengers[psgri].clone(true);
                    Ps.add(newp);     
                } 
                
            }
            
            for (cpsi = 0 ; cpsi < Compulsoris.size(); cpsi ++ )
            {
                if ( Compulsoris[cpsi].CarInsurancedCar__r.id == cars[cari].id){
                    wb_CIC_Compulsory__c newc = new wb_CIC_Compulsory__c();
                    newc = Compulsoris[cpsi].clone(true);
                    Cs.add(newc);     
                }
                
            }
            
            
            theCarList.add(new wb_CI_InsurancedCarRow(cars[cari], Ps, Cs));
        }
        
        return theCarList;
    }
    
    
    public void ApplyFilter2CarsList(){
        
      
        List<wb_CI_InsurancedCarRow> theCarList = new List<wb_CI_InsurancedCarRow>();
        
        List<wb_CIC_Passenger__c> Ps = new List<wb_CIC_Passenger__c>();
        List<wb_CIC_Compulsory__c> Cs = new List<wb_CIC_Compulsory__c>();
        integer cari=0, psgri=0, cpsi=0;
        integer psgrip, cpsip;


        
        for ( cari=0; cari < Cars.size(); cari ++ ){
            string CarNumber = String.valueof(cars[cari].RegistryNumber__c).toUpperCase();
            
            if ( CarNumber.contains(CarFilter.touppercase()) || CarFilter == '' ||  CarFilter == null ) {
                Ps = new List<wb_CIC_Passenger__c>();
                Cs = new List<wb_CIC_Compulsory__c>();
                
                for (psgri = 0 ; psgri < Passengers.size(); psgri ++ )
                {
                    if ( Passengers[psgri].CarInsurancedCar__r.id == cars[cari].id){
                        wb_CIC_Passenger__c newp = new wb_CIC_Passenger__c();
                        newp = Passengers[psgri].clone(true);
                        Ps.add(newp);     
                    } 
                    
                }
                
                   
               system.debug( Compulsoris.size() + ' '  + cpsi + ' ' +  cars[cari].RegistryNumber__c + ' ' + cars[cari].id );
                
                for (cpsi = 0 ; cpsi < Compulsoris.size(); cpsi ++ )
                {
                     system.debug( Compulsoris[cpsi].CarInsurancedCar__r.id + ' ' +  cars[cari].id );
                    
                    if ( Compulsoris[cpsi].CarInsurancedCar__r.id == cars[cari].id){
                        wb_CIC_Compulsory__c newc = new wb_CIC_Compulsory__c();
                        newc = Compulsoris[cpsi].clone(true);
                        Cs.add(newc);     
                    }
                    
                }
                
    
              
                theCarList.add(new wb_CI_InsurancedCarRow(cars[cari], Ps, Cs));
            }
        }
        

        InsurancedCarsList = new List<wb_CI_InsurancedCarRow>();
        InsurancedCarsPendingList = new List<wb_CI_InsurancedCarRow>();
        InsurancedCarsNoEffList = new List<wb_CI_InsurancedCarRow>();
        
  
        for ( wb_CI_InsurancedCarRow car:theCarList){
            system.debug( car.theCar.RegistryNumber__c + ' ' + car.IsPending + ' ' + car.IsAmendable);
            if (car.IsPending == true)
                InsurancedCarsPendingList.add( car);
            else if (car.IsAmendable == true)
                InsurancedCarsList.add( car);
            else
                InsurancedCarsNoEffList.add(car);
        }
        
    }
    
    public PageReference UpdateRecords(){
        
        validateheader();
        
        if(ApexPages.hasMessages(ApexPages.Severity.Error)){
            ErrAlert = true;
            return null;
        } else ErrAlert = false;
        
        CarInsurance.Status__c = Status;
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        
        if (CarInsurance.id == null) {
            insert CarInsurance;
            //return new PageReference('https://cs6.salesforce.com/a0O/o');
            return new PageReference(sfdcBaseURL +'/a0O/o');
            
        }
        else {
            update CarInsurance;
            for  (wb_CarInsurancedCars__c ic:InsurancedCars) 
            {
                upsert ic;
            }
            
            
            return new PageReference(sfdcBaseURL+'/'+ CarInsurance.id);

        }
        
        
        //return null;
    }
    
    public PageReference validate()
    {
        

        return null;
    }
    
    public PageReference SaveRecords(){
        
        validateheader();
        validateCars();
        
        if(ApexPages.hasMessages(ApexPages.Severity.Error)){
            ErrAlert = true;
            return null;
        } else ErrAlert = false;
        
        CarInsurance.Status__c = Status;
        if (CarInsurance.id == null) {
            insert CarInsurance;
            String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
            return new PageReference(sfdcBaseURL+'/apex/wb_CarInsurance?Id=' + CarInsurance.id);
            
   
            
        }
        else {
            update CarInsurance;
            for  (wb_CarInsurancedCars__c ic:InsurancedCars) 
            {
                upsert ic;
            }
            
            return null;
            
        }
        
        
        
    }
    
    public PageReference validateAndSave()
    {
        
        validate();
        validateCars();
        if(ApexPages.hasMessages(ApexPages.Severity.Error))
            return null;   
      // RemoveEmptyRecord();
        return SaveRecords();
        // return null;
    }
    
    public PageReference validateAndUpdate()
    {
        
        validate();
         validateCars();
        if(ApexPages.hasMessages(ApexPages.Severity.Error))
            return null;
        
      // RemoveEmptyRecord();
        
        return  UpdateRecords();
    }
    
    public void RemoveEmptyRecord(){
           for ( wb_CarInsurancedCars__c cic:InsurancedCars)
           {
               if (cic.Car__c == null && cic.id != null)
               {
                   delete cic;
               }
               
               if ( cic.id != null)
               {
                   
                   if ( [select id from wb_CIC_Passenger__c where CarInsurancedCar__c =: cic.id].size() == 0 &&
                       [select id from wb_CIC_Compulsory__c where CarInsurancedCar__c =: cic.id].size() == 0
                      ){
                            theInsurancedCarsId = cic.id;
                          InsurancedCars_Remove();
                      }
                       
                   
               }
           }
       
    }
    
    public PageReference Cancel(){
        
        if (CarInsurance.id != null) {

              String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
            return new PageReference(sfdcBaseURL+'/' +  CarInsurance.id);
        }
        else {
            String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
            return new PageReference(sfdcBaseURL+MyHome);
           // return new PageReference(sfdcBaseURL+'/a0f/o');
   
        }
        
        
    }
    
    


}