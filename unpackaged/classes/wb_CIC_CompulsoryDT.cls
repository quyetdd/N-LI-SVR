public class wb_CIC_CompulsoryDT {
    ApexPages.StandardController stdController;
    public id CI_ID {get;set;}
    public string CIC_ID {get;set;}
    
    public wb_CarInsurance__c CarInsurance {get;set;}
    public wb_CarInsurancedCars__c CarInsurancedCars {get;set;}
    
    public List<wb_CI_CompulsoryRow> CompulsoryDT {get;set;}
    public integer CompulsoryDTSize {get;set;}
    
    public wb_CIC_CompulsoryDT(ApexPages.StandardController stdController){
        this.stdController = stdController;
        CI_ID = apexpages.currentpage().getparameters().get('id');
        CIC_ID = apexpages.currentpage().getparameters().get('pv0');
        CarInsurance = [SELECT Name, Id, ContractCompany__c,ContractCompany__r.name,CommissionCurrency__c,
                        ContractCountry__c, ContractDate__c, Attribute__c, Status__c
                        FROM wb_CarInsurance__c
                        where ID =:CI_ID];
      
        CarInsurancedCars = [select id,LegalNumberofSeats__c  from wb_CarInsurancedCars__c where id =:CIC_ID];
        
        if  (CarInsurancedCars.id != null) {
            CompulsoryDT = new List<wb_CI_CompulsoryRow>();
            for ( wb_CIC_Compulsory__c cps:[SELECT Cps_PropertyLoss__c, Cps_PolicyNumber__c, Cps_NoLbtPropertyLoss__c, Cps_NoLbtAfterDeathImpediment__c, 
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
                                                                                          cps
                                                                                         )
                                                                );
                                            }
        }
        
        CompulsoryDTSize = CompulsoryDT.size();
    }
}