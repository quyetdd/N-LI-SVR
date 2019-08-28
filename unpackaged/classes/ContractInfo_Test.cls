@isTest(seeAllData=false)
public class ContractInfo_Test {
    public static List<ContractInfo__c> contract;
    static void init(){
        contract = new List<ContractInfo__c>();
    }
    static testMethod void testBudgetRate(){
        init();
        Test.startTest();
        Account a = new Account(name='ABC');
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

        contract.add(c);
        insert contract;
        ContractInfo__c con = [select BudgetRate__c from ContractInfo__c where id =:contract[0].id ];
/*        wb_BudgetRate__c r = [ select Rate__c from wb_BudgetRate__c 
                              where  ToCurrency__c =:record.Currency__c  
                              and FromDate__c <=:record.KeiyakuDate__c and ToDate__c >=:record.KeiyakuDate__c limit 1];
        */
         System.debug( 'Contract Budget Rate ' + con.BudgetRate__c );
         System.assertEquals(r.Rate__c, con.BudgetRate__c);
        Test.stopTest();
        MemberInfo__c MemberInfo = new MemberInfo__c( NAME='BEF',
                                                     MANKIDATE__C = system.today(),
                                                     KEIYAKUDATE__C=system.today(),
                                                     COMPANYKEIYAKUNO__C=a.id,
                                                     KEIYAKUCOMPANYNAME__C=a.id,
                                                     RELATIONSHIP__C='会員本人',
                                                     REGION_AND_AREA__C='アジア',
                                                     COMMODITY__C='メディック',
                                                     KEIYAKUKEITAI__C='法人／単身Global Plus Member',
                                                     SHOZOKUAREA__C='香港',
                                                     JURISDICTION__C='香港',
                                                     KINMUCOMPANY__C=a.id,
                                                     COUNTRYNAME__C='香港'
                                                    );


    }
    
}