@RestResource(urlMapping='/soap/ApiLog/*')

global with sharing class wb_soap_log {
    
    @HttpGet
    global static List<wb_soap_log__c> getApiLog() {
    //global static string getApiLog() {    
        RestRequest req = RestContext.request;
        string plastmodifieddate;
        if ( req.params.get('lastmodifieddate') != null)
            plastmodifieddate= req.params.get('lastmodifieddate');
        
        string wheresql;
        
        if (plastmodifieddate != null) {
           // wheresql = '  Contract_HospitalName__c like \'%' + HospitalName + '%\'  and f_AppPostingTarget__c = true' ; 
             wheresql = ' lastmodifieddate >= ' + plastmodifieddate  ; 
        }
        
         // string soql = 'SELECT Id,IsDeleted,JStr__c,LastAcessDate__c,LastModifiedDate,LogIn__c,MemberID__c,MemberInfo__c,MemberNo__c,Type__c FROM wb_soap_log__c';
         string soql = 'SELECT Id,IsDeleted, LastAcessDate__c,LastModifiedDate,LogIn__c,MemberID__c,MemberInfo__c,MemberNo__c,Type__c FROM wb_soap_log__c';
        if (wheresql != null )
        {
            soql = soql + ' ALL where ' + wheresql + ' order by LastModifiedDate limit 5000  ';
        } else 
        {
            soql = soql  + ' ALL order by LastModifiedDate limit 5000 ';     
        }
        
         List<wb_soap_log__c> Rst  = Database.query(soql);
        return Rst;
        //return soql;
    }

}