public class wb_CIC_PassengerDT {
    
    ApexPages.StandardController stdController;
    public id CI_ID {get;set;}
    public string CIC_ID {get;set;}

    public wb_CarInsurance__c CarInsurance {get;set;}
    public wb_CarInsurancedCars__c CarInsurancedCars {get;set;}
    
    public List<wb_CI_PassangerRow> PassengerDT {get;set;}
    
    public integer PassengerDTSize {get;set;}
    
    public wb_CIC_PassengerDT(ApexPages.StandardController stdController){
        this.stdController = stdController;
        CI_ID = apexpages.currentpage().getparameters().get('id');
        CIC_ID = apexpages.currentpage().getparameters().get('pv0');
        
       // CarInsurance = (wb_CarInsurance__c) stdController.getRecord();
        //CI_ID = 'a0fN0000005ZwByIAK';
        //CIC_ID ='a0hN0000005k9QYIAY';
        CarInsurance = [SELECT Name, Id, ContractCompany__c,ContractCompany__r.name,CommissionCurrency__c,
                        ContractCountry__c, ContractDate__c, Attribute__c, Status__c
                        FROM wb_CarInsurance__c
                        where ID =:CI_ID];
        
        CarInsurancedCars = [select id,LegalNumberofSeats__c  from wb_CarInsurancedCars__c where id =:CIC_ID];
        if  (CarInsurancedCars.id != null) {
                         PassengerDT = new List<wb_CI_PassangerRow>();
            
            for ( wb_CIC_Passenger__c p:[SELECT Psgr_CancelDate__c, 
                                         Psgr_CurrentEndDate__c, Psgr_CurrentStartDate__c, 
                                         Psgr_StdDriverSeatFee__c, Psgr_StdPassengerSeatFee__c, Psgr_AffiliationArea__c, 
                                         Psgr_CommodityName__c, Psgr_InitialStartDate__c, Psgr_InsuranceFee__c, 
                                         Psgr_InsuranceCompany__c, Psgr_InsurancePlan__c, 
                                         Psgr_Service__c, OP_CancelDate__c,
                                         OP_CurrentEndDate__c, OP_CurrentStartDate__c, 
                                         OP_CommodityName__c,  OP_Plan__c, OP_Service__c, 
                                         OP_StdDriverSeatFee__c, OP_StdPassengerSeatFee__c, OP_InsuranceFee__c,
                                         Name, CarInsurancedCar__c, Id , PassagerSeatInsurance__c ,DriverSeatInsurance__c,
                                         Psgr_Commission__c, OP_Commission__c, f_PsgrBillingAmount__c, f_OPBillingAmount__c 
                                         FROM wb_CIC_Passenger__c where CarInsurancedCar__c =:CarInsurancedCars.id]
                ) {
                    PassengerDT.add( new wb_CI_PassangerRow(CarInsurance.ContractCountry__c, 
                                                       CarInsurance.CommissionCurrency__c, 
                                                       Integer.valueof( CarInsurancedCars.LegalNumberofSeats__c),
                                                       p
                                                      )
                                   );
                }
        }
        PassengerDTSize = PassengerDT.size();
    }

}