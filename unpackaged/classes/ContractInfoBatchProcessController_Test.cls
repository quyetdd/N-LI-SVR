@isTest
public class ContractInfoBatchProcessController_Test {
    
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
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(new ContractInfo__c());
        ContractInfoBatchProcessController ContractBatchProcess = new ContractInfoBatchProcessController(sc);
        ContractBatchProcess.contractDataFromPage.KeiyakuArea__c = '東京';
        ContractBatchProcess.contractDataFromPage.EigyoTanto__c = SalesA.ID;
        ContractBatchProcess.search();
        ContractBatchProcess.inputLookUp.EigyoTanto__c = SalesB.Id;
        ContractBatchProcess.selectAll();
        ContractBatchProcess.updateRecord();
        ContractBatchProcess.contractDataFromPage.EigyoTanto__c = SalesB.ID;
        ContractBatchProcess.search();
        ContractBatchProcess.releaseAll();
        
      
    }


}