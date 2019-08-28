@RestResource(urlMapping='/2ndPhs/MobileAppMemberInfo/*')
global with sharing class wb_soap_MobileAppMemberInfo_2ndPhs {
    
    // Testing for Extra Insurance
    
    global class ExtraInsuranceMemeber{
      //  global Map<String,Integer> MemberList;
         global Map<String, List<String>> MemberList;
        
/*
        public ExtraInsuranceMemeber(){
          //  MemberList =  new Map<String,Integer>();
          	List<String> ExtraInsurance = new List<String>();
            ExtraInsurance.add('Happy China');
            ExtraInsurance.add('Medi Life');
            ExtraInsurance.add('Happy Life');
            ExtraInsurance.add('チャイナボウル');
            ExtraInsurance.add('ウェルライフ');
            ExtraInsurance.add('新優You');
            
            List<String> ExtraInsurance1 = new List<String>();
            ExtraInsurance1.add('Happy China');
            List<String> ExtraInsurance2 = new List<String>();
            ExtraInsurance2.add('Medi Life');
            ExtraInsurance2.add('Happy Life');
            List<String> ExtraInsurance3 = new List<String>();
            ExtraInsurance3.add('チャイナボウル');
            ExtraInsurance3.add('ウェルライフ');
            ExtraInsurance3.add('新優You');
            
            MemberList =  new Map<String,List<String>>();
            MemberList.put('1CHN2243420',ExtraInsurance);
            MemberList.put('1CHN2243270',ExtraInsurance);
            MemberList.put('1CHN2597560',ExtraInsurance);
            MemberList.put('1VTN2591150',ExtraInsurance);
            MemberList.put('1MYS2609360',ExtraInsurance);
            MemberList.put('1GME2580910',ExtraInsurance);
            MemberList.put('3JPN2584910',ExtraInsurance);
            MemberList.put('1THA2600760',ExtraInsurance);
       
          //  MemberList.put('1HKG2243421',ExtraInsurance1);
       
            MemberList.put('1CHN2243422',ExtraInsurance1);
            MemberList.put('1HKG2243423',ExtraInsurance2);
            MemberList.put('1HKG2243424',ExtraInsurance2);
            MemberList.put('1HKG2243425',ExtraInsurance3);
            MemberList.put('1CHN2243426',ExtraInsurance3);
            
        }
  */
        
    } 
    // Testing for Extra Insurance
    
    global class Field{
        global integer Nr;
        global string FieldName;
        global string FieldValue;
        public Field(integer n, string fn, string fv){
            Nr = n;
            FieldName = fn;
            FieldValue = fv;
        }
    }
    
    global class Insurance{
        global List<Field> Fields;
        
        public Insurance(string theInsuranceName , 
                         string MemberNo,string MemberName, string policyNo,
                         string CompanyName, string FirstName, string LastName,
                       //  date dateofbirth,
                         date InitialDate, date theStartDate, date theEndDate,
                         string OMSMedicalCoverage, string OMSDentalCoverage, string OMSVaccinationCoverage,
                         string OMSChildBirthCoverage,  string OMSExaminationCoverage
                        ){
                            
                            Fields = new List<Field>();
                            Fields.add( new Field(0, 'Name',theInsuranceName ));
                            
                            if (theInsuranceName =='Happy China' || theInsuranceName == 'Happy Life' ){
                                
                                
                                Fields.add( new Field(1, 'MemberNo',MemberNo ));
                                Fields.add( new Field(2, 'MemberName',MemberName ));
                                Fields.add( new Field(3, 'policyNo',policyNo ));
                                /*
                                if ( theStartDate != null)
                                    Fields.add( new Field(4, 'StartDate', DateTime.newInstance(
                                        theStartDate.year(), theStartDate.month(), theStartDate.day()
                                    ).format('yyyy/MM/dd') ));
                                else
                                    Fields.add( new Field(4, 'StartDate', null ));
								*/
                                if ( InitialDate != null)
                                    Fields.add( new Field(4, 'StartDate', DateTime.newInstance(
                                        InitialDate.year(), InitialDate.month(), InitialDate.day()
                                    ).format('yyyy/MM/dd') ));
                                else
                                    Fields.add( new Field(4, 'StartDate', null ));
                                
                                if (theEndDate !=null )
                                    Fields.add( new Field(5, 'ExpiryDate', DateTime.newInstance(
                                        theEndDate.year(), theEndDate.month(), theEndDate.day()
                                    ).format('yyyy/MM/dd') ));
                                else
                                    Fields.add( new Field(5, 'ExpiryDate', null ));                    
                                
                            } else if (theInsuranceName =='チャイナボウル'|| 
                                       theInsuranceName =='新優You' || theInsuranceName =='Medi Life' || theInsuranceName == 'ウェルライフ') {
                                           Fields.add( new Field(1, 'MemberNo',MemberNo ));
                                           Fields.add( new Field(2, 'CompanyName',CompanyName ));
                                           Fields.add( new Field(3, 'FirstName',FirstName ));
                                           Fields.add( new Field(4, 'LastName',LastName ));
                                           
                                           if (theInsuranceName =='チャイナボウル') {
                                               
                                               // 20190523
                                               /*
                                               if ( dateofbirth != null)
                                                   Fields.add( new Field(5, 'DateofBirth',DateTime.newInstance(
                                                       dateofbirth.year(), dateofbirth.month(), dateofbirth.day()
                                                   ).format('yyyy/MM/dd')  ));
                                               else 
                                                   Fields.add( new Field(5, 'DateofBirth',null ));
                                               */
                                               
                                               if ( theStartDate != null)
                                                   Fields.add( new Field(5, 'EffectiveDate',DateTime.newInstance(
                                                       theStartDate.year(), theStartDate.month(), theStartDate.day()
                                                   ).format('yyyy/MM/dd')  ));
                                               else 
                                                   Fields.add( new Field(5, 'EffectiveDate',null ));
                                               
                                           } else  if (theInsuranceName =='新優You' || theInsuranceName =='Medi Life' || theInsuranceName =='ウェルライフ') {
                                               if ( InitialDate != null)
                                                   Fields.add( new Field(5, 'FirstEffectiveDate',DateTime.newInstance(
                                                       InitialDate.year(), InitialDate.month(), InitialDate.day()
                                                   ).format('yyyy/MM/dd')  ));
                                               else
                                                   Fields.add( new Field(5, 'FirstEffectiveDate', null  ));
                                               
                                               if ( theEndDate != null)
                                                   Fields.add( new Field(6, 'ExpiryDate',DateTime.newInstance(
                                                       theEndDate.year(), theEndDate.month(), theEndDate.day()
                                                   ).format('yyyy/MM/dd')  ));
                                               else
                                                   Fields.add( new Field(6, 'ExpiryDate',null  ));
                                               
                                           }
                                           
                                       } else  if (theInsuranceName =='OM-S') {
                                           
                                           Fields.add( new Field(1, 'Remark1', null));
                                           Fields.add( new Field(2, 'Remark2', null));
                                           Fields.add( new Field(3, 'Coverage1', 'Medical'));
                                           Fields.add( new Field(4, 'Coverage2', 'Dental'));
                                           Fields.add( new Field(5, 'Coverage3', 'Vaccination'));
                                           Fields.add( new Field(6, 'Coverage4', 'Child Birth'));
                                           Fields.add( new Field(7, 'Coverage5', 'Examination'));
                                           Fields.add( new Field(8, 'Coverage1Value', OMSMedicalCoverage));
                                           Fields.add( new Field(9, 'Coverage2Value', OMSDentalCoverage));
                                           Fields.add( new Field(10, 'Coverage3Value', OMSVaccinationCoverage));
                                           Fields.add( new Field(11, 'Coverage4Value', OMSChildBirthCoverage));
                                           Fields.add( new Field(12, 'Coverage5Value', OMSExaminationCoverage));
                                           Fields.add( new Field(13, 'Tel', '+86-21-3337-5022'));
                                           
                                       }
                            else {
                                if ( theStartDate != null)
                                    Fields.add( new Field(1, 'StartDate', DateTime.newInstance(
                                        theStartDate.year(), theStartDate.month(), theStartDate.day()
                                    ).format('yyyy/MM/dd') ));
                                else
                                    Fields.add( new Field(1, 'StartDate', null ));      
                                if (theEndDate != null)
                                    Fields.add( new Field(2, 'ExpiryDate', DateTime.newInstance(
                                        theEndDate.year(), theEndDate.month(), theEndDate.day()
                                    ).format('yyyy/MM/dd') ));
                                else
                                    Fields.add( new Field(2, 'ExpiryDate', null ));
                                
                                
                            }
                        }
    }
    
    
    global class MyInfo{
        global string EmailAddress;
        global string PostalCode;
        global string Address;
        global string CountryCallingCode;
        global string Telephone;
        global string Mobile;
        global string Fax;
        global boolean MailDelivery;
    }
    
    global class Contact{
        //  global string Id;
        global string ContactName_1;
        global string ContactRelationship_1;
        global string ContactCountryCode_1;
        global string ContactTelephone_1;
        global string ContactMobile_1;
        global string ContactFax_1;
        global string ContactPostalCode_1;
        global string ContactAddress_1;
        global string ContactEmail_1;
        global string ContactName_2;
        global string ContactRelationship_2;
        global string ContactCountryCode_2;
        global string ContactTelephone_2;
        global string ContactMobile_2;
        global string ContactFax_2;
        global string ContactPostalCode_2;
        global string ContactAddress_2;
        global string ContactEmail_2;
        
        public Contact( ) {
        }
        
        public Contact( MemberInfo__c cr){
            //   Id = cr.Id;
            ContactName_1 = cr.ContactShimei_1__c;
            ContactRelationship_1 = cr.ContactRelationship_1__c;
            ContactCountryCode_1 = cr.ContactCountryCode_1__c ;
            ContactTelephone_1 = cr.ContactTel_1__c;
            ContactMobile_1 = cr.ContactMobile_1__c;
            ContactFax_1 = cr.ContactFax_1__c;
            ContactPostalCode_1=cr.ContactPostcd_1__c;
            ContactAddress_1 =cr.ContactAddress_1__c;
            ContactEmail_1=cr.ContactEmail_1__c;
            ContactName_2 = cr.ContactShimei_2__c;
            ContactRelationship_2 = cr.ContactRelationship_2__c;
            ContactCountryCode_2 = cr.ContactCountryCode_2__c ;
            ContactTelephone_2 = cr.ContactTel_2__c;
            ContactMobile_2 = cr.ContactMobile_2__c;
            ContactFax_2 = cr.ContactFax_2__c;
            ContactPostalCode_2=cr.ContactPostcd_2__c;
            ContactAddress_2 =cr.ContactAddress_2__c;
            ContactEmail_2=cr.ContactEmail_2__c;
            
        }
    }
    
    global class AreaControl{
        
        global string Area;
        global string Country;
        global string Jurisdiction;
        global string Affiliation;
        
        
        
        public AreaControl( ) {
        }
        
        public AreaControl( MemberInfo__c cr){

            Area = cr.Region_and_Area__c;
            Country = cr.CountryName__c;
            Jurisdiction = cr.Jurisdiction__c ;
            Affiliation = cr.ShozokuArea__c;
        }
        
        public AreaControl( FamilyInfo__c cr){

			
            Area = cr.Region_and_Area__c;
            Country = cr.CountryName__c;
            Jurisdiction = cr.Jurisdiction__c ;
            Affiliation = cr.ShozokuArea__c;
        }
        
        public AreaControl( wb_Member__c cr){
            Area = cr.WorkingCompany__r.Region_and_Area__c;
            Country = cr.WorkingCompany__r.CountryName__c;
            Jurisdiction = cr.WorkingCompany__r.Jurisdiction__c ;
            Affiliation = cr.WorkingCompany__r.ShozokuArea__c;
        }
    }
    
    
    global class MemberInfo{
        global AreaControl AreaControl;
        global string Commodity;
        global string Id; 
        global string MemberNo;   
        global string CompanyName;   
        global string ContractCompany_JP;  
        global string ContractCompany_ENG;  
        global string FirstName;   
        global string LastName;   
        global string Name;    
        global string EffectiveDate;  
        global string lastmodifieddate; 
        global string DateOfBirth;
        global string ServiceAreaCode;
        global string EmailAddress;
        
        // Second Phase   
        
        global List<Insurance> Insurances;
        
        global string PostalCode;
        global string Address;
        global string CountryCallingCode;
        global string Telephone;
        global string Mobile;
        global string Fax;
        global boolean MailDelivery;
        
        global Contact Contacts;
        
        
    //    public MemberInfo(){}
        
        public MemberInfo( MemberInfo__c cr )
        {
            AreaControl = new  AreaControl(cr);
            Commodity = cr.Commodity__c;
            Id = cr.id; 
            MemberNo= cr.MemberNo__c;
            Name = cr.Name;
            FirstName = cr.MeiRoma__c;
            LastName = cr.SeiRoma__c;
            datetime lmd = cr.lastmodifieddate;

            lastmodifieddate = lmd.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
            date ed = cr.KeiyakuDate__c;
            if (ed != null)
                EffectiveDate =   DateTime.newInstance(
                    ed.year(), ed.month(), ed.day()
                ).format('yyyy/MM/dd');
            CompanyName = cr.MemberCardKeiyakuCompanyName__c;
            ContractCompany_ENG = cr.KeiyakuCompanyName__r.CompanyNameEng__c;
            ContractCompany_JP = cr.KeiyakuCompanyName__r.Name;
                 
            date dob = cr.DateOfBirth__c;
            if ( dob != null)
                DateOfBirth = DateTime.newInstance(
                    dob.year(), dob.month(), dob.day()
                ).format('yyyy/MM/dd'); 
            ServiceAreaCode = cr.ServiceAreaCd__c;
            EmailAddress = cr.Email__c;
            MailDelivery = cr.MailHaishin__c;
            Insurances = new List<Insurance>();

           if (cr.InsuranceKind__c != null ) {
               Date OtaInsuranceShuki;
               if (cr.InsuranceCancelDate__c != null ){
                   OtaInsuranceShuki = cr.InsuranceCancelDate__c;
               } else {
                   OtaInsuranceShuki = cr.OtaInsuranceShuki__c;
               }
               
                if (cr.InsuranceKind__c =='OM-S') 
                    Insurances.add( new Insurance(cr.InsuranceKind__c, 
                                                  cr.MemberNo__c, cr.name, cr.ShokenNo__c,
                                                  cr.KinmuCompany__r.name,  cr.MeiRoma__c , cr.SeiRoma__c,
                                                 // cr.DateOfBirth__c,
                                                  cr.Shonendo_Shiki__c ,cr.OtaInsuranceShiki__c, // cr.OtaInsuranceShuki__c,
                                                  OtaInsuranceShuki,
                                                  cr.OMS_Medical__c, cr.OMS_Dental__c,  cr.OMS_Vaccination__c, cr.OMS_Child_Birth__c,  cr.OMS_Examination__c
                                                 ));
                else  {
                    Insurances.add( new Insurance(cr.InsuranceKind__c, 
                                                  cr.MemberNo__c, cr.name, cr.ShokenNo__c,
                                                  cr.KinmuCompany__r.name,  cr.MeiRoma__c , cr.SeiRoma__c,
                                               //   cr.DateOfBirth__c,
                                                  cr.Shonendo_Shiki__c ,cr.OtaInsuranceShiki__c, // cr.OtaInsuranceShuki__c,
                                                  OtaInsuranceShuki,
                                                  null,null,null,null,null
                                                 ));
                }
                
            }
            /*
            // to add extra insurance
            ExtraInsuranceMemeber theExtraInsuranceMemeber = new ExtraInsuranceMemeber();
            
            if ( theExtraInsuranceMemeber.MemberList.containsKey(cr.MemberNo__c)){
                List<String> insur = theExtraInsuranceMemeber.MemberList.get(cr.MemberNo__c);
                for ( integer i = 0; i < insur.size(); i ++) {
                    Insurances.add( new Insurance(insur[i], 
                                                  cr.MemberNo__c, cr.name, 'xxxxxx',
                                                  cr.KinmuCompany__r.name,  cr.MeiRoma__c , cr.SeiRoma__c,
                                                  cr.Shonendo_Shiki__c , //cr.OtaInsuranceShiki__c, cr.OtaInsuranceShuki__c,
                                                  system.today(), System.today().addYears(1),
                                                  null,null,null,null,null
                                                 ));
                    
                }
                
 
            }
			*/            
            
            PostalCode = cr.Postcd__c;
            Address = cr.Address__c;
            CountryCallingCode = cr.CountryCallingCodes__c;
            Telephone = cr.Tel__c;
            Mobile = cr.Mobile__c;
            Fax = cr.Fax__c;
            
            Contacts = new  Contact(cr);
            
        }

        
        public MemberInfo( FamilyInfo__c cfr)
        {
            AreaControl = new  AreaControl(cfr);
            Commodity = cfr.Commodity__c;
            
            Id = cfr.id; 
            MemberNo= cfr.MemberNo__c;
            Name = cfr.Name;
            FirstName = cfr.MeiRoma__c;
            LastName = cfr.SeiRoma__c;
            datetime lmd = cfr.lastmodifieddate;

            lastmodifieddate = lmd.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
            date ed = cfr.KeiyakuDate__c;
            if (ed != null)
                EffectiveDate =   DateTime.newInstance(
                    ed.year(), ed.month(), ed.day()
                ).format('yyyy/MM/dd');
            CompanyName = cfr.MemberCardKeiyakuCompanyName__c;
            ContractCompany_ENG = cfr.KeiyakuCompanyName__r.CompanyNameEng__c;
            ContractCompany_JP = cfr.KeiyakuCompanyName__r.Name;
            
            date dob = cfr.DateOfBirth__c;
            if ( dob != null)
                DateOfBirth = DateTime.newInstance(
                    dob.year(), dob.month(), dob.day()
                ).format('yyyy/MM/dd'); 
            ServiceAreaCode = cfr.ServiceAreaCd__c;

            
            if (cfr.Email__c != null )
                EmailAddress = cfr.Email__c;
            else 
                EmailAddress = cfr.MemberShimei__r.Email__c;
            
             MailDelivery = cfr.MailHaishin__c;
            
            Insurances = new List<Insurance>();
 
             if ( cfr.InsuranceKind__c != null  ){
                 // 2019-08-14
                 Date OtaInsuranceShuki;
                 if (cfr.InsuranceCancelDate__c != null ){
                     OtaInsuranceShuki = cfr.InsuranceCancelDate__c;
                 } else {
                     OtaInsuranceShuki = cfr.OtaInsuranceShuki__c;
                 }
                 
                if (cfr.InsuranceKind__c =='OM-S') 
                    Insurances.add( new Insurance(cfr.InsuranceKind__c,
                                                  cfr.MemberNo__c, cfr.name, cfr.ShokenNo__c,
                                                  cfr.MemberShimei__r.KinmuCompany__r.name,  
                                                  cfr.MeiRoma__c , cfr.SeiRoma__c,
                                                 // cfr.DateOfBirth__c,
                                                  cfr.Shonendo_Shiki__c, cfr.OtaInsuranceShiki__c, //cfr.OtaInsuranceShuki__c,
                                                   OtaInsuranceShuki,
                                                  cfr.OMS_Medical__c, cfr.OMS_Dental__c,  cfr.OMS_Vaccination__c, cfr.OMS_Child_Birth__c,  cfr.OMS_Examination__c));
                else  {
                    Insurances.add( new Insurance(cfr.InsuranceKind__c,
                                                  cfr.MemberNo__c, cfr.name, cfr.ShokenNo__c,
                                                  cfr.MemberShimei__r.KinmuCompany__r.name,  
                                                  cfr.MeiRoma__c , cfr.SeiRoma__c,
                                               //   cfr.DateOfBirth__c,
                                                  cfr.Shonendo_Shiki__c, cfr.OtaInsuranceShiki__c, // cfr.OtaInsuranceShuki__c,
                                                   OtaInsuranceShuki,
                                                  null,null,null,null,null));
                }
            }
            /*
            // to add extra insurance
            ExtraInsuranceMemeber theExtraInsuranceMemeber = new ExtraInsuranceMemeber();
            
            if ( theExtraInsuranceMemeber.MemberList.containsKey(cfr.MemberNo__c)){
      
                    List<String> insur = theExtraInsuranceMemeber.MemberList.get(cfr.MemberNo__c);
                    for ( integer i = 0; i < insur.size(); i ++) {
                        Insurances.add( new Insurance(insur[i], 
                                                      cfr.MemberNo__c, cfr.name, 'xxxxxx',
                                                      cfr.MemberShimei__r.KinmuCompany__r.name,  cfr.MeiRoma__c , cfr.SeiRoma__c,
                                                  //    cfr.DateOfBirth__c,
                                                      cfr.Shonendo_Shiki__c , //cr.OtaInsuranceShiki__c, cr.OtaInsuranceShuki__c,
                                                      system.today(), System.today().addYears(1),
                                                      null,null,null,null,null
                                                     ));
                        
                    }
                
      
                
            }
            */
            Mobile = cfr.Mobile__c;
        }

    }
    
    @HttpGet
    global static List<MemberInfo> getMemberInfo() {
        
        RestRequest request = RestContext.request;
        // grab the caseId from the end of the URL
        String req = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        system.debug('req:'+req);
        if ( req.indexOf('=') > 1){
            string reqType = req.left( req.indexOf('='));
            string reqInfo = req.right(req.length() - req.indexOf('=') - 1);
            
            if ( reqType=='Id') {
                
                return GetMemberInfobyId(reqInfo);
                
            } else
                return  new List<MemberInfo>();
            
            
        } else {
            return  new List<MemberInfo>();
        }
        
    }
    
    
    public static List<MemberInfo> GetMemberInfobyId( string Id ){
        
        List<MemberInfo>  Info = new List<MemberInfo>();
        
        if( [select id from MemberInfo__c where id =:Id].size() > 0 ) {

            return GetMemberFamily(Id);
            
        }
        else if ( [select id from FamilyInfo__c  where id =:Id].size() > 0  ){
            
            FamilyInfo__c cfr = [SELECT id, Name, MemberNo__c,  MemberShimei__r.KinmuCompany__r.name,
                                 SeiRoma__c, MeiRoma__c ,  
                                 MemberShimei__r.MankiDate__c, MemberShimei__r.KeiyakuDate__c,
                                 KeiyakuDate__c, KeiyakuDate_CdFmt__c, 
                                 DateOfBirth__c, DateOfBirth_CdFmt__c,
                                 lastmodifieddate,
                                 MemberCardKeiyakuCompanyName__c, ServiceAreaCd__c, Email__c,  MemberShimei__r.Email__c,
                                 OtaInsuranceShiki__c, OtaInsuranceShuki__c, InsuranceKind__c, InsuranceCancelDate__c,
                                 Mobile__c,
                                 ShokenNo__c,Shonendo_Shiki__c,
                                 // MemberShimei__r.KinmuCompany__r.Region_and_Area__c, MemberShimei__r.KinmuCompany__r.CountryName__c, MemberShimei__r.KinmuCompany__r.Jurisdiction__c, MemberShimei__r.KinmuCompany__r.ShozokuArea__c,
                                 Region_and_Area__c,CountryName__c,Jurisdiction__c,ShozokuArea__c,
                                 Commodity__c,
                                 MedicalBillKessaiHouhou__c,OMS_Child_Birth__c, OMS_Dental__c, OMS_Examination__c, OMS_Medical__c, OMS_Vaccination__c,
                                 MailHaishin__c, App_Registration__c
                                 FROM FamilyInfo__c  where id =:Id];
            
            if (cfr.App_Registration__c != true){
                cfr.App_Registration__c = true;
                update cfr;
            }
            
            if (cfr.MemberShimei__c == null ) {
                
                
                Info.add(new MemberInfo(cfr ));
                InsertLog(cfr.Id,cfr.MemberNo__c);
                
                return Info;
            } else 
                return GetMemberFamily(cfr.MemberShimei__c);                
            
        }
        
 
        return Info;
    }
    
    public static List<MemberInfo> GetMemberFamily( string Id ){
        
        List<MemberInfo>  Info = new List<MemberInfo>();
        
        MemberInfo__c cr= [SELECT id, Name, MemberNo__c, KinmuCompany__r.name, SeiRoma__c, 
                           MeiRoma__c , 
                           MankiDate__c, 
                           KeiyakuDate__c, KeiyakuDate_CdFmt__c, 
                           DateOfBirth__c, DateOfBirth_CdFmt__c,
                           lastmodifieddate, 
                           MemberCardKeiyakuCompanyName__c, 
                           KeiyakuCompanyName__r.Name, 
                           KeiyakuCompanyName__r.CompanyNameEng__c,
                           ServiceAreaCd__c, Email__c,
                           OtaInsuranceShiki__c, OtaInsuranceShuki__c, InsuranceKind__c, InsuranceCancelDate__c,
                           Postcd__c,Address__c,CountryCallingCodes__c,Tel__c,Mobile__c,Fax__c,
                           ContactShimei_1__c,ContactRelationship_1__c,ContactCountryCode_1__c,ContactTel_1__c,ContactMobile_1__c,ContactFax_1__c,ContactPostcd_1__c,ContactAddress_1__c,ContactEmail_1__c,
                           ContactShimei_2__c,ContactRelationship_2__c,ContactCountryCode_2__c,ContactTel_2__c,ContactMobile_2__c,ContactFax_2__c,ContactPostcd_2__c,ContactAddress_2__c,ContactEmail_2__c,
                          //  KinmuCompany__r.Region_and_Area__c, KinmuCompany__r.CountryName__c, KinmuCompany__r.Jurisdiction__c, KinmuCompany__r.ShozokuArea__c,
                           Region_and_Area__c,CountryName__c,Jurisdiction__c,ShozokuArea__c,
                           ShokenNo__c, Shonendo_Shiki__c,
                           Commodity__c,
                           MedicalBillKessaiHouhou__c, OMS_Child_Birth__c, OMS_Dental__c, OMS_Examination__c, OMS_Medical__c, OMS_Vaccination__c,
                           MailHaishin__c,
                           App_Registration__c
                           FROM MemberInfo__c
                           where id =:Id];
        
        if (cr.App_Registration__c != true){
            cr.App_Registration__c = true;
            update cr;
        }
        
        Info.add(new MemberInfo(cr ));
        
        
        for( FamilyInfo__c cfr:[SELECT id, Name, MemberNo__c,  MemberShimei__r.KinmuCompany__r.name,
                                SeiRoma__c, MeiRoma__c ,  
                                MemberShimei__r.MankiDate__c, MemberShimei__r.KeiyakuDate__c,
                                KeiyakuDate__c, KeiyakuDate_CdFmt__c, 
                                DateOfBirth__c, DateOfBirth_CdFmt__c,
                                lastmodifieddate,
                                MemberCardKeiyakuCompanyName__c, 
                                KeiyakuCompanyName__r.Name, 
                                KeiyakuCompanyName__r.CompanyNameEng__c,
                                ServiceAreaCd__c, Email__c,  MemberShimei__r.Email__c,
                                OtaInsuranceShiki__c, OtaInsuranceShuki__c, InsuranceKind__c, InsuranceCancelDate__c,
                                Mobile__c,
                               // MemberShimei__r.KinmuCompany__r.Region_and_Area__c, MemberShimei__r.KinmuCompany__r.CountryName__c, 
                              //  MemberShimei__r.KinmuCompany__r.Jurisdiction__c, MemberShimei__r.KinmuCompany__r.ShozokuArea__c,
                                Region_and_Area__c, CountryName__c, Jurisdiction__c, ShozokuArea__c,
                                ShokenNo__c,Shonendo_Shiki__c,
                                Commodity__c,
                                MedicalBillKessaiHouhou__c,OMS_Child_Birth__c, OMS_Dental__c, OMS_Examination__c, OMS_Medical__c, OMS_Vaccination__c,
                                MailHaishin__c
                                FROM FamilyInfo__c  
                                where MemberShimei__c =:cr.Id]) 
        {
            Info.add(new MemberInfo(cfr ));                          
        }
        
        InsertLog(cr.Id,cr.MemberNo__c);
        
        return Info;
        
    }
    
    global class Result{
        global boolean IsSucceeded;
        global string Reason;
        public Result(boolean a, string r){
            IsSucceeded = a;
            Reason = r;
        }
    }
    
    @HttpPatch
    // global static String updateContacts(string Id, MyInfo MyInfo, Contact Contacts) {
    global static Result updateContacts(string Id, MyInfo MyInfo, Contact Contacts) {
      //  system.debug(Contacts);
        
        InsertPatchLog(Id, MyInfo, Contacts);
        if ([select id from MemberInfo__c where id =:Id ].size() > 0) {
            
            MemberInfo__c m = [SELECT Id,  
                               Email__c,
                               Postcd__c,Address__c,CountryCallingCodes__c,Tel__c,Mobile__c,Fax__c,
                               ContactShimei_1__c,ContactRelationship_1__c,ContactCountryCode_1__c,ContactTel_1__c,ContactMobile_1__c,ContactFax_1__c,ContactPostcd_1__c,ContactAddress_1__c,ContactEmail_1__c,
                               ContactShimei_2__c,ContactRelationship_2__c,ContactCountryCode_2__c,ContactTel_2__c,ContactMobile_2__c,ContactFax_2__c,ContactPostcd_2__c,ContactAddress_2__c,ContactEmail_2__c,
                               MailHaishin__c, MemberKubunB__c
                               FROM MemberInfo__c where Id =: Id];
            
            if (m.MemberKubunB__c == '会員') {
                if(MyInfo!=null){
                    m.Email__c = MyInfo.EmailAddress;
                    m.Postcd__c = MyInfo.PostalCode;
                    m.Address__c = MyInfo.Address;
                    m.CountryCallingCodes__c = MyInfo.CountryCallingCode;
                    m.Tel__c = MyInfo.Telephone;
                    m.Mobile__c = MyInfo.Mobile;
                    m.Fax__c = MyInfo.Fax;
                    m.MailHaishin__c =  MyInfo.MailDelivery;
                }
                if (Contacts != null ) {
                    m.ContactShimei_1__c= Contacts.ContactName_1 ;
                    m.ContactRelationship_1__c= Contacts.ContactRelationship_1 ;
                    m.ContactCountryCode_1__c = Contacts.ContactCountryCode_1  ;
                    m.ContactTel_1__c =  Contacts.ContactTelephone_1 ;
                    m.ContactMobile_1__c = Contacts.ContactMobile_1 ;
                    m.ContactFax_1__c =  Contacts.ContactFax_1 ;
                    m.ContactPostcd_1__c =  Contacts.ContactPostalCode_1;
                    m.ContactAddress_1__c = Contacts.ContactAddress_1 ;
                    m.ContactEmail_1__c = Contacts.ContactEmail_1;
                    m.ContactShimei_2__c = Contacts.ContactName_2 ;
                    m.ContactRelationship_2__c =  Contacts.ContactRelationship_2 ;
                    m.ContactCountryCode_2__c = Contacts.ContactCountryCode_2  ;
                    m.ContactTel_2__c= Contacts.ContactTelephone_2 ;
                    m.ContactMobile_2__c=Contacts.ContactMobile_2 ;
                    m.ContactFax_2__c=Contacts.ContactFax_2 ;
                    m.ContactPostcd_2__c=Contacts.ContactPostalCode_2;
                    m.ContactAddress_2__c= Contacts.ContactAddress_2 ;
                    m.ContactEmail_2__c=Contacts.ContactEmail_2;
                }
                update m;
                // return 'Update Succeeded';
                return new Result(true, null);
            } else {
                return new Result(false, '退会');
            }
            
        }  else if ( [select id from FamilyInfo__c where id =:Id].size() > 0 ){
            
            FamilyInfo__c Fr = [SELECT id, Email__c, 
                                Mobile__c,
                                MailHaishin__c, MemberKubunB__c
                                FROM FamilyInfo__c  where id =:Id];
            
            if (Fr.MemberKubunB__c == '会員') {
                if(MyInfo!=null){
                    Fr.Email__c = MyInfo.EmailAddress;
                    Fr.Mobile__c = MyInfo.Mobile;
                    Fr.MailHaishin__c =  MyInfo.MailDelivery;
                }
                
                update Fr;
                //return 'Update Succeeded';
                return new Result(true, null);
            } else {
    			return new Result(false, '退会');            
	       }
            
        }
             
       // return 'Update Failed';
       return new Result(false, 'Not Exist');
    } 
    
    
    public static void InsertLog(Id Id, string MemberNo ){
        
        if ( [select Id from wb_soap_log__c 
              where Type__c ='2ND' and MemberNo__c=:MemberNo].size() == 0 ){
                  insert new wb_soap_log__c(LastAcessDate__c= System.today(),MemberID__c = Id,
                                            MemberNo__c=MemberNo,
                                            MemberInfo__c=1, Type__c ='2ND');
              } else {
                  wb_soap_log__c log = [select Id, MemberInfo__c, MemberID__c, LastAcessDate__c from wb_soap_log__c 
                                        where  Type__c ='2ND' and MemberNo__c=:MemberNo ];
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
    
    public static void InsertPatchLog(Id Id,  MyInfo MyInfo, Contact Contacts ){
        if (MyInfo != null)
        	insert new wb_soap_log__c(MemberID__c =Id, LastAcessDate__c= System.today(),JStr__c=JSON.serialize(MyInfo) ,Type__c ='2ND');
        if (Contacts != null)
            insert new wb_soap_log__c(MemberID__c =Id, LastAcessDate__c= System.today(),JStr__c=JSON.serialize(Contacts) ,Type__c ='2ND');
    }
    
}