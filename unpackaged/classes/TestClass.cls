@isTest
public class TestClass{
  static testMethod void NewContractMassUpdateControllerEx_Test(){
    AffiliatedCompany__c gp = TestUtil.createTestGroup();
    Account acKinmu = TestUtil.createTestAccount('KinmuTest');
    Account acKeiyaku = TestUtil.createTestAccount('KeiyakuTest');
    Account acKeiyakuCompany = TestUtil.createTestAccount('KeiyakuCompanyTest');
    ContractInfo__c ci = TestUtil.createTestContract(acKinmu.Id);    
    MemberInfo__c mi = TestUtil.createTestMemberInfo(acKinmu.Id, ci.Id, acKeiyakuCompany.Id);
    mi.CarryCost__c = 12345;
    update mi;
    FamilyInfo__c fi = TestUtil.createTestFamilyInfo(mi.Id);
    fi.OtaNote__c = 'test';
    update fi;
    Test.startTest();

    ApexPages.StandardController scon = new ApexPages.StandardController(ci);
    NewContractMassUpdateControllerEx con = new NewContractMassUpdateControllerEx(scon);
    
    con.searchPageBack();
    con.search();
    con.uncheckAll();
    con.closeSearchResult();
    con.search();
    con.checkAll();
    con.page2();
    con.itemClear();
    con.closeSearchResult();
    
    ApexPages.currentPage().getParameters().put('bLDocument','true');
    ApexPages.currentPage().getParameters().put('bLDocumentKeepingPlace','true');
    ApexPages.currentPage().getParameters().put('homeCountryCoverage','true');
    ApexPages.currentPage().getParameters().put('oTaRemarks','true');
       
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
    con.cancel2();

    PageReference pageRef = Page.NewContractMassUpdate;
    Test.setCurrentPage(pageRef);    
    NewContractMassUpdateControllerEx contro = new NewContractMassUpdateControllerEx(new ApexPages.StandardController(new ContractInfo__c()));
    contro.searchMemberLookUp.OtaInsuranceShuki__c = Date.newInstance(2015, 2, 1);
    contro.searchMemberLookUp2.OtaInsuranceShuki__c = Date.newInstance(2019, 2, 1);
    contro.searchMemberLookUp2.InsuranceKind__c = 'test';
    contro.search();
    
    PageReference pageRef2 = Page.NewContractMassUpdate2;
    Test.setCurrentPage(pageRef2);  
    NewContractMassUpdateControllerEx contro2 = new NewContractMassUpdateControllerEx(new ApexPages.StandardController(new ContractInfo__c()));
    ApexPages.currentPage().getParameters().put('bLDocument','true');
    ApexPages.currentPage().getParameters().put('bLDocumentKeepingPlace','true');
    ApexPages.currentPage().getParameters().put('homeCountryCoverage','true');
    ApexPages.currentPage().getParameters().put('oTaRemarks','true');    
    //contro2.copyCommon();
    contro2.itemClear();
    contro2.save2();
    
    Test.stopTest();           
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
  
    static testMethod void MDMemberReportController(){
        test.startTest();  
        RecordType rt = [select id from RecordType where developername ='Aggregate_Sheet_Affiliation'];
        RecordType rt2 = [select id from RecordType where developername ='Aggregate_Sheet_Contract'];
        Summary_of_members__c SummaryMem = new Summary_of_members__c(RecordTypeId =rt.id,Area__c='123',AreaEng__c='test',Company__c='123',data_F__c='1',Family__c='test');
        insert SummaryMem;
        Summary_of_members__c SummaryMem2 = new Summary_of_members__c(RecordTypeId = rt2.id,Area__c='123',AreaEng__c='test',Company__c='123',data_F__c='1',Family__c='test');
        insert SummaryMem2;
        MDMemberHeaders__c MDMemberHeaders = new MDMemberHeaders__c(Name = 'F',FieldName__c = 'data_F__c',Sorting__c=1);
        insert MDMemberHeaders;
        
        Document document = new Document();
        document.FolderId = UserInfo.getUserId();     
        document.name ='123';
        document.developername = 'MD_Member_Template_English12345';
        document.body = Blob.valueOf('ss:Name="Aggregate Sheet（Contract)">');
        insert document;
      
        PageReference testpage = page.MDMemberReport;
        MDMemberReportController cont1 = new MDMemberReportController();
        test.stopTest();
    }

     //item 1.9
     static testMethod void TestCompanyBatchProcess() {
 
        Shimei__c testStaff = new Shimei__c (name ='123',Cd__c='S243',SeiRoma__c='123', MeiRoma__c='123');
        insert(testStaff);
        Account testAccount = new Account(name='testing',CountryName__c='China',Jurisdiction__c='Shanghai',ShozokuArea__c ='Shanghai',EigyoTanto__c=testStaff.id,NaimuTanto__c=testStaff.id,BlEigyoTanto__c=testStaff.id,OfficeAdd__c='123213');
        insert(testAccount);
        Test.startTest();
        ApexPages.StandardController stdcontroller = new ApexPages.StandardController(testAccount);
        CompanyBatchProcessController controller = new CompanyBatchProcessController(stdcontroller);
         
        controller.search();       
        controller.selectAll();
        controller.releaseAll ();
        controller.selectAll();
        
        testAccount.EigyoTanto__c =testStaff.id;
        testAccount.NaimuTanto__c =testStaff.id;
        testAccount.BlEigyoTanto__c =testStaff.id;
        controller.closeSearchTable();
        controller.updateRecord();
        
        controller.back();
        Test.stopTest();   
     } 
     
     //item 1.10
     static testMethod void TestContractInfoBatchProcess() {

        Shimei__c testStaff = new Shimei__c (name ='123',Cd__c='0002',SeiRoma__c='MEGUMI TANZAWA', MeiRoma__c='123');
        insert(testStaff);
        Shimei__c testStaff2 = new Shimei__c (name ='124',Cd__c='0003',SeiRoma__c='HARUO OSHIMA', MeiRoma__c='123');
        insert(testStaff2);           
        Account testAccount = new Account(name='testAccount',CompanyNameEng__c='Higano Co., Ltd.',EigyoTanto__c=testStaff2.id,NaimuTanto__c=testStaff2.id,Jurisdiction__c='Beijing');
        insert(testAccount);       
        ContractInfo__c testContract = new ContractInfo__c(KeiyakuArea__c='Beijing',KeiyakuCompanyName__c=testAccount.id, MankiDate__c = date.newinstance(2015,02,11),KeiyakuDate__c=date.newinstance(2015,01,06),EigyoTanto__c=testStaff.id,NaimuTanto__c=testStaff2.id,TaikaiDate__c=null);
        insert(testContract);
        Test.startTest();
        ApexPages.StandardController stdcontroller = new ApexPages.StandardController(testContract);
        ContractInfoBatchProcessController controller = new ContractInfoBatchProcessController(stdcontroller);  
        
        
        controller.contractDataFromPage.KeiyakuArea__c = 'Beijing';
        controller.accountDataFromPage.EigyoTanto__c = testStaff.id;
        controller.accountDataFromPage.NaimuTanto__c = testStaff.id;
        
        controller.search();       
        controller.selectAll();
        controller.releaseAll ();
        controller.selectAll();        
           
        controller.inputLookUp.EigyoTanto__c = testStaff.id;
        controller.inputLookUp.NaimuTanto__c = testStaff.id;   
        

        controller.updateRecord();
        controller.closeSearchTable();
        
        controller.back();
        Test.stopTest();           
     }         
  
     //item 1.11
     static testMethod void TestMDMemberReportBatch () {
     
     MDMemberHeaders__c customerSettingMap = new MDMemberHeaders__c(FieldName__c ='data_FCV__c',name='FCV',Sorting__c=1 );
     insert customerSettingMap;
     List<RecordType> recordTypeList =  [select id,developerName from recordType where SobjectType = 'Summary_of_members__c'];
     RecordType rt = [select id from RecordType where developername ='Aggregate_Sheet_Affiliation'];
     RecordType rt2 = [select id from RecordType where developername ='Aggregate_Sheet_Contract'];
     ContractInfo__c testCon = new ContractInfo__c (MankiDate__c = date.newinstance(2018,02,11), KeiyakuArea__c='北京',KeiyakuDate__c = date.newinstance(2015,02,11));
     insert(testCon);
     Account testAcc = new Account(name='123');
     insert(testAcc);
     MemberInfo__c testMenInfo = new MemberInfo__c (CountryName__c='中国', Jurisdiction__c='北京',KeiyakuKeitai__c = '法人／単身C&V',ShozokuArea__c='北京',CompanyKeiyakuNo__c = testCon.id ,KeiyakuCompanyName__c=testAcc.id,TaikaiDate__c = null,Commodity__c='チャイナボウル',SeiRoma__c='123', MeiRoma__c='123');
     insert(testMenInfo);
     FamilyInfo__c testFamily = new FamilyInfo__c (MemberShimei__c = testMenInfo.id ,Commodity__c ='メディック',ShozokuArea__c='北京');
     insert(testFamily);
     //Summary_of_members__c SummaryMem = new Summary_of_members__c(RecordTypeId =rt.id,Area__c='123',AreaEng__c='test',Company__c='123',data_F__c='1');
     //insert SummaryMem;
     //Summary_of_members__c SummaryMem2 = new Summary_of_members__c(RecordTypeId = rt2.id,Area__c='123',AreaEng__c='test',Company__c='123',data_F__c='1');
     //insert SummaryMem2;  
     
     Test.startTest();
     //20160317 
     System.schedule('RunBatchApexTest', '0 0 0 1 4 ?', new MDMemberReportSchedular());
     Test.stopTest();
     }
     
     //item 1.13
        static testMethod void TestRenewalNoticeBatchProcess() {
        ContractInfo__c testContract = new ContractInfo__c( KeiyakuArea__c='Beijing',MankiDate__c = date.newinstance(2015,02,11),KeiyakuDate__c = date.newinstance(2015,02,11)  );
        insert(testContract);        
        Document testDoc = new Document(name='testFolder',FolderId='00l10000000cd4o');
        insert(testDoc); 
        Test.startTest();
        ApexPages.StandardController stdcontroller = new ApexPages.StandardController(testContract);
        RenewalNoticeBatchProcessController controller = new RenewalNoticeBatchProcessController(stdcontroller); 
        controller.pageData.MankiDate__c = date.newinstance(2015,02,10) ;
        controller.pageData2.MankiDate__c = date.newinstance(2015,03,10) ;   
        controller.pageData.KeiyakuArea__c = 'Beijing';   
        controller.m_selTemplate = 'testFolder';
        controller.search();
        controller.pageData.KeiyakuArea__c = 'Tokyo';  
        controller.search();
        controller.back();
        Test.stopTest();      
      }    
           
    //item 1.7
    static testMethod void TestCarInsuranceBatchProcess() {
     
       Account testAccount = new Account(name='testAccount',CompanyNameEng__c='Shanghai Higano Co., Ltd.');
       Account testAccount2 = new Account(name='testAccount2',CompanyNameEng__c='Shanghai Higano Co., Ltd.');
       
       insert(testAccount);
       insert(testAccount2);
       
       Ichiroheian__c testIchiroh = new Ichiroheian__c(name='019274',WOAgency__c='Agency',KeiyakuCompanyName__c = testAccount.id,ShiyoCompanyName__c=testAccount2.id ,KeiyakuArea__c='Beijing',WOInsuranceShukiAlpha__c = date.newinstance(2015,01,05),WOInsuranceCompany__c='Taipingy ang',WOCommodityName__c ='Anzen Banri',InsuranceShuki__c=date.newinstance(2015,01,05),Seat__c=1,OwnerKubun__c='所有');      
            
       insert(testIchiroh);
       
        Test.startTest();
        ApexPages.StandardController stdcontroller = new ApexPages.StandardController(testIchiroh);
        CarInsuranceBatchProcessController controller = new CarInsuranceBatchProcessController(stdcontroller);
        
        controller.search();       
        controller.selectAll();
        controller.releaseAll ();
        controller.selectAll();
        
        testIchiroh.PresentInsuranceShiki__c = date.newinstance(2015,01,06);
        testIchiroh.InsuranceShuki__c = date.newinstance(2015,01,06);
        testIchiroh.WOPresentInsuranceShikiAlpha__c = date.newinstance(2015,01,06);
        testIchiroh.WOInsuranceShukiAlpha__c = date.newinstance(2015,01,06);
        
        controller.updateRecord();     
        controller.closeSearchTable();
        controller.back();
        
        Test.stopTest();      
     }
          
     
     //item 1.5 
     static testMethod void TestMankiDateBatchProcess(){
    
         Account testAccount = new Account(name='testAccount',CompanyNameEng__c='Shanghai Higano Co., Ltd.');
         MemberInfo__c testMember = new MemberInfo__c (Name='testName',MemberNo__c='1JPN1914360',KeiyakuCompanyName__c=testAccount.id,MankiDate__c=date.newinstance(2015,02,09),Commodity__c='Medic',KinmuCompany__c =testAccount.id,MeiRoma__c='2222',SeiRoma__c='222');            
         ContractInfo__c testContract = new ContractInfo__c(KeiyakuCompanyName__c=testAccount.id,MankiDate__c=date.newinstance(2015,02,09),KeiyakuDate__c=date.newinstance(2015,02,09));
         testMember.CountryName__c ='中国'; //20160923
         testMember.KeiyakuKeitai__c = '法人／家族Asian';
         testMember.OtaAgency__c = 'WB扱い';
         
         insert(testMember);
         insert(testAccount);        
         insert(testContract);
         
         Test.startTest();
         ApexPages.StandardController stdcontroller = new ApexPages.StandardController(testContract);
         MankiDateBatchProcessController controller = new  MankiDateBatchProcessController(stdcontroller); 
  
        controller.selectAll();
        controller.releaseAll();
        controller.selectAll();
        
        testContract.MankiDate__c = date.newinstance(2015,01,06);
        controller.updateRecord();
        controller.closeSearchTable();
        controller.back();
        Test.stopTest();    
     }
    
     //item Invoice generate excel
      static testMethod void ContractInvoiceController_Test(){
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
        // 20160923 mi.OtaAgency__c = 'WB扱い';
        mi.CountryName__c ='中国';
        mi.KeiyakuKeitai__c = '法人／家族Asian';
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
        
        List<Folder> lstFolder = [Select Id From Folder Where Name = 'Invoice Template' ];
       
        Document document = new Document(FolderId = lstFolder.get(0).Id, Name='Test Name',Keywords = 'Test');

        insert document;        
        
        ApexPages.StandardController scon = new ApexPages.StandardController(ci); 
        ContractInvoiceController con = new ContractInvoiceController(scon);
        con.init();
        con.complete();
      }  
      
 //item renewal generate excel     
  static testMethod void ContractRenewalController_Test(){
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
    // 20160923 mi2.KeiyakuKeitai__c = '個人／家族Asian';
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

    List<Folder> lstFolder = [Select Id From Folder Where Name = 'Renewal Form Template' ];       
    Document document = new Document(FolderId = lstFolder.get(0).Id, Name='Test Name',Keywords = 'Test');
    insert document;
            
    ApexPages.StandardController scon = new ApexPages.StandardController(ci); 
    ContractRenewalController con = new ContractRenewalController(scon);
    con.init();
  }   
   
 //item new renewal generate excel     
  static testMethod void NewContractRenewalController_Test(){
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
    NewContractRenewalController con = new NewContractRenewalController(scon);
    con.init();
  }    
  
  static testMethod void NewContractInvoiceController_Test()
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
    NewContractInvoiceController con = new NewContractInvoiceController(scon);
    con.init();
    con.complete();
  }
       
    
  // CustomerDataControllerEx test
  static testMethod void CustomerDataControllerEx_Test()
  {
    Account ac = new Account();
    ac.Name = 'Test';
    insert(ac);
    Account acKeiyakuCompany = TestUtil.createTestAccount('KeiyakuCompanyTest');
    Account acKinmu = TestUtil.createTestAccount('KinmuTest');
    acKinmu.parentId = acKeiyakuCompany.id;
    update acKinmu;
    
    ContractInfo__c ci = TestUtil.createTestContract(acKinmu.Id);
    
    MemberInfo__c mi = new MemberInfo__c();
    mi.Name = 'TEST';
    mi.SeiRoma__c = 'Test';
    mi.MeiRoma__c = 'Test';
    mi.KinmuCompany__c = acKinmu.id;
    mi.KeiyakuCompanyName__c = acKeiyakuCompany.id;
    mi.CompanyKeiyakuNo__c = ci.Id;
    mi.MankiDate__c = system.today().addYears(1);
    mi.Tel__c='12343567';
    mi.Mobile__c='12233234';
    mi.OtaName__c ='未確認';
      mi.CountryName__c ='中国';  //20160903
      mi.KeiyakuKeitai__c = '法人／家族Asian';
      mi.OtaAgency__c = 'WB扱い';
    insert(mi);
    
    Ichiroheian__c i1 = TestUtil.createTestIchiroheian(acKinmu.Id);
    Ichiroheian__c i2 = TestUtil.createTestIchiroheian(acKinmu.Id);
    
    BL__c bl1 = TestUtil.createTestBL(acKinmu.Id);
    Kenshin__c k1 = TestUtil.createTestKenshin(mi.Id);
       
    //Account ac = [select Id, ParentId from Account where Id='001S000000E8sIe' limit 1];
    
    ApexPages.currentPage().getHeaders().put('USER-AGENT','MSIE');
    
    ApexPages.StandardController scon = new ApexPages.StandardController(acKinmu); 
    CustomerDataControllerEx con = new CustomerDataControllerEx(scon);
    con.init();
    con.uncheckAll();
    con.checkAll();
    con.Execute1();
    con.Execute2();
  }    
   
