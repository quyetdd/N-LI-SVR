@isTest
public class wb_Service_Test {
    static public wb_Service__c G {get;set;}
    static public wb_Service__c M {get;set;}
    static public wb_Service__c O {get;set;}
    static public wb_Service__c CPS {get;set;}
    static public wb_Service__c VLT {get;set;}
    
    
    static testMethod void Test_wb_Service_Car(){
                 G = new wb_Service__c(
            Country__c ='中国', ServiceCompany__c ='華泰', Service__c ='暢行中華',Plan__c ='Pプラン' ,ServiceClassification__c = '搭乗',
            Enable__c = true, DataType__c='G'
        );
        insert G;
        G = [select Country__c, ServiceCompany__c, Service__c, ServiceClassification__c, Enable__c, DataType__c 
             from wb_Service__c where id =: G.id];
        
        M = new wb_Service__c(Currency__c ='RMB', PassengerFee__c=415, DriverFee__c=0 , DriverSeatInsurance__c=0,
                              Country__c ='中国', ServiceCompany__c ='華泰', Service__c ='暢行中華',Plan__c ='B' ,ServiceClassification__c = '搭乗',
                              Enable__c = true, Group__c=G.id, DataType__c='M'
                             );
        insert M;
        O = new wb_Service__c(Currency__c ='RMB', PassengerFee__c=500,DriverFee__c=0, DriverSeatInsurance__c = null, MaxSeat__c = 99,
                              Country__c ='中国', ServiceCompany__c ='華泰', Service__c ='Pプラン',Plan__c ='P5' ,ServiceClassification__c = '搭乗',
                              Enable__c = true, ParentService__c=G.id, DataType__c='O'
                             );
        insert O;
        
        CPS = new wb_Service__c(
            Country__c ='中国', Currency__c='RMB',ServiceCompany__c ='太平洋財産保険', Service__c ='車強制保険',
            ServiceClassification__c = '強制',
            Enable__c = true
        );
        insert CPS;
        
        VLT = new wb_Service__c(
            Country__c ='中国', Currency__c='RMB',ServiceCompany__c ='太平洋財産保険', Service__c ='任意保険',
            ServiceClassification__c = '任意',
            Enable__c = true
        );
        insert VLT;
        
        PageReference pageRef = Page.wb_Service;
        Test.setCurrentPage(pageRef);
        wb_Service__c s = new wb_Service__c();
        ApexPages.Standardcontroller ctl = new ApexPages.Standardcontroller(s);
        
        wb_Service wb_s = new wb_Service(ctl);
       //   Country__c ='中国', ServiceCompany__c ='華泰', Service__c ='暢行中華',Plan__c ='A' ,ServiceClassification__c = '搭乗',
        //    Enable__c = true, DataType__c='G'
      
        wb_s.selectedServiceClassification ='搭乗';
        wb_s.fetchServiceGroupOtn();
        wb_s.ServiceGroupOtn.selectedCountry='中国';
        wb_s.fetchCurrencyOptions();
        wb_s.ServiceGroupOtn.selectedCurrency='RMB';
        wb_s.fetchInsuranceCompanyOptions();
        wb_s.ServiceGroupOtn.selectedInsuranceCompany='華泰';
        wb_s.fetchServiceOptions();
        wb_s.ServiceGroupOtn.selectedService='暢行中華';
        wb_s.fetchServiceGroupOptions();
        wb_s.ServiceGroupOtn.selectedGroupID =G.id;
        wb_s.GetPsgService();
        
        wb_s.ServiceGroupOtn.selectedCountry='中国';
        wb_s.fetchCurrencyOptions();
        wb_s.ServiceGroupOtn.selectedCurrency='RMB';
        wb_s.fetchInsuranceCompanyOptions();
        wb_s.ServiceGroupOtn.selectedInsuranceCompany='華泰';
        wb_s.fetchServiceOptions();
        wb_s.ServiceGroupOtn.selectedService='暢行中華';
        wb_s.fetchServiceGroupOptions();
        wb_s.ServiceGroupOtn.selectedGroupID ='--New--';
        wb_s.GetPsgService();
        wb_s.PSGService.UpdateRecord();
        wb_s.PSGService.AddMainService();
  		wb_s.PSGService.AddOpService();
        
        wb_s.ServiceGroupOtn.selectedCountry='中国';
        wb_s.fetchCurrencyOptions();
        wb_s.ServiceGroupOtn.selectedCurrency='RMB';
        wb_s.fetchInsuranceCompanyOptions();
        wb_s.ServiceGroupOtn.selectedInsuranceCompany='華泰';
        wb_s.fetchServiceOptions();
        wb_s.ServiceGroupOtn.selectedService='--New--';
        wb_s.fetchServiceGroupOptions();
        
        wb_s.ServiceGroupOtn.selectedCountry='中国';
        wb_s.fetchCurrencyOptions();
        wb_s.ServiceGroupOtn.selectedCurrency='--New--';
        wb_s.fetchInsuranceCompanyOptions();

        wb_s.ServiceGroupOtn.selectedCountry='--New--';
        wb_s.fetchCurrencyOptions();

        
        wb_s.ServiceGroupOtn.selectedCountry='中国';
        wb_s.fetchCurrencyOptions();
        wb_s.ServiceGroupOtn.selectedCurrency='RMB';
        wb_s.fetchInsuranceCompanyOptions();
        wb_s.ServiceGroupOtn.selectedInsuranceCompany='--New--';
        wb_s.fetchServiceOptions();
        wb_s.PSGService.PsgrGroup.ServiceCompany__c='ABC Company';
        wb_s.PSGService.PsgrGroup.Service__c='暢行';
        wb_s.PSGService.PsgrGroup.MainType__c='席数';
        wb_s.PSGService.NewMainService();
        wb_s.PSGService.PsgrMain[0].Plan__c ='A';
        wb_s.PSGService.PsgrMain[0].DriverSeatInsurance__c=0;
        wb_s.PSGService.PsgrMain[0].DriverFee__c=0;
        wb_s.PSGService.PsgrMain[0].PassengerFee__c=100;
        wb_s.PSGService.SaveNew();
       
        wb_s.PSGService.PsgrGroup.Plan__c ='OP';
        wb_s.PSGService.PsgrGroup.MainType__c='固定';
         wb_s.PSGService.NewOpService();
            
    }

