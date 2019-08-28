@RestResource(urlMapping='/Accounts/*')
global with sharing class wb_AccountManager {
    global class AccountInfo{
        global string Id;
        global string Name;   
         global string lastmodifieddate; 
        public AccountInfo(){}
        
        public AccountInfo(string theId, string theName, datetime dt){
            Id = theId;
            Name= theName;
            String formatedDt = dt.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
            lastmodifieddate = formatedDt;
        }
    }
    
    @HttpGet
    global static List<AccountInfo> getAccountInfo() {
        RestRequest request = RestContext.request;
        // grab the caseId from the end of the URL
        String req = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        system.debug('req:'+req);
        if ( req.indexOf('=') > 1){
            string reqType = req.left( req.indexOf('='));
            string reqInfo = req.right(req.length() - req.indexOf('=') - 1);
            
            if ( reqType=='id') {
                
                return GetAccountbyID(reqInfo);
            } else
                return new List<AccountInfo>();
            
        } else if ( req.indexOf('Like') > 1 || req.indexOf('like') > 1 ){
            string reqType;
            string reqInfo;
            
            if (req.indexOf('Like') > 1 ){
                reqType = req.left( req.indexOf('Like'));
                reqInfo = req.right(req.length() - req.indexOf('Like') - 4);
            } else {
                reqType = req.left( req.indexOf('like'));
                reqInfo = req.right(req.length() - req.indexOf('like') - 4);
            }
            
            
            // string reqInfo = req.right(req.length() - req.indexOf('Like') - 4);
            system.debug( reqType + ':' + reqInfo );
            if ( reqType=='Name') {
                return GetAccountLikeName(reqInfo);
            } else
                return new List<AccountInfo>();   
        } else {
            return GetAccountbyID(req); 
        }
    }
    
     public static List<AccountInfo> GetAccountbyID( string theId ){
        List<Account> results = [SELECT Id,Name, lastmodifieddate
                        FROM Account
                        WHERE Id =:theId];
        List<AccountInfo> AL = new List<AccountInfo>();
        for ( Account r:results){
            AL.add(new AccountInfo(r.id, r.name, r.lastmodifieddate) );
        }
        return AL;
    }
    
     public static List<AccountInfo> GetAccountLikeName( string theinfo ){
        
        String SOQL = ' SELECT Id, Name,lastmodifieddate  FROM Account ';
        SOQL +=  'WHERE Name like \'%' + theinfo + '%\'';
        system.debug('SOQL:' + SOQL);
        List<Account> results =  Database.query(SOQL);
        List<AccountInfo> AL = new List<AccountInfo>();
        for ( Account r:results){
            AL.add(new AccountInfo(r.id, r.name, r.lastmodifieddate) );
        }
        return AL;
    }

}