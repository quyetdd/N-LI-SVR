@isTest
public class wb_CarInsurance_BaseClass_Test {
    // wb_CI_PassangerRow
    // wb_CI_CompulsoryRow
    // wb_CIC_Passenger_redirect
    // wb_CIC_Compulsory_redirect
    // wb_CIC_PassengerDT
    // wb_CIC_CompulsoryDT
    // wb_CarInsurancedCars_redirect

    static public Account theContractCompany {get;set;}
    static public wb_Vehicle__c theCar {get;set;}
    static public wb_CarInsurance__c CI {get;set;}
    static public wb_Service__c G {get;set;}
    static public wb_Service__c M {get;set;}
    static public wb_Service__c O {get;set;}
    static public wb_Service__c CPS {get;set;}
    static public wb_Service__c VLT {get;set;}
    static public List<wb_CarInsurancedCars__c> theCarInsuranceCars {get;set;}
    
    static testMethod void Test0_BasicClass(){
        test.startTest();
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
        
        
        
        NewServices();
        
        
        Test_wb_CI_CompulsoryRow();
        wb_CarInsurance__c CarI = NewCarInsuranceHeaderwithCar();
        Test_wb_CI_PassangerRow(CarI);
        
        test.stopTest(); 
    }
    
    static testMethod void Test1_BasicClass(){
        test.startTest();
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
        
        
        NewServices();
        
        //Test_wb_CarInsuranceBilling();
        Test_wb_CIC_PassengerDT_CIC_CompulsoryDT();
        test.stopTest(); 
    }
    
