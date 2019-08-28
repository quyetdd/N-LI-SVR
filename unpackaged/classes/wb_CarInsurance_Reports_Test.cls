@isTest
public class wb_CarInsurance_Reports_Test {
    
      // wb_CarInsurance_InvoiceXls
      // wb_CarInsurance_Data_for_MDReport
      // wb_Ichiroheian_to_CarInsurance
      
    static public Account theContractCompany {get;set;}
    static public wb_Vehicle__c theCar {get;set;}
    static public wb_Vehicle__c the2ndCar {get;set;}
    static public wb_CarInsurance__c theCI {get;set;}

    static public void NewIchiroheian(){
        
        date di = date.valueOf('2017-01-01');
        date ds = date.valueOf('2017-01-01');
        date de = date.valueOf('2017-12-31');
        
        insert new Ichiroheian__c( Name='AX001', CarModel__c='BMW',OwnerKubun__c='所有',Seat__c=5,EngineNo__c='EG2017',CarNo__c='XX',
                               ShiyoCompanyName__c =theContractCompany.id, 
                                  KeiyakuCompanyName__c=theContractCompany.id,
                                  WOInsuranceCompany__c='華泰',
                                WOCommodityName__c='暢行中華',InsurancePlan__c='B',InsuranceShiki__c=di, 
                                PresentInsuranceShiki__c =ds,InsuranceShuki__c=de,
                                WOCommodityNameAlpha__c='Pプラン',WOInsurancePlanAlpha__c='P5',
                                WOInsuranceShikiAlpha__c=di,WOPresentInsuranceShikiAlpha__c=ds, WOInsuranceShukiAlpha__c=de,
                                KeiyakuCountry__c='中国',WOAgency__c='ブローカー',
                                OI_CompanyName__c='太平洋財産保険', OI_InsuranceShiki__c=ds, OI_InsuranceShuki__c=de,
                                VI_CompanyName__c='太平洋財産保険',VI_InsuranceShiki__c=ds,VI_InsuranceShuki__c=de,
                                  OI_KeiyakuArea__c='華中',CarShozokuArea__c='上海'
        );
    }
    static public void NewServices(){
        wb_Service__c G = new wb_Service__c(
            Country__c ='中国', ServiceCompany__c ='華泰', Service__c ='暢行中華',Plan__c ='Pプラン' ,
            ServiceClassification__c = '搭乗',
            CommissionRate__c = 10,
            MainType__c='席数',
            OptionType__c='固定',
            Enable__c = true, DataType__c='G'
        );
        insert G;
        G = [select Country__c, ServiceCompany__c, Service__c, ServiceClassification__c, Enable__c, DataType__c , CommissionRate__c
             from wb_Service__c where id =: G.id];
        
        wb_Service__c M = new wb_Service__c(Currency__c ='RMB', PassengerFee__c=415, DriverFee__c=0 , DriverSeatInsurance__c=0, CommissionRate__c = 10,
                                            Country__c ='中国', ServiceCompany__c ='華泰', Service__c ='暢行中華',Plan__c ='B' ,ServiceClassification__c = '搭乗',
                                            Enable__c = true, Group__c=G.id, DataType__c='M'
                                           );
        insert M;
        wb_Service__c O = new wb_Service__c(Currency__c ='RMB', PassengerFee__c=500,DriverFee__c=0, DriverSeatInsurance__c = null, MaxSeat__c = 99, CommissionRate__c = 10,
                                            Country__c ='中国', ServiceCompany__c ='華泰', Service__c ='Pプラン',Plan__c ='P5' ,ServiceClassification__c = '搭乗',
                                            Enable__c = true, ParentService__c=G.id, DataType__c='O'
                                           );
        insert O;
        
        wb_Service__c CPS = new wb_Service__c(
            Country__c ='中国', Currency__c='RMB',ServiceCompany__c ='太平洋財産保険', Service__c ='車強制保険',
            ServiceClassification__c = '強制',
            Enable__c = true
        );
        insert CPS;
        
        wb_Service__c VLT = new wb_Service__c(
            Country__c ='中国', Currency__c='RMB',ServiceCompany__c ='太平洋財産保険', Service__c ='任意保険',
            ServiceClassification__c = '任意',
            Enable__c = true
        );
        insert VLT;
        
        // Malasia
        
        wb_Service__c MG = new wb_Service__c(
            Country__c ='中国', ServiceCompany__c ='Tokio Marine(Malaysia)', 
            Service__c ='Well Drive',Plan__c ='' ,
            ServiceClassification__c = '搭乗',
            CommissionRate__c = 10,
            MainType__c='固定',
            Enable__c = true, DataType__c='G'
        );
        insert MG;
        
        insert new wb_Service__c (Currency__c ='RMB', PassengerFee__c=1544, DriverFee__c=null , DriverSeatInsurance__c=null,
                                  Country__c ='中国', ServiceCompany__c ='Tokio Marine(Malaysia)', Service__c ='Well Drive',
                                  Plan__c ='プランA' ,ServiceClassification__c = '搭乗',MinSeat__c=5, MaxSeat__c=99, CommissionRate__c = 10,
                                  Enable__c = true, Group__c=MG.id, DataType__c='M'
                                 );
        
    }   
      
