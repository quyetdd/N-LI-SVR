@isTest
public class wb_MemberInfo_HealthCheck_Test {
  

    @isTest static void wb_MemberInfo_HealthCheck_Test() {
     
        Test.startTest();
         List<ContractInfo__c> contract;
        Account a = new Account(name='ABC',PersonalInfoDisclosure__c=true);
        insert a;
        DateTime dT = System.now();
        DateTime fD = dT.addDays(-30);
        DateTime tD = dT.addDays(30);
        Date fDate = date.newinstance(fD.year(), fD.month(), fD.day());
        Date tDate = date.newinstance(tD.year(), tD.month(), tD.day());
        
        wb_BudgetRate__c r = new wb_BudgetRate__c(ToCurrency__c='JPY', Rate__c = 120.3, FromDate__c= fDate, ToDate__c=tDate);
        insert r;
        ContractInfo__c c = new ContractInfo__c(KeiyakuArea__c='北京',SeikyuArea__c='東京',
                                                MankiDate__c=Date.today(),KeiyakuDate__c=Date.today(),
                                                Currency__c = 'JPY',
                                                KeiyakuCompanyName__c=a.id,SeikyuCompanyName__c=a.id );
        //contract = new List<ContractInfo__c>();

       // contract.add(c);
        insert c;
        ContractInfo__c con = [select BudgetRate__c from ContractInfo__c where id =:c.id ];
          MemberInfo__c MemberInfo = new MemberInfo__c( NAME='BEF',
                                                     MANKIDATE__C = system.today(),
                                                     KEIYAKUDATE__C=system.today(),
         											 COMPANYKEIYAKUNO__C=c.id,
                                                     KEIYAKUCOMPANYNAME__C=a.id,
                                                     RELATIONSHIP__C='会員本人',
                                                     REGION_AND_AREA__C='アジア',
                                                     COMMODITY__C='メディック',
                                                     KEIYAKUKEITAI__C='法人／家族Global Plus Member',
                                                     SHOZOKUAREA__C='香港',
                                                     JURISDICTION__C='香港',
                                                     KINMUCOMPANY__C=a.id,
                                                     COUNTRYNAME__C='香港',
                                                       SeiRoma__c='A', MeiRoma__c='B'
                                                    );
        insert MemberInfo;
        
        FamilyInfo__c FamilyInfo = new FamilyInfo__c( NAME='BEF-W',
                                                    // MANKIDATE__C = system.today(),
                                                    // KEIYAKUDATE__C=system.today(),
                                                    // COMPANYKEIYAKUNO__C=c.id,
                                                    // KEIYAKUCOMPANYNAME__C=a.id,
                                                     RELATIONSHIP__C='妻',
                                                     MemberShimei__c =MemberInfo.id,
                                                     REGION_AND_AREA__C='アジア',
                                                     COMMODITY__C='メディック',
                                                   //  KEIYAKUKEITAI__C='法人／単身Global Plus Member',
                                                     SHOZOKUAREA__C='香港',
                                                     JURISDICTION__C='香港',
                                                    // KINMUCOMPANY__C=a.id,
                                                     COUNTRYNAME__C='香港',
                                                     SeiRoma__c='A', MeiRoma__c='B'
                                                    );
           insert FamilyInfo;
        PageReference pageRef = Page.wb_Service;
        Test.setCurrentPage(pageRef);
        system.debug(MemberInfo);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(MemberInfo);
        
        wb_MemberInfo_HealthCheck sc_a = new wb_MemberInfo_HealthCheck(sc);
        sc_a.MemberInfo = MemberInfo;
        sc_a.Edit();
        sc_a.View();
        
        PageReference pageRef2 = Page.wb_Service;
        Test.setCurrentPage(pageRef2);
        system.debug(FamilyInfo);
        ApexPages.Standardcontroller sc2 = new ApexPages.Standardcontroller(FamilyInfo);
        
        wb_FamilyInfo_HealthCheck sc_2 = new wb_FamilyInfo_HealthCheck(sc2);
        sc_2.FamilyInfo = FamilyInfo;
        sc_2.Edit();
        sc_2.View();
       

    }
    
}