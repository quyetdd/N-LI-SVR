@isTest(seeAllData=false)
public class ContractMassUpdateControllerEx_Test {
    
    static void init(){
       
    }

     static testMethod void ContractMassUpdateControllerEx_Test()
  {
    AffiliatedCompany__c gp = TestUtil.createTestGroup();
    Account acKinmu = TestUtil.createTestAccount('KinmuTest');
    Account acKinmu2 = TestUtil.createTestAccount('KinmuTest2');
    Account acKeiyaku = TestUtil.createTestAccount('KeiyakuTest');
    Account acKeiyaku2 = TestUtil.createTestAccount('KeiyakuTest2');
    ContractInfo__c ci = TestUtil.createTestContract(acKeiyaku.Id);
    ContractInfo__c ci2 = TestUtil.createTestContract(acKeiyaku2.Id);
    Account acKeiyakuCompany = TestUtil.createTestAccount('KeiyakuCompanyTest');
    MemberInfo__c mi = TestUtil.createTestMemberInfo(acKinmu.Id, ci.Id, acKeiyakuCompany.Id);
    MemberInfo__c mi2 = TestUtil.createTestMemberInfo(acKinmu.Id, ci.Id, acKeiyakuCompany.Id);
    FamilyInfo__c fi = TestUtil.createTestFamilyInfo(mi.Id);
    Ichiroheian__c i1 = TestUtil.createTestIchiroheian(acKeiyaku.Id);
    Ichiroheian__c i2 = TestUtil.createTestIchiroheian(acKeiyaku.Id);
    BL__c bl1 = TestUtil.createTestBL(acKeiyaku.Id);
    BL__c bl2 = TestUtil.createTestBL(acKeiyaku.Id);
    Kenshin__c k1 = TestUtil.createTestKenshin(mi.Id);
    Kenshin__c k2 = TestUtil.createTestKenshin(mi.Id);
    acKinmu.AffiliatedCompanyName__c = gp.Id;
    update(acKinmu);
    acKeiyaku.AffiliatedCompanyName__c = gp.Id;
    update(acKeiyaku);
    acKinmu2.AffiliatedCompanyName__c = gp.Id;
    update(acKinmu);
    acKeiyaku2.AffiliatedCompanyName__c = gp.Id;
    update(acKeiyaku);
      mi.CountryName__c ='中国';
      mi.KeiyakuKeitai__c = '法人／家族Asian';
      mi.OtaAgency__c = 'WB扱い';
      mi.OtaInsuranceShuki__c = system.today();
      update(mi);
      mi2.CountryName__c ='中国';
      mi2.KeiyakuKeitai__c = '法人／家族Asian';
      // mi2.KeiyakuKeitai__c = '法人／無記名Asian';
    update(mi2);
    i1.OI_InsuranceShuki__c = system.today();
    update(i1);
    i2.OI_InsuranceShuki__c = system.today();
    update(i2);
    
    ci = [select Id, Name, KeiyakuCompanyName__r.Id, KeiyakuCompanyName__r.Name,
     MankiDate__c
     from ContractInfo__c where Id=:ci.Id];
     
    ApexPages.StandardController scon = new ApexPages.StandardController(ci);
    ContractMassUpdateControllerEx con = new ContractMassUpdateControllerEx(scon);
    con.uncheckAll();
    con.page2();
    con.checkAll();
    con.page2();
    
    con.Common.OtaName__c = 'Test';
      con.Common.InsuranceKind__c = 'Test';
      con.Common.OtaAgency__c = 'Test';
      con.Common.ShokenNo__c = 'Test';
      con.Common.ShokenGetSituation__c = 'Test';
      con.Common.OtaKeepPlace__c = 'Test';
      con.Common.MedicalBillKessaiHouhou__c = 'Test';
      con.Common.OtaInsuranceShiki__c = system.today();  
      con.Common.OtaInsuranceShuki__c = system.today();  
      con.Common.InsurancePlan__c = 'Test';  
      con.Common.InsuranceCurrency__c = 'Test';
      con.Common.InjuryDeathCost__c = 1;  
      con.Common.TreatmentCost__c = 1;  
      con.Common.TreatmentRescueCost__c = 1;
      con.Common.DiseaseCost__c = 1;
      con.Common.InjuryCost__c = 1;  
      con.Common.DiseaseDeathCost__c = 1;
      con.Common.RescueCost__c = 1; 
      con.Common.DamagesCost__c = 1;  
      con.Common.CarryCost__c = 1; 
      con.Common.HomeCountryCoverage__c = true; 
      con.Common.OtaNote__c = 'Test';  
    
    con.copyCommon();
    con.save2();
  } 
}