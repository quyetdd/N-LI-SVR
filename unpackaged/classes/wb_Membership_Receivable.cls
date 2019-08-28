public class wb_Membership_Receivable {
    private ApexPages.StandardController standardController;
    public wb_Membership__c Membership {get; set;}
    public List<wb_ReceivableServiceFee__c> ReceivableServiceFee {get; set;}
    
    public wb_Membership_Receivable(ApexPages.StandardController stdController){
        this.standardController = stdController;
        Membership = (wb_Membership__c) stdController.getRecord();
        
        ReceivableServiceFee = [SELECT Id, Service__c, ServiceName__c, ServiceCommission__c, ServiceAmount__c, Membership__c, Date__c, Classification__c, f_Service__c, Country__c, District__c, Name, TotalAmount__c, CarInsurance__c, parent__c, InvoicingCompany__c, Currency__c 
                                FROM wb_ReceivableServiceFee__c where Membership__c =:Membership.id ];
    }
    
}