    static public wb_CarInsurance__c NewCarInsuranceWithDetail(){
        
        wb_CarInsurance__c CI = new wb_CarInsurance__c (ContractCompany__c=theContractCompany.id,
                                                        Agent__c='ブローカー',
                                                        ContractCountry__c='中国',
                                                        ContractDistrict__c='華中',
                                                        AffiliationDistrict__c='上海',
                                                        Attribute__c='会員企業',
                                                        CommissionCurrency__c='RMB',
                                                        Status__c='未確定',
                                                        ContractDate__c=system.today()
                                                       );
        
        insert CI;
        CI = [select name,ContractCompany__c,Agent__c,ContractCountry__c,ContractDistrict__c,Attribute__c,
              CommissionCurrency__c,Status__c,ContractDate__c,id from wb_CarInsurance__c where id =: CI.id ];
        
        wb_CarInsurancedCars__c CICar = new wb_CarInsurancedCars__c(
            name = CI.name +'-1',
            CarInsurance__c = CI.id,
            Car__c = theCar.id,
            EngineNo__c = theCar.EngineNumber__c,
            Model__c = theCar.Model__c,
            Ownership__c = theCar.Ownership__c,
            RegistryNumber__c = theCar.Name,
            LegalNumberofSeats__c=theCar.LegalNumberofSeats__c,
            UsingCompany__c= theCar.UsingCompany__c);
        
        insert CICar;
        
        date d = system.today();
        date e = d.addYears(1);
        e = e.addDays(-1);
        wb_CIC_Passenger__c p = new wb_CIC_Passenger__c (
            name = CICar.Name +'-P1',
            CarInsurancedCar__c =CICar.ID,
            Car__c = theCar.id,
            Psgr_InsuranceCompany__c ='華泰',
            Psgr_CommodityName__c='暢行中華',
            Psgr_InsurancePlan__c='B',
            Psgr_CurrentStartDate__c = d,
            Psgr_CurrentEndDate__c = e,
            OP_CommodityName__c='Pプラン',
            OP_Plan__c='P5',
            OP_CurrentStartDate__c=d,
            OP_CurrentEndDate__c=e
        );      
        wb_CI_PassangerRow pr = new wb_CI_PassangerRow(p,CI.ContractCountry__c,'RMB',5);
        insert pr.thePassenger;
        
        
        // insert pr.thePassenger;
        
        wb_CIC_Compulsory__c cp = new wb_CIC_Compulsory__c (
            name = CICar.Name +'-C1',
            CarInsurancedCar__c =CICar.ID,
            Car__c = theCar.id,
            Cps_Service__c = null,
            Cps_InsuranceCompany__c= '太平洋財産保険',
            Cps_CurrentStartDate__c =d,
            Cps_CurrentEndDate__c =e,
            Cps_Currency__c = 'RMB',
            Cps_InsuranceAmount__c = 1000,
            Cps_CommissionRate__c = 2,
            Cps_Commission__c = 1000 * 0.02,
            Vlt_Service__c = null,
            Vlt_InsuranceCompany__c='太平洋財産保険',
            Vlt_StartDate__c =d,
            Vlt_EndDate__c =e,
            Vlt_Currency__c = 'RMB',
            Vlt_InsuranceAmount__c = 1000,
            Vlt_CommissionRate__c = 2,
            Vlt_Commission__c = 1000 * 0.02
        );
        wb_CI_CompulsoryRow cps = new wb_CI_CompulsoryRow(CI.ContractCountry__c,'RMB',5,cp);
        cps.fetchComplusoryInsuranceFee();
        cps.fetchVoluntaryInsuranceFee();
        
        insert cps.theCompulsory;
        
         wb_CarInsurancedCars__c CICar2 = new wb_CarInsurancedCars__c(
            name = CI.name +'-2',
            CarInsurance__c = CI.id,
            Car__c = the2ndCar.id,
            EngineNo__c = the2ndCar.EngineNumber__c,
            Model__c = the2ndCar.Model__c,
            Ownership__c = the2ndCar.Ownership__c,
            RegistryNumber__c = the2ndCar.Name,
            LegalNumberofSeats__c=the2ndCar.LegalNumberofSeats__c,
            UsingCompany__c= the2ndCar.UsingCompany__c);
        
        insert CICar2;
        
          wb_CIC_Passenger__c p2 = new wb_CIC_Passenger__c (
            name = CICar2.Name +'-P1',
            CarInsurancedCar__c =CICar2.ID,
            Car__c = the2ndCar.id,
            Psgr_InsuranceCompany__c ='華泰',
            Psgr_CommodityName__c='暢行中華',
            Psgr_InsurancePlan__c='B',
            Psgr_CurrentStartDate__c = null,
            Psgr_CurrentEndDate__c = null,
            OP_CommodityName__c='Pプラン',
            OP_Plan__c='P5',
            OP_CurrentStartDate__c=d,
            OP_CurrentEndDate__c=e
        );      
        wb_CI_PassangerRow pr2 = new wb_CI_PassangerRow(p2,CI.ContractCountry__c,'RMB',5);
        insert pr2.thePassenger;
        
         wb_CIC_Compulsory__c cp2 = new wb_CIC_Compulsory__c (
            name = CICar2.Name +'-C2',
            CarInsurancedCar__c =CICar2.ID,
            Car__c = the2ndCar.id,
            Cps_Service__c = null,
            Cps_InsuranceCompany__c= '太平洋財産保険',
            Cps_CurrentStartDate__c =d,
            Cps_CurrentEndDate__c =e,
            Cps_Currency__c = 'RMB',
            Cps_InsuranceAmount__c = 1000,
            Cps_CommissionRate__c = 2,
            Cps_Commission__c = 1000 * 0.02,
            Vlt_Service__c = null,
            Vlt_InsuranceCompany__c='太平洋財産保険',
            Vlt_StartDate__c =d,
            Vlt_EndDate__c =e,
            Vlt_Currency__c = 'RMB',
            Vlt_InsuranceAmount__c = 1000,
            Vlt_CommissionRate__c = 2,
            Vlt_Commission__c = 1000 * 0.02
        );
        wb_CI_CompulsoryRow cps2 = new wb_CI_CompulsoryRow(CI.ContractCountry__c,'RMB',5,cp2);
        cps2.fetchComplusoryInsuranceFee();
        cps2.fetchVoluntaryInsuranceFee();
        
        insert cps2.theCompulsory;
        
        return CI;
    }
    
