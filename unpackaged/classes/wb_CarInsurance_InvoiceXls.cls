public class wb_CarInsurance_InvoiceXls {
    
    public List<InvRow> theInvoice {get;set;}
    public string InvoiceNo {get;set;}
    
    public wb_CarInsurance_InvoiceXls(){
        // ApexPages.currentPage().getParameters().get('ID')
        string ciid;
      //ciid = 'a0fN0000006SBkn';
      ciid = ApexPages.currentPage().getParameters().get('Id');
      //   sendCSVmail(ciid);
      
         string CIC_ID;
        //string CIC_ID = apexpages.currentpage().getparameters().get('pv0');
        if (apexpages.currentpage().getparameters().get('pv0')!=null)
          CIC_ID = apexpages.currentpage().getparameters().get('pv0');
        
        system.debug('id, pv0:' + ciid + ' ' + CIC_ID );
        wb_CarInsurance__c ci =[select PreriousContract__c from wb_CarInsurance__c where id =:ciid];
        
        
         if (CIC_ID == null)
              Fill_by2( ciid, null);
             else 
        Fill_by2( ciid, CIC_ID);
      
    }
        
    public  wb_CarInsurance_InvoiceXls( string ciid)
    {

      Fill_by2(ciid, null);
       
    }

    
    public void Fill_by2(string ciid, string cic_id){
        
         wb_CarInsurance__c ci =[select PreriousContract__c from wb_CarInsurance__c where id =:ciid];
        
        string contracttype;
        
        if (ci.PreriousContract__c == null)
            contracttype = '新規';
        else
            contracttype = '継続';
        
        theInvoice = new List<InvRow>();
        
        List<wb_CarInsurancedCars__c> ciCars;
        ciCars = new List<wb_CarInsurancedCars__c>();
        
        List<wb_CIC_Passenger__c> Passengers;
        Passengers = new List<wb_CIC_Passenger__c>();
            
        if (CIC_ID == null) {
            
            ciCars =[SELECT id, CarInsurance__r.name,
                     CarInsurance__r.AffiliationDistrict__c, CarInsurance__r.ContractCompany__r.name,CarInsurance__r.AcctPIC__r.name,
                     RegistryNumber__c, EngineNo__c, Ownership__c, LegalNumberofSeats__c, ReplacedDate__c
                     FROM wb_CarInsurancedCars__c
                     where CarInsurance__r.id=:ciid
                    order by id];
            
            Passengers = [SELECT CarInsurancedCar__r.id, id, name, CarInsurancedCar__c,
                          Psgr_InsuranceFee__c,   Psgr_CurrentStartDate__c, Psgr_CurrentEndDate__c, 
                          Psgr_InsurancePlan__c, Psgr_CommodityName__c, Psgr_AffiliationArea__c, 
                          OP_CommodityName__c, OP_Plan__c, OP_CurrentStartDate__c, OP_CurrentEndDate__c,OP_InsuranceFee__c,
                          f_PsgrBillingAmount__c, f_OPBillingAmount__c, PassagerSeatInsurance__c, DriverSeatInsurance__c
                          FROM wb_CIC_Passenger__c
                          where CarInsurancedCar__r.CarInsurance__r.id =:ciid
                          order by CarInsurancedCar__r.id, id 
                         ];
            
        }
        else {
            ciCars =[SELECT id, CarInsurance__r.name,
                     CarInsurance__r.AffiliationDistrict__c, CarInsurance__r.ContractCompany__r.name,CarInsurance__r.AcctPIC__r.name,
                     RegistryNumber__c, EngineNo__c, Ownership__c, LegalNumberofSeats__c, ReplacedDate__c
                     FROM wb_CarInsurancedCars__c
                     where CarInsurance__r.id=:ciid and id=:CIC_ID
                     order by id
                    ];
            
            Passengers = [SELECT CarInsurancedCar__r.id, id, name, CarInsurancedCar__c,
                          Psgr_InsuranceFee__c,   Psgr_CurrentStartDate__c, Psgr_CurrentEndDate__c, 
                          Psgr_InsurancePlan__c, Psgr_CommodityName__c, Psgr_AffiliationArea__c, 
                          OP_CommodityName__c, OP_Plan__c, OP_CurrentStartDate__c, OP_CurrentEndDate__c,OP_InsuranceFee__c,
                          f_PsgrBillingAmount__c, f_OPBillingAmount__c, PassagerSeatInsurance__c, DriverSeatInsurance__c
                          FROM wb_CIC_Passenger__c
                          where CarInsurancedCar__r.CarInsurance__r.id =:ciid and CarInsurancedCar__r.id =:CIC_ID 
                         order by CarInsurancedCar__r.id, id  ];
            
        }
            
            
        system.debug('ciCars N' + ciCars.size());  
        system.debug('Passengers' + Passengers.size());  
        
        for ( wb_CarInsurancedCars__c ciCar:ciCars
            ) {
                InvoiceNo = ciCar.CarInsurance__r.name;
                for ( wb_CIC_Passenger__c ciP:Passengers
                    ){
                      
                        if ( ciP.CarInsurancedCar__r.id == ciCar.id) {                        
                            string name = ciP.name;
                            system.debug('p:' + ciP.name + ' ' + name.indexOf('r',0)+' ' + ciP.Psgr_CurrentStartDate__c +  ' ' + ciP.Psgr_CurrentEndDate__c);
                            InvRow r;
                            if ( name.indexOf('e',0)==-1){
                                if (ciP.Psgr_CurrentEndDate__c != null ) {
                                    system.debug('p:' + ciP.name + ' ' + ciP.Psgr_CurrentStartDate__c +  ' ' + ciP.Psgr_CurrentEndDate__c);   
                                    r = new InvRow(contracttype,ciCar.CarInsurance__r.AffiliationDistrict__c,
                                                   ciCar.CarInsurance__r.ContractCompany__r.name, ciCar.RegistryNumber__c,
                                                   ciCar.EngineNo__c,ciCar.Ownership__c,
                                                   ciP.Psgr_CommodityName__c, ciP.Psgr_InsurancePlan__c,
                                                   String.valueof(ciCar.LegalNumberofSeats__c), 
                                                   String.valueof(ciP.PassagerSeatInsurance__c) + ' ' + String.valueof(ciP.DriverSeatInsurance__c) , 
                                                   String.valueof(ciP.Psgr_InsuranceFee__c),
                                                   String.valueof(ciP.Psgr_CurrentStartDate__c), 
                                                   String.valueof(ciP.Psgr_CurrentEndDate__c),
                                                   String.valueof(ciP.OP_CommodityName__c), String.valueof(ciP.OP_Plan__c),String.valueof(ciP.OP_InsuranceFee__c),
                                                   String.valueof(ciCar.CarInsurance__r.AcctPIC__r.name)
                                                  );
                                }
                                else
                                    r = new InvRow(contracttype,ciCar.CarInsurance__r.AffiliationDistrict__c,
                                                   ciCar.CarInsurance__r.ContractCompany__r.name, ciCar.RegistryNumber__c,
                                                   ciCar.EngineNo__c,ciCar.Ownership__c,
                                                   ciP.Psgr_CommodityName__c, ciP.Psgr_InsurancePlan__c,
                                                   String.valueof(ciCar.LegalNumberofSeats__c), 
                                                   String.valueof(ciP.PassagerSeatInsurance__c) + ' ' + String.valueof(ciP.DriverSeatInsurance__c) , 
                                                   String.valueof(ciP.Psgr_InsuranceFee__c),
                                                   String.valueof(ciP.OP_CurrentStartDate__c), 
                                                   String.valueof(ciP.OP_CurrentEndDate__c),
                                                   String.valueof(ciP.OP_CommodityName__c), String.valueof(ciP.OP_Plan__c),String.valueof(ciP.OP_InsuranceFee__c),
                                                   String.valueof(ciCar.CarInsurance__r.AcctPIC__r.name)
                                                  );
                                
                            }
                            else {
                                
                                r = new InvRow(contracttype,ciCar.CarInsurance__r.AffiliationDistrict__c,
                                               ciCar.CarInsurance__r.ContractCompany__r.name, ciCar.RegistryNumber__c,
                                               ciCar.EngineNo__c,ciCar.Ownership__c,
                                               ciP.Psgr_CommodityName__c, ciP.Psgr_InsurancePlan__c,
                                               String.valueof(ciCar.LegalNumberofSeats__c), 
                                               String.valueof(ciP.PassagerSeatInsurance__c) + ' ' + String.valueof(ciP.DriverSeatInsurance__c), 
                                               String.valueof(ciP.f_PsgrBillingAmount__c),
                                               // String.valueof(ciP.Psgr_CurrentStartDate__c), 
                                               String.valueof(ciCar.ReplacedDate__c), 
                                               String.valueof(ciP.Psgr_CurrentEndDate__c),
                                               String.valueof(ciP.OP_CommodityName__c), String.valueof(ciP.OP_Plan__c),String.valueof(ciP.f_OPBillingAmount__c),
                                               String.valueof(ciCar.CarInsurance__r.AcctPIC__r.name)
                                              );
                            }
                            
                            theInvoice.add(r);
                        }
                        
                    }
            }
			system.debug('theInvoice' + theInvoice.size());  
    }
    
    public class InvRow{
        public string ContractStatus {get;set;}
        public string AffiliationDistrict {get;set;}
        public string ContractCompany {get;set;}
        public string RegistryNumber {get;set;}
        public string EngineNo {get;set;}
        public string Ownership {get;set;}
        public string Insurance {get;set;}
        public string Plan {get;set;}
        public string LegalNumberofSeats {get;set;}
        public string NumberofInsuranceSeat {get;set;}
        public string InsuranceFee {get;set;}
        public string StartDate {get;set;}
        public string EndDate {get;set;}
        public string PIC {get;set;}
        public string OP_Insurance {get;set;}
        public string OP_Plan {get;set;}
        public string OP_InsuranceFee {get;set;}

        public InvRow(string aContractStatus,  string aAffiliationDistrict, 
                      string aContractCompany,  string aRegistryNumber, 
                      string aEngineNo,  string aOwnership, 
                      string aInsurance,  string aPlan, 
                      string aLegalNumberofSeats,  string aNumberofInsuranceSeat, string aInsuranceFee,
                      string aStartDate, string aEndDate,
                      string aOP_Insurance, string aOP_Plan,
                      string aOP_InsuranceFee, string aPIC
                     ){
                         system.debug( aStartDate + ' : ' + aEndDate);
                         ContractStatus = aContractStatus;
                         AffiliationDistrict = aAffiliationDistrict;
                         ContractCompany = aContractCompany;
                         RegistryNumber = aRegistryNumber;
                         EngineNo = aEngineNo;
                         Ownership = aOwnership;
                         Insurance = aInsurance;
                         Plan = aPlan;
                         LegalNumberofSeats = aLegalNumberofSeats;
                         NumberofInsuranceSeat = aNumberofInsuranceSeat;
                         InsuranceFee = aInsuranceFee;
                         StartDate = aStartDate;
                         EndDate = aEndDate;
                         OP_Insurance = aOP_Insurance;
                         OP_Plan = aOP_Plan;
                         OP_InsuranceFee = aOP_InsuranceFee;
                         PIC = aPIC;
                     }
    }
    
}