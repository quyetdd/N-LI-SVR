@isTest
public class wb_convert_ContractInfo_Test {
    
     @isTest static void test_Convert(){
         
         TestUtil.createService();
         TestUtil.CreateCurrency();
         TestUtil.CreateBudgetRate();
         TestUtil.CreateCountryDistrict();
         
        // Account ContractComp = TestUtil.createTestAccount('ContractComp');
         Account   ContractComp = TestUtil.CreateCompany('ウェルビー JPN',
                                                         'WellBe JAPAN',
                                                         'アジア',
                                                         '日本',
                                                         '東京',
                                                         '東京');
        
         
         // Account WorkingComp = TestUtil.createTestAccount('WorkingComp');
         Account WorkingComp = TestUtil.CreateCompany('ウェルビー ',
                                                      'WellBe ',
                                                      'アジア',
                                                      '日本',
                                                      '名古屋',
                                                      '名古屋');
         system.debug(WorkingComp);
         ContractInfo__c Contract  =  TestUtil.createTestContract(ContractComp);
         
         MemberInfo__c Member  =  TestUtil.createTestMemberInfo(WorkingComp.Id,Contract.Id,ContractComp.Id,'法人／家族Global Plus Member');
         FamilyInfo__c Family = TestUtil.createTestFamilyInfo(Member.Id);
         
         MemberInfo__c Single  =  TestUtil.createTestMemberInfo(WorkingComp.Id,Contract.Id,ContractComp.Id,'法人／単身Global Plus Member');
         
         MemberInfo__c CardHolder  =  TestUtil.createTestMemberInfo(WorkingComp.Id,Contract.Id,ContractComp.Id,'法人／無記名Biz Trip Pass');
         system.debug(CardHolder);
        // Id CId ='0015D00000DEbMY';
        // 
    
		List<MemberInfo__c> m = new List<MemberInfo__c>();

	
         wb_convert_ContractInfo_Batch ConvertMgr = new wb_convert_ContractInfo_Batch(ContractComp);
        // system.debug(ConvertMgr.theCompany);
         ConvertMgr.startConvert();
         
         m.add(Single);
         m.add(CardHolder);
         
          ConvertMgr = new wb_convert_ContractInfo_Batch(Contract,m);
         // system.debug(ConvertMgr.theCompany);
         ConvertMgr.startConvert();
     }

}