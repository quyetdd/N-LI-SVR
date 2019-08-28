@isTest
public class NewRenewalBatchProcessControllerTest{
	
	static testMethod void NewRenewalBatchProcessControllerTest(){
    AffiliatedCompany__c gp = TestUtil.createTestGroup();
    Account acKinmu = TestUtil.createTestAccount('KinmuTest');
    Account acKinmu2 = TestUtil.createTestAccount('KinmuTest2');
    Account acKeiyaku = TestUtil.createTestAccount('KeiyakuTest');
    Account acKeiyaku2 = TestUtil.createTestAccount('KeiyakuTest2');
    ContractInfo__c ci = TestUtil.createTestContract(acKeiyaku.Id);
    ci.KeiyakuArea__c = '東京';
    ci.ImportCntractNo__c = '12312';
    update ci;
    ContractInfo__c ci2 = TestUtil.createTestContract(acKeiyaku2.Id);
    Account acKeiyakuCompany = TestUtil.createTestAccount('KeiyakuCompanyTest');
    MemberInfo__c mi = TestUtil.createTestMemberInfo(acKinmu.Id, ci.Id, acKeiyakuCompany.Id);
    MemberInfo__c mi2 = TestUtil.createTestMemberInfo(acKinmu.Id, ci.Id, acKeiyakuCompany.Id);
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
    // 20160923 mi.KeiyakuKeitai__c = '法人／家族';
    mi.CountryName__c ='中国';
    mi.KeiyakuKeitai__c = '法人／家族Asian';
    mi.OtaAgency__c = 'WB扱い';
    mi.OtaInsuranceShuki__c = system.today();
    update(mi);
    // 20160923 mi2.KeiyakuKeitai__c = '法人／無記名';
    mi2.CountryName__c ='中国';
    mi2.KeiyakuKeitai__c = '法人／家族Asian';
    update(mi2);
    i1.OI_InsuranceShuki__c = system.today();
    update(i1);
    i2.OI_InsuranceShuki__c = system.today();
    update(i2);
        
    insert new Excel_Gen__c(Name='Default',Destination_Path__c = 'C:\temp');
    
    
    ci = [select Id, Name, KeiyakuCompanyName__r.Id, KeiyakuCompanyName__r.Name,
     MankiDate__c,KeiyakuArea__c,EigyoTanto__c,ImportCntractNo__c
     from ContractInfo__c where Id=:ci.Id];
    
    ApexPages.StandardController scon = new ApexPages.StandardController(ci); 
    NewRenewalBatchProcessController con = new NewRenewalBatchProcessController(scon);
    con.init();
    con.closeSearchTable();
    con.getKeiyakuAreas();
    con.selectAll();
    con.releaseAll();
    con.showPageMessage();
    con.clearPageMessage();
    con.searchData = ci;
    con.query();
    
    con.FirstPage();
    con.next();
    con.previous();
    con.LastPage();
    con.getprev();
    con.getnxt();
    
  } 
	
	//item new renewal generate excel     
  static testMethod void NewContractRenewalController2_Test(){
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
    // 20160923 mi.KeiyakuKeitai__c = '法人／家族';
    mi.CountryName__c ='中国';
    mi.KeiyakuKeitai__c = '法人／家族Asian';
    mi.OtaAgency__c = 'WB扱い';
    mi.OtaInsuranceShuki__c = system.today();
    update(mi);
    // 20160923 mi2.KeiyakuKeitai__c = '法人／無記名';
    mi2.CountryName__c ='中国';
    mi2.KeiyakuKeitai__c = '法人／家族Asian';
    update(mi2);
    i1.OI_InsuranceShuki__c = system.today();
    update(i1);
    i2.OI_InsuranceShuki__c = system.today();
    update(i2);
    
    ci = [select Id, Name, KeiyakuCompanyName__r.Id, KeiyakuCompanyName__r.Name,
     MankiDate__c
     from ContractInfo__c where Id=:ci.Id];
    
    ApexPages.StandardController scon = new ApexPages.StandardController(ci); 
    NewContractRenewalController2 con = new NewContractRenewalController2(scon);
    con.init();
    
  }   
}