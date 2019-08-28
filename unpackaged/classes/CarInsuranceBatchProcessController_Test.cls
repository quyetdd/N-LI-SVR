@isTest
public class CarInsuranceBatchProcessController_Test {
    static testMethod void CarInsuranceBatchProcessControllerTest(){
        Account ContractComp = TestUtil.createTestAccount('ContractComp');
        Ichiroheian__c CarInsu = TestUtil.createTestIchiroheian(ContractComp.id);
        CarInsu.CancelDate__c = system.today();
        update CarInsu;
        system.debug(CarInsu);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(new Ichiroheian__c());
        CarInsuranceBatchProcessController CarInsuranceBatchProcess = new CarInsuranceBatchProcessController(sc);
        CarInsuranceBatchProcess.fetchWOInsuranceCompanyOptions();
        CarInsuranceBatchProcess.fetchKeiyakuCountryOptions();
        CarInsuranceBatchProcess.fetchKeiyakuAreaOptions();
        CarInsuranceBatchProcess.fetchWOCommodityNameOptions();
        CarInsuranceBatchProcess.cs.InsuranceShuki__c = system.today();
        CarInsuranceBatchProcess.search();
        CarInsuranceBatchProcess.selectAll();
        CarInsuranceBatchProcess.releaseAll();
        CarInsuranceBatchProcess.selectAll();
        CarInsuranceBatchProcess.updateRecord();
        CarInsuranceBatchProcess.closeSearchTable();
        CarInsuranceBatchProcess.back();
        
        ApexPages.StandardSetController sec = new ApexPages.StandardSetController(new List<Ichiroheian__c>());
        
        CarInsuranceBatchProcess = new CarInsuranceBatchProcessController(sec);
    }
    
}