    static public void NewServices(){
        G = new wb_Service__c(
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
        
        M = new wb_Service__c(Currency__c ='RMB', PassengerFee__c=415, DriverFee__c=0 , DriverSeatInsurance__c=0, CommissionRate__c = 10,
                              Country__c ='中国', ServiceCompany__c ='華泰', Service__c ='暢行中華',Plan__c ='B' ,ServiceClassification__c = '搭乗',
                              Enable__c = true, Group__c=G.id, DataType__c='M'
                             );
        insert M;
        O = new wb_Service__c(Currency__c ='RMB', PassengerFee__c=500,DriverFee__c=0, DriverSeatInsurance__c = null, MaxSeat__c = 99, CommissionRate__c = 10,
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
    
    static public wb_CarInsurance__c NewCarInsuranceHeaderwithCar(){
        
        
        wb_CarInsurance__c CarI = new wb_CarInsurance__c (ContractCompany__c=theContractCompany.id,
                                                          Agent__c='ブローカー',
                                                          ContractCountry__c='中国',
                                                          ContractDistrict__c='華中',
                                                          AffiliationDistrict__c='上海',
                                                          Attribute__c='会員企業',
                                                          CommissionCurrency__c='RMB',
                                                          Status__c='未確定',
                                                          ContractDate__c=system.today()
                                                         );
        
        insert CarI;
        
        CarI = [select name,ContractCompany__c,Agent__c,ContractCountry__c,ContractDistrict__c,Attribute__c,
                CommissionCurrency__c,Status__c,ContractDate__c,id from wb_CarInsurance__c where id =: CarI.id ];
        
        wb_CarInsurancedCars__c CICar = new wb_CarInsurancedCars__c(
            name = CarI.name +'-1',
            CarInsurance__c = CarI.id,
            Car__c = theCar.id,
            EngineNo__c = theCar.EngineNumber__c,
            Model__c = theCar.Model__c,
            Ownership__c = theCar.Ownership__c,
            RegistryNumber__c = theCar.Name,
            LegalNumberofSeats__c=theCar.LegalNumberofSeats__c,
            UsingCompany__c= theCar.UsingCompany__c);
        
        insert CICar;
        
        return CarI;
        
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
            Cps_Service__c = CPS.id,
            Cps_InsuranceCompany__c= CPS.ServiceCompany__c,
            Cps_CurrentStartDate__c =d,
            Cps_CurrentEndDate__c =e,
            Cps_Currency__c = 'RMB',
            Cps_InsuranceAmount__c = 1000,
            Cps_CommissionRate__c = 2,
            Cps_Commission__c = 1000 * 0.02,
            Vlt_Service__c = Vlt.id,
            Vlt_InsuranceCompany__c=Vlt.ServiceCompany__c,
            Vlt_StartDate__c =d,
            Vlt_EndDate__c =e,
            Vlt_Currency__c = 'RMB',
            Vlt_InsuranceAmount__c = 1000,
            Vlt_CommissionRate__c = 2,
            Vlt_Commission__c = 1000 * 0.02
        );
        insert cp;
        
        return CI;
    }
    
    
    static public void Test_wb_CI_CompulsoryRow(){
        
        date d = system.today();
        date e = d.addYears(1);
        e = e.addDays(-1);
        
        wb_CIC_Compulsory__c cp = new wb_CIC_Compulsory__c (
            name = '100000-1-C1',
            Car__c = theCar.id,
            Cps_Service__c = CPS.id,
            Cps_InsuranceCompany__c = CPS.ServiceCompany__c,
            Cps_CurrentStartDate__c =d,
            Cps_CurrentEndDate__c =e,
            Cps_Currency__c = 'RMB',
            Cps_InsuranceAmount__c = 1000,
            Cps_CommissionRate__c = 2,
            Cps_Commission__c = 1000 * 0.02,
            Vlt_Service__c = Vlt.id,
            Vlt_InsuranceCompany__c = VLT.ServiceCompany__c,
            Vlt_StartDate__c =d,
            Vlt_EndDate__c =e,
            Vlt_Currency__c = 'RMB',
            Vlt_InsuranceAmount__c = 1000,
            Vlt_CommissionRate__c = 2,
            Vlt_Commission__c = 1000 * 0.02
        );
        
        wb_CI_CompulsoryRow cr = new wb_CI_CompulsoryRow('中国','RMB',5,cp);
        cr.fetchComplusoryInsuranceFee();
        cr.fetchCpsCommissionRate();
        cr.fetchCpsCommissionFee();
        cr.fetchCps_EndDate();
        cr.fetchVoluntaryInsuranceFee();
        cr.fetchVltCommissionRate();
        cr.fetchVltCommissionFee();
        cr.fetchVlt_EndDate();
        
        List<wb_Service__c> CpsService =[SELECT Id, ServiceCompany__c, Currency__c,
                                         Cps_MedicalCost__c, Cps_AfterDeathImpediment__c, Cps_NoLbtAfterDeathMedicalCost__c, Cps_NoLbtAfterDeathImpediment__c, 
                                         Cps_NoLbtPropertyLoss__c, Cps_PropertyLoss__c, 
                                         CommissionRate__c, ContactNumber__c
                                         FROM wb_Service__c 
                                         where Country__c ='中国' 
                                         and ServiceClassification__c = '強制'  and Enable__c = true
                                         order by ServiceCompany__c ];
        
          cr.fetchComplusoryInsuranceFeeOffline( CpsService);
        
        List<wb_Service__c> VltService = [SELECT Id, Currency__c, ServiceCompany__c, CommissionRate__c
                                          FROM wb_Service__c 
                                          where Country__c  ='中国'   
                                          and ServiceClassification__c = '任意'  and Enable__c = true order by ServiceCompany__c];
        
         cr.fetchVoluntaryInsuranceFeeOffLine( VltService);
        
    }
    
    static public void Test_wb_CI_PassangerRow(wb_CarInsurance__c CarI) {
        
        wb_CarInsurancedCars__c cic = [select id from wb_CarInsurancedCars__c where CarInsurance__c =:CarI.id limit 1]; 
        
        List<wb_Service__c> PsgrService = [ SELECT  ServiceCompany__c, Service__c, Plan__c, MaxSeat__c, MinSeat__c, Currency__c, PassengerFee__c, DriverFee__c,
                                           DriverSeatInsurance__c,CommissionRate__c, group__r.maintype__c, ParentService__c, DataType__c, ParentService__r.Optiontype__c
                                           FROM wb_Service__c 
                                           where  Country__c ='中国'  
                                           and ServiceClassification__c = '搭乗'  
                                           and Enable__c = true 
                                           order by ServiceCompany__c, Service__c, Plan__c, lastmodifieddate desc
                                          ];
        
        date d = system.today();
        date e = d.addYears(1);
        e = e.addDays(-1);
        wb_CIC_Passenger__c p = new wb_CIC_Passenger__c (
            name = '10000-1-P1',
            Psgr_InsuranceCompany__c ='華泰',
            Psgr_CommodityName__c='暢行中華',
            Psgr_CurrentStartDate__c = d,
            Psgr_CurrentEndDate__c = e,
            Psgr_InsurancePlan__c='B',
            OP_CommodityName__c='Pプラン',
            OP_Plan__c='P5',
            OP_CurrentStartDate__c=d,
            OP_CurrentEndDate__c=e
        );      
        
        wb_CI_PassangerRow prow = new wb_CI_PassangerRow(p,'中国','RMB',7);
        
        
        wb_CIC_Passenger__c p2 = new wb_CIC_Passenger__c (
            name = '10000-1-P2',
            Psgr_InsuranceCompany__c ='Tokio Marine(Malaysia)',
            Psgr_CommodityName__c='Well Drive',
            Psgr_InsurancePlan__c='プランA',
            Psgr_CurrentStartDate__c = d,
            Psgr_CurrentEndDate__c = e
        );      
        
        wb_CI_PassangerRow prow2 = new wb_CI_PassangerRow('中国','RMB',5, false, p2);
        prow2.fetchPlanFeeOnly(5);
        prow2.fetchPlanFeeOnly(4,1);
        
        prow2.fetchPsgr_EndDate();
        prow2.thePassenger.OP_CurrentStartDate__c = d;
        prow2.fetchOP_EndDate();
        prow2.fetchOPPlanFee();
        
        prow2.fetchPlanFeeOnlyOffLine( 5 , PsgrService);
        prow2.fetchOPPlanFeeOffLine(PsgrService);
        
        wb_CIC_Passenger__c p3 = new wb_CIC_Passenger__c (
            name = '10000-1-P3',
            Psgr_InsuranceCompany__c ='華泰',
            Psgr_CommodityName__c='暢行中華',
            Psgr_CurrentStartDate__c = d,
            Psgr_CurrentEndDate__c = e.addDays(-30),
            Psgr_InsurancePlan__c='B',
            OP_CommodityName__c='Pプラン',
            OP_Plan__c='P5',
            OP_CurrentStartDate__c=d,
            OP_CurrentEndDate__c=e.addDays(-30)
        );      
        
        wb_CI_PassangerRow prow3 = new wb_CI_PassangerRow('中国','RMB',7, true, p3);
        prow3.fetchPlanFeeOnly(7);
        prow3.fetchPlanFeeOnly(6,1);
        prow3.fetchPsgr_EndDate();
        prow3.fetchOP_EndDate();
        prow3.fetchOPPlanFee();
        prow3.thePassenger.Psgr_InsuranceCompany__c ='華泰';
        prow3.fetchCompanyCommodityPlan();
        prow3.thePassenger.Psgr_CommodityName__c='暢行中華';
        prow3.fetchCommodityOptions();
        prow3.thePassenger.Psgr_InsurancePlan__c='B';
        prow3.fetchPlanFee();
        prow3.fetchOP_CommodityPlan();
        prow3.thePassenger.OP_InsuranceFee__c = 100;
        prow3.thePassenger.OP_Commission__c = 10;
        prow3.ChangetheOPCommission();
        prow3.ChangethePsgrCommission();
        prow3.ChangetheOPInsuranceFee();
        prow3.ChangethePsgrInsuranceFee();
        prow3.ChangetheLegalNumberofSeats();
        prow3.ChangetheNumberofPassagerSeats();
        
        prow3.fetchPlanFeeOnlyOffLine( 5 , PsgrService);
        prow3.fetchOPPlanFeeOffLine(PsgrService);
        
        
        wb_CIC_Passenger__c p4 = new wb_CIC_Passenger__c (
            name = '10000-1-P4',
            Psgr_InsuranceCompany__c ='華泰',
            Psgr_CommodityName__c='暢行中華',
            Psgr_CurrentStartDate__c = d,
            Psgr_CurrentEndDate__c = e,
            Psgr_InsurancePlan__c='B',
            OP_CommodityName__c='Pプラン',
            OP_Plan__c='P5',
            OP_CurrentStartDate__c=d,
            OP_CurrentEndDate__c=e,
            Psgr_RemainInsuranceFee__c =0,
            OP_RemainInsuranceFee__c = 0,
            CarInsurancedCar__c=cic.id
        );
        wb_CI_PassangerRow prow4 = new wb_CI_PassangerRow('中国','RMB',5, false, p4);
        prow4.fetchPlanFeeOnly(5);
        insert prow4.thePassenger;
        
        
        wb_CIC_Passenger__c p4e = new wb_CIC_Passenger__c (
            name = '10000-1-P4e',
            Psgr_InsuranceCompany__c ='華泰',
            Psgr_CommodityName__c='暢行中華',
            Psgr_CurrentStartDate__c = d,
            Psgr_CurrentEndDate__c = e,
            Psgr_InsurancePlan__c='B',
            OP_CommodityName__c='Pプラン',
            OP_Plan__c='P5',
            OP_CurrentStartDate__c=d,
            OP_CurrentEndDate__c=e,
            Psgr_RemainInsuranceFee__c =0,
            OP_RemainInsuranceFee__c = 0
        );
        
        wb_CI_PassangerRow prow4e = new wb_CI_PassangerRow('中国','RMB',5, false, p4e);
        // prow5.fetchPsgr_EndDate();
        system.debug(prow4e.thePassenger.Psgr_CommissionRate__c + ' ' + prow4e.thePassenger.Psgr_InsuranceCompany__c + ' ' + 
                     prow4e.thePassenger.Psgr_CommodityName__c + ' ' +  prow4e.thePassenger.Psgr_InsurancePlan__c  );
        prow4e.fetchPlanFeeOnly(5);
        system.debug(prow4e.thePassenger.Psgr_CommissionRate__c + ' ' + prow4e.thePassenger.Psgr_InsuranceCompany__c + ' ' + 
                     prow4e.thePassenger.Psgr_CommodityName__c + ' ' +  prow4e.thePassenger.Psgr_InsurancePlan__c  );
        
        
        system.debug(prow4e.thePassenger.Psgr_CommissionRate__c );
        prow4e.thePassenger.Psgr_CommissionRate__c = 10;
        prow4e.fetchBillAmount();
        
        wb_CIC_Passenger__c p5 = new wb_CIC_Passenger__c (
            name = '10000-1-P5',
            Psgr_InsuranceCompany__c ='華泰',
            Psgr_CommodityName__c='暢行中華',
            Psgr_CurrentStartDate__c = d,
            Psgr_CurrentEndDate__c = e,
            Psgr_InsurancePlan__c='B',
            OP_CommodityName__c='Pプラン',
            OP_Plan__c='P5',
            OP_CurrentStartDate__c=d,
            OP_CurrentEndDate__c=e,
            Psgr_RemainInsuranceFee__c =0,
            OP_RemainInsuranceFee__c = 0
        );
        
        wb_CI_PassangerRow prow5 = new wb_CI_PassangerRow('中国','RMB',5,p5);
        
        wb_CIC_Passenger__c p6 = new wb_CIC_Passenger__c (
            name = '10000-1-P6',
            Psgr_InsuranceCompany__c ='華泰',
            Psgr_CommodityName__c='暢行中華',
            Psgr_CurrentStartDate__c = d,
            Psgr_CurrentEndDate__c = e,
            Psgr_InsurancePlan__c='B',
            OP_CommodityName__c='Pプラン',
            OP_Plan__c='P5',
            OP_CurrentStartDate__c=d,
            OP_CurrentEndDate__c=e,
            Psgr_RemainInsuranceFee__c =0,
            OP_RemainInsuranceFee__c = 0
        );
        wb_CI_PassangerRow prow6 = new wb_CI_PassangerRow('中国','RMB',5,true,p6,e.addDays(-30),'');
        
        
        
        wb_CIC_Passenger__c p7 = p4.clone(false);
        p7.name = '10000-1-P7';
        

        
        wb_CI_PassangerRow prow7 = new wb_CI_PassangerRow(p7);
        prow7.theCountry = '中国';
        prow7.theCommissionCurrency = 'RMB';
        prow7.theLegalNumberofSeats = 5;
        prow7.fetchPlanFeeOnlyOffLine( 5 , PsgrService);
        prow7.fetchOPPlanFeeOffLine(PsgrService);
        
    }
        
    static public void Test_wb_CIC_PassengerDT_CIC_CompulsoryDT(){
        
        wb_CarInsurance__c CarInsurance = NewCarInsuranceWithDetail();
        // wb_CarInsuranceBilling.Billing(CarInsurance.id);
        wb_CarInsurancedCars__c CICar = [ select id from wb_CarInsurancedCars__c where CarInsurance__c =:CarInsurance.id];
        
        PageReference pageRef = Page.wb_CIC_CompulsoryDT;
        pageRef.getParameters().put('id', String.valueOf(CarInsurance.id));
        pageRef.getParameters().put('pv0',  String.valueOf(CICar.id));
        
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(CarInsurance);
        
        wb_CIC_CompulsoryDT nc = new wb_CIC_CompulsoryDT(sc);
        
        PageReference pageRef2 = Page.wb_CIC_PassengerDT;
        pageRef2.getParameters().put('id', String.valueOf(CarInsurance.id));
        pageRef2.getParameters().put('pv0',  String.valueOf(CICar.id));
        
        Test.setCurrentPage(pageRef2);
        ApexPages.Standardcontroller sc2 = new ApexPages.Standardcontroller(CarInsurance);
        
        wb_CIC_PassengerDT nc2 = new wb_CIC_PassengerDT(sc2);
        
        wb_CIC_Passenger__c p = [select id from wb_CIC_Passenger__c where CarInsurancedCar__c =:CICar.id];
        
        PageReference pageRef3 = Page.wb_CIC_Passenger_redirect;
        Test.setCurrentPage(pageRef3);
        ApexPages.Standardcontroller sc3 = new ApexPages.Standardcontroller(p);
        
        wb_CIC_Passenger_redirect nc3 = new wb_CIC_Passenger_redirect(sc3);
        nc3.redirect();
        
        
        
      wb_CIC_Compulsory__c c = [select id from wb_CIC_Compulsory__c where CarInsurancedCar__c =:CICar.id];
        
        PageReference pageRef4 = Page.wb_CIC_Compulsory_redirect;
        Test.setCurrentPage(pageRef4);
        ApexPages.Standardcontroller sc4 = new ApexPages.Standardcontroller(c);
        wb_CIC_Compulsory_redirect nc4 = new wb_CIC_Compulsory_redirect(sc4);
        nc4.redirect();
        

        
        
       // wb_CarInsurancedCars__c cc = [select id from wb_CarInsurancedCars__c where CarInsurance__c =:CICar.id];
        
        PageReference pageRef5 = Page.wb_CarInsurancedCars_redirect;
        Test.setCurrentPage(pageRef5);
        ApexPages.Standardcontroller sc5 = new ApexPages.Standardcontroller(CICar);
        wb_CarInsurancedCars_redirect nc5 = new wb_CarInsurancedCars_redirect(sc5);
        nc5.redirect();        
    }
    
    
    
    
    
}