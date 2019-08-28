@isTest
public class wb_soap_logApi_Test {
    
    @isTest static void test1(){
        
        insert new wb_soap_log__c(MemberNo__c ='12345', MemberID__c='HGK') ;
        
         RestRequest request = new RestRequest();
        
        request.requestUri = 'https://cs72.salesforce.com/services/apexrest/soap/ApiLog/';
        request.httpMethod = 'GET';
        RestContext.request = request;
        
        wb_soap_log.getApiLog();
        
    }
    
   
}