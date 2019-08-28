@RestResource(urlMapping='/MobileAppLogin/*')
global with sharing class wb_soap_MobileAppLogin {
    
    global class MemberLoginInfo{
       	global string Id; 
        global string MemberNo;   
        global string MemberClassification;  
        global string lastmodifieddate; 
        public MemberLoginInfo(){}
        
        public MemberLoginInfo( id theId, string theMemberNo, string Classification, datetime dt){
   			Id = theId; 
            MemberNo= theMemberNo;
            String formatedDt = dt.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
            lastmodifieddate = formatedDt;
            MemberClassification = Classification;

        }
    }
        
    @HttpGet
    global static MemberLoginInfo getMemberLoginInfo() {
        
        RestRequest request = RestContext.request;
        // grab the caseId from the end of the URL
        String req = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        system.debug('req:'+req);
        if ( req.indexOf('=') > 1){
            string reqType = req.left( req.indexOf('='));
            string reqInfo = req.right(req.length() - req.indexOf('=') - 1);
            
            if ( reqType=='MemberNo') {
                
                return GetMemberLoginInfobyMemberNo(reqInfo);
                
            } else
                return new MemberLoginInfo();
            
 
        } else {
            return new MemberLoginInfo();
        }
        
    }
    
    public static MemberLoginInfo GetMemberLoginInfobyMemberNo( string theMemberNo ){
        
        if ( [select Id from wb_soap_log__c 
              where Type__c ='1ST' and MemberNo__c=:theMemberNo].size() == 0 ){
            insert new wb_soap_log__c(LastAcessDate__c= System.today(),MemberNo__c=theMemberNo,LogIn__c=1, Type__c ='1ST' );
        } else {
            wb_soap_log__c log = [select Id, LogIn__c ,LastAcessDate__c from wb_soap_log__c 
                                  where  Type__c ='1ST' and MemberNo__c=:theMemberNo ];
            if ( log.LastAcessDate__c == System.today() ) {
                if (log.LogIn__c != null) {
                    log.LogIn__c = log.LogIn__c + 1;
                   // log.LogIn__c = integer.valueOf('x');
                }
                else
                    log.LogIn__c = 1;
            }
            else {
                log.LastAcessDate__c = System.today();
                log.LogIn__c = 1;
                log.MemberInfo__c = 0;
            }
            update log; 
        }
        

        if( [select id from MemberInfo__c where MemberNo__c =:theMemberNo].size() > 0 ) {
                 
                 MemberInfo__c cr= [select id, MemberNo__c, CompanyKeiyakuNo__r.MankiDate__c, MemberKubunB__c,
                                    lastmodifieddate 
                                    from MemberInfo__c where MemberNo__c =:theMemberNo];
                  return new MemberLoginInfo(cr.id, cr.MemberNo__c, cr.MemberKubunB__c,
                                             cr.lastmodifieddate ) ;
             }
        else if ( [select id from FamilyInfo__c where MemberNo__c =:theMemberNo].size() > 0  ){
            FamilyInfo__c cfr = [select id, MemberShimei__r.CompanyKeiyakuNo__r.MankiDate__c,
                                 MemberNo__c, MemberKubunB__c,
                                 lastmodifieddate from FamilyInfo__c where MemberNo__c =:theMemberNo];
             return new MemberLoginInfo(cfr.id, cfr.MemberNo__c, cfr.MemberKubunB__c, 
                                        cfr.lastmodifieddate ) ;
        } 
        else if ([select id from wb_Member__c where f_MemberNo__c =:theMemberNo].size() > 0 ){
           // SELECT f_Classification__c,f_MemberNo__c,Individual__c,Name,r_EffectiveUntil__c FROM wb_Member__c
         /*   wb_MemberHistory__c r = [select member__r.Individual__c, MemberNo__c, MembershipEndDate__c, lastmodifieddate
                                     from wb_MemberHistory__c 
                                     where  MemberNo__c =: theMemberNo 
                                     and ( CancellationDate__c = null or CancellationDate__c > today )
                                     order by MembershipEndDate__c desc limit 1];*/
            wb_Member__c r = [SELECT Id, f_Classification__c,f_MemberNo__c,Individual__c,Name,r_EffectiveUntil__c, 
                              lastmodifieddate, Individual__r.lastmodifieddate
                              FROM wb_Member__c where f_MemberNo__c =:theMemberNo];
            return new MemberLoginInfo(r.Id, r.f_MemberNo__c, r.f_Classification__c, r.lastmodifieddate ) ;
        } else
            return new MemberLoginInfo();
    }
    

}