  //new NewCustomerDataControllerEx 
  static testMethod void NewCustomerDataControllerEx_Test()
  {
    Account ac = new Account();
    ac.Name = 'Test';
    insert(ac);
    Account acKeiyakuCompany = TestUtil.createTestAccount('KeiyakuCompanyTest');
    Account acKinmu = TestUtil.createTestAccount('KinmuTest');
    acKinmu.parentId = acKeiyakuCompany.id;
    update acKinmu;
    
    ContractInfo__c ci = TestUtil.createTestContract(acKinmu.Id);
    
    MemberInfo__c mi = new MemberInfo__c();
    mi.Name = 'TEST';
    mi.SeiRoma__c = 'Test';
    mi.MeiRoma__c = 'Test';
    mi.KinmuCompany__c = acKinmu.id;
    mi.KeiyakuCompanyName__c = acKeiyakuCompany.id;
    mi.CompanyKeiyakuNo__c = ci.Id;
    mi.MankiDate__c = system.today().addYears(1);
    mi.Tel__c='12343567';
    mi.Mobile__c='12233234';
    mi.OtaName__c ='未確認';
        mi.CountryName__c ='中国'; //20160923
      mi.KeiyakuKeitai__c = '法人／家族Asian';
      mi.OtaAgency__c = 'WB扱い';
    insert(mi);
    
    Ichiroheian__c i1 = TestUtil.createTestIchiroheian(acKinmu.Id);
    Ichiroheian__c i2 = TestUtil.createTestIchiroheian(acKinmu.Id);
    
    BL__c bl1 = TestUtil.createTestBL(acKinmu.Id);
    Kenshin__c k1 = TestUtil.createTestKenshin(mi.Id);
       
    //Account ac = [select Id, ParentId from Account where Id='001S000000E8sIe' limit 1];
    
    ApexPages.currentPage().getHeaders().put('USER-AGENT','MSIE');
    
    ApexPages.StandardController scon = new ApexPages.StandardController(acKinmu); 
    NewCustomerDataControllerEx con = new NewCustomerDataControllerEx(scon);
    con.init();    
    con.uncheckAll();
    con.checkAll();
    con.Execute1();
    con.Execute2();
    con.accountsId = acKinmu.id;
    con.appendParentsParentAccount();
    con.appendOneLevelChildAccountUnderParent();
    con.removeChildAccount();
  } 
  
