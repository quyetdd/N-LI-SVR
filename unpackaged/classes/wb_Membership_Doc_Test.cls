@isTest
public class wb_Membership_Doc_Test {
    
        
    @isTest static void test_1(){
        
       Account theCompanyHongKong = wb_Membership_Test.CreateCompany('ウェルビー Holding',
                                           'WellBe Holding Ltd',
                                           'アジア',
                                           '香港',
                                           '香港',
                                           '香港',
                                           'HKD');
        //system.debug(theCompanyHongKong);
        wb_Membership_Test WBT = new wb_Membership_Test();
      //  WBT.Service = TestUtil.createService();
        List<wb_Currency__c> Curr = wb_Membership_Test.CreateCurrency();
        List<wb_BudgetRate__c> BudgetRate = wb_Membership_Test.CreateBudgetRate();
        
        
        wb_Membership MSHongKong = wb_Membership_Test.createMembershipContract(theCompanyHongKong);
        MSHongKong = wb_Membership_Test.MembershipContractAdd(MSHongKong,'入会金',10);

        MSHongKong = wb_Membership_Test.MembershipContractAdd(MSHongKong,'単身',5);

        
        MSHongKong.removeEmptyRow();
        MSHongKong = wb_Membership_Test.MembershipContractAdd(MSHongKong,'家族',2);
 
        MSHongKong.removeEmptyRow();
        MSHongKong = wb_Membership_Test.MembershipContractAdd(MSHongKong,'無記名',null);
  
        
        MSHongKong.Membership.Currency__c ='JPY';
        MSHongKong.ChangeCurrency();
        MSHongKong.GetGroupDiscountPercentage();
        MSHongKong.removeEmptyRow();

        MSHongKong.ValidateAndUpdate();

        
        
        PageReference pageRef = Page.wb_Membership_Edit;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(new wb_Membership__c());
        
        sc = new ApexPages.Standardcontroller(new wb_Membership__c());
        wb_Membership MS = new wb_Membership(sc);
        MS.Membership = MSHongKong.Membership;
        
        MS.start_View();
        
        MS.removeEmptyRow();
        MS.theMembershipDetail[2].IsSelected = true;
        MS.DeleteSelectedRows();
        MS.ValidateMembershipFee();
   		MS.ValidateAndUpdate();

           
        MS.GenerateMemeberNo();
        MS.Confirm();
        
     	wb_Membership_Invoice InoviceData = new wb_Membership_Invoice(MS.Membership);
          
        pageRef = Page.wb_Membership_InvoiceExport;
        pageRef.getParameters().put('id', String.valueOf(MS.Membership.id));
        pageRef.getParameters().put('pv0', 'YES');
        InoviceData.SaveOption='YES';
        Test.setCurrentPage(pageRef);
        InoviceData.SaveOption='YES';
        InoviceData.saveAttachment();
        InoviceData = new wb_Membership_Invoice();
        
      
    }
    
