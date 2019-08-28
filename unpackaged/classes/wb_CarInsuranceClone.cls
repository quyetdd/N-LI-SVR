public class wb_CarInsuranceClone {
    ApexPages.StandardController stdController;
    public id OrgCI {get;set;}
    public id p_CarID {get;set;}
    public id p_ciid {get;set;}
    public integer p_size {get;set;}
    public string p_sql {get;set;}
    
    public wb_CarInsurance__c OldCI {get;set;}
    public List<wb_CarInsurancedCars__c> OldCICars {get;set;}
    public List<wb_CIC_Passenger__c> OldCIPassengerInsurance { get; set; }
    public List<wb_CIC_Compulsory__c> OldCICompulsoryInsurance { get; set;}
    public List<wb_CI_InsurancedCarRow> OldInsurancedCarsList {get;set;}
    


    public CarInsurance theNewCarInsurance {get;set;}
    
    public class CarInsurance {
        public wb_CarInsurance__c Header  { get; set; }
        public List<CarInsuranceDetail> Detail  { get; set; }
        
        public CarInsurance(wb_CarInsurance__c h){
            Header = h;
            Detail = new List<CarInsuranceDetail>();
        }
    }
    
    public class CarInsuranceDetail {
        public wb_Vehicle__c theCar { get; set; }
        public wb_CarInsurancedCars__c theCIC { get; set; }
        public List<wb_CI_PassangerRow> PsgrBatch { get; set; }
        public List<wb_CI_CompulsoryRow> CpsBatch { get; set; }
        public CarInsuranceDetail(wb_CarInsurancedCars__c row){
            theCIC = row;
        }
        
        public CarInsuranceDetail(  string Country , string Cur, wb_CarInsurancedCars__c CIC,  List<wb_CIC_Passenger__c> Psgr, List<wb_CIC_Compulsory__c>  Cps){
      
            theCIC = CIC;
            //PsgrBatch=Psgr;
                     PsgrBatch = new List<wb_CI_PassangerRow>();
            for (wb_CIC_Passenger__c p:Psgr){
                wb_CI_PassangerRow pr = new wb_CI_PassangerRow(p);
                pr.theCountry = Country;
                pr.theCommissionCurrency = Cur;
                pr.theLegalNumberofSeats = Integer.valueOf( theCIC.LegalNumberofSeats__c);
                pr.FeeCalculatedbyDay = false;
                PsgrBatch.add(pr);
            }
            
            CpsBatch = new List<wb_CI_CompulsoryRow>();
            for (wb_CIC_Compulsory__c c:Cps){
                wb_CI_CompulsoryRow cr = new wb_CI_CompulsoryRow(c);
                cr.theCountry =Country;
                cr.theCommissionCurrency = Cur;
              //  cr.theLegalNumberofSeats = Integer.valueOf( theCIC.LegalNumberofSeats__c);
              //  cr.FeeCalculatedbyDay = false;
                CpsBatch.add(cr);
            }                       

            
            //CpsBatch=Cps;
        }
    }
    
    
    public wb_CarInsurance__c NewCI {get;set;}
    public List<wb_CarInsurancedCars__c> NewCICars {get;set;}
    public List<wb_CIC_Passenger__c> NewCIPassengerInsurance { get; set; }
    public List<wb_CIC_Compulsory__c> NewCICompulsoryInsurance { get; set; }
    
    
    public wb_CarInsurance__c CI {get;set;}
    public List<wb_CarInsurancedCars__c> CICars {get;set;}
    public List<wb_CIC_Passenger__c> CIPassengerInsurance { get; set; }
    public List<wb_CIC_Compulsory__c> CICompulsoryInsurance { get; set; }
    public List<wb_CI_InsurancedCarRow> NewInsurancedCarsList {get;set;}
    
    public boolean QuitMe { get; set; }
    
    public wb_CarInsuranceClone(ApexPages.StandardController stdController){
        this.stdController = stdController;
        CI = (wb_CarInsurance__c) stdController.getRecord();
        CI = [select id, name from wb_CarInsurance__c where id =: CI.id ];
        OrgCI = CI.id;
        
        
    }
    
    public void ApplytoContinue(){
        
        NewCI=null;
        NewCICars = new List<wb_CarInsurancedCars__c>();
        for ( wb_CI_InsurancedCarRow sl:OldInsurancedCarsList){
            if (sl.IsSelected == true){
                if (NewCI == null){
                    NewCI = new wb_CarInsurance__c ( Status__c = '未確定', ContractDate__c =  date.today(), PreriousContract__c = OrgCI,
                                                    CommissionCurrency__c = oldCI.CommissionCurrency__c, AffiliationDistrict__c = oldCI.AffiliationDistrict__c,
                                                    Attribute__c = oldCI.Attribute__c, ContractDistrict__c = oldCI.ContractDistrict__c,
                                                    ContractCountry__c = oldCI.ContractCountry__c,
                                                    ContractCompany__c=oldCI.ContractCompany__c, 
                                                    Agent__c =oldCI.Agent__c, AcctPIC__c=oldCI.AcctPIC__c );
                    theNewCarInsurance = new CarInsurance(NewCI);
                }
                
                boolean found = false;
                integer theIdx;
                for ( integer i=0; i < theNewCarInsurance.Detail.size(); i ++){
                    if ( theNewCarInsurance.Detail[i].theCIC.Car__c == sl.theCar.Car__c )
                    {
                        theNewCarInsurance.Detail[i].theCIC.Pattern__c+=';' + sl.theCar.name;
                        found = true;
                        theIdx = i;
                        i = theNewCarInsurance.Detail.size();
                    }
                }
                
                if (found == false ) {
                    wb_CarInsurancedCars__c nCiC = new wb_CarInsurancedCars__c( 
                        RegistryNumber__c = sl.theCar.Car__r.Name,
                        FirstRegistryDate__c = sl.theCar.FirstRegistryDate__c, 
                        LegalNumberofSeats__c = sl.theCar.Car__r.LegalNumberofSeats__c,
                        UsingCompany__c = sl.theCar.Car__r.UsingCompany__c, 
                        Car__c = sl.theCar.Car__c, 
                        Model__c = sl.theCar.Car__r.Model__c, 
                        Ownership__c = sl.theCar.Car__r.Ownership__c,
                        EngineNo__c = sl.theCar.Car__r.EngineNumber__c,
                        Pattern__c='継続' +';' + sl.theCar.name
                    ) ;
                    
                    List<wb_CIC_Passenger__c> newpl = new List<wb_CIC_Passenger__c>();
                    for ( wb_CIC_Passenger__c p:OldCIPassengerInsurance)
                    {
                        if (p.CarInsurancedCar__c == sl.theCar.id){
                            wb_CIC_Passenger__c newp = new wb_CIC_Passenger__c();
                            newp = p.clone(false);
                           
                            date s;
                            if ( newp.Psgr_CurrentEndDate__c != null) {
                                s = newp.Psgr_CurrentEndDate__c;
                                s = s.addDays(1);
                                newp.Psgr_CurrentStartDate__c = s;
                                s = s.addYears(1);
                                s = s.addDays(-1);
                                newp.Psgr_CurrentEndDate__c = s; 
                            }
                            
                            if ( newp.OP_CurrentEndDate__c != null) {
                                s = newp.OP_CurrentEndDate__c;
                                s = s.addDays(1);
                                newp.OP_CurrentStartDate__c = s;
                                s = s.addYears(1);
                                s = s.addDays(-1);
                                newp.OP_CurrentEndDate__c = s; 
                            }
                                
                            
                            
                            newp.Car__c=sl.theCar.Car__c;
							newp.CarInsurancedCar__c = null;                           
                            newpl.add(newp);
                        }
                    }
                    
                    List<wb_CIC_Compulsory__c> newcl = new List<wb_CIC_Compulsory__c>();
                    for ( wb_CIC_Compulsory__c c:OldCICompulsoryInsurance)
                    {
                        if (c.CarInsurancedCar__c == sl.theCar.id){
                            wb_CIC_Compulsory__c newc = new wb_CIC_Compulsory__c();
                            newc = c.clone(false);
                            newc.Car__c=sl.theCar.Car__c;
                            newc.CarInsurancedCar__c = null;   
                            date s;
                            if ( newc.Cps_CurrentEndDate__c != null) {
                                s = newc.Cps_CurrentEndDate__c;
                                s = s.addDays(1);
                                newc.Cps_CurrentStartDate__c = s;
                                s = s.addYears(1);
                                s = s.addDays(-1);
                                newc.Cps_CurrentEndDate__c = s; 
                            }
                            
                            if ( newc.Vlt_EndDate__c != null) {
                                s = newc.Vlt_EndDate__c;
                                s = s.addDays(1);
                                newc.Vlt_StartDate__c = s;
                                s = s.addYears(1);
                                s = s.addDays(-1);
                                newc.Vlt_EndDate__c = s; 
                            }
                            newcl.add(newc);
                        }
                    }
                    
                    theNewCarInsurance.Detail.add(  new CarInsuranceDetail(  theNewCarInsurance.Header.ContractCountry__c,
                                                                           theNewCarInsurance.Header.CommissionCurrency__c,
                                                                           nCiC,
                                                                           newpl,
                                                                           newcl
                                                                          ));
                    
                    NewCICars.add( nCiC );
                } 
                else {
                    
                    List<wb_CIC_Passenger__c> newpl = new List<wb_CIC_Passenger__c>();
                    for ( wb_CIC_Passenger__c p:OldCIPassengerInsurance)
                    {
                        if (p.CarInsurancedCar__c == sl.theCar.id){
                            wb_CIC_Passenger__c newp = new wb_CIC_Passenger__c();
                            newp = p.clone(false);
                            newp.Car__c=sl.theCar.Car__c;
                            newp.CarInsurancedCar__c = null;  
                            
                            date s;
                            if ( newp.Psgr_CurrentEndDate__c != null) {
                                s = newp.Psgr_CurrentEndDate__c;
                                s = s.addDays(1);
                                newp.Psgr_CurrentStartDate__c = s;
                                s = s.addYears(1);
                                s = s.addDays(-1);
                                newp.Psgr_CurrentEndDate__c = s; 
                            }
                            
                            if ( newp.OP_CurrentEndDate__c != null) {
                                s = newp.OP_CurrentEndDate__c;
                                s = s.addDays(1);
                                newp.OP_CurrentStartDate__c = s;
                                s = s.addYears(1);
                                s = s.addDays(-1);
                                newp.OP_CurrentEndDate__c = s; 
                            }
                            
                            wb_CI_PassangerRow pr = new wb_CI_PassangerRow(newp);
                            pr.theCountry = theNewCarInsurance.Header.ContractCountry__c;
                            pr.theCommissionCurrency = theNewCarInsurance.Header.CommissionCurrency__c;
                            pr.theLegalNumberofSeats = Integer.valueOf( theNewCarInsurance.Detail[theIdx].theCIC.LegalNumberofSeats__c);
                            theNewCarInsurance.Detail[theIdx].PsgrBatch.add(pr);   
                            // newpl.add(newp);
                        }
                    }
                    
                    List<wb_CIC_Compulsory__c> newcl = new List<wb_CIC_Compulsory__c>();
                    for ( wb_CIC_Compulsory__c c:OldCICompulsoryInsurance)
                    {
                        if (c.CarInsurancedCar__c == sl.theCar.id){
                            wb_CIC_Compulsory__c newc = new wb_CIC_Compulsory__c();
                            newc = c.clone(false);
                            newc.Car__c=sl.theCar.Car__c;
                            newc.CarInsurancedCar__c = null;  
                            
                            date s;
                            if ( newc.Cps_CurrentEndDate__c != null) {
                                s = newc.Cps_CurrentEndDate__c;
                                s = s.addDays(1);
                                newc.Cps_CurrentStartDate__c = s;
                                s = s.addYears(1);
                                s = s.addDays(-1);
                                newc.Cps_CurrentEndDate__c = s; 
                            }
                            
                            if ( newc.Vlt_EndDate__c != null) {
                                s = newc.Vlt_EndDate__c;
                                s = s.addDays(1);
                                newc.Vlt_StartDate__c = s;
                                s = s.addYears(1);
                                s = s.addDays(-1);
                                newc.Vlt_EndDate__c = s; 
                            }
                
                            wb_CI_CompulsoryRow cr = new wb_CI_CompulsoryRow(newc);
                            cr.theCountry =theNewCarInsurance.Header.ContractCountry__c;
                            cr.theCommissionCurrency = theNewCarInsurance.Header.CommissionCurrency__c;
                            
                            theNewCarInsurance.Detail[theIdx].CpsBatch.add(cr);
                            // newcl.add(newc);
                        }
                    }
                    
                    
                }
                
                
            }
            
            
        }

        List<wb_Service__c> PsgrService = [ SELECT  ServiceCompany__c, Service__c, Plan__c, MaxSeat__c, MinSeat__c, Currency__c, PassengerFee__c, DriverFee__c,
                                           DriverSeatInsurance__c,CommissionRate__c, group__r.maintype__c, ParentService__c, DataType__c, ParentService__r.Optiontype__c
                                           FROM wb_Service__c 
                                           where  Country__c =:theNewCarInsurance.Header.ContractCountry__c  
                                           and ServiceClassification__c = '搭乗'  
                                           and Enable__c = true 
                                           order by ServiceCompany__c, Service__c, Plan__c, lastmodifieddate desc
                                          ];
        
       // CIPassengerInsurance = new List<wb_CIC_Passenger__c>();
       // 
        for ( CarInsuranceDetail d:theNewCarInsurance.Detail ) {
            if (d.PsgrBatch != null) {
                for (wb_CI_PassangerRow pr:d.PsgrBatch) {
                pr.fetchPlanFeeOnlyOffLine( integer.valueof(d.theCIC.LegalNumberofSeats__c) , PsgrService);
                pr.fetchOPPlanFeeOffLine(PsgrService);
                }
            }
        }
        
          List<wb_Service__c> CpsService =[SELECT Id, ServiceCompany__c, Currency__c,
                                         Cps_MedicalCost__c, Cps_AfterDeathImpediment__c, Cps_NoLbtAfterDeathMedicalCost__c, Cps_NoLbtAfterDeathImpediment__c, 
                                         Cps_NoLbtPropertyLoss__c, Cps_PropertyLoss__c, 
                                         CommissionRate__c, ContactNumber__c
                                         FROM wb_Service__c 
                                         where Country__c =:theNewCarInsurance.Header.ContractCountry__c  
                                         and ServiceClassification__c = '強制'  and Enable__c = true
                                         order by ServiceCompany__c ];
        
        for ( CarInsuranceDetail d:theNewCarInsurance.Detail ) {
            if ( d.CpsBatch != null ) {
                for ( wb_CI_CompulsoryRow cr:d.CpsBatch) {
                if ( cr.theCompulsory.Cps_InsuranceCompany__c != null)
                    cr.fetchComplusoryInsuranceFeeOffline(  CpsService);
                }
            }
            
        }
        
        List<wb_Service__c> VltService = [SELECT Id, Currency__c, ServiceCompany__c, CommissionRate__c
                                          FROM wb_Service__c 
                                          where Country__c =:theNewCarInsurance.Header.ContractCountry__c  
                                          and ServiceClassification__c = '任意'  and Enable__c = true order by ServiceCompany__c];
        
        for ( CarInsuranceDetail d:theNewCarInsurance.Detail ) {
            if (d.CpsBatch != null ){ 
                  for ( wb_CI_CompulsoryRow cr:d.CpsBatch) {
                if ( cr.theCompulsory.Vlt_InsuranceCompany__c != null)
                    cr.fetchVoluntaryInsuranceFeeOffLine( VltService);
                  }
            }
            
        }
        
    
        NewInsurancedCarsList = new List<wb_CI_InsurancedCarRow>();
        
        for ( CarInsuranceDetail d:theNewCarInsurance.Detail){
            List<wb_CIC_Passenger__c>   pl = new List<wb_CIC_Passenger__c>();
            List<wb_CIC_Compulsory__c> cl = new List<wb_CIC_Compulsory__c>();
            for ( wb_CI_PassangerRow pr:d.PsgrBatch){
                pl.add(pr.thePassenger);
            }
            
            for ( wb_CI_CompulsoryRow cr:d.CpsBatch){
                cl.add(cr.theCompulsory);
            }
       // system.debug(d.theCIC.id + ' ' + pl.size() +' '+ pl[0].Psgr_InsuranceCompany__c +' ' + pl[0].Psgr_CommodityName__c +' ' + pl[0].CarInsurancedCar__c +  cl.size());
        NewInsurancedCarsList.add(new wb_CI_InsurancedCarRow(d.theCIC, pl, cl));
            
        }
    }
    
   
   public void SaveSelectContinue(){
       // upsert theCars;
        /*
        for ( CarInsuranceDetail d:theCarInsurance.Detail){
            if ( d.theRow.Car__c == null)
                d.theRow.Car__c = d.theCar.id;
        }*/
        

        upsert NewCI;
        
         NewCI = [select id, name, CommissionCurrency__c, AffiliationDistrict__c,
                     ContractDate__c, ContractDistrict__c, Agent__c, ContractCompany__c, Attribute__c,
                     Status__c
                     from wb_CarInsurance__c where id=: NewCI.id ];
        
        integer i = 1;
        for ( wb_CarInsurancedCars__c d:NewCICars){
            d.CarInsurance__c = NewCI.id;
            d.Name =  NewCI.name +'-' + i;
            i ++;
        }
        upsert NewCICars;
        
       NewCIPassengerInsurance = new List<wb_CIC_Passenger__c>();
       
        for ( CarInsuranceDetail d:theNewCarInsurance.Detail){
            if ( d.PsgrBatch != null) {
                //d.theRow.Car__c = d.theCar.id;
                i = 1;
                for ( wb_CI_PassangerRow pb: d.PsgrBatch){
                    pb.thePassenger.CarInsurancedCar__c = d.theCIC.id;
                    pb.thePassenger.name = d.theCIC.name + i;
                   // pb.thePassenger.Car__c = d.theCar.id;
                   NewCIPassengerInsurance.add(pb.thePassenger);
                    i ++;
                }
            }
        }
        
     NewCICompulsoryInsurance = new List<wb_CIC_Compulsory__c>();
           
        for ( CarInsuranceDetail d:theNewCarInsurance.Detail){
            if ( d.CPsBatch != null) {
                //d.theRow.Car__c = d.theCar.id;
                i = 1;
                for ( wb_CI_CompulsoryRow cb: d.CpsBatch){
                    cb.theCompulsory.CarInsurancedCar__c = d.theCIC.id;
                     cb.theCompulsory.name = d.theCIC.name + i;
                   // cb.theCompulsory.Car__c = d.theCar.id;
                   NewCICompulsoryInsurance.add(cb.theCompulsory);
                   i ++;
                }
            }
        }
       
        if ( NewCIPassengerInsurance.size() > 0)
            upsert NewCIPassengerInsurance;
        if ( NewCICompulsoryInsurance.size() > 0)
            upsert NewCICompulsoryInsurance;
        

        
    }
    
    
    public PageReference CIContinue(){
        id ciid;
        ciid= OrgCI;   
        oldCI =  [SELECT id, Name, Status__c, CommissionCurrency__c, AffiliationDistrict__c, Attribute__c, ContractDate__c, ContractDistrict__c, 
                  ContractCountry__c, ContractCompany__c, Agent__c ,AcctPIC__c
                  FROM wb_CarInsurance__c where id = :ciid];
        
     //   system.debug( 'CIContinue:' + oldCI.name);
      
        if ( oldCI.Status__c == '確定'){
            CI = new wb_CarInsurance__c ( Status__c = '未確定', ContractDate__c =  date.today(), PreriousContract__c = OrgCI,
                                         CommissionCurrency__c = oldCI.CommissionCurrency__c, AffiliationDistrict__c = oldCI.AffiliationDistrict__c,
                                         Attribute__c = oldCI.Attribute__c, ContractDistrict__c = oldCI.ContractDistrict__c,
                                         ContractCountry__c = oldCI.ContractCountry__c,
                                         ContractCompany__c=oldCI.ContractCompany__c, 
                                         Agent__c =oldCI.Agent__c, AcctPIC__c=oldCI.AcctPIC__c );
            insert CI;
            CI = [SELECT id, name, Status__c, CommissionCurrency__c, AffiliationDistrict__c, Attribute__c, ContractDate__c, ContractDistrict__c, 
                  ContractCountry__c, ContractCompany__c, Agent__c 
                  FROM wb_CarInsurance__c where id =:CI.id]; 
            
            CICars = new List<wb_CarInsurancedCars__c>(); 
            integer n = 0;
            
            for (wb_CarInsurancedCars__c cicar :  [SELECT Id, Car__r.EngineNumber__c, 
                                                   FirstRegistryDate__c, 
                                                   Car__r.UsingCompany__c,  
                                                   Car__r.Ownership__c,
                                                   Car__c, 
                                                   Car__r.Model__c, 
                                                   Car__r.Name,
                                                   Car__r.LegalNumberofSeats__c,
                                                   CarInsurance__c
                                                   FROM wb_CarInsurancedCars__c
                                                   where ReplacedDate__c = null and CarInsurance__c =:ciid
                                                   order by Car__c]
                ) {
                    if (( [select id from wb_CIC_Passenger__c where CarInsurancedCar__c =:cicar.id].size() > 0 )||
                        ( [select id from wb_CIC_Compulsory__c where CarInsurancedCar__c =:cicar.id].size() > 0 ))
                        n = n + 1;    
                    
                    boolean found = false;
                    for ( integer i=0; i < CICars.size(); i ++){
                        if ( CICars[i].Car__c == cicar.Car__c )
                        {
                            found = true;
                            i = CICars.size();
                        }
                    }
                    if (found == false ) {
                        CICars.add( new wb_CarInsurancedCars__c( 
                            name = CI.Name + '-' + String.Valueof(n),
                            RegistryNumber__c = cicar.Car__r.Name,
                            FirstRegistryDate__c = cicar.FirstRegistryDate__c, 
                            LegalNumberofSeats__c = cicar.Car__r.LegalNumberofSeats__c,
                            UsingCompany__c = cicar.Car__r.UsingCompany__c, 
                            Car__c = cicar.Car__c, 
                            Model__c = cicar.Car__r.Model__c, 
                            CarInsurance__c = CI.id, 
                            Ownership__c = cicar.Car__r.Ownership__c,
                            EngineNo__c = cicar.Car__r.EngineNumber__c) 
                                  );
                    }
                }
            insert CICars;
            
            CIPassengerInsurance = new List<wb_CIC_Passenger__c>();
            
            
            
            for( wb_CIC_Passenger__c op:[SELECT  Psgr_AffiliationArea__c,  Psgr_InitialStartDate__c,
                                         Psgr_InsuranceCompany__c,Psgr_Service__c, Psgr_CommodityName__c, Psgr_InsurancePlan__c,
                                         // Psgr_InsuranceSeat__c, 
                                         PassagerSeatInsurance__c, DriverSeatInsurance__c,
                                         Psgr_CurrentEndDate__c, Psgr_CurrentStartDate__c, 
                                         Psgr_StdDriverSeatFee__c, 
                                         Psgr_StdPassengerSeatFee__c,
                                         OP_CurrentEndDate__c, OP_CurrentStartDate__c,
                                         OP_Service__c, OP_CommodityName__c,  OP_Plan__c, 
                                         CarInsurancedCar__r.Car__c
                                         FROM wb_CIC_Passenger__c
                                         where CarInsurancedCar__c in ( select id FROM wb_CarInsurancedCars__c
                                                                       where ReplacedDate__c = null and CarInsurance__c =:ciid
                                                                      )
                                         order by CarInsurancedCar__r.Car__c
                                        ]
               ){
                   wb_CIC_Passenger__c newp = new wb_CIC_Passenger__c();
                   newp = op.clone(false);
                   wb_CarInsurancedCars__c thenewCar = getthenewCar(CICars, op.CarInsurancedCar__r.Car__c);
                   newp.CarInsurancedCar__c = thenewCar.id;
                   newp.Car__c=thenewCar.Car__c;
                   newp.Name = thenewCar.Name;
                   CIPassengerInsurance.add(newp);
               } 
            
            string theName='';
            for ( wb_CIC_Passenger__c np:CIPassengerInsurance){
                
                if (np.name != theName){
                    n = 1;
                    theName = np.name;
                    np.name = theName + '-' + String.valueof(n);
                } else
                    np.name = theName + '-' + String.valueof(n);
                n=n+1;
            }      
            
            for (wb_CIC_Passenger__c np:CIPassengerInsurance ){
                date s;
                if ( np.Psgr_CurrentEndDate__c != null) {
                    s = np.Psgr_CurrentEndDate__c;
                    s = s.addDays(1);
                    np.Psgr_CurrentStartDate__c = s;
                    s = s.addYears(1);
                    s = s.addDays(-1);
                    np.Psgr_CurrentEndDate__c = s; 
                }
                
                if ( np.OP_CurrentEndDate__c != null) {
                    s = np.OP_CurrentEndDate__c;
                    s = s.addDays(1);
                    np.OP_CurrentStartDate__c = s;
                    s = s.addYears(1);
                    s = s.addDays(-1);
                    np.OP_CurrentEndDate__c = s; 
                }
                
            }
            integer theLegalNumberofSeats;
            wb_CI_PassangerRow PRow;
            for (wb_CIC_Passenger__c np:CIPassengerInsurance ){
                for ( wb_CarInsurancedCars__c c: CICars){
                    if (c.Car__c == np.Car__c)
                        theLegalNumberofSeats = integer.valueof(c.LegalNumberofSeats__c);
                }
                PRow = new wb_CI_PassangerRow(np, CI.ContractCountry__c,CI.CommissionCurrency__c,theLegalNumberofSeats
                                             );
                insert PRow.thePassenger;
            }
            //insert CIPassengerInsurance;
            
            
            CICompulsoryInsurance = new List<wb_CIC_Compulsory__c>();
            
            
            for( wb_CIC_Compulsory__c cp:[ SELECT Cps_PropertyLoss__c, Cps_PolicyNumber__c, Cps_NoLbtPropertyLoss__c, Cps_NoLbtAfterDeathImpediment__c, Cps_NoLbtAfterDeathMedicalCost__c, 
                                          Cps_AfterDeathImpediment__c, Cps_CommissionRate__c, 
                                          Cps_Commission__c, Cps_MedicalCost__c, Cps_Currency__c, Cps_CancelReason__c, 
                                          Cps_CancelDate__c, Cps_CurrentEndDate__c, Cps_InsuranceAmount__c, Cps_CurrentStartDate__c, Cps_InsuranceCompany__c, Cps_Service__c, 
                                          VIt_ScratchDamage__c, VIt_VehicleTheft__c, VIt_VehicleDamage__c, Vlt_DriverInjury__c, Vlt_PassengerInjury__c, Vlt_PolicyNumber__c, 
                                          Vlt_3rdPartyDamage__c, Vlt_PsgrPersonalAccident__c, Vlt_CommissionRate__c, 
                                          Vlt_Commission__c, Vlt_Currency__c, Vlt_CancelReason__c, 
                                          Vlt_CancelDate__c, Vlt_EndDate__c, Vlt_InsuranceAmount__c, Vlt_StartDate__c, Vlt_InsuranceCompany__c, Vlt_GlassBreakage__c, 
                                          Vlt_OtherItems__c , CarInsurancedCar__r.Car__c
                                          FROM wb_CIC_Compulsory__c
                                          where CarInsurancedCar__c in ( select id FROM wb_CarInsurancedCars__c
                                                                        where ReplacedDate__c = null and CarInsurance__c =:ciid
                                                                       )
                                          order by CarInsurancedCar__r.Car__c
                                         ]
               ){
                   wb_CIC_Compulsory__c newcp = new wb_CIC_Compulsory__c();
                   newcp = cp.clone(false);
                   wb_CarInsurancedCars__c thenewCar = getthenewCar(CICars, cp.CarInsurancedCar__r.Car__c);
                   newcp.CarInsurancedCar__c = thenewCar.id;
                   newcp.Car__c =thenewCar.Car__c;
                   newcp.Name = thenewCar.Name;
                   CICompulsoryInsurance.add(newcp);
               } 
            
            theName='';
            for ( wb_CIC_Compulsory__c cp:CICompulsoryInsurance){
                
                if (cp.name != theName){
                    n = 1;
                    theName = cp.name;
                    cp.name = theName + '-' + String.valueof(n);
                } else
                    cp.name = theName + '-' + String.valueof(n);
                n=n+1;
            }      
            
            for (wb_CIC_Compulsory__c cp:CICompulsoryInsurance ){
                date s;
                if ( cp.Cps_CurrentEndDate__c != null) {
                    s = cp.Cps_CurrentEndDate__c;
                    s = s.addDays(1);
                    cp.Cps_CurrentStartDate__c = s;
                    s = s.addYears(1);
                    s = s.addDays(-1);
                    cp.Cps_CurrentEndDate__c = s; 
                }
                
                if ( cp.Vlt_EndDate__c != null) {
                    s = cp.Vlt_EndDate__c;
                    s = s.addDays(1);
                    cp.Vlt_StartDate__c = s;
                    s = s.addYears(1);
                    s = s.addDays(-1);
                    cp.Vlt_EndDate__c = s; 
                }
                
            }
            insert CICompulsoryInsurance;
            
            
            return new PageReference('/'+CI.id);
        } else 
            return null;

    }
    
    
    public void CreateOldListforSelectandContinue(){
        id ciid;
        ciid= OrgCI;   
        oldCI =  [SELECT id, Name, Status__c, CommissionCurrency__c, AffiliationDistrict__c, Attribute__c, ContractDate__c, ContractDistrict__c, 
                  ContractCountry__c, ContractCompany__c, Agent__c ,AcctPIC__c
                  FROM wb_CarInsurance__c where id = :ciid];
        
        system.debug( 'CIContinue:' + oldCI.name);
        
        if ( oldCI.Status__c == '確定'){
            
            OldCICars = [SELECT Id, Name, Car__r.EngineNumber__c, 
                         FirstRegistryDate__c, 
                         Car__r.UsingCompany__c,  
                         Car__r.Ownership__c,
                         Car__c, 
                         Car__r.Model__c, 
                         Car__r.Name,
                         Car__r.LegalNumberofSeats__c,
                         CarInsurance__c, PendingAction__c, RegistryNumber__c, UsingCompany__c, 
                         LegalNumberofSeats__c, EngineNo__c, ReplacedDate__c,Pattern__c 
                         FROM wb_CarInsurancedCars__c
                         where ReplacedDate__c = null and CarInsurance__c =:ciid
                         order by Car__c];
            
            OldCIPassengerInsurance = [SELECT  Psgr_AffiliationArea__c,  Psgr_InitialStartDate__c,
                                       Psgr_InsuranceCompany__c,Psgr_Service__c, Psgr_CommodityName__c, Psgr_InsurancePlan__c,
                                       // Psgr_InsuranceSeat__c, 
                                       PassagerSeatInsurance__c, DriverSeatInsurance__c,
                                       Psgr_CurrentEndDate__c, Psgr_CurrentStartDate__c, 
                                       Psgr_StdDriverSeatFee__c, 
                                       Psgr_StdPassengerSeatFee__c,
                                       OP_CurrentEndDate__c, OP_CurrentStartDate__c,
                                       OP_Service__c, OP_CommodityName__c,  OP_Plan__c, 
                                       CarInsurancedCar__r.Car__c
                                       FROM wb_CIC_Passenger__c
                                       where CarInsurancedCar__c in ( select id FROM wb_CarInsurancedCars__c
                                                                     where ReplacedDate__c = null and CarInsurance__c =:ciid
                                                                    )
                                       order by CarInsurancedCar__r.Car__c];
            
            OldCICompulsoryInsurance = [ SELECT Cps_PropertyLoss__c, Cps_PolicyNumber__c, Cps_NoLbtPropertyLoss__c, Cps_NoLbtAfterDeathImpediment__c, Cps_NoLbtAfterDeathMedicalCost__c, 
                                        Cps_AfterDeathImpediment__c, Cps_CommissionRate__c, 
                                        Cps_Commission__c, Cps_MedicalCost__c, Cps_Currency__c, Cps_CancelReason__c, 
                                        Cps_CancelDate__c, Cps_CurrentEndDate__c, Cps_InsuranceAmount__c, Cps_CurrentStartDate__c, Cps_InsuranceCompany__c, Cps_Service__c, 
                                        VIt_ScratchDamage__c, VIt_VehicleTheft__c, VIt_VehicleDamage__c, Vlt_DriverInjury__c, Vlt_PassengerInjury__c, Vlt_PolicyNumber__c, 
                                        Vlt_3rdPartyDamage__c, Vlt_PsgrPersonalAccident__c, Vlt_CommissionRate__c, 
                                        Vlt_Commission__c, Vlt_Currency__c, Vlt_CancelReason__c, 
                                        Vlt_CancelDate__c, Vlt_EndDate__c, Vlt_InsuranceAmount__c, Vlt_StartDate__c, Vlt_InsuranceCompany__c, Vlt_GlassBreakage__c, 
                                        Vlt_OtherItems__c , CarInsurancedCar__r.Car__c
                                        FROM wb_CIC_Compulsory__c
                                        where CarInsurancedCar__c in ( select id FROM wb_CarInsurancedCars__c
                                                                      where ReplacedDate__c = null and CarInsurance__c =:ciid
                                                                     )
                                        order by CarInsurancedCar__r.Car__c
                                       ];
            
            //OldInsurancedCarsList = new List<wb_CI_InsurancedCarRow>();
            system.debug( OldCICars.size() + ' ' +  OldCIPassengerInsurance.size() + ' ' + OldCICompulsoryInsurance.size() );
            
            OldInsurancedCarsList = CreateCarsList(OldCICars, OldCIPassengerInsurance,OldCICompulsoryInsurance );
            
        } 
    }
    
    public List<wb_CI_InsurancedCarRow> CreateCarsList(List<wb_CarInsurancedCars__c> Cars,
                                                       List<wb_CIC_Passenger__c> Psgrs,
                                                       List<wb_CIC_Compulsory__c> Cps
                                                      ){

                                                          
                                                          List<wb_CI_InsurancedCarRow> theCarList = new List<wb_CI_InsurancedCarRow>();
                                                          
                                                          List<wb_CIC_Passenger__c> Ps = new List<wb_CIC_Passenger__c>();
                                                          List<wb_CIC_Compulsory__c> Cs = new List<wb_CIC_Compulsory__c>();
                                                          
                                                          integer cari=0, psgri=0, cpsi=0;
                                                          integer psgrip, cpsip;
                                                          
                                                          
                                                          for ( cari=0; cari < Cars.size(); cari ++ ){
                                                              
                                                              Ps = new List<wb_CIC_Passenger__c>();
                                                              Cs = new List<wb_CIC_Compulsory__c>();
                                                              
                                                              for (psgri= 0 ; psgri < Psgrs.size(); psgri ++ )
                                                              {
                                                                  if ( Psgrs[psgri].CarInsurancedCar__r.id == cars[cari].id){
                                                                      wb_CIC_Passenger__c newp = new wb_CIC_Passenger__c();
                                                                      newp = Psgrs[psgri].clone(true);
                                                                      Ps.add(newp);     
                                                                  } 
                                                                  
                                                              }
                                                              
                                                              
                                                              
                                                              for (cpsi = 0 ; cpsi < Cps.size(); cpsi ++ )
                                                              {
                                                                  if ( Cps[cpsi].CarInsurancedCar__r.id == cars[cari].id){
                                                                      wb_CIC_Compulsory__c newc = new wb_CIC_Compulsory__c();
                                                                      newc = Cps[cpsi].clone(true);
                                                                      Cs.add(newc);     
                                                                  }
                                                                  
                                                              }
                                                              
                                                              
                                                              theCarList.add(new wb_CI_InsurancedCarRow(cars[cari], Ps, Cs));
                                                          }
                                                          
                                                          return theCarList;
                                                      }
    
    
    public PageReference CIClone(){
        
        id ciid;
        ciid= OrgCI;   
        wb_CarInsurance__c oldCI =  [SELECT id, Status__c, CommissionCurrency__c, AffiliationDistrict__c, Attribute__c, ContractDate__c, ContractDistrict__c, 
                                     ContractCountry__c, ContractCompany__c, Agent__c 
                                     FROM wb_CarInsurance__c where id = :ciid];
        
        CI = new wb_CarInsurance__c ( Status__c = '未確定', ContractDate__c =  date.today(), // PreriousContract__c = OrgCI,
                                     CommissionCurrency__c = oldCI.CommissionCurrency__c, AffiliationDistrict__c = oldCI.AffiliationDistrict__c,
                                     Attribute__c = oldCI.Attribute__c, ContractDistrict__c = oldCI.ContractDistrict__c,
                                     ContractCountry__c = oldCI.ContractCountry__c,ContractCompany__c=oldCI.ContractCompany__c, Agent__c =oldCI.Agent__c );
        insert CI;
        CI = [SELECT id, name, Status__c, CommissionCurrency__c, AffiliationDistrict__c, Attribute__c, ContractDate__c, ContractDistrict__c, 
              ContractCountry__c, ContractCompany__c, Agent__c 
              FROM wb_CarInsurance__c where id =:CI.id]; 
        
        CICars = new List<wb_CarInsurancedCars__c>(); 
        integer n = 0;
        
        
        for (wb_CarInsurancedCars__c cicar :  [SELECT Id, Car__r.EngineNumber__c, 
                                               FirstRegistryDate__c, 
                                               Car__r.UsingCompany__c,  
                                               Car__r.Ownership__c,
                                               Car__c, 
                                               Car__r.Model__c, 
                                               Car__r.Name,
                                               Car__r.LegalNumberofSeats__c,
                                               CarInsurance__c
                                               FROM wb_CarInsurancedCars__c
                                               where ReplacedDate__c = null and CarInsurance__c =:ciid
                                               order by Car__c]
            ) {
                if (( [select id from wb_CIC_Passenger__c where CarInsurancedCar__c =:cicar.id].size() > 0 )||
                    ( [select id from wb_CIC_Compulsory__c where CarInsurancedCar__c =:cicar.id].size() > 0 ))
                    n = n + 1;        
             /*   CICars.add( new wb_CarInsurancedCars__c( 
                    name = CI.Name + '-' + String.Valueof(n),
                    RegistryNumber__c = cicar.Car__r.Name,
                    FirstRegistryDate__c = cicar.FirstRegistryDate__c, 
                    LegalNumberofSeats__c = cicar.Car__r.LegalNumberofSeats__c,
                    UsingCompany__c = cicar.Car__r.UsingCompany__c, 
                    Car__c = cicar.Car__c, 
                    Model__c = cicar.Car__r.Model__c, 
                    CarInsurance__c = CI.id, 
                    Ownership__c = cicar.Car__r.Ownership__c,
                    EngineNo__c = cicar.Car__r.EngineNumber__c) 
                          ); */
                 boolean found = false;
                    for ( integer i=0; i < CICars.size(); i ++){
                        if ( CICars[i].Car__c == cicar.Car__c )
                        {
                            found = true;
                            i = CICars.size();
                        }
                    }
                    if (found == false ) {
                        CICars.add( new wb_CarInsurancedCars__c( 
                            name = CI.Name + '-' + String.Valueof(n),
                            RegistryNumber__c = cicar.Car__r.Name,
                            FirstRegistryDate__c = cicar.FirstRegistryDate__c, 
                            LegalNumberofSeats__c = cicar.Car__r.LegalNumberofSeats__c,
                            UsingCompany__c = cicar.Car__r.UsingCompany__c, 
                            Car__c = cicar.Car__c, 
                            Model__c = cicar.Car__r.Model__c, 
                            CarInsurance__c = CI.id, 
                            Ownership__c = cicar.Car__r.Ownership__c,
                            EngineNo__c = cicar.Car__r.EngineNumber__c) 
                                  );
                    }
                
            }
        insert CICars;
        
        CIPassengerInsurance = new List<wb_CIC_Passenger__c>();
        
        
        for( wb_CIC_Passenger__c op:[SELECT //Psgr_ChangeStartDate__c, 
                                     Psgr_CurrentEndDate__c, Psgr_CurrentStartDate__c, Psgr_StdDriverSeatFee__c, 
                                     Psgr_StdPassengerSeatFee__c, Psgr_AffiliationArea__c, Psgr_CommodityName__c, Psgr_InitialStartDate__c, 
                                     Psgr_InsuranceFee__c, Psgr_InsuranceCompany__c, Psgr_InsurancePlan__c, // Psgr_InsuranceSeat__c, 
                                     PassagerSeatInsurance__c, DriverSeatInsurance__c,
                                     Psgr_Service__c, 
                                     //OP_ChangeStartDate__c,
                                     OP_CurrentEndDate__c, OP_CurrentStartDate__c, OP_CommodityName__c, 
                                     OP_Plan__c, OP_Service__c, CarInsurancedCar__c, CarInsurancedCar__r.Car__c
                                     FROM wb_CIC_Passenger__c
                                     where CarInsurancedCar__c in ( select id FROM wb_CarInsurancedCars__c
                                                                   where ReplacedDate__c = null and CarInsurance__c =:ciid
                                                                  )
                                     order by CarInsurancedCar__r.Car__c
                                    ]
           ){
               wb_CIC_Passenger__c newp = new wb_CIC_Passenger__c();
               newp = op.clone(false);
               wb_CarInsurancedCars__c thenewCar = getthenewCar(CICars, op.CarInsurancedCar__r.Car__c);
               newp.CarInsurancedCar__c = thenewCar.id;
               newp.Car__c =thenewCar.Car__c;
               newp.Name = thenewCar.Name;
               CIPassengerInsurance.add(newp);
           } 
        
        string theName='';
        for ( wb_CIC_Passenger__c np:CIPassengerInsurance){
            
            if (np.name != theName){
                n = 1;
                theName = np.name;
                np.name = theName + '-' + String.valueof(n);
            } else
                np.name = theName + '-' + String.valueof(n);
            n=n+1;
        }      
        
        
        
        insert CIPassengerInsurance;
        
        
        
        CICompulsoryInsurance = new List<wb_CIC_Compulsory__c>();
        
        
        for( wb_CIC_Compulsory__c cp:[ SELECT Cps_PropertyLoss__c, Cps_PolicyNumber__c, Cps_NoLbtPropertyLoss__c, Cps_NoLbtAfterDeathImpediment__c, Cps_NoLbtAfterDeathMedicalCost__c, 
                                      Cps_AfterDeathImpediment__c, Cps_CommissionRate__c, 
                                      Cps_Commission__c, Cps_MedicalCost__c, Cps_Currency__c, Cps_CancelReason__c, 
                                      Cps_CancelDate__c, Cps_CurrentEndDate__c, Cps_InsuranceAmount__c, Cps_CurrentStartDate__c, Cps_InsuranceCompany__c, Cps_Service__c, 
                                      VIt_ScratchDamage__c, VIt_VehicleTheft__c, VIt_VehicleDamage__c, Vlt_DriverInjury__c, Vlt_PassengerInjury__c, Vlt_PolicyNumber__c, 
                                      Vlt_3rdPartyDamage__c, Vlt_PsgrPersonalAccident__c, Vlt_CommissionRate__c, 
                                      Vlt_Commission__c, Vlt_Currency__c, Vlt_CancelReason__c, 
                                      Vlt_CancelDate__c, Vlt_EndDate__c, Vlt_InsuranceAmount__c, Vlt_StartDate__c, Vlt_InsuranceCompany__c, Vlt_GlassBreakage__c, 
                                      Vlt_OtherItems__c , CarInsurancedCar__r.Car__c
                                      FROM wb_CIC_Compulsory__c
                                      where CarInsurancedCar__c in ( select id FROM wb_CarInsurancedCars__c
                                                                    where ReplacedDate__c = null and CarInsurance__c =:ciid
                                                                   )
                                      order by CarInsurancedCar__r.Car__c
                                     ]
           ){
               wb_CIC_Compulsory__c newcp = new wb_CIC_Compulsory__c();
               newcp = cp.clone(false);
               wb_CarInsurancedCars__c thenewCar = getthenewCar(CICars, cp.CarInsurancedCar__r.Car__c);
               newcp.CarInsurancedCar__c = thenewCar.id;
               newcp.Car__c =thenewCar.Car__c;
               newcp.Name = thenewCar.Name;
               CICompulsoryInsurance.add(newcp);
           } 
        
        theName='';
        for ( wb_CIC_Compulsory__c cp:CICompulsoryInsurance){
            
            if (cp.name != theName){
                n = 1;
                theName = cp.name;
                cp.name = theName + '-' + String.valueof(n);
            } else
                cp.name = theName + '-' + String.valueof(n);
            n=n+1;
        }      
        
        insert CICompulsoryInsurance;
        
        
        return new PageReference('/'+CI.id);
        
    }
    
    
    public wb_CarInsurancedCars__c getthenewCar(List<wb_CarInsurancedCars__c> newCars, id Car){
        for ( wb_CarInsurancedCars__c nc:newCars){
            if (nc.Car__c == Car){
                return nc;
            }
        }
        return null;
    }
    
    public PageReference Cancel(){
        //QuitMe = true;
       String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        return new PageReference(sfdcBaseURL+'/' +  OrgCI);
        //return null;
    }
    
    
    
}