  public class NamedItem
  {
    private string m_value;
    
    public string Name { get; set; }
    public string Value 
    { 
      get { return m_value; }
      set { m_value = (value==null ? '' : value); } 
    }
    public NamedItem(string name, string value)
    {
      this.Name = name;
      this.Value = value; 
    }
  }
  
  public class AccountSelection
  {
    public boolean Selected {get; set;}
    public Account Acc { get; set;}
    public string Indent {get; set;}
    public AccountSelection(Account a, string indent)
    {
      this.Selected = false;
      this.Acc = a;
      this.Indent = indent;
    }
  }  
    
  //CustomData
  static testMethod void CustomData_Test()
  {
    Account acKinmu = TestUtil.createTestAccount('KinmuTest');
    Account acKinmu2 = TestUtil.createTestAccount('KinmuTest2');
    Account acKeiyaku = TestUtil.createTestAccount('KeiyakuTest');
    Account acKeiyaku2 = TestUtil.createTestAccount('KeiyakuTest2');
    ContractInfo__c ci = TestUtil.createTestContract(acKeiyaku.Id);
    ContractInfo__c ci2 = TestUtil.createTestContract(acKeiyaku2.Id);
    Account acKeiyakuCompany = TestUtil.createTestAccount('KeiyakuCompanyTest');
    MemberInfo__c mi = TestUtil.createTestMemberInfo(acKinmu.Id, ci.Id, acKeiyakuCompany.Id);
    MemberInfo__c mi2 = TestUtil.createTestMemberInfo(acKinmu2.Id, ci2.Id, acKeiyakuCompany.Id);
    
    CustomerData cd = new CustomerData();   
    //MemberHeader mh = new MemberHeader(mi.KinmuCompany__r, mi.CompanyKeiyakuNo__r, mi.KeiyakuCompanyName__r);
    //MemberHeader mh2 = new MemberHeader(mi2.KinmuCompany__r, mi2.CompanyKeiyakuNo__r, mi2.KeiyakuCompanyName__r);
    //cd.Data.add(mh);
    //mh.Match(mh);
    //mh.Match(mh2);
  
 
    NamedItem ni = new NamedItem('<Worksheet ss:Name="' + 'Test' + '">','Test') ;
    string s;
    
    s = ni.Name;
    ni.Name = s;
    s = ni.Value;
    ni.Value = s;
    
    Account ac = TestUtil.createTestAccount();
    AccountSelection acs = new AccountSelection(ac, 'test');
    s = acs.Indent;
    acs.Indent = s;
    ac = acs.Acc;
    acs.Acc = ac;
    Boolean b;
    b = acs.Selected;
    acs.Selected = b;
  }        
}