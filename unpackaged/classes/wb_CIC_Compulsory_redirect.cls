public class wb_CIC_Compulsory_redirect {
    ApexPages.StandardController stdController;
    public wb_CIC_Compulsory__c wb_CIC_Compulsory {get;set;}
    
    public wb_CIC_Compulsory_redirect(ApexPages.StandardController stdController){
        this.stdController = stdController;
        wb_CIC_Compulsory = (wb_CIC_Compulsory__c) stdController.getRecord();
        wb_CIC_Compulsory = [select id, CarInsurancedCar__c, CarInsurancedCar__r.CarInsurance__c from wb_CIC_Compulsory__c where id =: wb_CIC_Compulsory.id ];
    }
    
    public PageReference redirect() {
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        
        return new PageReference(sfdcBaseURL+'/apex/wb_CarInsurance?Id=' + wb_CIC_Compulsory.CarInsurancedCar__r.CarInsurance__c);
    }
    
    
}