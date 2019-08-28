@RestResource(urlMapping='/2ndPhs/MobileAppLogin/*')
global with sharing class wb_soap_MobileAppLogin_2ndPhs {
    
    global class MemberLoginInfo{
        global string Id; 
        global string MemberNo;   
        global string ServiceAreaCode;
        global string MemberClassification;  
        global string Commodity;
        global wb_soap_MobileAppMemberInfo_2ndPhs.AreaControl AreaControl;
        global string lastmodifieddate; 
        public MemberLoginInfo(){}
        
        public MemberLoginInfo( id theId, string theMemberNo, string Classification, datetime dt,
                               string ServiceAreaCd, string vcommodity)
        {
            Id = theId; 
            MemberNo= theMemberNo;
            // String formatedDt = dt.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
            // lastmodifieddate = formatedDt;
            lastmodifieddate = dt.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
            MemberClassification = Classification;
            ServiceAreaCode = ServiceAreaCd;
            Commodity = vcommodity;
            
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
        
        
        InsertLog(theMemberNo);
        
        if( [select id from MemberInfo__c where MemberNo__c =:theMemberNo].size() > 0 ) {
            
            MemberInfo__c cr= [select id, MemberNo__c, CompanyKeiyakuNo__r.MankiDate__c, MemberKubunB__c,
                               lastmodifieddate, ServiceAreaCd__c,
                              // KinmuCompany__r.Region_and_Area__c, KinmuCompany__r.CountryName__c, KinmuCompany__r.Jurisdiction__c, KinmuCompany__r.ShozokuArea__c,
                               Region_and_Area__c, CountryName__c, Jurisdiction__c, ShozokuArea__c,
                               Commodity__c
                               from MemberInfo__c where MemberNo__c =:theMemberNo];
            MemberLoginInfo rst = new MemberLoginInfo(cr.id, cr.MemberNo__c, cr.MemberKubunB__c,
                                                      cr.lastmodifieddate, cr.ServiceAreaCd__c, cr.Commodity__c );
            
            rst.AreaControl = new wb_soap_MobileAppMemberInfo_2ndPhs.AreaControl(cr);
            /*   return new MemberLoginInfo(cr.id, cr.MemberNo__c, cr.MemberKubunB__c,
			cr.lastmodifieddate, cr.ServiceAreaCd__c ) ; */
            return rst;
        }
        else if ( [select id from FamilyInfo__c where MemberNo__c =:theMemberNo].size() > 0  ){
            FamilyInfo__c cfr = [select id, MemberShimei__r.CompanyKeiyakuNo__r.MankiDate__c,
                                 MemberNo__c, MemberKubunB__c,
                                 lastmodifieddate, ServiceAreaCd__c,
                               //  MemberShimei__r.KinmuCompany__r.Region_and_Area__c, MemberShimei__r.KinmuCompany__r.CountryName__c, 
                              //   MemberShimei__r.KinmuCompany__r.Jurisdiction__c, MemberShimei__r.KinmuCompany__r.ShozokuArea__c,
                                 
                                  Region_and_Area__c, CountryName__c, Jurisdiction__c, ShozokuArea__c,
                                 
                                 Commodity__c
                                 from FamilyInfo__c where MemberNo__c =:theMemberNo];
            MemberLoginInfo rst = new MemberLoginInfo(cfr.id, cfr.MemberNo__c, cfr.MemberKubunB__c, 
                                                      cfr.lastmodifieddate, cfr.ServiceAreaCd__c, cfr.Commodity__c );
            
            rst.AreaControl = new wb_soap_MobileAppMemberInfo_2ndPhs.AreaControl(cfr);
            /* return new MemberLoginInfo(cfr.id, cfr.MemberNo__c, cfr.MemberKubunB__c, 
cfr.lastmodifieddate, cfr.ServiceAreaCd__c ) ;*/
            return rst;
        } 
        
        else if ([select id from wb_Member__c where f_MemberNo__c =:theMemberNo].size() > 0 ){    
            
            
            wb_Member__c r = [SELECT Id, f_Classification__c,f_MemberNo__c,Individual__c,Name,r_EffectiveUntil__c, 
                              lastmodifieddate, Individual__r.lastmodifieddate,
                              MembershipDetail__r.Service__r.ServiceAreaCd__c,
                              WorkingCompany__r.Region_and_Area__c, WorkingCompany__r.CountryName__c, WorkingCompany__r.Jurisdiction__c, WorkingCompany__r.ShozokuArea__c,
                              MembershipDetail__r.Service__r.Commodity__c
                              FROM wb_Member__c where f_MemberNo__c =:theMemberNo];
            MemberLoginInfo rst =  new MemberLoginInfo(r.Id, r.f_MemberNo__c, r.f_Classification__c, r.lastmodifieddate,  
                                                       r.MembershipDetail__r.Service__r.ServiceAreaCd__c, r.MembershipDetail__r.Service__r.Commodity__c);
            rst.AreaControl = new wb_soap_MobileAppMemberInfo_2ndPhs.AreaControl(r);
            /*  return new MemberLoginInfo(r.Id, r.f_MemberNo__c, r.f_Classification__c, r.lastmodifieddate,  
r.MembershipDetail__r.Service__r.ServiceAreaCd__c) ;*/
            return rst;
            
        } else
            return new MemberLoginInfo();
    }
    
    public static void InsertLog( string MemberNo ){
        
        /*  wb_soap_log__c log = [select Id, LogIn__c ,LastAcessDate__c from wb_soap_log__c 
where Type__c ='2ND' and MemberNo__c=:MemberNo ];*/
        
        if ( [select Id from wb_soap_log__c where Type__c ='2ND' and MemberNo__c=:MemberNo].size() == 0 ){
            //  if ( log == null ){
            insert new wb_soap_log__c(LastAcessDate__c= System.today(),MemberNo__c=MemberNo,LogIn__c=1,Type__c ='2ND');
        } else {
            wb_soap_log__c log = [select Id, LogIn__c ,LastAcessDate__c from wb_soap_log__c 
                                  where Type__c ='2ND' and MemberNo__c=:MemberNo ]; 
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
            //log.LogIn__c = integer.valueOf('x');
            update log; 
        }
        
    }
    
    
    
}