    @isTest static void test_2(){
        
       Account theCompanyHongKong = wb_Membership_Test.CreateCompany('ウェルビー Holding',
                                           'WellBe Holding Ltd',
                                           'アジア',
                                           '香港',
                                           '香港',
                                           '香港',
                                           'HKD');
        //system.debug(theCompanyHongKong);
        wb_Membership_Test WBT = new wb_Membership_Test();
      //  WBT.Service = TestUtil.createService();
        List<wb_Currency__c> Curr = wb_Membership_Test.CreateCurrency();
        List<wb_BudgetRate__c> BudgetRate = wb_Membership_Test.CreateBudgetRate();
        
        
        wb_Membership MSHongKong = wb_Membership_Test.createMembershipContract(theCompanyHongKong);
        MSHongKong = wb_Membership_Test.MembershipContractAdd(MSHongKong,'入会金',10);

        MSHongKong = wb_Membership_Test.MembershipContractAdd(MSHongKong,'単身',5);

        
        MSHongKong.removeEmptyRow();
        MSHongKong = wb_Membership_Test.MembershipContractAdd(MSHongKong,'家族',2);
 
        MSHongKong.removeEmptyRow();
        MSHongKong = wb_Membership_Test.MembershipContractAdd(MSHongKong,'無記名',null);
  
        
        MSHongKong.Membership.Currency__c ='JPY';
        MSHongKong.ChangeCurrency();
        MSHongKong.GetGroupDiscountPercentage();
        MSHongKong.removeEmptyRow();

        MSHongKong.ValidateAndUpdate();

        
        
        PageReference pageRef = Page.wb_Membership_Edit;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(new wb_Membership__c());
        
        sc = new ApexPages.Standardcontroller(new wb_Membership__c());
        wb_Membership MS = new wb_Membership(sc);
        MS.Membership = MSHongKong.Membership;
        
        MS.start_View();
        
        MS.removeEmptyRow();
        MS.theMembershipDetail[2].IsSelected = true;
        MS.DeleteSelectedRows();
        MS.ValidateMembershipFee();
   		MS.ValidateAndUpdate();

           
        MS.GenerateMemeberNo();
        MS.Confirm(); 
        
     	wb_Membership_Renewal RenewalData = new wb_Membership_Renewal(MS.Membership);
          
        pageRef = Page.wb_Membership_RenewalExport;
        pageRef.getParameters().put('id', String.valueOf(MS.Membership.id));
 
        Test.setCurrentPage(pageRef);
        RenewalData = new wb_Membership_Renewal();
        
      
    }
    
        @isTest static void test_3(){
        
       Account theCompanyHongKong = wb_Membership_Test.CreateCompany('ウェルビー Holding',
                                           'WellBe Holding Ltd',
                                           'アジア',
                                           '香港',
                                           '香港',
                                           '香港',
                                           'HKD');
        //system.debug(theCompanyHongKong);
        wb_Membership_Test WBT = new wb_Membership_Test();
      //  WBT.Service = TestUtil.createService();
        List<wb_Currency__c> Curr = wb_Membership_Test.CreateCurrency();
        List<wb_BudgetRate__c> BudgetRate = wb_Membership_Test.CreateBudgetRate();
        
        
        wb_Membership MSHongKong = wb_Membership_Test.createMembershipContract(theCompanyHongKong);
        MSHongKong = wb_Membership_Test.MembershipContractAdd(MSHongKong,'入会金',10);

        MSHongKong = wb_Membership_Test.MembershipContractAdd(MSHongKong,'単身',5);

        
        MSHongKong.removeEmptyRow();
        MSHongKong = wb_Membership_Test.MembershipContractAdd(MSHongKong,'家族',2);
 
        MSHongKong.removeEmptyRow();
        MSHongKong = wb_Membership_Test.MembershipContractAdd(MSHongKong,'無記名',null);
  
        
        MSHongKong.Membership.Currency__c ='JPY';
        MSHongKong.ChangeCurrency();
        MSHongKong.GetGroupDiscountPercentage();
        MSHongKong.removeEmptyRow();

        MSHongKong.ValidateAndUpdate();

        
        
        PageReference pageRef = Page.wb_Membership_Edit;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(new wb_Membership__c());
        
        sc = new ApexPages.Standardcontroller(new wb_Membership__c());
        wb_Membership MS = new wb_Membership(sc);
        MS.Membership = MSHongKong.Membership;
        
        MS.start_View();
        
        MS.removeEmptyRow();
        MS.theMembershipDetail[2].IsSelected = true;
        MS.DeleteSelectedRows();
        MS.ValidateMembershipFee();
   		MS.ValidateAndUpdate();

           
        MS.GenerateMemeberNo();
        MS.Confirm();
        
     	wb_Membership_Quotation QuotationData = new wb_Membership_Quotation(MS.Membership);
          
        pageRef = Page.wb_Membership_QuotationExport;
        pageRef.getParameters().put('id', String.valueOf(MS.Membership.id));
       // pageRef.getParameters().put('pv0', 'YES');
      //  InoviceData.SaveOption='YES';
        Test.setCurrentPage(pageRef);
    //    InoviceData.SaveOption='YES';
     //   InoviceData.saveAttachment();
        QuotationData = new wb_Membership_Quotation();
        
      
    }
    
    


}