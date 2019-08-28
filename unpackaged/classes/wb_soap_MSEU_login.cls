@RestResource(urlMapping='/MSEnterpriseUsers/Login/*')
global with sharing class wb_soap_MSEU_login {
    global class CompanyUser{
        global string Id; 
        global string CompanyCode;
        global string UserName;
        global string emailaddress;
        global string AllowedIP;
        global string hashedpassword;
        public CompanyUser( Account a )
        {
            Id = a.Id; 
            UserName= a.Name;
            CompanyCode = a.CompanyCd__c;
            emailaddress = a.MSEU_emailaddress__c;
            AllowedIP = a.AllowedIP__c;
            // OfficeAdd=theOfficeAdd;
            hashedpassword= a.MSEU_hashedpassword__c;
        }
    }
    
    public class Request{
        public string Type {get;set;}
        public string Value {get;set;}
        public Request( string t, string v){
            Type = t;
            Value = v;
        }
    }
    
    @HttpGet
    global static CompanyUser getCompanyUser() {
        RestRequest request = RestContext.request;
        // grab the caseId from the end of the URL
        String req = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        system.debug('req:'+req);
  		
        Account a;
        List<Request> Rqst  = New List<Request>();
        while ( req.indexOf('&') > 1)
        {
            string reqInfo = req.left( req.indexOf('&'));
            string reqType = req.left( req.indexOf('='));
            string reqValue = req.right(req.length() - req.indexOf('=') - 1);
            Rqst.add(new Request(reqType,reqValue));
            req = req.right(req.length() - req.indexOf('&') - 1);
        }  
        
        if ( req.indexOf('=') > 1){
            string reqType = req.left( req.indexOf('='));
            string reqValue = req.right(req.length() - req.indexOf('=') - 1);
            Rqst.add(new Request(reqType,reqValue));
        }
        
        if (Rqst.size() > 0){
            string Sql = ' SELECT Id , Name,CompanyCd__c, MSEU_emailaddress__c,AllowedIP__c,MSEU_hashedpassword__c FROM Account ';
            string sql_where ;
            for (Request r:Rqst){
                if (r.Type =='CompanyCode'){
                    if ( sql_where == null )
                        sql_where = ' CompanyCd__c = \'' + r.value + '\'';
                    else 
                        sql_where = ' and CompanyCd__c = \'' + r.value + '\'';   
                } else  if (r.Type =='emailaddress'){
                    if ( sql_where == null )
                        sql_where = ' MSEU_emailaddress__c = \'' + r.value + '\'';
                    else 
                        sql_where = ' and MSEU_emailaddress__c = \'' + r.value + '\'';   
                }
            }
            
           a = Database.query( Sql + ' where ' + sql_where );
        }
        
        return  new CompanyUser(a);
        
    }
    
    

}