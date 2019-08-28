public class wb_CarInsurancedCars_redirect {
    ApexPages.StandardController stdController;
    public wb_CarInsurancedCars__c wb_CarInsurancedCars {get;set;}
    public wb_CarInsurancedCars_redirect(ApexPages.StandardController stdController){
        this.stdController = stdController;
        wb_CarInsurancedCars = (wb_CarInsurancedCars__c) stdController.getRecord();
        wb_CarInsurancedCars = [select id, CarInsurance__c from wb_CarInsurancedCars__c where id =: wb_CarInsurancedCars.id ];
    }
    
    public PageReference redirect() {
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        
        return new PageReference(sfdcBaseURL+'/apex/wb_CarInsurance?Id=' + wb_CarInsurancedCars.CarInsurance__c);
    }
    
}