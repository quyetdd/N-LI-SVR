@isTest
public class CompanyBatchProcessController_Test {
    
    
    static testMethod void ContractInfoBatchProcessControllerTest(){
        Account acKinmu = TestUtil.createTestAccount('KinmuTest');
        ContractInfo__c ci = TestUtil.createTestContract(acKinmu.Id);
        ci.KeiyakuArea__c = '東京';
        Shimei__c SalesA = TestUtil.createShimei('SA','001','SA','SA','正社員','WB Japan',
                                                '日本','営業','営業内務','WB Japan','東京',system.today(),
                                                '女','日本',system.today());
        Shimei__c SalesB = TestUtil.createShimei('SB','002','SB','SB','正社員','WB Japan',
                                                '日本','営業','営業内務','WB Japan','東京',system.today(),
                                                '女','日本',system.today());
        Shimei__c ClerkA = TestUtil.createShimei('CA','003','CA','CA','正社員','WB Japan',
                                                '日本','営業','営業内務','WB Japan','東京',system.today(),
                                                '女','日本',system.today());
       // Shimei__c ClerkB = TestUtil.createShimei('CB');
        ci.EigyoTanto__c = SalesA.ID;
        ci.NaimuTanto__c = ClerkA.ID;
        update ci;
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(new Account());
        CompanyBatchProcessController CompanyBatchProcess = new CompanyBatchProcessController(sc);
        CompanyBatchProcess.SelectedRegion_and_Area = 'アジア';
        CompanyBatchProcess.fetchCountryNameOptions();
        CompanyBatchProcess.SelectedCountryName = '中国';
        CompanyBatchProcess.fetchJurisdictionOptions();
  		CompanyBatchProcess.SelectedJurisdiction = '深セン';
        CompanyBatchProcess.fetchShozokuAreaOptions();
        CompanyBatchProcess.SelectedShozokuArea = '深セン';
        CompanyBatchProcess.fetchEigyoTantoOptions();
        CompanyBatchProcess.search();
        CompanyBatchProcess.releaseAll();
        CompanyBatchProcess.selectAll();
        
        CompanyBatchProcess.updateRecord();
      
        //ApexPages.StandardSetController sec = new ApexPages.StandardSetController(new Account[]);
            
    }

}