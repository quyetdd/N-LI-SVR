public class wb_CarInsuranceCarsDetail {
    ApexPages.StandardController stdController;
    public PageReference refresh = ApexPages.currentPage();
    
    public wb_CarInsuranceCarsDetail(ApexPages.StandardController stdController){
        this.stdController = stdController;
        
        CarInsurancedCars = (wb_CarInsurancedCars__c) stdController.getRecord();
        //CarInsurancedCars.id ='a0QN0000005aLGQ';
        MeType = Apexpages.currentpage().getparameters().get('Type');
        if  (CarInsurancedCars.id != null) {
            CarInsurancedCars = [ select id, Name, CarInsurance__c, Car__c,FirstRegistryDate__c, UsingCompany__c,
                                 Model__c,Ownership__c, LegalNumberofSeats__c,EngineNo__c, ReplacedDate__c 
                                 from wb_CarInsurancedCars__c where id =: CarInsurancedCars.id];    
            
            CarInsurance = [SELECT Name, Id, ContractCompany__c,ContractCompany__r.name, CommissionCurrency__c,
                            ContractCountry__c, ContractDate__c, Attribute__c, Status__c
                            FROM wb_CarInsurance__c
                            where ID =:CarInsurancedCars.CarInsurance__c ];
            
            
            
            PassengerDT = new List<wb_CI_PassangerRow>();
            
            for ( wb_CIC_Passenger__c p:[SELECT Psgr_CancelDate__c , 
                                         Psgr_CurrentEndDate__c, Psgr_CurrentStartDate__c, 
                                         Psgr_StdDriverSeatFee__c, Psgr_StdPassengerSeatFee__c,Psgr_CommissionRate__c, Psgr_Commission__c, Psgr_AffiliationArea__c, 
                                         Psgr_CommodityName__c, Psgr_InitialStartDate__c, Psgr_InsuranceFee__c, 
                                         Psgr_InsuranceCompany__c, Psgr_InsurancePlan__c,  
                                         Psgr_Service__c,OP_CancelDate__c,
                                         OP_PolicyNumber__c,
                                         OP_CurrentEndDate__c, OP_CurrentStartDate__c, 
                                         OP_CommodityName__c,  OP_Plan__c, OP_Service__c, 
                                         OP_StdDriverSeatFee__c, OP_StdPassengerSeatFee__c, OP_InsuranceFee__c,	OP_CommissionRate__c, OP_Commission__c,
                                         Name, CarInsurancedCar__c, CarInsurancedCar__r.ReplacedDate__c, Id , Psgr_PolicyNumber__c,
                                         Psgr_CancelReason__c, PassagerSeatInsurance__c, DriverSeatInsurance__c,f_PsgrBillingAmount__c ,f_OPBillingAmount__c 
                                         FROM wb_CIC_Passenger__c where CarInsurancedCar__c =:CarInsurancedCars.id]
                ) {
                    PassengerDT.add( new wb_CI_PassangerRow(CarInsurance.ContractCountry__c, 
                                                            CarInsurance.CommissionCurrency__c, 
                                                            Integer.valueof( CarInsurancedCars.LegalNumberofSeats__c),
                                                            p
                                                           )
                                   );
                }
            
            
            CompulsoryDT = new List<wb_CI_CompulsoryRow>();
            
            for ( wb_CIC_Compulsory__c c:[SELECT Cps_PropertyLoss__c, Cps_PolicyNumber__c, Cps_NoLbtPropertyLoss__c, Cps_NoLbtAfterDeathImpediment__c, 
                                          Cps_NoLbtAfterDeathMedicalCost__c, Cps_AfterDeathImpediment__c, Cps_CommissionRate__c, 
                                          Cps_Commission__c, 
                                          Cps_MedicalCost__c, Cps_CancelReason__c, Cps_CancelDate__c, Cps_CurrentEndDate__c, Cps_InsuranceAmount__c, 
                                          Cps_CurrentStartDate__c, Cps_InsuranceCompany__c, Cps_Service__c, VIt_ScratchDamage__c, VIt_VehicleTheft__c, 
                                          VIt_VehicleDamage__c, Vlt_DriverInjury__c, Vlt_PassengerInjury__c, Vlt_PolicyNumber__c, Vlt_3rdPartyDamage__c, 
                                          Vlt_PsgrPersonalAccident__c, Vlt_CommissionRate__c, 
                                          Vlt_Commission__c, Vlt_Currency__c, Vlt_CancelReason__c, 
                                          Vlt_CancelDate__c, Vlt_EndDate__c, Vlt_InsuranceAmount__c, Vlt_StartDate__c, Vlt_InsuranceCompany__c, 
                                          Vlt_GlassBreakage__c, Vlt_OtherItems__c, Name, CarInsurancedCar__c, id ,
                                          Cps_Currency__c, Vlt_Selfburning__c, Vlt_Submersion__c, Vlt_Remark__c  
                                          FROM wb_CIC_Compulsory__c where CarInsurancedCar__c =:CarInsurancedCars.id]) {
                                              CompulsoryDT.add( new wb_CI_CompulsoryRow(CarInsurance.ContractCountry__c, 
                                                                                        CarInsurance.CommissionCurrency__c,
                                                                                        Integer.valueof( CarInsurancedCars.LegalNumberofSeats__c),
                                                                                        c
                                                                                       )
                                                              );
                                          }
            
        }
        else {
            
            CarInsurance = [SELECT Name, Id, ContractCompany__c,ContractCompany__r.name,
                            ContractCountry__c, ContractDate__c, Attribute__c, Status__c
                            FROM wb_CarInsurance__c
                            where ID =:CarInsurancedCars.CarInsurance__c ];
            
            CarInsurancedCars = new wb_CarInsurancedCars__c();
            CarInsurancedCars.CarInsurance__c = CarInsurance.id;
            PassengerDT = new List<wb_CI_PassangerRow>();
            CompulsoryDT = new List<wb_CI_CompulsoryRow>();
            
        }
        
        QuitMe = false;
        
    }
    
    public string MeType  {get;set;}
    public boolean QuitMe  {get;set;}
    //public boolean OpnCarTerminate {get;set;}
    public wb_CarInsurance__c CarInsurance {get;set;}
    public wb_CarInsurancedCars__c CarInsurancedCars {get;set;}
    
    public List<wb_CI_PassangerRow> PassengerDT {get;set;}
    public List<wb_CI_CompulsoryRow> CompulsoryDT {get;set;}
    
    public string thePassengerId {get;set;}
    public integer thePassengerIndex {get;set;}
    public void PassengerDT_remove(){
        if (thePassengerId != ''){
            if( PassengerDT.get(thePassengerIndex-1).thePassenger.id ==thePassengerId )
                delete PassengerDT.get(thePassengerIndex-1).thePassenger;
            PassengerDT.remove(thePassengerIndex-1);
        } else
        {
            PassengerDT.remove(thePassengerIndex-1);
        }
    }
    
    public string theCompulsoryId {get;set;}
    public integer theCompulsoryIndex {get;set;}
    public void CompulsoryDT_remove(){
        if (theCompulsoryId != ''){
            if( CompulsoryDT.get(theCompulsoryIndex-1).theCompulsory.id ==theCompulsoryId )
                delete CompulsoryDT.get(theCompulsoryIndex-1).theCompulsory;
            CompulsoryDT.remove(theCompulsoryIndex-1);
        } else
        {
            CompulsoryDT.remove(theCompulsoryIndex-1);
        }
    }
    
   // public wb_Vehicle__c Car {get;set;}
   // public wb_Service__c Service {get;set;}
    
   // public List<wb_Service__c> AllService{get;set;}
    
    
    public PageReference NewPassengerInsurance() {
        
        Integer n = [select id from  wb_CIC_Passenger__c where CarInsurancedCar__c =:CarInsurancedCars.id ].size();
        for ( wb_CI_PassangerRow p:PassengerDT) {
            if ( p.thePassenger.id == null){
                n ++;
            }
        }
        
        string nm = CarInsurancedCars.name + '-P' + string.valueof(n+1);            
        
        PassengerDT.add( new wb_CI_PassangerRow(CarInsurance.ContractCountry__c, 
                                                CarInsurance.CommissionCurrency__c, 
                                                Integer.valueof( CarInsurancedCars.LegalNumberofSeats__c),
                                                new wb_CIC_Passenger__c(CarInsurancedCar__c = CarInsurancedCars.id,  name = nm,
                                                                        Car__c = CarInsurancedCars.Car__c,
                                                                        PassagerSeatInsurance__c = CarInsurancedCars.LegalNumberofSeats__c - 1
                                                                       )
                                               )
                       );
        return null;
    }
    
    public PageReference NewCompulsoryInsurance() {
        
        Integer n = [select id from  wb_CIC_Compulsory__c where CarInsurancedCar__c =:CarInsurancedCars.id ].size();
        for ( wb_CI_CompulsoryRow p:CompulsoryDT) {
            if ( p.theCompulsory.id == null){
                n ++;
            }
        }
        
        string nm = CarInsurancedCars.name + '-C' + string.valueof(n+1);            
        
        CompulsoryDT.add( new wb_CI_CompulsoryRow(CarInsurance.ContractCountry__c, 
                                                  CarInsurance.CommissionCurrency__c, 
                                                  Integer.valueof( CarInsurancedCars.LegalNumberofSeats__c),
                                                  new wb_CIC_Compulsory__c(CarInsurancedCar__c = CarInsurancedCars.id,  name = nm, 
                                                                           Car__c = CarInsurancedCars.Car__c )
                                                 )
                        );
        
        return null;
    }
    
    
    public PageReference ValidateSaveClose(){
        
        validate();
        
        if(ApexPages.hasMessages(ApexPages.Severity.Error)){
            QuitMe = false;
            
        } else {
            for ( wb_CI_PassangerRow p:PassengerDT) {
                if (p.thePassenger.OP_Service__c != null && p.thePassenger.OP_CommodityName__c == null )
                    p.thePassenger.OP_Service__c = null;
                
                if ( p.thePassenger.id == null)
                    insert p.thePassenger;
                else
                    update p.thePassenger;
            }
            
            for ( wb_CI_CompulsoryRow c:CompulsoryDT) {
                if ( c.theCompulsory.id  == null)
                    insert c.theCompulsory;
                else
                    update c.theCompulsory;
            }
            QuitMe = true;
        }
        
        return null;
        
    }
    
    public PageReference ValidateSave(){
        
        validate();
        
        if(ApexPages.hasMessages(ApexPages.Severity.Error)){
            QuitMe = false;
            
        } else {
            for ( wb_CI_PassangerRow p:PassengerDT) {
                if ( p.thePassenger.id == null)
                    insert p.thePassenger;
                else
                    update p.thePassenger;
            }
            
            for ( wb_CI_CompulsoryRow c:CompulsoryDT) {
                if ( c.theCompulsory.id  == null)
                    insert c.theCompulsory;
                else
                    update c.theCompulsory;
            }
            QuitMe = false;
        }
        
        return null;
        
    }
    
    public PageReference validate()
    {
        for (wb_CI_PassangerRow psgr: PassengerDT)
        {
            if ( psgr.thePassenger.Psgr_InsuranceCompany__c == null ) 
                psgr.thePassenger.Psgr_InsuranceCompany__c.addError('!!!!');
            if ( psgr.thePassenger.Psgr_CommodityName__c == null ) 
                psgr.thePassenger.Psgr_CommodityName__c.addError('!!!!');
            
            if ( psgr.thePassenger.Psgr_InsurancePlan__c == null ) {
                psgr.thePassenger.Psgr_InsurancePlan__c.addError('!!!!'); 
            }   else {
                if ( psgr.thePassenger.Psgr_CurrentStartDate__c == null ) 
                    psgr.thePassenger.Psgr_CurrentStartDate__c.addError('!!!!'); 
                if ( psgr.thePassenger.Psgr_CurrentEndDate__c == null ) 
                    psgr.thePassenger.Psgr_CurrentEndDate__c.addError('!!!!'); 
            }
            
        }
        
        
        for (wb_CI_CompulsoryRow cps: CompulsoryDT)
        {
            
            if ( cps.theCompulsory.Cps_InsuranceCompany__c != null ||  cps.theCompulsory.Cps_CurrentStartDate__c != null
               ||  cps.theCompulsory.Cps_CurrentEndDate__c != null || cps.theCompulsory.Cps_InsuranceAmount__c != null ) {
                
                if ( cps.theCompulsory.Cps_CurrentStartDate__c == null ) 
                    cps.theCompulsory.Cps_CurrentStartDate__c.addError('!!!!'); 
                if ( cps.theCompulsory.Cps_CurrentEndDate__c == null ) 
                    cps.theCompulsory.Cps_CurrentEndDate__c.addError('!!!!'); 
                if ( cps.theCompulsory.Cps_InsuranceAmount__c == null ) 
                    cps.theCompulsory.Cps_InsuranceAmount__c.addError('!!!!'); 
                if ( cps.theCompulsory.Cps_InsuranceCompany__c == null ) 
                    cps.theCompulsory.Cps_InsuranceCompany__c.addError('!!!!'); 
              
            
            }
            
            if ( cps.theCompulsory.Vlt_InsuranceCompany__c != null || cps.theCompulsory.Vlt_StartDate__c != null ||
                cps.theCompulsory.Vlt_EndDate__c != null || cps.theCompulsory.Vlt_InsuranceAmount__c != null) {
                
                    if ( cps.theCompulsory.Vlt_StartDate__c == null ) 
                        cps.theCompulsory.Vlt_StartDate__c.addError('!!!!'); 
                    if ( cps.theCompulsory.Vlt_EndDate__c == null ) 
                        cps.theCompulsory.Vlt_EndDate__c.addError('!!!!'); 
                    if ( cps.theCompulsory.Vlt_InsuranceAmount__c == null ) 
                        cps.theCompulsory.Vlt_InsuranceAmount__c.addError('!!!!'); 
                    if ( cps.theCompulsory.Vlt_InsuranceCompany__c == null ) 
                        cps.theCompulsory.Vlt_InsuranceCompany__c.addError('!!!!'); 
                    if ( cps.theCompulsory.Vlt_CommissionRate__c == null ) 
                        cps.theCompulsory.Vlt_CommissionRate__c.addError('!!!!'); 
                
            }
               

        }
        
        return null;
    }
    
    public PageReference Cancel(){
        if (MeType=='popup'){
            QuitMe = true;
            return null;
        } else {
            PageReference returnPage = new PageReference(ApexPages.currentPage().getParameters().get('retURL'));
            return returnPage;
        }
        
        
    }

    
}