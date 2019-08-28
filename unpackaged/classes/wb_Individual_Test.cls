@isTest
public class wb_Individual_Test {
    
    @isTest static void test_1(){
        Account theCompany = TestUtil.CreateCompany('ウェルビー Holding',
                                           'WellBe Holding Ltd',
                                           'アジア',
                                           '香港',
                                           '香港',
                                           '香港',
                                           'HKD');
        TestUtil.createService();
        List<wb_Service__c> s =[SELECT id, Service__c, CardPrefix__c, Currency__c, ServiceFee__c,  
                DataType__c
                FROM wb_Service__c];
        system.debug(s);
        wb_Individual__c theMember = TestUtil.createMember('A',theCompany.Id);
        
        PageReference pageRef = Page.wb_Individual_SearchAndNew;
     	pageRef.getParameters().put('pv3',  string.valueOf(theCompany.Id));
        pageRef.getParameters().put('pv4',  '2018/07/16');
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(theMember);
        
       // wb_CarInsurance sc_a = new wb_CarInsurance(sc);
        
        wb_Individual IndMgr = new wb_Individual();
        
        IndMgr.WorkFor = theCompany;
        
        IndMgr.search();
        IndMgr.Home();
        IndMgr.Cancel();
        
        IndMgr = new wb_Individual(sc);
        IndMgr.NewFamilyMember();
        IndMgr.validateAndUpdate();
        
        
    }

}