    /*
    static testMethod void Test_wb_Service_BL(){
        wb_Service__c pservice = new wb_Service__c(Service__c='オフィスバッゲージ',ServiceCompany__c='ALL',ParentService__c=null,ServiceClassification__c='BL');
        insert pservice;
        insert new wb_Service__c(Service__c='補償対象地／エリア',ServiceCompany__c='ALL',ParentService__c=pservice.id,ServiceClassification__c='BL');
        insert new wb_Service__c(Service__c='建物、内装',ServiceCompany__c='ALL',ParentService__c=pservice.id,ServiceClassification__c='BL');
        insert new wb_Service__c(Service__c='営業中断',ServiceCompany__c='ALL',ParentService__c=pservice.id,ServiceClassification__c='BL');
        
        PageReference pageRef = Page.wb_Service;
        Test.setCurrentPage(pageRef);
        wb_Service__c s = new wb_Service__c();
        ApexPages.Standardcontroller ctl = new ApexPages.Standardcontroller(s);
        
        wb_Service wb_s = new wb_Service(ctl);
        
        wb_s.selectedServiceClassification ='BL';
        wb_s.fetchServiceGroupOtn();
        wb_s.BL.selectedInsurance=pservice.id;
        wb_s.BL.fetchInsuranceItem();
        wb_s.BL.AddNewInsuranceItem();
        wb_s.BL.item[wb_s.BL.item.size()-1].Service__c='現金';
        wb_s.BL.SaveInsuranceItem();
        // Remove Item
        wb_s.BL.InsuranceItemRemoveIndex = 1;
        wb_s.BL.InsuranceItemRemoveId = wb_s.BL.item[0].id;
        wb_s.BL.InsuranceItemRemove();
        
        wb_s.selectedServiceClassification ='';
        wb_s.fetchServiceGroupOtn();
        wb_s.selectedServiceClassification ='BL';
        wb_s.fetchServiceGroupOtn();
        wb_s.BL.selectedInsurance='--New--';
        wb_s.BL.fetchInsuranceItem();
        wb_s.BL.new_pservice.Service__c='財産';
        wb_s.BL.AddNewInsurance();
        
    }
*/
}