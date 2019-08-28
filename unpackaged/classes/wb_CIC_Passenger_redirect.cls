public class wb_CIC_Passenger_redirect {
    ApexPages.StandardController stdController;
    
    public wb_CIC_Passenger__c wb_CIC_Passenger {get;set;}
    
    public wb_CIC_Passenger_redirect(ApexPages.StandardController stdController){
        this.stdController = stdController;
        wb_CIC_Passenger = (wb_CIC_Passenger__c) stdController.getRecord();
        wb_CIC_Passenger = [select id, CarInsurancedCar__c, CarInsurancedCar__r.CarInsurance__c from wb_CIC_Passenger__c where id =: wb_CIC_Passenger.id ];
    }
    
    public PageReference redirect() {
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        
        return new PageReference(sfdcBaseURL+'/apex/wb_CarInsurance?Id=' + wb_CIC_Passenger.CarInsurancedCar__r.CarInsurance__c);
    }
    
}