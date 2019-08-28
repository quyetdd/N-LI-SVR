public class wb_CarInsuranceAmend {
    
    ApexPages.StandardController stdController;
    public boolean QuitMe {get;set;} // To quit the window in Java
    public id CI_ID {get;set;}
    public string CIC_ID {get;set;}
    public string CIC_pendingID {get;set;}
    
    public string theMessage {get;set;}
    
    // Original Car
    public wb_CarInsurance__c CarInsurance {get;set;}
    public wb_CarInsurancedCars__c CarInsurancedCar {get;set;}
    
    public List<wb_CIC_Passenger__c> CIC_Passengers {get;set;}
    public List<wb_CIC_Compulsory__c> CIC_Compulsories {get;set;}
    
    // To handle the Addtional Car and Replacement
    public wb_CarInsurancedCars__c CarInsuranceAdditionalCar {get;set;}
    public List<wb_CI_PassangerRow> PassengerAdditionalDT {get;set;}
    public List<wb_CI_CompulsoryRow> CompulsoryAdditionalDT {get;set;}
    public List<wb_CI_PassangerRow> PassengerDT {get;set;}
    public List<wb_CI_CompulsoryRow> CompulsoryDT {get;set;}
    public date ReplacementDate  {get;set;}     
    
    // For Option
    public AvailableOption ChangeOption	{get;set;}
    
    public class AvailableOption{
        public boolean OpnCarExchange {get;set;}
        public boolean OpnCarTerminate {get;set;}
        public wb_CarInsurancedCars__c OrgCar {get;set;}
        public wb_CarInsurancedCars__c NewCar {get;set;}
        public date TerminateDate {get;set;}
        public string CancellationReason {get;set;}
        public boolean ValidPsgr {get;set;}
        public boolean PsgrTerminate {get;set;}
        public boolean ValidCps {get;set;}
        public boolean CpsTerminate {get;set;}
        public boolean ValidVlt {get;set;}
        public boolean VltTerminate {get;set;}
        
        public void fetchOpnCarExchange(){
            if (OpnCarExchange == true)
                OpnCarTerminate = false;
            else
                OpnCarTerminate = true;
        }
        
        public void fetchOpnCarTerminate(){
            if (OpnCarTerminate == true) {

                OpnCarExchange = false;          
            }
            else {
                NewCar.ReplacedDate__c = null;
                OpnCarExchange = true;
            }
            
        }
        
        public AvailableOption(wb_CarInsurancedCars__c oCar,
                               List<wb_CIC_Passenger__c> Psgr,
                               List<wb_CIC_Compulsory__c> Cps
                              ){
                                  OrgCar = oCar;
                                  NewCar = new wb_CarInsurancedCars__c();
                                  ValidPsgr = true;
                                  if ( Psgr.size()>0) {
                                      for ( wb_CIC_Passenger__c c:Psgr) {
                                          if ( c.Psgr_CancelDate__c != null)
                                              ValidPsgr = false;
                                      }
                                  } else
                                      ValidPsgr = false;
                                  
                                  ValidCps = true;
                                  if (Cps.size()>0 ) {
                                      for ( wb_CIC_Compulsory__c c:Cps) {
                                          if ( c.Cps_CancelDate__c != null)
                                              ValidCps = false;
                                      }
                                  } else
                                      ValidCps = false;
                                  
                                  ValidVlt = true;
                                  if (Cps.size()>0) {
                                      for ( wb_CIC_Compulsory__c c:Cps) {
                                          if ( c.Vlt_CancelDate__c != null)
                                              ValidVlt = false;
                                      }
                                  } else
                                      ValidVlt = false;
                                  
                                  
                              }
    }
    
    public boolean InvalidReplacementDate{ get; set; }
    public string InvalidReplacementDateMessage{ get; set; }
    
    
    
    // public List<wb_ReceivableServiceFee__c> Refund{get;set;}
    
    public List<ClsRefund> RefundList{get;set;}
    
    public class ClsRefund{
        public wb_ReceivableServiceFee__c Refund{get;set;}
        public decimal MainCommissionRate {get;set;}
        public decimal OPCommissionRate {get;set;}
        public string Memo{get;set;}
        public string OpMemo{get;set;}
        public  ClsRefund( wb_ReceivableServiceFee__c rf ){
            Refund = rf;
        }
        public  ClsRefund( wb_ReceivableServiceFee__c rf, string m, string m2 ){
            Refund = rf;
            Memo = m;
            OpMemo = m2;
        }
        
        public  ClsRefund( wb_ReceivableServiceFee__c rf, string m, string m2, decimal r1, decimal r2 ){
            Refund = rf;
            Memo = m;
            OpMemo = m2;
            MainCommissionRate = r1;
            OPCommissionRate = r2;
        }
        
        public void fetchServiceCommission(){
            system.debug('' + MainCommissionRate + ' ' +  Refund.ServiceCommission__c + ' ' + Refund.ServiceAmount__c);
            if ( MainCommissionRate != null )
            Refund.ServiceCommission__c = (Refund.ServiceAmount__c * ( MainCommissionRate / 100.0)).setScale(2); 
        }
    } 
    
    public wb_CarInsuranceAmend(ApexPages.StandardController stdController){
        
        this.stdController = stdController;
        CI_ID = apexpages.currentpage().getparameters().get('id');
        CIC_ID = apexpages.currentpage().getparameters().get('pv0');
        CIC_pendingID = apexpages.currentpage().getparameters().get('pv1');
        
        system.debug('CIC_ID CIC_pendingID:' + CIC_ID + ' ' + CIC_pendingID);
        
        
        CarInsurance = [SELECT Name, Id, ContractCompany__c,ContractCompany__r.name,CommissionCurrency__c,
                        ContractCountry__c, ContractDate__c, Attribute__c, Status__c
                        FROM wb_CarInsurance__c
                        where ID =:CI_ID];
        
        // To make change to an existing car　Car Replacement
        
        if (CIC_ID !='null') {
            if ( [select id from wb_CarInsurancedCars__c where pendingaction__c = null and OriginalCar__c =: CIC_ID].size() == 0 ) {
                CarInsurancedCar = [ select id, Name, CarInsurance__c, Car__c,Car__r.name, FirstRegistryDate__c, UsingCompany__c,
                                    Model__c,Ownership__c, LegalNumberofSeats__c,EngineNo__c, ReplacedDate__c 
                                    from wb_CarInsurancedCars__c where id =: CIC_ID];  
                CIC_Passengers = [SELECT Psgr_Service__c,  Psgr_InsurancePlan__c, 
                                  Psgr_InsuranceCompany__c, Psgr_InsuranceFee__c, Psgr_CancelReason__c, 
                                  Psgr_InitialStartDate__c, Psgr_CommodityName__c, Psgr_AffiliationArea__c, 
                                  Psgr_StdPassengerSeatFee__c, Psgr_StdDriverSeatFee__c, Psgr_CurrentStartDate__c, 
                                  Psgr_CurrentEndDate__c, Psgr_CancelDate__c, 
                                  OP_Service__c, OP_Plan__c, 
                                  OP_InsuranceFee__c, OP_CommodityName__c, 
                                  OP_StdPassengerSeatFee__c, OP_StdDriverSeatFee__c, OP_CurrentStartDate__c, 
                                  OP_CurrentEndDate__c, OP_CancelDate__c, 
                                  DriverSeatInsurance__c, PassagerSeatInsurance__c,
                                  Name, CarInsurancedCar__c, Psgr_Commission__c , Psgr_CommissionRate__c, OP_Commission__c, OP_CommissionRate__c, Car__c,
                                  f_PsgrBillingAmount__c 
                                  FROM wb_CIC_Passenger__c
                                  where CarInsurancedCar__c =: CarInsurancedCar.Id ];
                
                
                CIC_Compulsories = [SELECT Id,CarInsurancedCar__c, Cps_CurrentStartDate__c, Cps_CurrentEndDate__c,
                                    Cps_CancelDate__c, Cps_CancelReason__c, Cps_Service__c, Cps_InsuranceCompany__c, 
                                    Cps_PolicyNumber__c, Cps_Currency__c, Vlt_Currency__c, Vlt_CancelDate__c, Vlt_EndDate__c, 
                                    Vlt_CancelReason__c, Vlt_Service__c, Vlt_StartDate__c, Vlt_InsuranceCompany__c, Vlt_PolicyNumber__c,
                                    Cps_CommissionRate__c, Vlt_CommissionRate__c
                                    FROM wb_CIC_Compulsory__c 
                                    where CarInsurancedCar__c =:CarInsurancedCar.Id ];
                // Default　Change Option
                ChangeOption = new AvailableOption(CarInsurancedCar,CIC_Passengers,CIC_Compulsories);
                ChangeOption.OpnCarExchange = true;
                
                if ( CIC_pendingID == null){
                    
                    CarInsuranceAdditionalCar = new wb_CarInsurancedCars__c( CarInsurance__c = CarInsurance.id, 
                                                                            name = CarInsurancedCar.Name + 'r',
                                                                            OriginalCar__c = CarInsurancedCar.id);                    
                } else
                {
                    CarInsuranceAdditionalCar = [select id, name, Car__c, RegistryNumber__c, Model__c,EngineNo__c,LegalNumberofSeats__c ,UsingCompany__c,
                                                 Ownership__c , CarInsurance__c, pendingaction__c,ReplacedDate__c
                                                 from wb_CarInsurancedCars__c where id=:CIC_pendingID];
                    ChangeOption.NewCar.ReplacedDate__c = CarInsuranceAdditionalCar.ReplacedDate__c;
                    
                    Date d = ChangeOption.NewCar.ReplacedDate__c;
                    
                    for (wb_CIC_Passenger__c p:CIC_Passengers){
                        p.Psgr_CancelDate__c = d.addDays(-1);
                        p.OP_CancelDate__c = d.addDays(-1);
                    }
                    for ( wb_CIC_Compulsory__c c:CIC_Compulsories){
                        if ( c.Cps_CurrentStartDate__c <> null)
                            c.Cps_CancelDate__c = d.addDays(-1);
                        if ( c.Vlt_StartDate__c <> null)
                            c.Vlt_CancelDate__c = d.addDays(-1);
                    }
                    
                    PassengerAdditionalDT = new List<wb_CI_PassangerRow>();
                    
                    for ( wb_CIC_Passenger__c p:[SELECT Psgr_CancelDate__c , 
                                                 Psgr_CurrentEndDate__c, Psgr_CurrentStartDate__c, 
                                                 Psgr_StdDriverSeatFee__c, Psgr_StdPassengerSeatFee__c, Psgr_AffiliationArea__c, 
                                                 Psgr_CommodityName__c, Psgr_InitialStartDate__c, Psgr_InsuranceFee__c, 
                                                 Psgr_InsuranceCompany__c, Psgr_InsurancePlan__c,  
                                                 Psgr_Service__c,OP_CancelDate__c,
                                                 OP_PolicyNumber__c,
                                                 OP_CurrentEndDate__c, OP_CurrentStartDate__c, 
                                                 OP_CommodityName__c, OP_Plan__c, OP_Service__c, 
                                                 OP_StdDriverSeatFee__c, OP_StdPassengerSeatFee__c, OP_InsuranceFee__c,
                                                 Name, CarInsurancedCar__c, CarInsurancedCar__r.ReplacedDate__c, Id , Psgr_PolicyNumber__c,
                                                 Psgr_CancelReason__c, PassagerSeatInsurance__c, DriverSeatInsurance__c,
                                                 Psgr_RemainInsuranceFee__c,OP_RemainInsuranceFee__c ,
                                                 Psgr_Commission__c , Psgr_CommissionRate__c, OP_Commission__c, OP_CommissionRate__c,
                                                 f_PsgrBillingAmount__c,f_OPBillingAmount__c, Car__c
                                                 FROM wb_CIC_Passenger__c where CarInsurancedCar__c =:CarInsuranceAdditionalCar.id]
                        ) {
                            PassengerAdditionalDT.add( new wb_CI_PassangerRow(CarInsurance.ContractCountry__c, 
                                                                              CarInsurance.CommissionCurrency__c, 
                                                                              Integer.valueof( CarInsuranceAdditionalCar.LegalNumberofSeats__c),
                                                                              p
                                                                             )
                                                     );
                        }
                    
                    CompulsoryAdditionalDT = new List<wb_CI_CompulsoryRow>();
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
                                                  FROM wb_CIC_Compulsory__c where CarInsurancedCar__c =:CarInsuranceAdditionalCar.id]) {
                                                      CompulsoryAdditionalDT.add( new wb_CI_CompulsoryRow(CarInsurance.ContractCountry__c, 
                                                                                                          CarInsurance.CommissionCurrency__c,
                                                                                                          Integer.valueof( CarInsuranceAdditionalCar.LegalNumberofSeats__c),
                                                                                                          c
                                                                                                         )
                                                                                );
                                                  }
                    
                    
                }
                
            }
            
        }
        
        
        // To add a car to the contract
        if (CIC_ID == 'null'){
            
            if ( CIC_pendingID == null ) {
                Integer n = [select id from  wb_CarInsurancedCars__c where CarInsurance__c =:CarInsurance.id ].size();
                
                
                string nm = CarInsurance.name + '-A' + string.valueof(n+1);   
                
                CarInsuranceAdditionalCar = new wb_CarInsurancedCars__c( CarInsurance__c = CarInsurance.id, name = nm);
            } else {
                
                CarInsuranceAdditionalCar = [select id, name, Car__c, RegistryNumber__c, Model__c,EngineNo__c,LegalNumberofSeats__c ,UsingCompany__c,
                                             Ownership__c , CarInsurance__c, pendingaction__c
                                             from wb_CarInsurancedCars__c where id=:CIC_pendingID];
                
                PassengerAdditionalDT = new List<wb_CI_PassangerRow>();
                
                for ( wb_CIC_Passenger__c p:[SELECT Psgr_CancelDate__c , 
                                             Psgr_CurrentEndDate__c, Psgr_CurrentStartDate__c, 
                                             Psgr_StdDriverSeatFee__c, Psgr_StdPassengerSeatFee__c, Psgr_AffiliationArea__c, 
                                             Psgr_CommodityName__c, Psgr_InitialStartDate__c, Psgr_InsuranceFee__c, 
                                             Psgr_InsuranceCompany__c, Psgr_InsurancePlan__c,  
                                             Psgr_Service__c,OP_CancelDate__c,
                                             OP_PolicyNumber__c,
                                             OP_CurrentEndDate__c, OP_CurrentStartDate__c, 
                                             OP_CommodityName__c, OP_Plan__c, OP_Service__c, 
                                             OP_StdDriverSeatFee__c, OP_StdPassengerSeatFee__c, OP_InsuranceFee__c,
                                             Name, CarInsurancedCar__c, CarInsurancedCar__r.ReplacedDate__c, Id , Psgr_PolicyNumber__c,
                                             Psgr_CancelReason__c, PassagerSeatInsurance__c, DriverSeatInsurance__c,
                                             Psgr_RemainInsuranceFee__c,OP_RemainInsuranceFee__c ,
                                             Psgr_Commission__c , Psgr_CommissionRate__c, OP_Commission__c, OP_CommissionRate__c
                                             FROM wb_CIC_Passenger__c where CarInsurancedCar__c =:CarInsuranceAdditionalCar.id]
                    ) {
                        PassengerAdditionalDT.add( new wb_CI_PassangerRow(CarInsurance.ContractCountry__c, 
                                                                          CarInsurance.CommissionCurrency__c, 
                                                                          Integer.valueof( CarInsuranceAdditionalCar.LegalNumberofSeats__c),
                                                                          p
                                                                         )
                                                 );
                    }
                
                CompulsoryAdditionalDT = new List<wb_CI_CompulsoryRow>();
                
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
                                              FROM wb_CIC_Compulsory__c where CarInsurancedCar__c =:CarInsuranceAdditionalCar.id]) {
                                                  CompulsoryAdditionalDT.add( new wb_CI_CompulsoryRow(CarInsurance.ContractCountry__c, 
                                                                                                      CarInsurance.CommissionCurrency__c,
                                                                                                      Integer.valueof( CarInsuranceAdditionalCar.LegalNumberofSeats__c),
                                                                                                      c
                                                                                                     )
                                                                            );
                                              }
                
            }
            
            
            
            
        }
        
        if (CIC_pendingID==null){
            PassengerAdditionalDT = new List<wb_CI_PassangerRow>();
            CompulsoryAdditionalDT = new List<wb_CI_CompulsoryRow>();
        }
    }
    
    public void RetriveAddtionalCarInfo(){
        
        if ( CarInsuranceAdditionalCar.Car__c != null ) {
            wb_Vehicle__c Car = [SELECT Id, Name, Ownership__c, UsingCompany__c, EngineNumber__c, LegalNumberofSeats__c, Model__c 
                                 FROM wb_Vehicle__c where ID =:CarInsuranceAdditionalCar.Car__c];
            CarInsuranceAdditionalCar.RegistryNumber__c = Car.Name;
            CarInsuranceAdditionalCar.Model__c = Car.Model__c;
            CarInsuranceAdditionalCar.EngineNo__c = Car.EngineNumber__c;
            CarInsuranceAdditionalCar.LegalNumberofSeats__c = Car.LegalNumberofSeats__c;
            CarInsuranceAdditionalCar.UsingCompany__c = Car.UsingCompany__c;
            CarInsuranceAdditionalCar.Ownership__c = Car.Ownership__c;
            
        }
        
    }
    
    public PageReference NewAdditionalPassengerInsurance() {
        
        //Integer n = CarInsurancedCars.size();
        Integer n = [select id from  wb_CIC_Passenger__c where CarInsurancedCar__c =:CarInsuranceAdditionalCar.id ].size();
        for ( wb_CI_PassangerRow p:PassengerAdditionalDT) {
            if ( p.thePassenger.id == null){
                n ++;
            }
        }
        
        string nm = CarInsuranceAdditionalCar.name + '-PA' + string.valueof(n+1);   
        
        Date PsgEnd;
        
        if ([SELECT Psgr_CurrentEndDate__c 
                                    FROM wb_CIC_Passenger__c
             where CarInsurancedCar__r.CarInsurance__c =:CarInsuranceAdditionalCar.CarInsurance__c].size()>0)
        {
            wb_CIC_Passenger__c EndD = [SELECT Psgr_CurrentEndDate__c 
                                        FROM wb_CIC_Passenger__c
                                        where CarInsurancedCar__r.CarInsurance__c =:CarInsuranceAdditionalCar.CarInsurance__c
                                        and Psgr_CurrentEndDate__c !=null
                                        order by Psgr_CurrentEndDate__c desc limit 1];
            PsgEnd = EndD.Psgr_CurrentEndDate__c;
        }
       
            
        
        PassengerAdditionalDT.add( new wb_CI_PassangerRow(CarInsurance.ContractCountry__c, 
                                                          CarInsurance.CommissionCurrency__c, 
                                                          Integer.valueof( CarInsuranceAdditionalCar.LegalNumberofSeats__c),
                                                          true,
                                                          new wb_CIC_Passenger__c(CarInsurancedCar__c = CarInsuranceAdditionalCar.id,  
                                                                                  name = nm,
                                                                                  Car__c = CarInsuranceAdditionalCar.Car__c,
                                                                                  PassagerSeatInsurance__c = CarInsuranceAdditionalCar.LegalNumberofSeats__c - 1,
                                                                                  Psgr_CurrentEndDate__c = PsgEnd
                                                                               //   OP_CurrentEndDate__c= PsgEnd
                                                                                 )
                                                         )
                                 );
        return null;
    }
    
    public integer theAdditionalPassengerIdx {get;set;}
    
    public void AdditionalPassengerDT_remove(){
        
        if ( PassengerAdditionalDT[theAdditionalPassengerIdx-1].thePassenger.id <> null ){
           
            delete  PassengerAdditionalDT[theAdditionalPassengerIdx-1].thePassenger ;
        }
        PassengerAdditionalDT.remove(theAdditionalPassengerIdx-1);
        
    }
    
    public PageReference NewAdditionalCompulsoryInsurance() {
        
        Integer n = [select id from  wb_CIC_Compulsory__c where CarInsurancedCar__c =:CarInsuranceAdditionalCar.id ].size();
        for ( wb_CI_CompulsoryRow p:CompulsoryAdditionalDT) {
            if ( p.theCompulsory.id == null){
                n ++;
            }
        }
        
        string nm = CarInsuranceAdditionalCar.name + '-CA' + string.valueof(n+1);            
        
        CompulsoryAdditionalDT.add( new wb_CI_CompulsoryRow(CarInsurance.ContractCountry__c, 
                                                            CarInsurance.CommissionCurrency__c, 
                                                            Integer.valueof( CarInsuranceAdditionalCar.LegalNumberofSeats__c),
                                                            new wb_CIC_Compulsory__c(CarInsurancedCar__c = CarInsuranceAdditionalCar.id,  
                                                                                     name = nm,  Car__c = CarInsuranceAdditionalCar.Car__c,
                                                                                     Vlt_InsuranceAmount__c = 0 )
                                                           )
                                  );
        
        return null;
    }
    
    public integer theAdditionalCompulsoryIdx {get;set;}
    
    public void AdditionalCompulsoryDT_remove(){
        if (CompulsoryAdditionalDT[theAdditionalCompulsoryIdx-1].theCompulsory.id <> null ){
            delete CompulsoryAdditionalDT[theAdditionalCompulsoryIdx-1].theCompulsory;
        }
        CompulsoryAdditionalDT.remove(theAdditionalCompulsoryIdx-1);
        
    }
    
 public   PageReference ValidateConfirmAddtionalCarasDraft(){
        wb_CarInsurancedCars__c CurStatus = 
            [select PendingAction__c from wb_CarInsurancedCars__c where id =:CarInsuranceAdditionalCar.id ];
        if ( CurStatus.PendingAction__c == '増車待ち')
        {
            ValidateSaveAddtionalCar();
        }
      //QuitMe = true;
        return null;
    }
    
    public PageReference ValidateSaveAddtionalCarasDraft(){
        AddtionalCarValidation();
        if(ApexPages.hasMessages(ApexPages.Severity.Error)){
            QuitMe = false;
            
        }  else {
            CarInsuranceAdditionalCar.PendingAction__c = '増車待ち';
            if (CarInsuranceAdditionalCar.id == null)
                insert CarInsuranceAdditionalCar;
            else
                update CarInsuranceAdditionalCar;  
            
            for ( wb_CI_PassangerRow p:PassengerAdditionalDT) {
                if ( p.thePassenger.CarInsurancedCar__c == null )
                p.thePassenger.CarInsurancedCar__c = CarInsuranceAdditionalCar.id;
                if ( p.thePassenger.id == null)
                    insert p.thePassenger;
                else
                    update p.thePassenger;
            }
            
            for ( wb_CI_CompulsoryRow c:CompulsoryAdditionalDT) {
                if ( c.theCompulsory.CarInsurancedCar__c == null )
                c.theCompulsory.CarInsurancedCar__c = CarInsuranceAdditionalCar.id;
                if ( c.theCompulsory.id  == null)
                    insert c.theCompulsory;
                else
                    update c.theCompulsory;
            }
            QuitMe = true;
        }
        return null;
    }
    
    public PageReference ValidateSaveAddtionalCar(){
        
        AddtionalCarValidation();
        
        if(ApexPages.hasMessages(ApexPages.Severity.Error)){
            QuitMe = false;
            
        } else {
            CarInsuranceAdditionalCar.PendingAction__c = null;
            if (CarInsuranceAdditionalCar.id == null)
                insert CarInsuranceAdditionalCar;
            else 
                update CarInsuranceAdditionalCar;
            
            for ( wb_CI_PassangerRow p:PassengerAdditionalDT) {
                if ( p.thePassenger.CarInsurancedCar__c == null)
                    p.thePassenger.CarInsurancedCar__c = CarInsuranceAdditionalCar.id;
                if ( p.thePassenger.id == null)
                    insert p.thePassenger;
                else
                    update p.thePassenger;
            }
            
            for ( wb_CI_CompulsoryRow c:CompulsoryAdditionalDT) {
                if (c.theCompulsory.CarInsurancedCar__c == null)
                    c.theCompulsory.CarInsurancedCar__c = CarInsuranceAdditionalCar.id;
                if ( c.theCompulsory.id  == null)
                    insert c.theCompulsory;
                else
                    update c.theCompulsory;
            }
            
            wb_CarInsuranceBilling billing = new wb_CarInsuranceBilling();
            if ( billing.BillingAddtionCar(CarInsuranceAdditionalCar.id)==true)
                QuitMe = true;
            else
                QuitMe = false;
        }
        
        return null;
        
    }
    
    public   PageReference ValidateConfirmCarReplacementDrift(){
        wb_CarInsurancedCars__c CurStatus = 
            [select PendingAction__c from wb_CarInsurancedCars__c where id =:CarInsuranceAdditionalCar.id ];
        if ( CurStatus.PendingAction__c == '入替待ち')
        {
            SaveCarReplacement();
        }
        //QuitMe = true;
        return null;
    }
    
    public PageReference SaveCarReplacementAsDrift(){
        
        
        Validation();
        
        if(ApexPages.hasMessages(ApexPages.Severity.Error))
            QuitMe = false;
        else {
            CarInsuranceAdditionalCar.PendingAction__c = '入替待ち';
            upsert CarInsuranceAdditionalCar;  
            
            for ( wb_CI_PassangerRow p:PassengerAdditionalDT) {
                if (p.thePassenger.CarInsurancedCar__c == null)
                    p.thePassenger.CarInsurancedCar__c = CarInsuranceAdditionalCar.id;
                if (p.thePassenger.Car__c == null)
                    p.thePassenger.Car__c = CarInsuranceAdditionalCar.Car__c;
                upsert p.thePassenger;
            }
            
            for ( wb_CI_CompulsoryRow c:CompulsoryAdditionalDT) {
                if (c.theCompulsory.CarInsurancedCar__c == null)
                    c.theCompulsory.CarInsurancedCar__c = CarInsuranceAdditionalCar.id;
                if (c.theCompulsory.Car__c == null)
                    c.theCompulsory.Car__c = CarInsuranceAdditionalCar.Car__c;
                upsert c.theCompulsory; 
            }
            
            QuitMe = true;
        }
        
        return null;
    }
    
    public PageReference  SaveCarReplacement(){
        
              
        Validation();
        
        if(ApexPages.hasMessages(ApexPages.Severity.Error)==false) {
            
            //To Save the Replacement
            update CarInsurancedCar;
            
            for (wb_CIC_Passenger__c org_p:CIC_Passengers){
                update org_p;
            }
            for (wb_CIC_Compulsory__c org_c:CIC_Compulsories){
                update org_c;
            }
            CarInsuranceAdditionalCar.PendingAction__c = null;
            upsert CarInsuranceAdditionalCar;
            
            for ( wb_CI_PassangerRow p:PassengerAdditionalDT) {
                if (p.thePassenger.CarInsurancedCar__c==null )
                    p.thePassenger.CarInsurancedCar__c = CarInsuranceAdditionalCar.id;
                //if( p.thePassenger.Car__c == null)
                p.thePassenger.Car__c = CarInsuranceAdditionalCar.Car__c;
                
                upsert p.thePassenger;
                
            }
            
            for ( wb_CI_CompulsoryRow c:CompulsoryAdditionalDT) {
                if (c.theCompulsory.CarInsurancedCar__c==null)
                    c.theCompulsory.CarInsurancedCar__c = CarInsuranceAdditionalCar.id;
                c.theCompulsory.Car__c = CarInsuranceAdditionalCar.Car__c;
                
                upsert c.theCompulsory;
                
            }
            
            
            wb_CarInsuranceBilling billing = new wb_CarInsuranceBilling();
            if ( billing.BillingAddtionCar(CarInsuranceAdditionalCar.id)==true)
                QuitMe = true;
            else
                QuitMe = false;
        } else
            QuitMe = false;
        
        //QuitMe=true; 
        return  null;
    }
    
   public void Validation(){
                for (wb_CI_PassangerRow psgr: PassengerAdditionalDT)
        {
            if ( psgr.thePassenger.Psgr_InsuranceCompany__c == null ) 
                psgr.thePassenger.Psgr_InsuranceCompany__c.addError('!!!!');
            if ( psgr.thePassenger.Psgr_CommodityName__c == null ) 
                psgr.thePassenger.Psgr_CommodityName__c.addError('!!!!');
            
            if ( psgr.thePassenger.Psgr_InsurancePlan__c == null ) {
                psgr.thePassenger.Psgr_InsurancePlan__c.addError('!!!!'); 
            }
            
            else {
                // For Option Plan without Main Plan
                if ( psgr.thePassenger.OP_CurrentStartDate__c == null &&  psgr.thePassenger.OP_CurrentEndDate__c == null ) {
                    if ( psgr.thePassenger.Psgr_CurrentStartDate__c == null ) 
                        psgr.thePassenger.Psgr_CurrentStartDate__c.addError('!!!!'); 
                    if ( psgr.thePassenger.Psgr_CurrentEndDate__c == null ) 
                        psgr.thePassenger.Psgr_CurrentEndDate__c.addError('!!!!'); 
                }
                
                if (  psgr.thePassenger.OP_Plan__c != null && psgr.thePassenger.OP_CurrentStartDate__c != null &&  psgr.thePassenger.OP_CurrentEndDate__c != null ) {
                    if ( psgr.thePassenger.Psgr_CurrentEndDate__c != null && psgr.thePassenger.Psgr_CurrentStartDate__c == null ) 
                        psgr.thePassenger.Psgr_CurrentStartDate__c.addError('!!!!'); 
                    if (  psgr.thePassenger.Psgr_CurrentStartDate__c != null && psgr.thePassenger.Psgr_CurrentEndDate__c == null ) 
                        psgr.thePassenger.Psgr_CurrentEndDate__c.addError('!!!!'); 
                }
                
                
            }
            
        }
        
        
        for (wb_CI_CompulsoryRow cps: CompulsoryAdditionalDT)
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
    }
    
    public PageReference AddtionalCarValidation()
    {
        
        if ( CarInsuranceAdditionalCar.Car__c == null ) 
            CarInsuranceAdditionalCar.Car__c.addError('!!!!');
        if ( PassengerAdditionalDT.size()==0 && CompulsoryAdditionalDT.size()==0)
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter value to either Passanger or Compulsory Insurance!!!'));
        /*
        for (wb_CI_PassangerRow psgr: PassengerAdditionalDT)
        {
            if ( psgr.thePassenger.Psgr_InsuranceCompany__c == null ) 
                psgr.thePassenger.Psgr_InsuranceCompany__c.addError('!!!!');
            if ( psgr.thePassenger.Psgr_CommodityName__c == null ) 
                psgr.thePassenger.Psgr_CommodityName__c.addError('!!!!');
            
            if ( psgr.thePassenger.Psgr_InsurancePlan__c == null ) {
                psgr.thePassenger.Psgr_InsurancePlan__c.addError('!!!!'); 
            }
            
            else {
                // For Option Plan without Main Plan
                if ( psgr.thePassenger.OP_CurrentStartDate__c == null &&  psgr.thePassenger.OP_CurrentEndDate__c == null ) {
                    if ( psgr.thePassenger.Psgr_CurrentStartDate__c == null ) 
                        psgr.thePassenger.Psgr_CurrentStartDate__c.addError('!!!!'); 
                    if ( psgr.thePassenger.Psgr_CurrentEndDate__c == null ) 
                        psgr.thePassenger.Psgr_CurrentEndDate__c.addError('!!!!'); 
                }
                
                if (  psgr.thePassenger.OP_Plan__c != null && psgr.thePassenger.OP_CurrentStartDate__c != null &&  psgr.thePassenger.OP_CurrentEndDate__c != null ) {
                    if ( psgr.thePassenger.Psgr_CurrentEndDate__c != null && psgr.thePassenger.Psgr_CurrentStartDate__c == null ) 
                        psgr.thePassenger.Psgr_CurrentStartDate__c.addError('!!!!'); 
                    if (  psgr.thePassenger.Psgr_CurrentStartDate__c != null && psgr.thePassenger.Psgr_CurrentEndDate__c == null ) 
                        psgr.thePassenger.Psgr_CurrentEndDate__c.addError('!!!!'); 
                }
                
                
            }
            
        }
        
        
        for (wb_CI_CompulsoryRow cps: CompulsoryAdditionalDT)
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
        } */
        
        Validation();
        return null;
    }
    
    public PageReference ApplyChange(){
        
        
        if( ChangeOption.OpnCarExchange == true ){
            CarReplacement();
        } else if (ChangeOption.OpnCarTerminate == true ){
            CarTerminate();
        } 
        return null;
    }
    
    public PageReference CarReplacement(){
        
        Date d = ChangeOption.NewCar.ReplacedDate__c;
        
        CarInsuranceAdditionalCar.ReplacedDate__c=ChangeOption.NewCar.ReplacedDate__c;
        
        for (wb_CIC_Passenger__c p:CIC_Passengers){
            p.Psgr_CancelDate__c = d.addDays(-1);
            
            Date startDat = p.Psgr_CurrentStartDate__c;
            Date endDat = p.Psgr_CurrentEndDate__c;
            
            decimal daysofperiod = decimal.valueof(startDat.daysBetween(endDat)+1) ;
            decimal remainddays = decimal.valueof(startDat.daysBetween(endDat) + 1  - startDat.daysBetween(d)) ;
            decimal Psgr_RemainInsuranceFee,OP_RemainInsuranceFee;
            
            if ( p.Psgr_InsuranceFee__c != null  )
                Psgr_RemainInsuranceFee = (p.Psgr_InsuranceFee__c * (remainddays / daysofperiod )).setScale(2);
            else 
                Psgr_RemainInsuranceFee = 0;
            
            if (p.OP_InsuranceFee__c != null )
                OP_RemainInsuranceFee= (p.OP_InsuranceFee__c * (remainddays / daysofperiod )).setScale(2);
            else
                OP_RemainInsuranceFee=0;
            
            wb_CIC_Passenger__c psg = new wb_CIC_Passenger__c(
                Name = p.Name + 'e',
                Psgr_AffiliationArea__c = p.Psgr_AffiliationArea__c,
                Psgr_InsuranceCompany__c = p.Psgr_InsuranceCompany__c,
                Psgr_CommodityName__c = p.Psgr_CommodityName__c,
                Psgr_InsurancePlan__c = p.Psgr_InsurancePlan__c,
                Psgr_Service__c = p.Psgr_Service__c,
                
                Psgr_CurrentStartDate__c = p.Psgr_CurrentStartDate__c,
                Psgr_CurrentEndDate__c = p.Psgr_CurrentEndDate__c,
                Psgr_StdDriverSeatFee__c = p.Psgr_StdDriverSeatFee__c,
                Psgr_StdPassengerSeatFee__c = p.Psgr_StdPassengerSeatFee__c,
                //  Psgr_InsuranceSeat__c = p.Psgr_InsuranceSeat__c,            
                Psgr_RemainInsuranceFee__c = Psgr_RemainInsuranceFee
            );
            
            if (p.OP_CurrentStartDate__c != null){
                p.OP_CancelDate__c = d.addDays(-1);
                psg.OP_CommodityName__c = p.OP_CommodityName__c;
                psg.OP_Plan__c = p.OP_Plan__c;
                psg.OP_Service__c = p.OP_Service__c;
                
                psg.OP_CurrentStartDate__c = p.OP_CurrentStartDate__c;
                psg.OP_CurrentEndDate__c = p.OP_CurrentEndDate__c;
                psg.OP_StdDriverSeatFee__c = p.OP_StdDriverSeatFee__c;
                psg.OP_StdPassengerSeatFee__c = p.OP_StdPassengerSeatFee__c;
                psg.OP_RemainInsuranceFee__c = OP_RemainInsuranceFee;
            }
            
            PassengerAdditionalDT.add( new wb_CI_PassangerRow(CarInsurance.ContractCountry__c, 
                                                              CarInsurance.CommissionCurrency__c, 
                                                              Integer.valueof( CarInsuranceAdditionalCar.LegalNumberofSeats__c),
                                                              true,
                                                              psg,
                                                              d,// Starting Date 
                                                              string.valueOf(remainddays.setScale(0)) +'/'+ string.valueOf(daysofperiod.setScale(0))
                                                             ));
        }
        
        for (wb_CI_PassangerRow r:PassengerAdditionalDT){
            r.fetchPlanFee();
            r.fetchOPPlanFee();   
        }
        
        for ( wb_CIC_Compulsory__c c:CIC_Compulsories){
            if ( c.Cps_CurrentStartDate__c <> null)
                c.Cps_CancelDate__c = d.addDays(-1);
            if ( c.Vlt_StartDate__c <> null)
                c.Vlt_CancelDate__c = d.addDays(-1);
        }
        
        
        
        return  null;
    }
    
    public void ReplacementDateValidation(){
        if (ChangeOption.NewCar.ReplacedDate__c == null){
            InvalidReplacementDate = true;
            InvalidReplacementDateMessage = 'Empty Replacemnet Date is not allowed!!';
        } else 
            ApplyChange();
    }
    
    public void ResetReplacementDateValidationStatus(){
        InvalidReplacementDate = false;
        InvalidReplacementDateMessage = '';
    }
    
    public PageReference CarTerminate(){
        
        // Refund = New List<wb_ReceivableServiceFee__c>(); 
        RefundList = New List<ClsRefund>();
        system.debug('Refund' + RefundList.size() );
        Date d = ChangeOption.NewCar.ReplacedDate__c;
        //CarInsurancedCar.ReplacedDate__c = ChangeOption.NewCar.ReplacedDate__c;
        
        if (ChangeOption.PsgrTerminate==true) {
            for (wb_CIC_Passenger__c p:CIC_Passengers){
                
                wb_ReceivableServiceFee__c prf = new wb_ReceivableServiceFee__c();
                string m1;
                string m2;
                
               
                String Name = p.Name;
                //Name= Name.replace('e', '');
                wb_CIC_Passenger__c orgp = [ select Psgr_CurrentStartDate__c from wb_CIC_Passenger__c where name =:Name limit 1];
                
                Date OrgStartDate;
                 if ( CarInsurancedCar.name.indexOf('r')==-1)
                    OrgStartDate = orgp.Psgr_CurrentStartDate__c ;
                else
                     OrgStartDate = CarInsurancedCar.ReplacedDate__c ;
                
                decimal All_Psgr_InsuranceFee;
                decimal All_OP_InsuranceFee;
                decimal All_Psgr_Commission;
                decimal All_OP_Commission;
      
                String SOQL = 'select sum(Psgr_InsuranceFee__c), sum(OP_InsuranceFee__c), sum(Psgr_Commission__c), sum(OP_Commission__c) from wb_CIC_Passenger__c where name = \''+Name+'\'';
               
                AggregateResult AgR = database.query(SOQL);             
                
                All_Psgr_InsuranceFee = (Decimal) AgR.get('expr0');
                All_OP_InsuranceFee = (Decimal) AgR.get('expr1');
                All_Psgr_Commission = (Decimal) AgR.get('expr2');
                All_OP_Commission = (Decimal) AgR.get('expr3');
                system.debug('p ' + p.name + ' ' + p.Psgr_CurrentStartDate__c + ' ' + p.Psgr_CancelDate__c);
                
                //if ( p.Psgr_CurrentStartDate__c != null && p.Psgr_CancelDate__c == null )
                if ( p.Psgr_CurrentStartDate__c != null  )
                {
                    p.Psgr_CancelDate__c = d.addDays(-1);
                    p.Psgr_CancelReason__c = ChangeOption.CancellationReason;
                    //Date startDat = p.Psgr_CurrentStartDate__c;
                    
                    
                    Date startDat =  OrgStartDate;           
                    
                    Date endDat = p.Psgr_CurrentEndDate__c;
                    decimal daysofperiod = decimal.valueof(startDat.daysBetween(endDat.addDays(1))) ;
                    decimal remainddays = decimal.valueof(startDat.daysBetween(endDat.addDays(1)) - startDat.daysBetween(d)) ;
                    // decimal remaindfee =  p.Psgr_InsuranceFee__c * (remainddays / daysofperiod );
                    // 
                    Datetime cdate = d.addDays(-1);
                    
                    string Memo = '解約日：' + String.valueof(cdate.year()) +'/'+ String.valueof(cdate.month()) +'/'+ String.valueof(cdate.day()) + ':24:00 ';
                    Memo+='計算開始日：' + String.valueof(startDat.year()) +'/'+ String.valueof(startDat.month()) + '/'+String.valueof(startDat.day())+ ' ';
                    Memo+='満期日：' + String.valueof(endDat.year()) +'/'+ String.valueof(endDat.month()) +'/'+ String.valueof(endDat.day()) + ' ' ;
                    //Memo+='数式：' + String.valueof(p.Psgr_InsuranceFee__c) + '* (' + String.valueof(remainddays) + '/' + String.valueof(daysofperiod)+ ')';
                    
                    Memo+='数式：' + String.valueof(All_Psgr_InsuranceFee.setScale(2)) + ' * (' + String.valueof(remainddays) + '/' + String.valueof(daysofperiod)+ ')';
                    
                    prf.Date__c	= date.today();
                    prf.CarInsurance__c= CarInsurance.id;
                    prf.CarInsurancedCar__c=p.CarInsurancedCar__c;
                    prf.Country__c = CarInsurance.ContractCountry__c;
                    prf.Currency__c = CarInsurance.CommissionCurrency__c;
                    prf.InvoicingCompany__c= CarInsurance.ContractCompany__c;
                    prf.ServiceName__c = p.Psgr_CommodityName__c + p.Psgr_InsurancePlan__c;
                    prf.Classification__c ='返金';
                    //prf.ServiceAmount__c = - (p.Psgr_InsuranceFee__c * (remainddays / daysofperiod )).setScale(2); 
                    if (All_Psgr_InsuranceFee != null)
                        prf.ServiceAmount__c = - (All_Psgr_InsuranceFee * (remainddays / daysofperiod )).setScale(2);
                     if (All_Psgr_Commission != null)
                        prf.ServiceCommission__c = - (All_Psgr_Commission * (remainddays / daysofperiod )).setScale(2);
                    m1 = Memo;
                    
                }
                
                //if ( p.OP_CurrentStartDate__c != null && p.OP_CancelDate__c == null )
                if ( p.OP_CurrentStartDate__c != null )
                {
                    p.OP_CancelDate__c= d.addDays(-1);
                    
                    // Date startDat = p.Psgr_CurrentStartDate__c;
                    Date startDat =  OrgStartDate;  
                    Date endDat = p.OP_CurrentEndDate__c;
                    decimal daysofperiod = decimal.valueof(startDat.daysBetween(endDat.addDays(1))) ;
                    decimal remainddays = decimal.valueof(startDat.daysBetween(endDat.addDays(1)) - startDat.daysBetween(d)) ;
                    //decimal remaindfee =  p.OP_InsuranceFee__c * (remainddays / daysofperiod );
                    Datetime cdate = d.addDays(-1);
                    
                    string Memo = '解約日：' + String.valueof(cdate.year()) +'/'+ String.valueof(cdate.month()) +'/'+ String.valueof(cdate.day()) + ':24:00 ';
                    Memo+='計算開始日：' + String.valueof(startDat.year()) +'/'+ String.valueof(startDat.month()) + '/'+String.valueof(startDat.day())+ ' ';
                    Memo+='満期日：' + String.valueof(endDat.year()) +'/'+ String.valueof(endDat.month()) +'/'+ String.valueof(endDat.day()) + ' ' ;
                    //Memo+='数式：' + String.valueof(p.OP_InsuranceFee__c) + '* (' + String.valueof(remainddays) + '/' + String.valueof(daysofperiod)+ ')';
                    Memo+='数式：' + String.valueof(All_OP_InsuranceFee) + '* (' + String.valueof(remainddays) + '/' + String.valueof(daysofperiod)+ ')';
                    
                    
                    prf.OptionName__c =  p.OP_CommodityName__c + p.OP_Plan__c;
                    //prf.OptionAmount__c = - (p.OP_InsuranceFee__c * (remainddays / daysofperiod )).setScale(2);
                    if (All_OP_InsuranceFee!=null )
                        prf.OptionAmount__c = - (All_OP_InsuranceFee * (remainddays / daysofperiod )).setScale(2);
                    if (All_OP_Commission!=null )
                        prf.OptionCommission__c = - (All_OP_Commission * (remainddays / daysofperiod )).setScale(2);
                    
                    m2 = Memo;
                    
                }
                
                RefundList.add( new ClsRefund(prf, m1, m2));
            }
            
               system.debug('Refund' + RefundList.size());
            if (RefundList.size() > 0 ){
                  system.debug('Refund ' + RefundList[0].Refund.ServiceName__c + ' ' + RefundList[0].Refund.ServiceAmount__c );
            }
        } else {
			for (wb_CIC_Passenger__c p:CIC_Passengers){    
                if (p.Psgr_CancelDate__c != null)
                    p.Psgr_CancelDate__c = null;
                if (p.OP_CancelDate__c != null)
                    p.OP_CancelDate__c = null;
            }
        }
        
        
        for (wb_CIC_Compulsory__c c:CIC_Compulsories) {
            
            if (ChangeOption.CpsTerminate==true) {
                                
               // if( c.Cps_CurrentStartDate__c != null && c.Cps_CancelDate__c == null )
                if( c.Cps_CurrentStartDate__c != null  )
                {
                    c.Cps_CancelDate__c = d.addDays(-1);
                    c.Cps_CancelReason__c = ChangeOption.CancellationReason;
                    
                    system.debug('Cps_CommissionRate__c' + c.Cps_CommissionRate__c);
                    
                    RefundList.add( new clsRefund(new wb_ReceivableServiceFee__c (Date__c	= date.today(),
                                                                                  CarInsurance__c= CarInsurance.id,
                                                                                  CarInsurancedCar__c=c.CarInsurancedCar__c,
                                                                                  Country__c = CarInsurance.ContractCountry__c,
                                                                                  Currency__c = CarInsurance.CommissionCurrency__c,
                                                                                  InvoicingCompany__c= CarInsurance.ContractCompany__c,
                                                                                  ServiceName__c = '強制', //c.Cps_InsuranceCompany__c,
                                                                                  Classification__c ='返金'
                                                                                 ),
                                                  null,
                                                  null,
                                                  c.Cps_CommissionRate__c,
                                                  null
                                                 )
                                  );
                    
                }
                
            } else
            {
                 if( c.Cps_CancelDate__c != null )
                      c.Cps_CancelDate__c = null;
            }
            
            if (ChangeOption.VltTerminate==true){
                
                //if( c.Vlt_StartDate__c != null && c.Vlt_CancelDate__c == null ) 
                if( c.Vlt_StartDate__c != null  ) 
                {
                    c.Vlt_CancelDate__c = d.addDays(-1);
                    c.Vlt_CancelReason__c = ChangeOption.CancellationReason;
                    
                        system.debug('Vlt_CommissionRate__c' + c.Vlt_CommissionRate__c);
                    
                    RefundList.add( new ClsRefund( new wb_ReceivableServiceFee__c (Date__c	= date.today(),
                                                                                   CarInsurance__c= CarInsurance.id,
                                                                                   CarInsurancedCar__c=c.CarInsurancedCar__c,
                                                                                   Country__c = CarInsurance.ContractCountry__c,
                                                                                   Currency__c = CarInsurance.CommissionCurrency__c,
                                                                                   InvoicingCompany__c= CarInsurance.ContractCompany__c,
                                                                                   ServiceName__c = '任意', // c.Vlt_InsuranceCompany__c ,
                                                                                   Classification__c ='返金'
                                                                                  ),
                                                  null,
                                                  null,
                                                  c.Vlt_CommissionRate__c,
                                                  null
                                                 )
                                  );
                    
                }
                
            } else
            {
                 if( c.Vlt_CancelDate__c != null )
                      c.Vlt_CancelDate__c = null;
            }
        }
        
        //  }
        
        
        
        return null;
    }
    
    
    
    public PageReference  SaveRefund(){
        update CarInsurancedCar;
        for (wb_CIC_Passenger__c org_p:CIC_Passengers){
            update org_p;
        }
        for  (wb_CIC_Compulsory__c org_c:CIC_Compulsories){
            update org_c;
        }
        
        //insert Refund;
        for ( ClsRefund rf:RefundList) {
            rf.refund.memo__c = rf.memo + rf.Opmemo;
            insert rf.refund;
        }
        QuitMe=true;
        return  null;
    }
    
}