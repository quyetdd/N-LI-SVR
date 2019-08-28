@RestResource(urlMapping='/Member/*')
global with sharing class  wb_soap_Member {
    
    global class LocalMedical{
        global string InsurancePlan;
        global string Nationality;
        global string OutpatientWaitingPeriod;
        global string HospitalizationWaitingPeriod;
        global boolean VietnamDentalTherapy;
        global string InsuranceAge;
        global string IndoneiaAttribute;
        global string IndoneiaTemporaryResidence;
        
        public LocalMedical(string vInsurancePlan, string vNationality, string vOutpatientWaitingPeriod,
                            string vHospitalizationWaitingPeriod, boolean vVietnamDentalTherapy,
                            string vInsuranceAge, string vIndoneiaAttribute, string vIndoneiaTemporaryResidence ){
                                InsurancePlan = vInsurancePlan;
                                Nationality = vNationality;
                                OutpatientWaitingPeriod = vOutpatientWaitingPeriod;
                                HospitalizationWaitingPeriod = vHospitalizationWaitingPeriod;
                                VietnamDentalTherapy = vVietnamDentalTherapy;
                                InsuranceAge = vInsuranceAge;
                                IndoneiaAttribute = vIndoneiaAttribute;
                                IndoneiaTemporaryResidence = vIndoneiaTemporaryResidence;
                            }
        
        
    }
    
    global class Insurance{
        global string InsuranceCompany;
        global string InsuranceName;
        
        global string HandlingBy;
        global string HandlingNotice;
        global string PolicyNumber;
        global string PolicyAvailability;
        global string StorageLocation;
        global string InsuranceStartDate;
        global string InsuranceEndDate;
        global string InsuranceCancelDate;
        global string InsuranceCancellationNotice;
        global string MedicalSettlement;
        global string InsuranceCurrency;
        global string InjuryDeathCost;
        global string TreatmentCost;
        global string TreatmentRescueCost;
        global string InjuryCost;
        global string DiseaseCost;
        global string DiseaseDeathCost;
        global string RescueCost;
        global string DamagesCost;
        global string BaggageCost;
        global boolean HomeCountryCoverage;
        
        global string Note;
        
        public string date2string( date d){
            if (d != null)
                return   DateTime.newInstance(
                    d.year(), d.month(), d.day()
                ).format('yyyy/MM/dd');
            else
                return null;
        }
        
        public Insurance(string vInsuranceCompany, string vInsuranceName, string vHandlingBy,
                         string vHandlingNotice, string  vPolicyNumber, string vPolicyAvailability,
                         string vStorageLocation, date vInsuranceStartDate, date vInsuranceEndDate,
                         date vInsuranceCancelDate, string vInsuranceCancellationNotice, string vMedicalSettlement,
                         string vInsuranceCurrency, string vInjuryDeathCost, string vTreatmentCost,
                         string vTreatmentRescueCost, string vInjuryCost, string vDiseaseCost,
                         string vDiseaseDeathCost, string vRescueCost, string vDamagesCost,
                         string vBaggageCost, boolean vHomeCountryCoverage, string  vNote
                        )
        {
            InsuranceCompany = vInsuranceCompany ;
            InsuranceName = vInsuranceName ;
            HandlingBy = vHandlingBy;
            HandlingNotice = vHandlingNotice;
            PolicyNumber = vPolicyNumber;
            PolicyAvailability = vPolicyAvailability;
            StorageLocation = vStorageLocation;
            InsuranceStartDate = date2string(vInsuranceStartDate);
            InsuranceEndDate = date2string(vInsuranceEndDate);
            InsuranceCancelDate = date2string(vInsuranceCancelDate);
            InsuranceCancellationNotice = vInsuranceCancellationNotice;
            MedicalSettlement = vMedicalSettlement;
            InsuranceCurrency  = vInsuranceCurrency;
            InjuryDeathCost= vInjuryDeathCost;
            TreatmentCost= vTreatmentCost;
            TreatmentRescueCost = vTreatmentRescueCost;
            InjuryCost = vInjuryCost;
            DiseaseCost = vDiseaseCost;
            DiseaseDeathCost =vDiseaseDeathCost;
            RescueCost = vRescueCost;
            DamagesCost = vDamagesCost;
            BaggageCost  = vBaggageCost;
            HomeCountryCoverage = vHomeCountryCoverage;
            Note = vNote;
            
        }
        
    }
    
    global class Member{
        
        global string Id;
        global string ContractNo;
        global string MemberNo;
        global string ContractDate;
        global string ExpiryDate;
        global string Commodity;
        global string ContractStatus;
        

        
        global string WorkingCompany;
        global string Name;
        global string FirstName;   
        global string LastName;   
        global string FirstNameKana;   
        global string LastNameKana;   
        global string Position;
        global string Relationship;  
        global string Sex;
        global string DateOfBirth;
        global string Age;
        global string PassportNo;
        global string Nationality;
        global string PostalCode;
        global string Address;
        global string CountryCallingCode;
        global string Mobile;
        global string Fax;    
        global string Tel;
        global string lastmodifieddate; 
        global string EmailAddress;
        global string ContractCompany;  
        global string MemberClassification;  
        global string CancellationDate;
        global string Area;
        global string Country;
        global string Jurisdiction;
        global string Affiliation;
        global boolean MailDelivery;
        
        global List<Insurance> Insurance;     
        global LocalMedical LocalMedical;
        
        global string SecurityPIC;
        global string SecurityPICEmail;
        global string SecurityPICMobile;
        global string SecurityDept;
        global string SecurityDeptPhone;
        
        global string ContactName_1;
        global string ContactCompanyName_1;
        global string ContactRelationship_1;
        global string ContactCountryCode_1;
        global string ContactTelephone_1;
        global string ContactMobile_1;
        global string ContactFax_1;
        global string ContactPostalCode_1;
        global string ContactAddress_1;
        global string ContactEmail_1;
        global string ContactName_2;
        global string ContactCompanyName_2;
        global string ContactRelationship_2;
        global string ContactCountryCode_2;
        global string ContactTelephone_2;
        global string ContactMobile_2;
        global string ContactFax_2;
        global string ContactPostalCode_2;
        global string ContactAddress_2;
        global string ContactEmail_2;
        global string ContactName_3;
        global string ContactCompanyName_3;
        global string ContactRelationship_3;
        global string ContactCountryCode_3;
        global string ContactTelephone_3;
        global string ContactMobile_3;
        global string ContactFax_3;
        global string ContactPostalCode_3;
        global string ContactAddress_3;
        global string ContactEmail_3;
        
        global string ContactExtNo_1;
        global string ContactExtNo_2;
        global string ContactExtNo_3;
        global string ContactDept_1;
        global string ContactDept_2;
        global string ContactDept_3;
        global string ContactHolidayTel_1;
        global string ContactHolidayTel_2;
        global string ContactHolidayTel_3;
        
		global string Healthcheck_NOT_WB;
        
        public string date2string( date d){
            if (d != null)
                return   DateTime.newInstance(
                    d.year(), d.month(), d.day()
                ).format('yyyy/MM/dd');
            else
                return null;
        }
        
        //  global string lastmodifieddate; 
        public Member(MemberInfo__c m){
            
            Id = m.id;
            Name = m.Name;
            MemberNo= m.MemberNo__c;
            FirstName = m.MeiRoma__c;
            LastName = m.SeiRoma__c;
            datetime lmd = m.lastmodifieddate;
            String formatedDt = lmd.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
            lastmodifieddate = formatedDt;
            
            
            DateOfBirth = date2string(m.DateOfBirth__c);
            
            EmailAddress = m.Email__c;
            PostalCode = m.Postcd__c;
            Address = m.Address__c;
            CountryCallingCode = m.CountryCallingCodes__c;
            
            Mobile = m.Mobile__c;
            Fax = m.Fax__c;
            
            ContractNo = m.CompanyKeiyakuNo__r.name;
            ContractDate = date2string(m.KeiyakuDate__c);
            ExpiryDate = date2string(m.MankiDate__c);
            Commodity = m.Commodity__c;
            ContractStatus = m.KeiyakuKeitai__c ;   
            
            ContractCompany =  m.CompanyKeiyakuNo__r.KeiyakuCompanyName__r.name;
            MemberClassification = m.MemberKubunB__c;
            CancellationDate = date2string(m.TaikaiDate__c);
            
            Area = m.KinmuCompany__r.Region_and_Area__c;
            Country = m.KinmuCompany__r.CountryName__c;
            Jurisdiction = m.KinmuCompany__r.Jurisdiction__c ;
            Affiliation = m.KinmuCompany__r.ShozokuArea__c;
            
            MailDelivery = m.MailHaishin__c;
            Healthcheck_NOT_WB =m.Healthcheck_NOT_WB__c;
            /*   
Insurance = new List<Insurance>();

Insurance.add( new Insurance(m));
*/ 
            SecurityPIC = m.Security_PIC__c;
            SecurityPICEmail= m.Security_PIC_Email__c;
            SecurityPICMobile= m.Security_PIC_Mobile__c;
            SecurityDept= m.Security_Dept__c;
            SecurityDeptPhone= m.Security_Dept_Phone__c;
            
            ContactName_1 = m.ContactShimei_1__c;
            ContactRelationship_1 = m.ContactRelationship_1__c;
            ContactCountryCode_1 = m.ContactCountryCode_1__c ;
            ContactTelephone_1 = m.ContactTel_1__c;
            ContactMobile_1 = m.ContactMobile_1__c;
            ContactFax_1 = m.ContactFax_1__c;
            ContactPostalCode_1=m.ContactPostcd_1__c;
            ContactAddress_1 =m.ContactAddress_1__c;
            ContactEmail_1=m.ContactEmail_1__c;
            ContactName_2 = m.ContactShimei_2__c;
            ContactRelationship_2 = m.ContactRelationship_2__c;
            ContactCountryCode_2 = m.ContactCountryCode_2__c ;
            ContactTelephone_2 = m.ContactTel_2__c;
            ContactMobile_2 = m.ContactMobile_2__c;
            ContactFax_2 = m.ContactFax_2__c;
            ContactPostalCode_2=m.ContactPostcd_2__c;
            ContactAddress_2 =m.ContactAddress_2__c;
            ContactEmail_2=m.ContactEmail_2__c;
            ContactName_3 = m.ContactShimei_3__c;
            ContactRelationship_3 = m.ContactRelationship_3__c;
            ContactCountryCode_3 = m.ContactCountryCode_3__c ;
            ContactTelephone_3 = m.ContactTel_3__c;
            ContactMobile_3 = m.ContactMobile_3__c;
            ContactFax_3 = m.ContactFax_3__c;
            ContactPostalCode_3=m.ContactPostcd_3__c;
            ContactAddress_3 =m.ContactAddress_3__c;
            ContactEmail_3=m.ContactEmail_3__c;           
            
            ContactCompanyName_1 = m.ContactCompanyName_1__c;
            ContactCompanyName_2 = m.ContactCompanyName_2__c;
            ContactCompanyName_3 = m.ContactCompanyName_3__c;
            
            ContactExtNo_1= m.ContactExtNo_1__c;
            ContactExtNo_2=m.ContactExtNo_2__c;
            ContactExtNo_3=m.ContactExtNo_3__c;
            ContactDept_1 = m.ContactBusho_1__c; 
            ContactDept_2 = m.ContactBusho_2__c; 
            ContactDept_3 = m.ContactBusho_3__c;
            ContactHolidayTel_1=m.ContactHolidayTel_1__c;
            ContactHolidayTel_2=m.ContactHolidayTel_2__c;
            ContactHolidayTel_3=m.ContactHolidayTel_3__c;
            
        }
        
        public Member(FamilyInfo__c f){
            Id = f.id; 
            Name = f.Name; 
            MemberNo= f.MemberNo__c;
            FirstName = f.MeiRoma__c;
            LastName = f.SeiRoma__c;
            datetime lmd = f.lastmodifieddate;
            String formatedDt = lmd.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
            lastmodifieddate = formatedDt;
            
            DateOfBirth = date2string(f.DateOfBirth__c);
            
            EmailAddress = f.Email__c;
            Mobile = f.Mobile__c;
            
            ContractNo = f.MemberShimei__r.CompanyKeiyakuNo__r.name;
            ContractDate = date2string(f.MemberShimei__r.KeiyakuDate__c);
            ExpiryDate = date2string(f.MemberShimei__r.MankiDate__c);
            Commodity = f.MemberShimei__r.Commodity__c;
            ContractStatus = f.MemberShimei__r.KeiyakuKeitai__c ; 
            
            ContractCompany =  f.MemberShimei__r.CompanyKeiyakuNo__r.KeiyakuCompanyName__r.name;
            MemberClassification = f.MemberShimei__r.MemberKubunB__c;
            CancellationDate = date2string(f.MemberShimei__r.TaikaiDate__c);
            
            Area = f.MemberShimei__r.KinmuCompany__r.Region_and_Area__c;
            Country = f.MemberShimei__r.KinmuCompany__r.CountryName__c;
            Jurisdiction = f.MemberShimei__r.KinmuCompany__r.Jurisdiction__c ;
            Affiliation = f.MemberShimei__r.KinmuCompany__r.ShozokuArea__c;
            
            MailDelivery = f.MailHaishin__c;
            Healthcheck_NOT_WB = f.Healthcheck_NOT_WB__c;
            

            
        }
        /*
        public Member(wb_Member__c m){
            
            Id = m.id;
            Name = m.Individual__r.Name;
            MemberNo= m.f_MemberNo__c;
            FirstName = m.Individual__r.FirstNameRoma__c;
            LastName = m.Individual__r.LastNameRoma__c;
            datetime lmd = m.lastmodifieddate;
            String formatedDt = lmd.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
            lastmodifieddate = formatedDt;
            
            DateOfBirth = Date2String(m.Individual__r.DateOfBirth__c);
            
            EmailAddress = m.Individual__r.EmailAddress__c;
            
            PostalCode = m.Individual__r.PostalCode__c;
            Address = m.Individual__r.Address__c;
            CountryCallingCode = m.Individual__r.CountryCallingCodes__c;
            
            Mobile = m.Individual__r.Mobile__c;
            
            
            
            ContractNo = m.MembershipDetail__r.Membership__r.name;
            ContractDate = date2string(m.MembershipDetail__r.Membership__r.ContractDate__c);
            ExpiryDate = date2string(m.MembershipDetail__r.Membership__r.ContractExpiryDate__c);
            Commodity = null;
            ContractStatus = m.MembershipDetail__r.f_ContractStatus__c ;     
            
            
            ContractCompany =  m.MembershipDetail__r.Membership__r.ContractCompany__r.name;
            MemberClassification = m.f_Classification__c;
            CancellationDate = date2string(m.MembershipDetail__r.MembershipStopDate__c);
            
            Area = m.WorkingCompany__r.Region_and_Area__c;
            Country = m.WorkingCompany__r.CountryName__c;
            Jurisdiction = m.WorkingCompany__r.Jurisdiction__c ;
            Affiliation = m.WorkingCompany__r.ShozokuArea__c;
            
            MailDelivery = m.Individual__r.MailDelivery__c; */
            /*
Insurance = new List<Insurance>();
if ( MemberInsurance != null) {
for ( wb_MedicalInsuranceDetail__c i:MemberInsurance)
Insurance.add( new Insurance(i));
}
*/
        /*
            SecurityPIC = m.WorkingCompany__r.Security_PIC__c;
            SecurityPICEmail= m.WorkingCompany__r.Security_PIC_Email__c;
            SecurityPICMobile= m.WorkingCompany__r.Security_PIC_Mobile__c;
            SecurityDept= m.WorkingCompany__r.Security_Dept__c;
            SecurityDeptPhone= m.WorkingCompany__r.Security_Dept_Phone__c;
            
            */
            /*
ContactName_1 = m.ContactShimei_1__c;
ContactRelationship_1 = m.ContactRelationship_1__c;
ContactCountryCode_1 = m.ContactCountryCode_1__c ;
ContactTelephone_1 = m.ContactTel_1__c;
ContactMobile_1 = m.ContactMobile_1__c;
ContactFax_1 = m.ContactFax_1__c;
ContactPostalCode_1=m.ContactPostcd_1__c;
ContactAddress_1 =m.ContactAddress_1__c;
ContactEmail_1=m.ContactEmail_1__c;
ContactName_2 = m.ContactShimei_2__c;
ContactRelationship_2 = m.ContactRelationship_2__c;
ContactCountryCode_2 = m.ContactCountryCode_2__c ;
ContactTelephone_2 = m.ContactTel_2__c;
ContactMobile_2 = m.ContactMobile_2__c;
ContactFax_2 = m.ContactFax_2__c;
ContactPostalCode_2=m.ContactPostcd_2__c;
ContactAddress_2 =m.ContactAddress_2__c;
ContactEmail_2=m.ContactEmail_2__c;
ContactName_3 = m.ContactShimei_3__c;
ContactRelationship_3 = m.ContactRelationship_3__c;
ContactCountryCode_3 = m.ContactCountryCode_3__c ;
ContactTelephone_3 = m.ContactTel_3__c;
ContactMobile_3 = m.ContactMobile_3__c;
ContactFax_3 = m.ContactFax_3__c;
ContactPostalCode_3=m.ContactPostcd_3__c;
ContactAddress_3 =m.ContactAddress_3__c;
ContactEmail_3=m.ContactEmail_3__c;    */        
           /* 
        }
        
        */
    }
    
    @HttpGet
    global static List<Member> getMemberInfo() {
        
        RestRequest req = RestContext.request;
        
        system.debug(req);
        
        string Name;
        if ( req.params.get('Name') != null)
            Name= req.params.get('Name');
        
        string WorkingCompany;
        if (  req.params.get('WorkingCompany') != null)
            WorkingCompany = req.params.get('WorkingCompany');
        
        string ContractCompany;
        if (  req.params.get('ContractCompany') != null)
            ContractCompany = req.params.get('ContractCompany');

        
        string MemberNo;
        if (  req.params.get('MemberNo') != null)
            MemberNo = req.params.get('MemberNo');
        
        system.debug(req.params.get('MemberNo'));
        system.debug(MemberNo);
        
        string wheresql;
        string soql;
        
        if (Name != null) {
            wheresql = '  Name like \'%' + Name + '%\'  ' ; 
        }
        
        if (WorkingCompany != null){
            if ( wheresql == null )
                wheresql = ' KinmuCompany__r.name like \'%' + WorkingCompany + '%\'  ';
            else
                wheresql += ' and  KinmuCompany__r.name like \'%' + WorkingCompany + '%\'  ';                
        }
        
        if (MemberNo != null){
            if ( wheresql == null )
                wheresql = '  MemberNo__c = \'' + MemberNo + '\'  ';
            else
                wheresql += ' and  MemberNo__c = \'' + MemberNo + '\'  ';                
        }
        
        if (ContractCompany != null){
            if ( wheresql == null )
                wheresql = ' CompanyKeiyakuNo__r.KeiyakuCompanyName__r.name like \'%' + ContractCompany + '%\'  ';
            else
                wheresql += ' and  CompanyKeiyakuNo__r.KeiyakuCompanyName__r.name like \'%' + ContractCompany + '%\'  ';                
        }
        
        soql = ' select id from MemberInfo__c where ' + wheresql;      
        
        system.debug( soql);
        
        List<Member> Rst = new  List<Member>();
        
        if(  Database.query(soql).size() > 0 ) {
            
            soql = ' SELECT id, name, MemberNo__c, KinmuCompany__r.name, SeiRoma__c, ';
            soql += ' MeiRoma__c, KeiyakuDate_CdFmt__c, ';
            soql += ' DateOfBirth__c, DateOfBirth_CdFmt__c, lastmodifieddate, ';
            soql += ' MemberCardKeiyakuCompanyName__c, ServiceAreaCd__c, Email__c,'; 
            soql += ' OtaName__c, InsuranceKind__c,Field5__c,Shonendo_Shiki__c,InsuranceCancelDate__c,InsuranceCancelContact__c,AnshinOutpatientWaitingPeriod__c,AnshinHospitalizationWaitingPeriod__c,OtaNote__c,';
            soql += ' Postcd__c,Address__c,CountryCallingCodes__c,Tel__c,Mobile__c,Fax__c, ';
            soql += ' CompanyKeiyakuNo__r.name,KeiyakuDate__c,MankiDate__c,Commodity__c,KeiyakuKeitai__c, ';
            soql += ' CompanyKeiyakuNo__r.KeiyakuCompanyName__r.name, MemberKubunB__c, TaikaiDate__c, MailHaishin__c,';
            soql += ' KinmuCompany__r.Region_and_Area__c, KinmuCompany__r.CountryName__c, KinmuCompany__r.Jurisdiction__c, KinmuCompany__r.ShozokuArea__c, ';
            soql += ' InsurancePlan__c,OtaAgency__c,ShokenNo__c,ShokenGetSituation__c,OtaKeepPlace__c,OtaInsuranceShiki__c,OtaInsuranceShuki__c,';
            soql += ' MedicalBillKessaiHouhou__c,InsuranceCurrency__c,InjuryDeathCost__c,TreatmentCost__c,TreatmentRescueCost__c,InjuryCost__c,';
            soql += ' DiseaseCost__c,DiseaseDeathCost__c,RescueCost__c,DamagesCost__c,CarryCost__c,HomeCountryCoverage__c,';
            soql += ' Nationality__c, DentalTherapy__c,InsuranceShikiAge__c,IDN_Attibute__c,IDN_KITAS_NO__c, ';
            soql += ' Security_PIC_Email__c, Security_PIC_Mobile__c, Security_PIC__c, Security_Dept__c, Security_Dept_Phone__c,';
            soql += ' Healthcheck_NOT_WB__c, ';
            soql += ' ContactShimei_1__c,ContactRelationship_1__c,ContactCountryCode_1__c,ContactTel_1__c,ContactMobile_1__c,ContactFax_1__c,ContactPostcd_1__c,ContactAddress_1__c,ContactEmail_1__c, ';
            soql += ' ContactShimei_2__c,ContactRelationship_2__c,ContactCountryCode_2__c,ContactTel_2__c,ContactMobile_2__c,ContactFax_2__c,ContactPostcd_2__c,ContactAddress_2__c,ContactEmail_2__c, ';
            soql += ' ContactShimei_3__c,ContactRelationship_3__c,ContactCountryCode_3__c,ContactTel_3__c,ContactMobile_3__c,ContactFax_3__c,ContactPostcd_3__c,ContactAddress_3__c,ContactEmail_3__c, ';
            soql += ' ContactCompanyName_1__c, ContactCompanyName_2__c, ContactCompanyName_3__c, ';
            soql += ' ContactExtNo_1__c, ContactExtNo_2__c, ContactExtNo_3__c, ContactBusho_1__c,ContactBusho_2__c,ContactBusho_3__c, ';
            soql += ' ContactHolidayTel_1__c,ContactHolidayTel_2__c, ContactHolidayTel_3__c ';
            soql += ' FROM MemberInfo__c where ' + wheresql; 
            
            List<MemberInfo__c> MemberInfo = Database.query(soql);
            
            for (MemberInfo__c m:MemberInfo ) {
                Member mRow = new Member( m);
                mRow.Insurance = new List<Insurance>();
                mRow.Insurance.add( new Insurance(m.OtaName__c,
                                                  m.InsuranceKind__c,m.OtaAgency__c,m.Field5__c,m.ShokenNo__c,
                                                  m.ShokenGetSituation__c,m.OtaKeepPlace__c, m.OtaInsuranceShiki__c,
                                                  m.OtaInsuranceShuki__c ,m.InsuranceCancelDate__c,
                                                  m.InsuranceCancelContact__c, m.MedicalBillKessaiHouhou__c, m.InsuranceCurrency__c,
                                                  String.Valueof(m.InjuryDeathCost__c),String.valueof(m.TreatmentCost__c),
                                                  String.Valueof(m.TreatmentRescueCost__c),String.Valueof(m.InjuryCost__c),
                                                  String.Valueof(m.DiseaseCost__c),String.Valueof(m.DiseaseDeathCost__c),
                                                  String.Valueof(m.RescueCost__c),String.Valueof(m.DamagesCost__c),
                                                  String.Valueof(m.CarryCost__c), m.HomeCountryCoverage__c,m.OtaNote__c
                                                 ));
                mRow.LocalMedical = new  LocalMedical(m.InsurancePlan__c,m.Nationality__c,m.AnshinOutpatientWaitingPeriod__c,
                                                      m.AnshinHospitalizationWaitingPeriod__c,m.DentalTherapy__c,
                                                      string.valueof(m.InsuranceShikiAge__c), m.IDN_Attibute__c, m.IDN_KITAS_NO__c);
                Rst.add(mRow);
            }
            
        } 
        
        if (Name != null) {
            wheresql = '  Name like \'%' + Name + '%\'  ' ; 
        } else
            wheresql = null;
        
        if (WorkingCompany != null){
            if ( wheresql == null )
                wheresql = ' MemberShimei__r.KinmuCompany__r.name like \'%' + WorkingCompany + '%\'  ';
            else
                wheresql += ' and  MemberShimei__r.KinmuCompany__r.name like \'%' + WorkingCompany + '%\'  ';                
        }
        
        if (MemberNo != null){
            if ( wheresql == null )
                wheresql = '  MemberNo__c = \'' + MemberNo + '\'  ';
            else
                wheresql += ' and  MemberNo__c = \'' + MemberNo + '\'  ';                
        }
        
        if (ContractCompany != null){
            if ( wheresql == null )
                wheresql = ' MemberShimei__r.CompanyKeiyakuNo__r.KeiyakuCompanyName__r.name like \'%' + ContractCompany + '%\'  ';
            else
                wheresql += ' and  MemberShimei__r.CompanyKeiyakuNo__r.KeiyakuCompanyName__r.name like \'%' + ContractCompany + '%\'  ';                
        }
        
        soql = ' select id from FamilyInfo__c where ' + wheresql;     
        
        if(  Database.query(soql).size() > 0 ) {
            
            soql = ' SELECT id, Name, MemberNo__c,  MemberShimei__r.KinmuCompany__r.name,';
            soql += ' SeiRoma__c, MeiRoma__c , ';
            soql += ' KeiyakuDate__c, KeiyakuDate_CdFmt__c,  DateOfBirth__c, DateOfBirth_CdFmt__c,';
            soql += ' lastmodifieddate,  MemberCardKeiyakuCompanyName__c, ServiceAreaCd__c, Email__c,  MemberShimei__r.Email__c,';
            soql += ' OtaName__c, InsuranceKind__c,Field1__c, Mobile__c, Shonendo_Shiki__c,InsuranceCancelDate__c,InsuranceCancelContact__c,AnshinOutpatientWaitingPeriod__c,AnshinHospitalizationWaitingPeriod__c,OtaNote__c,';
            soql += ' MemberShimei__r.CompanyKeiyakuNo__r.name,MemberShimei__r.KeiyakuDate__c,MemberShimei__r.MankiDate__c,MemberShimei__r.Commodity__c,MemberShimei__r.KeiyakuKeitai__c, ';
            soql += ' MemberShimei__r.CompanyKeiyakuNo__r.KeiyakuCompanyName__r.name, MemberShimei__r.MemberKubunB__c, MemberShimei__r.TaikaiDate__c, MailHaishin__c,';
            soql += ' MemberShimei__r.KinmuCompany__r.Region_and_Area__c, MemberShimei__r.KinmuCompany__r.CountryName__c, MemberShimei__r.KinmuCompany__r.Jurisdiction__c, MemberShimei__r.KinmuCompany__r.ShozokuArea__c, ';
            soql += ' Nationality__c, InsurancePlan__c,OtaAgency__c,ShokenNo__c,ShokenGetSituation__c,OtaKeepPlace__c,OtaInsuranceShiki__c,OtaInsuranceShuki__c,';
            soql += ' MedicalBillKessaiHouhou__c,InsuranceCurrency__c,InjuryDeathCost__c,TreatmentCost__c,TreatmentRescueCost__c,InjuryCost__c,';
            soql += 'DiseaseCost__c,DiseaseDeathCost__c,RescueCost__c,DamagesCost__c,CarryCost__c,HomeCountryCoverage__c,';
            soql += ' DentalTherapy__c,InsuranceShikiAge__c, Healthcheck_NOT_WB__c '; //,IDN_Attibute__c,IDN_KITAS_NO__c ';
            soql += ' FROM FamilyInfo__c  where ' + wheresql; 
            
            List<FamilyInfo__c> FamilyInfo = Database.query(soql);
            
            
            
            for (FamilyInfo__c f:FamilyInfo ) {
                Member mRow = new Member(f);
                
                mRow.Insurance = new List<Insurance>();
                mRow.Insurance.add( new Insurance(f.OtaName__c,
                                                  f.InsuranceKind__c,f.OtaAgency__c,f.Field1__c,f.ShokenNo__c,
                                                  f.ShokenGetSituation__c,f.OtaKeepPlace__c, f.OtaInsuranceShiki__c,
                                                  f.OtaInsuranceShuki__c ,f.InsuranceCancelDate__c,
                                                  f.InsuranceCancelContact__c, f.MedicalBillKessaiHouhou__c, f.InsuranceCurrency__c,
                                                  String.Valueof(f.InjuryDeathCost__c),String.valueof(f.TreatmentCost__c),
                                                  String.Valueof(f.TreatmentRescueCost__c),String.Valueof(f.InjuryCost__c),
                                                  String.Valueof(f.DiseaseCost__c),String.Valueof(f.DiseaseDeathCost__c),
                                                  String.Valueof(f.RescueCost__c),String.Valueof(f.DamagesCost__c),
                                                  String.Valueof(f.CarryCost__c), f.HomeCountryCoverage__c,f.OtaNote__c
                                                 ));
                
                mRow.LocalMedical = new  LocalMedical(f.InsurancePlan__c,f.Nationality__c,f.AnshinOutpatientWaitingPeriod__c,
                                                      f.AnshinHospitalizationWaitingPeriod__c,f.DentalTherapy__c,
                                                      string.valueof(f.InsuranceShikiAge__c), null, null);
                
                Rst.add(mRow);
            }
            
            
        }
        
        if (Name != null) {
            wheresql = '  Individual__r.Name like \'%' + Name + '%\'  ' ; 
        } else
            wheresql = null;
        
        if (WorkingCompany != null){
            if ( wheresql == null )
                wheresql = ' WorkingCompany__r.name like \'%' + WorkingCompany + '%\'  ';
            else
                wheresql += ' and  WorkingCompany__r.name like \'%' + WorkingCompany + '%\'  ';                
        }
        
        if (MemberNo != null){
            if ( wheresql == null )
                wheresql = ' f_MemberNo__c = \'' + MemberNo + '\'  ';
            else
                wheresql += ' and  f_MemberNo__c = \'' + MemberNo + '\'  ';                
        }
        
        if (ContractCompany != null){
            if ( wheresql == null )
                wheresql = ' MembershipDetail__r.Membership__r.ContractCompany__r.name like \'%' + ContractCompany + '%\'  ';
            else
                wheresql += ' and  MembershipDetail__r.Membership__r.ContractCompany__r.name like \'%' + ContractCompany + '%\'  ';                
        }
        
        
        soql = ' select id from wb_Member__c  where  f_Classification__c =\'会員\' and ' + wheresql;
        
        if(  Database.query(soql).size() > 0 ) {
            soql = ' select Id, f_MemberNo__c, WorkingCompany__r.name, Individual__r.FirstNameRoma__c, Individual__r.LastNameRoma__c,';
            soql += '  r_EffectiveUntil__c , MembershipDetail__r.Service__r.ServiceAreaCd__c, ';
            soql += ' lastmodifieddate, Individual__c, Individual__r.lastmodifieddate, Individual__r.DateOfBirth__c,' ;
            soql += ' Individual__r.Name, Individual__r.EmailAddress__c, Individual__r.Parent__r.EmailAddress__c,Individual__r.MailDelivery__c,';
            soql += ' Individual__r.PostalCode__c,Individual__r.Address__c,Individual__r.Mobile__c,Individual__r.Tel__c,Individual__r.CountryCallingCodes__c,';
            soql += ' MembershipDetail__r.Membership__r.name,MembershipDetail__r.Membership__r.ContractDate__c,MembershipDetail__r.Membership__r.ContractExpiryDate__c,MembershipDetail__r.f_ContractStatus__c,';
            soql += ' MembershipDetail__r.Membership__r.ContractCompany__r.name, f_Classification__c, MembershipDetail__r.MembershipStopDate__c,';
            soql += 'WorkingCompany__r.Region_and_Area__c, WorkingCompany__r.CountryName__c, WorkingCompany__r.Jurisdiction__c, WorkingCompany__r.ShozokuArea__c,';
            soql += ' WorkingCompany__r.Security_PIC_Email__c, WorkingCompany__r.Security_PIC_Mobile__c, WorkingCompany__r.Security_PIC__c, WorkingCompany__r.Security_Dept__c, WorkingCompany__r.Security_Dept_Phone__c';
            soql += ' from wb_Member__c  where  f_Classification__c =\'会員\' and ' + wheresql;
            soql += ' order by Individual__c ';
            List<wb_Member__c> members = Database.query(soql);
            
            List<Id> MemberIndIDs = new  List<Id>();
            for (wb_Member__c m:members)
                MemberIndIDs.add(m.Individual__c);
            
            List<wb_MedicalInsuranceDetail__c> membersinsurance = 
                [select Individual__c, InsuranceCompany__c, InsurancePlan__c,HandlingBy__c,PolicyNumber__c,PolicyAvailability__c,
                 StorageLocation__c,InsuranceStartDate__c,InsuranceEndDate__c,
                 MedicalSettlement__c,InsuranceCurrency__c,InjuryDeathCost__c,
                 TreatmentCost__c,TreatmentRescueCost__c,InjuryCost__c,
                 DiseaseCost__c,DiseaseDeathCost__c,RescueCost__c,
                 DamagesCost__c,BaggageCost__c,HomeCountryCoverage__c
                 from wb_MedicalInsuranceDetail__c
                 where Individual__c =:MemberIndIDs order by Individual__c ]; // and InsuranceEndDate__c >= today];
            
            integer i = 0;
            integer j = 0;
            
            
            /*
            for ( ; i < members.size();i++){
                List<wb_MedicalInsuranceDetail__c> mi = new List<wb_MedicalInsuranceDetail__c>();
                for (;j < membersinsurance.size() && members[i].Individual__c >= membersinsurance[j].Individual__c; j++){
                    if ( members[i].Individual__c == membersinsurance[j].Individual__c)
                        mi.add(membersinsurance[j]);
                }
                
               Member mRow = new Member(members[i]);
                
                mRow.Insurance = new List<Insurance>();
                if ( mi != null) {
                    for ( wb_MedicalInsuranceDetail__c m:mi)
                        
                        mRow.Insurance.add( new Insurance(m.InsuranceCompany__c,
                                                          null, m.HandlingBy__c,null,m.PolicyNumber__c,
                                                          m.PolicyAvailability__c,m.StorageLocation__c, m.InsuranceStartDate__c,
                                                          m.InsuranceEndDate__c , null,
                                                          null, m.MedicalSettlement__c, m.InsuranceCurrency__c,
                                                          String.Valueof(m.InjuryDeathCost__c),String.valueof(m.TreatmentCost__c),
                                                          String.Valueof(m.TreatmentRescueCost__c),String.Valueof(m.InjuryCost__c),
                                                          String.Valueof(m.DiseaseCost__c),String.Valueof(m.DiseaseDeathCost__c),
                                                          String.Valueof(m.RescueCost__c),String.Valueof(m.DamagesCost__c),
                                                          String.Valueof(m.BaggageCost__c), m.HomeCountryCoverage__c,null
                                                         ));
                }
                
                Rst.add(mRow);
                
            } */
            
        }
        
        
        return Rst;
    }
    
    
    
    
    
}