    static testMethod void Test_Reports(){
        theContractCompany = new Account(name = 'Contract Company');
        insert theContractCompany;
        
        theCar = new wb_Vehicle__c(  Name='HK234',
                                   EngineNumber__c='EN1234',   Model__c='BMW',
                                   Ownership__c='所有',   LegalNumberofSeats__c=5,
                                   UsingCompany__c =theContractCompany.id
                                  );
        insert theCar;
        
        theCar = [select Name,EngineNumber__c,Model__c,Ownership__c,LegalNumberofSeats__c,UsingCompany__c, id 
                  from wb_Vehicle__c where id =: theCar.id];
        
        the2ndCar = new wb_Vehicle__c(  Name='HK123',
                                      EngineNumber__c='EN123',   Model__c='TOYOTA',
                                      Ownership__c='所有',   LegalNumberofSeats__c=5,
                                      UsingCompany__c =theContractCompany.id
                                     );
        insert the2ndCar;
        
        the2ndCar = [select Name,EngineNumber__c,Model__c,Ownership__c,LegalNumberofSeats__c,UsingCompany__c, id 
                     from wb_Vehicle__c where id =: the2ndCar.id];
        
        NewServices();
        wb_CarInsurance__c CarInsurance = NewCarInsuranceWithDetail();
        
        Test_wb_CarInsurance_InvoiceXls(CarInsurance);
        wb_CarInsuranceBilling.Billing(CarInsurance.id);
        Test_wb_CarInsurance_Data_for_MDReport();
        
    }
    
