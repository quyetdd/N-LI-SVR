public class wb_MemberInfo_Edit {
    private ApexPages.StandardController standardController;
    public MemberInfo__c MemberInfo {get;set;}
    
    public wb_MemberInfo_Edit(ApexPages.StandardController stdController){
        this.standardController = stdController;
        MemberInfo = (MemberInfo__c) stdController.getRecord();
        if (MemberInfo.id != null) {
        MemberInfo = [select Id,  CompanyKeiyakuNo__c, MemberNo__c,OtherMemberNo__c,
                      Healthcheck_NOT_WB__c,KeiyakuDate__c,MankiDate__c,Commodity__c,
                      KeiyakuNo__c,TaikaiDate__c, Region_and_Area__c, KeiyakuKeitai__c,
                      CountryName__c,CountryOfDeparture_Object__c,Jurisdiction__c,
                      ShozokuArea__c,Country_or_Region__c,KeiyakuCompanyName__c,Issues_To_AC__c,                      
                      KinmuCompany__c,staff__c,Name,Yakushoku__c,SeiRoma__c,Relationship__c,
                      MeiRoma__c,Sex__c,SeiKana__c,DateOfBirth__c,MeiKana__c,
                      Postcd__c,Address__c,CountryCallingCodes__c,Email__c,
                      Tel__c,MailHaishin__c,Mobile__c,
                      Fax__c,
                      OtaName__c, InsuranceCurrency__c,InsuranceKind__c,InjuryDeathCost__c,
                      OtaAgency__c,TreatmentCost__c,ShokenNo__c,TreatmentRescueCost__c,
                      ShokenGetSituation__c,InjuryCost__c,OtaKeepPlace__c,DiseaseCost__c,
                      Shonendo_Shiki__c,DiseaseDeathCost__c,OtaInsuranceShiki__c,
                      RescueCost__c,OtaInsuranceShuki__c,DamagesCost__c,
                      MedicalBillKessaiHouhou__c,CarryCost__c,
                      HomeCountryCoverage__c,DentalTherapy__c,IDN_Attibute__c,
                      OtaNote__c,InsuranceCancelDate__c,InsuranceCancelContact__c,
                      InsurancePlan__c,PassportNo__c,Nationality__c,IDN_KITAS_NO__c,
                      Formar_Healthcheck_Date__c, Formar_Healthcheck_Facility__c, Formar_Healthcheck_Country__c,
                      Issues_from_Sales__c,Jibyo__c,Note__c,
                      ContactShimei_1__c,ContactRelationship_1__c,ContactCompanyName_1__c,ContactBusho_1__c,
                      ContactPostcd_1__c,ContactAddress_1__c,ContactCountryCode_1__c,ContactMobile_1__c,
                      ContactTel_1__c,ContactHolidayTel_1__c,ContactExtNo_1__c,ContactEmail_1__c,
                      ContactFax_1__c,
                      ContactShimei_2__c,ContactRelationship_2__c,ContactCompanyName_2__c,ContactBusho_2__c,
                      ContactPostcd_2__c,ContactAddress_2__c,ContactCountryCode_2__c,ContactMobile_2__c,
                      ContactTel_2__c,ContactHolidayTel_2__c,ContactExtNo_2__c,ContactEmail_2__c,
                      ContactFax_2__c,      
                      ContactShimei_3__c,ContactRelationship_3__c,ContactCompanyName_3__c,ContactBusho_3__c,
                      ContactPostcd_3__c,ContactAddress_3__c,ContactCountryCode_3__c,ContactMobile_3__c,
                      ContactTel_3__c,ContactHolidayTel_3__c,ContactExtNo_3__c,ContactEmail_3__c,
                      ContactFax_3__c,   
                      TaikaiKinmuCompany__c,TaikaiBusho__c,TaikaiYakushoku__c,
                      KinmuCompany__r.PersonalInfoDisclosure__c, 
                      CompanyKeiyakuNo__r.KeiyakuCompanyName__r.PersonalInfoDisclosure__c
                      
                      from MemberInfo__c
                    //  where Id = 'a085D00000191FG'];
        			 where Id =: MemberInfo.id];
        } else
            MemberInfo = new MemberInfo__c();
        
    }
    public void  doFullSave(){
        upsert MemberInfo;
    }
    public PageReference doFullSave1(){
        doFullSave();
        String str = ApexPages.currentPage().getUrl().subStringAfter('/').substringBefore('?');
        return new PageReference('/apex/' + str).setRedirect(true);
    }  
    
    public PageReference Save(){
        
        upsert MemberInfo;
        system.debug(MemberInfo.TaikaiDate__c);
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        
        return new PageReference(sfdcBaseURL +'/'+ MemberInfo.id);
    }

}