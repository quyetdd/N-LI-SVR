@RestResource(urlMapping='/Account/*')
global with sharing class wb_soap_Account {
    global class Company{
        global string Id; 
        global string Name;
        global string OfficePostcd;
        global string OfficeAdd;
        global string Message;
        
        public Company( id theId, string theName, 
                       string theOfficePostcd, string theOfficeAdd, string theMessage )
        {
            Id = theId; 
            Name= theName;
            OfficePostcd = theOfficePostcd;
            OfficeAdd=theOfficeAdd;
            Message= theMessage;
        }
    }
    
    @HttpGet
    global static List<Company> getCompany() {
        
        RestRequest request = RestContext.request;
        // grab the caseId from the end of the URL
        String req = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        system.debug('req:'+req);
        if ( req.indexOf('=') > 1){
            string reqType = req.left( req.indexOf('='));
            string reqInfo = req.right(req.length() - req.indexOf('=') - 1);
            if ( reqType=='LIST') {
                return GetCompanyList(reqInfo);
            } else if ( reqType=='ID')
                return GetCompany(Id.valueOf(reqInfo));
            else 
                return null;
        } else
            return null;            
        

    }
    
    public static List<Company> GetCompanyList(string Info){
        List<Company> CompanyList = new List<Company>();
        for ( Account a:[select id, name from Account order by lastmodifieddate desc limit 10]){
            CompanyList.add( new Company(a.id, a.name, null, null,null));
        }
        return CompanyList;
    }
    
     public static List<Company> GetCompany(Id CompID){
         List<Company> CompanyList = new List<Company>();
         account a =[select id, name, OfficePostcd__c,OfficeAdd__c,President__c,Phone,Fax,Busho__c,Yakushoku__c,Shimei__c,SubBusho__c,SubYakushoku__c,SubShimei__c
                     from account where id =:CompID];
         CompanyList.add( new Company(a.id, a.name, a.OfficePostcd__c, a.OfficeAdd__c, null));
         return CompanyList;
     }
    
    @HttpPatch
    global static List<Company> updateCompany(String CompanyId, String OfficePostcd) {
        List<Company> CompanyList = new List<Company>();
        try {
            account a =[select id, name, OfficePostcd__c,OfficeAdd__c,President__c,Phone,Fax,Busho__c,Yakushoku__c,Shimei__c,SubBusho__c,SubYakushoku__c,SubShimei__c
                        from account where id =:CompanyId];
            if ( a != null)
                a.OfficePostcd__c = OfficePostcd;
            update a;
            CompanyList.add(new Company(a.id, a.name, a.OfficePostcd__c, a.OfficeAdd__c,'update success'));
            return CompanyList;
        }
        catch(Exception e) {
            CompanyList.add(new Company(CompanyId, null, OfficePostcd, null,'update failed'));
            return CompanyList;
        }
 
    }

}