    static testMethod void Test_ConvertionTool(){
        theContractCompany = new Account(name = 'the Company');
        insert theContractCompany;
        NewServices();
        NewIchiroheian();
        
        PageReference pageRef = Page.wb_Ichiroheian_to_CarInsurance;
        
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(theContractCompany);
        
        wb_Ichiroheian_to_CarInsurance ItoC = new wb_Ichiroheian_to_CarInsurance(sc);
        ItoC.GetIchiroheian();
        ItoC.IchiroheianSelectAll();
        ItoC.Convert_to_New();
        ItoC.fetchCarInfo();
        ItoC.SaveConvertion();
        
        
        PageReference pageRef2 = Page.wb_Ichiroheian_to_CarInsurance;
        
        Test.setCurrentPage(pageRef2);
        ApexPages.Standardcontroller sc2 = new ApexPages.Standardcontroller(theContractCompany);
        
        wb_Ichiroheian_to_CarInsurance ItoC2 = new wb_Ichiroheian_to_CarInsurance(sc2);
        ItoC2.GetIchiroheian();
        ItoC2.selectedValue='2';
        ItoC2.IchiroheianSelectAll();
        ItoC2.Convert_to_New();
        ItoC2.fetchCarInfo();
        ItoC2.SaveConvertion();
        
        
           
    }
    
    static  void Test_wb_CarInsurance_InvoiceXls( wb_CarInsurance__c CI){
        

        
        PageReference pageRef = Page.wb_CarInsurance_InvoiceXls;
        pageRef.getParameters().put('id', String.valueOf(CI.id));
        
        
        Test.setCurrentPage(pageRef);
        //   ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(CarInsurance);
        
        wb_CarInsurance_InvoiceXls nc = new wb_CarInsurance_InvoiceXls();
        
    }
    
    static  void Test_wb_CarInsurance_Data_for_MDReport(){
        PageReference pageRef = Page.wb_CarInsurance_Data_for_MDReport;
        pageRef.getParameters().put('id', String.valueOf(theContractCompany.id));
        
        
        Test.setCurrentPage(pageRef);
        //   ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(CarInsurance);
        
        wb_CarInsurance_Data_for_MDReport nc = new wb_CarInsurance_Data_for_MDReport();
    }
    
}