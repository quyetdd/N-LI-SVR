@RestResource(urlMapping='/MobileAppMemberCard/*')
global with sharing class wb_soap_MobileAppMemberCard {
    
    global class MemberCardInfo{
        global string Id; 
        global string MemberNo;   
        global string CompanyName;   
        global string FirstName;   
        global string LastName;   
        global string ExpiryDate;  
        // Effective Date on Mobile App, which is the start date of the Contract
        global string lastmodifieddate; 
        global string ContractDate;
        global string DateOfBirth;
        global string ServiceAreaCode;
        global string EmailAddress;
        public MemberCardInfo(){}
        
        public MemberCardInfo( id theId, string theMemberNo, string theCompanyName, string theFirstName, string theLastName,
                              date theExpiryDate, datetime dt, //string ContractD, string DofBirth, 
                              date ContractD, date DofBirth, 
                              string ServiceAC, string email )
        {
            Id = theId; 
            MemberNo= theMemberNo;
            FirstName = theFirstName;
            LastName = theLastName;
            String formatedDt = dt.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
            lastmodifieddate = formatedDt;
            if (theExpiryDate != null)
            ExpiryDate =   DateTime.newInstance(
                theExpiryDate.year(), theExpiryDate.month(), theExpiryDate.day()
            ).format('yyyy/MM/dd');
            CompanyName = theCompanyName;
            // ContractDate = ContractD;
            //DateOfBirth = DofBirth;
            if (ContractD != null)
            ContractDate = DateTime.newInstance(
                ContractD.year(), ContractD.month(), ContractD.day()
            ).format('yyyy/MM/dd'); 
            if ( DofBirth != null)
            DateOfBirth = DateTime.newInstance(
                DofBirth.year(), DofBirth.month(), DofBirth.day()
            ).format('yyyy/MM/dd'); 
            ServiceAreaCode = ServiceAC;
            EmailAddress = email;
        }

    }
    
    @HttpGet
    global static MemberCardInfo getMemberCardInfo() {
            
            RestRequest request = RestContext.request;
            // grab the caseId from the end of the URL
            String req = request.requestURI.substring(
                request.requestURI.lastIndexOf('/')+1);
            system.debug('req:'+req);
            if ( req.indexOf('=') > 1){
                string reqType = req.left( req.indexOf('='));
                string reqInfo = req.right(req.length() - req.indexOf('=') - 1);
                
                if ( reqType=='Id') {
                    
                    return GetMemberCardInfobyId(reqInfo);
                    
                } else
                    return new MemberCardInfo();
                
                
            } else {
                return new MemberCardInfo();
            }
            
        }
    
    
    public static MemberCardInfo GetMemberCardInfobyId( string Id ){
        
        if( [select id from MemberInfo__c where id =:Id].size() > 0 ) {
            

            
            MemberInfo__c cr= [SELECT id, MemberNo__c, KinmuCompany__r.name, SeiRoma__c, 
                               MeiRoma__c , //CompanyKeiyakuNo__r.MankiDate__c, 
                               MankiDate__c, 
                               KeiyakuDate__c, KeiyakuDate_CdFmt__c, 
                               DateOfBirth__c, DateOfBirth_CdFmt__c,
                               lastmodifieddate, 
                               	MemberCardKeiyakuCompanyName__c, ServiceAreaCd__c, Email__c,
                               	App_Registration__c
                               FROM MemberInfo__c
                                where id =:Id];
            
            if ( cr.App_Registration__c != true) {
                cr.App_Registration__c = true;
                update cr;
            }
            
            if ( [select Id from wb_soap_log__c 
                  where Type__c ='1ST' and MemberNo__c=:cr.MemberNo__c].size() == 0 ){
                insert new wb_soap_log__c(LastAcessDate__c= System.today(),MemberID__c = cr.id,
                                          MemberNo__c=cr.MemberNo__c,
                                          MemberInfo__c=1, Type__c ='1ST');
            } else {
                wb_soap_log__c log = [select Id, MemberInfo__c, MemberID__c, LastAcessDate__c from wb_soap_log__c 
                                      where Type__c ='1ST' and MemberNo__c=:cr.MemberNo__c ];
                if ( log.MemberID__c == null || log.id == log.MemberID__c )
                    log.MemberID__c = cr.id;
                date td =  System.today();
                if ( log.LastAcessDate__c == td ) {
                    if (log.MemberInfo__c != null)
                        log.MemberInfo__c = log.MemberInfo__c + 1;
                    else 
                        log.MemberInfo__c = 1;
                }
                else {
                    log.LastAcessDate__c = td;
                    log.LogIn__c = 0;
                    log.MemberInfo__c = 1;
                }
                update log; 
            }
            
            
            return new MemberCardInfo(cr.id, cr.MemberNo__c, cr.MemberCardKeiyakuCompanyName__c , cr.MeiRoma__c,cr.SeiRoma__c,
                                     // cr.CompanyKeiyakuNo__r.MankiDate__c,
                                     
                                     // cr.MankiDate__c,
                                      cr.KeiyakuDate__c,
                                      cr.lastmodifieddate, 
                                      //cr.KeiyakuDate_CdFmt__c, cr.DateOfBirth_CdFmt__c, 
                                      cr.KeiyakuDate__c, cr.DateOfBirth__c, 
                                      cr.ServiceAreaCd__c, cr.Email__c ) ;
        }
        else if ( [select id from FamilyInfo__c  where id =:Id].size() > 0  ){
            FamilyInfo__c cfr = [SELECT id, MemberNo__c,  MemberShimei__r.KinmuCompany__r.name,
                                 SeiRoma__c, MeiRoma__c ,  //MemberShimei__r.CompanyKeiyakuNo__r.MankiDate__c,
                                 MemberShimei__r.MankiDate__c, MemberShimei__r.KeiyakuDate__c,
                                 KeiyakuDate__c, KeiyakuDate_CdFmt__c, 
                                 DateOfBirth__c, DateOfBirth_CdFmt__c,
                                 lastmodifieddate,
                                 MemberCardKeiyakuCompanyName__c, ServiceAreaCd__c, Email__c,  MemberShimei__r.Email__c, 
                                 App_Registration__c
                                 FROM FamilyInfo__c  where id =:Id];
            
            if ( cfr.App_Registration__c != true) {
                cfr.App_Registration__c = true;
                update cfr;
            }
            
           if ( [select Id from wb_soap_log__c 
                 where Type__c ='1ST' and MemberNo__c=:cfr.MemberNo__c].size() == 0 ){
                insert new wb_soap_log__c(LastAcessDate__c= System.today(),MemberID__c = cfr.id,
                                          MemberNo__c=cfr.MemberNo__c,
                                          MemberInfo__c=1, Type__c ='1ST');
            } else {
                wb_soap_log__c log = [select Id, MemberInfo__c, MemberID__c, LastAcessDate__c from wb_soap_log__c 
                                      where  Type__c ='1ST' and MemberNo__c=:cfr.MemberNo__c ];
                if ( log.MemberID__c == null || log.MemberID__c == log.id )
                    log.MemberID__c = cfr.id;
                date td =  System.today();
                if ( log.LastAcessDate__c == td ) {
                    if (log.MemberInfo__c != null)
                        log.MemberInfo__c = log.MemberInfo__c + 1;
                    else 
                        log.MemberInfo__c = 1;
                }
                else {
                    log.LastAcessDate__c = td;
                    log.LogIn__c = 0;
                    log.MemberInfo__c = 1;
                }
                update log; 
            }
            //20180406 To return member email address if the family email address is empty
            string fremail;
            if (cfr.Email__c != null )
                fremail = cfr.Email__c;
            else 
            	fremail = cfr.MemberShimei__r.Email__c;
            
            return new MemberCardInfo(cfr.id, cfr.MemberNo__c, cfr.MemberCardKeiyakuCompanyName__c,  cfr.MeiRoma__c,cfr.SeiRoma__c,
                                      //cfr.MemberShimei__r.CompanyKeiyakuNo__r.MankiDate__c, 
                                     // cfr.MemberShimei__r.MankiDate__c,
                                     cfr.MemberShimei__r.KeiyakuDate__c,
                                      cfr.lastmodifieddate, 
                                      //cfr.KeiyakuDate_CdFmt__c, cfr.DateOfBirth_CdFmt__c, 
                                      cfr.KeiyakuDate__c, cfr.DateOfBirth__c, 
                                      cfr.ServiceAreaCd__c, // 20180406 cfr.Email__c 
                                      fremail
                                      ) ;
        } 
        else if ([select id from wb_Member__c 
                   where id =:Id and f_Classification__c ='会員' ].size() > 0)
        {
          /*  wb_MemberHistory__c member = [SELECT member__r.Individual__c, MemberNo__c, MembershipDetail__r.WorkingCompany__r.name,
                                          member__r.Individual__r.LastNameRoma__c,
                                          member__r.Individual__r.FirstNameRoma__c,
                                          MembershipDetail__r.MembershipEndDate__c,
                                          member__r.Individual__r.EmailAddress__c,
                                          MembershipDetail__c, CancellationDate__c,
                                          member__r.Individual__r.lastmodifieddate
                                          FROM wb_MemberHistory__c
                                          where  member__r.Individual__c =:Id and CancellationDate__c = null
                                          and MembershipDetail__r.MembershipStopDate__c >= today
                                          and MembershipDetail__r.MembershipEndDate__c >= today order by MembershipDetail__r.MembershipEndDate__c desc limit 1 ];*/
            
            wb_Member__c member = [select Id, f_MemberNo__c, WorkingCompany__r.name,
                                   Individual__r.FirstNameRoma__c, Individual__r.LastNameRoma__c,
                                   r_EffectiveUntil__c , MembershipDetail__r.Membership__r.ContractDate__c,
                                   MembershipDetail__r.Service__r.ServiceAreaCd__c,
                                   lastmodifieddate, Individual__r.lastmodifieddate, 
                                   Individual__r.DateOfBirth__c,
                                   Individual__r.EmailAddress__c, Individual__r.Parent__r.EmailAddress__c
                                   from wb_Member__c where Id=:Id];
            InsertLog(member.Id,member.f_MemberNo__c);
            string emailaddress;
            if ( member.Individual__r.EmailAddress__c != null)
                emailaddress = member.Individual__r.EmailAddress__c;
            else if (member.Individual__r.Parent__c != null )
                 emailaddress = member.Individual__r.Parent__r.EmailAddress__c;
            datetime lud;
            if (member.lastmodifieddate > member.Individual__r.lastmodifieddate)
                lud = member.lastmodifieddate;
            else
                lud = member.Individual__r.lastmodifieddate;
            
            return new MemberCardInfo(member.Id, 
                                      member.f_MemberNo__c, 
                                      member.WorkingCompany__r.name, 
                                      member.Individual__r.FirstNameRoma__c,  member.Individual__r.LastNameRoma__c,
                                      member.MembershipDetail__r.Membership__r.ContractDate__c, 
                                      lud, 
                                      member.MembershipDetail__r.Membership__r.ContractDate__c, member.Individual__r.DateOfBirth__c, 
                                      member.MembershipDetail__r.Service__r.ServiceAreaCd__c, 
                                      emailaddress ) ;
            
        } 

         return new MemberCardInfo();
    }
    
    public static void InsertLog(Id Id, string MemberNo ){
        
          if ( [select Id from wb_soap_log__c 
                 where Type__c ='1ST' and MemberNo__c=:MemberNo].size() == 0 ){
                insert new wb_soap_log__c(LastAcessDate__c= System.today(),MemberID__c = Id,
                                          MemberNo__c=MemberNo,
                                          MemberInfo__c=1, Type__c ='1ST');
            } else {
                wb_soap_log__c log = [select Id, MemberInfo__c, MemberID__c, LastAcessDate__c from wb_soap_log__c 
                                      where  Type__c ='1ST' and MemberNo__c=:MemberNo ];
                if ( log.MemberID__c == null || log.MemberID__c != Id)
                    log.MemberID__c = Id;
                date td =  System.today();
                if ( log.LastAcessDate__c == td ) {
                    if (log.MemberInfo__c != null)
                        log.MemberInfo__c = log.MemberInfo__c + 1;
                    else 
                        log.MemberInfo__c = 1;
                }
                else {
                    log.LastAcessDate__c = td;
                    log.LogIn__c = 0;
                    log.MemberInfo__c = 1;
                }
                update log; 
            }
        
    }

}