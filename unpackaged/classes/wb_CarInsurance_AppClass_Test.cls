@isTest
public class wb_CarInsurance_AppClass_Test {
    // wb_CI_InsurancedCarRow
    // wb_CarInsuranceDetailView
    // wb_CarInsuranceCarsDetail
    // wb_CarInsuranceClone
    // wb_CarInsuranceBilling
    // wb_CarInsuranceAmend
    // wb_CI_PolicyNumber
    // wb_CarInsurance
    // wb_CI_Searching
    
    static public Account theContractCompany {get;set;}
    static public wb_Vehicle__c theCar {get;set;}
    static public wb_CarInsurance__c CI {get;set;}
    static public wb_Service__c CPS {get;set;}
    static public wb_Service__c VLT {get;set;}
    
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
    
    static testMethod void Test1(){
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
        
        
        PageReference pageRef = Page.wb_CarInsurance;
        // pageRef.getParameters().put('id', String.valueOf(CI.id));
        
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(new wb_CarInsurance__c());
        
        wb_CarInsurance sc_a = new wb_CarInsurance(sc);
        
        // sc_a.validateHeader();
        
        wb_CarInsurance__c CarInsurance = NewCarInsuranceWithDetail();
        
        PageReference pageRef_b = Page.wb_CarInsurance;
        // pageRef.getParameters().put('id', String.valueOf(CI.id));
        
        Test.setCurrentPage(pageRef_b);
        ApexPages.Standardcontroller scb = new ApexPages.Standardcontroller(CarInsurance);
        
        wb_CarInsurance sc_ab = new wb_CarInsurance(scb);
        sc_ab.CarFilter = 'HK';
        sc_ab.ApplyFilter2CarsList();
        sc_ab.RemoveEmptyRecord();
        
        
        wb_CarInsurancedCars__c wb_CarInsurancedCars = [select id, CarInsurance__c from wb_CarInsurancedCars__c where CarInsurance__c =: CarInsurance.id ];
        
        PageReference pageRef2 = Page.wb_CarInsurancedCars_redirect;
        Test.setCurrentPage(pageRef2);
        ApexPages.Standardcontroller sc2 = new ApexPages.Standardcontroller(wb_CarInsurancedCars);
        wb_CarInsurancedCars_redirect nc2 = new wb_CarInsurancedCars_redirect(sc2);
        nc2.redirect();
        
        Test_wb_CarInsurance_CarInsuranceCarsDetail(CarInsurance);
        //  Test_wb_CarInsurance_InvoiceXls(CarInsurance);
        //Test_wb_map_Ichiroheian(CarInsurance);
        
        
        test.stopTest(); 
    }
    
    static testMethod void Test2(){
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
        
        Test_wb_CarInsuranceBilling();
        Test_wb_CarInsurance_Continue_Copy();
        
        
        
        test.stopTest();
    } 
    
    static testMethod void Test3(){
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
        
        Test_wb_CarInsuranceAmend_Terminate(); 
        
        Test_wb_CarInsuranceAmend_Replacement();
        
        
        test.stopTest();
    }
    
    static testMethod void Test3b(){
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
        
        
        Test_wb_CarInsuranceAmend_Replacement2();
        
        test.stopTest();
    }
    
    static testMethod void Test4(){
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
        
        
        
        Test_wb_CarInsuranceAmend_AdditionalCar();
        
        test.stopTest();
    }
    
    
    static testMethod void Test5(){
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
        
        Test_wb_CI_PolicyNumber();
        Test_wb_CI_Searching();
        test.stopTest();
    }
    
    static public void Test_wb_CarInsurance_CarInsuranceCarsDetail(wb_CarInsurance__c CIns) {
        
        //  NewCarandServices();
        //    theCarInsurance = NewCarInsuranc();
        
        //    wb_CarInsuranceDetailView
        PageReference pageRefv = Page.wb_CarInsurance;
        Test.setCurrentPage(pageRefv);
        ApexPages.Standardcontroller scv = new ApexPages.Standardcontroller(CIns);
        
        wb_CarInsuranceDetailView ncv = new wb_CarInsuranceDetailView(scv);
        
        
        PageReference pageRef = Page.wb_CarInsurance;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(CIns);
        
        wb_CarInsurance nc = new wb_CarInsurance(sc);
        nc.getStatus();
        SelectOption[] StatusItems = nc.getStatusItems();
        nc.fetchAttribute();
        nc.fetchAgentOptions();
        nc.fetchContractCountryOptions();
        nc.fetchContractDistrictOptions();
        nc.fetchAffiliationDistrictOptions();
        nc.CarInsurance.Attribute__c ='会員企業';
        
        //  nc.NewInsurancedCars();
        system.debug( nc.InsurancedCarsList.size() +' ' + nc.InsurancedCars.size() );
        nc.NewInsurancedCarsofList();
        system.debug( nc.InsurancedCarsList.size() +' ' + nc.InsurancedCars.size());
        
        for ( wb_CI_InsurancedCarRow CI:nc.InsurancedCarsList){
            CI.theCar.Car__c = theCar.id;
            CI.theCar.EngineNo__c = theCar.EngineNumber__c;
            CI.theCar.Model__c = theCar.Model__c;
            CI.theCar.Ownership__c = theCar.Ownership__c;
            CI.theCar.Model__c = theCar.Model__c;
            CI.theCar.RegistryNumber__c = theCar.Name;
            CI.theCar.UsingCompany__c= theCar.UsingCompany__c;
            CI.theCar.LegalNumberofSeats__c = theCar.LegalNumberofSeats__c;
        }
        
     	nc.theInsurancedCarsIndex = 2;
        nc.RetriveCarInfo();
        nc.UpdateRecords();
        nc.validateAndUpdate();
        nc.theInsurancedCarsId = nc.InsurancedCarsList[1].theCar.id;
        nc.theInsurancedCarsIndex = 2;
        nc.InsurancedCars_Remove();
        system.debug( nc.InsurancedCarsList.size() +' ' + nc.InsurancedCars.size());
        
       // nc.UpdateRecords();
      //  nc.validateAndUpdate();
        nc.validateAndSave();
        nc.CurrencyOptions = nc.getCurrencyOptions();
        // nc.Cancel();
        
        
        wb_CarInsurancedCars__c CICar = [ select id from wb_CarInsurancedCars__c where CarInsurance__c =:CIns.id limit 1];
        ApexPages.Standardcontroller ci_d = new ApexPages.Standardcontroller(CICar);
        wb_CarInsuranceCarsDetail cid = new wb_CarInsuranceCarsDetail(ci_d);
        cid.validate();
        cid.ValidateSave();
        cid.NewPassengerInsurance();
        
        cid.thePassengerIndex=1;
        cid.PassengerDT_remove();
        cid.NewCompulsoryInsurance();
        
        cid.theCompulsoryIndex=1;
        cid.CompulsoryDT_remove();
        cid.ValidateSaveClose();
        //  cid.Cancel();
        //  
        
        wb_CarInsurancedCars__c CICar2 = new wb_CarInsurancedCars__c();
        CICar2.CarInsurance__c = CIns.id;
        ApexPages.Standardcontroller ci_d2 = new ApexPages.Standardcontroller(CICar2);
        wb_CarInsuranceCarsDetail cid2 = new wb_CarInsuranceCarsDetail(ci_d2);
        
        
    }
    /*
static public void Test_wb_CarInsurance_InvoiceXls( wb_CarInsurance__c CI){
// NewCarandServices();
// wb_CarInsurance__c CarInsurance = NewCarInsuranc();

PageReference pageRef = Page.wb_CarInsurance_InvoiceXls;
pageRef.getParameters().put('id', String.valueOf(CI.id));


Test.setCurrentPage(pageRef);
//   ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(CarInsurance);

wb_CarInsurance_InvoiceXls nc = new wb_CarInsurance_InvoiceXls();

}
*/
    static public void Test_wb_CarInsuranceBilling(){
        
        wb_CarInsurance__c CarInsurance = NewCarInsuranceWithDetail();
        wb_CarInsuranceBilling.Billing(CarInsurance.id);
        wb_CarInsuranceBilling.CancelBilling(CarInsurance.id);
        
        wb_CarInsuranceBilling CB = new wb_CarInsuranceBilling();
        CB.BillingList = new List<wb_CarInsuranceBilling.BillingClass>();
        CB.BillingList.add( new wb_CarInsuranceBilling.BillingClass('a',CarInsurance.id,'b',10,'c',1));
        
    }
    
    static public void Test_wb_CarInsurance_Continue_Copy(){
        
        wb_CarInsurance__c CarInsurance = NewCarInsuranceWithDetail();
        wb_CarInsuranceBilling.Billing(CarInsurance.id);
        List<wb_CarInsurancedCars__c>  Cic = [select id from wb_CarInsurancedCars__c where CarInsurance__c =: CarInsurance.id];
        List<wb_CIC_Passenger__c> Psgr = [select id from wb_CIC_Passenger__c where CarInsurancedCar__r.CarInsurance__c =: CarInsurance.id];
        system.debug( 'Test_wb_CarInsurance_Continue_Copy' + Cic.size() + ' ' + Psgr.size());
        
        PageReference pageRef0 = Page.wb_CarInsuranceContinue;
        
        Test.setCurrentPage(pageRef0);
        ApexPages.Standardcontroller sc0 = new ApexPages.Standardcontroller(CarInsurance);
        
        wb_CarInsuranceClone nc0 = new wb_CarInsuranceClone(sc0);
        nc0.CIContinue();
        
        PageReference pageRef0b = Page.wb_CarInsuranceContinue;
        
        Test.setCurrentPage(pageRef0b);
        ApexPages.Standardcontroller sc0b = new ApexPages.Standardcontroller(CarInsurance);
        
        wb_CarInsuranceClone nc0b = new wb_CarInsuranceClone(sc0b);
        nc0b.CreateOldListforSelectandContinue();
        
        for ( wb_CI_InsurancedCarRow sl:nc0b.OldInsurancedCarsList)
            sl.IsSelected = true;
        
        nc0b.ApplytoContinue();
        nc0b.SaveSelectContinue();
        
        wb_CarInsuranceBilling.CancelBilling(CarInsurance.id);
        
        PageReference pageRef = Page.wb_CarInsuranceClone;
        
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(CarInsurance);
        
        wb_CarInsuranceClone nc = new wb_CarInsuranceClone(sc);
        nc.CIClone();
        
    }
    
    static public void Test_wb_CarInsuranceAmend_Terminate() {
        
        
        // NewCarandServices();
        wb_CarInsurance__c CarInsurance = NewCarInsuranceWithDetail();
        // wb_CarInsuranceBilling billing = new wb_CarInsuranceBilling();
        wb_CarInsuranceBilling.Billing(CarInsurance.id);
        
        // if( billing.BillingCarInsurance(CarInsurance.id) == true){
        
        wb_CarInsurancedCars__c CICar = [ select id from wb_CarInsurancedCars__c where CarInsurance__c =:CarInsurance.id];
        
        PageReference pageRef = Page.wb_CarInsuranceAmend;
        pageRef.getParameters().put('id', String.valueOf(CarInsurance.id));
        pageRef.getParameters().put('pv0',  String.valueOf(CICar.id));
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller cia = new ApexPages.Standardcontroller(CarInsurance);
        
        
        
        wb_CarInsuranceAmend ci_a = new wb_CarInsuranceAmend(cia);
        date d = system.today();
        //ci_a.ChangeOption.TerminateDate = d.addDays(30);
        ci_a.ChangeOption.NewCar.ReplacedDate__c = d.addDays(30);
        ci_a.ChangeOption.PsgrTerminate = true;
        ci_a.ChangeOption.CpsTerminate = true;
        ci_a.ChangeOption.VltTerminate = true;
        ci_a.ChangeOption.OpnCarTerminate = true;
        ci_a.ChangeOption.OpnCarExchange = false;
        ci_a.ReplacementDateValidation(); 
        ci_a.SaveRefund();
        //  }
        
        
    }
    
    static public void Test_wb_CarInsuranceAmend_Replacement() {
        
        
        // NewCarandServices();
        wb_CarInsurance__c CarInsurance = NewCarInsuranceWithDetail();
        
        wb_CarInsuranceBilling.Billing(CarInsurance.id);
        
        
        
        wb_CarInsurancedCars__c CICar = [ select id from wb_CarInsurancedCars__c where CarInsurance__c =:CarInsurance.id];
        
        PageReference pageRef = Page.wb_CarInsuranceAmend;
        pageRef.getParameters().put('id', String.valueOf(CarInsurance.id));
        pageRef.getParameters().put('pv0',  String.valueOf(CICar.id));
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller cia = new ApexPages.Standardcontroller(CarInsurance);
        
        
        
        wb_CarInsuranceAmend ci_a = new wb_CarInsuranceAmend(cia);
        date d = system.today();
        
        
        
        //ci_a.RetriveAddtionalCarInfo();
        ci_a.ChangeOption.OpnCarTerminate = false;
        ci_a.ChangeOption.OpnCarExchange = true;
        ci_a.ChangeOption.NewCar.ReplacedDate__c = d.addDays(30);
        //ci_a.ChangeOption.NewCar.Car__c = theCar.Id;
        ci_a.CarInsuranceAdditionalCar.car__c = theCar.Id;
        ci_a.RetriveAddtionalCarInfo();
        
        ci_a.ReplacementDateValidation(); 
        
        ci_a.NewAdditionalPassengerInsurance();
        ci_a.NewAdditionalCompulsoryInsurance();
        ci_a.theAdditionalCompulsoryIdx = 1;
        ci_a.AdditionalCompulsoryDT_remove();
        ci_a.theAdditionalPassengerIdx = 2;
        ci_a.AdditionalPassengerDT_remove();
        ci_a.SaveCarReplacementAsDrift();
        ci_a.SaveCarReplacement();
        
        
        
    }
    
    
    static public void Test_wb_CarInsuranceAmend_Replacement2() {
        
        
        // NewCarandServices();
        wb_CarInsurance__c CarInsurance = NewCarInsuranceWithDetail();
        
        wb_CarInsuranceBilling.Billing(CarInsurance.id);
        
        
        
        wb_CarInsurancedCars__c CICar = [ select id from wb_CarInsurancedCars__c where CarInsurance__c =:CarInsurance.id];
        
        PageReference pageRef = Page.wb_CarInsuranceAmend;
        pageRef.getParameters().put('id', String.valueOf(CarInsurance.id));
        pageRef.getParameters().put('pv0',  String.valueOf(CICar.id));
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller cia = new ApexPages.Standardcontroller(CarInsurance);
        
        
        
        wb_CarInsuranceAmend ci_a = new wb_CarInsuranceAmend(cia);
        date d = system.today();
        
        
        
        //ci_a.RetriveAddtionalCarInfo();
        ci_a.ChangeOption.OpnCarTerminate = false;
        ci_a.ChangeOption.OpnCarExchange = true;
        ci_a.ChangeOption.NewCar.ReplacedDate__c = d.addDays(30);
        //ci_a.ChangeOption.NewCar.Car__c = theCar.Id;
        ci_a.CarInsuranceAdditionalCar.car__c = theCar.Id;
        ci_a.RetriveAddtionalCarInfo();
        
        ci_a.ReplacementDateValidation(); 
        
        ci_a.NewAdditionalPassengerInsurance();
        ci_a.NewAdditionalCompulsoryInsurance();
        ci_a.theAdditionalCompulsoryIdx = 1;
        ci_a.AdditionalCompulsoryDT_remove();
        ci_a.theAdditionalPassengerIdx = 2;
        ci_a.AdditionalPassengerDT_remove();
        ci_a.SaveCarReplacementAsDrift();
        ci_a.ValidateConfirmCarReplacementDrift();
        
        
        
    }
    
    
    static public void Test_wb_CarInsuranceAmend_AdditionalCar() {
        
        system.debug('Test_wb_CarInsuranceAmend_AdditionalCar');
        
        wb_CarInsurance__c CarInsurance = NewCarInsuranceWithDetail();
        
        wb_CarInsuranceBilling.Billing(CarInsurance.id);
        
        
        wb_CarInsurancedCars__c CICar = [ select id from wb_CarInsurancedCars__c where CarInsurance__c =:CarInsurance.id];
        
        PageReference pageRef = Page.wb_CarInsuranceAmend;
        pageRef.getParameters().put('id', String.valueOf(CarInsurance.id));
        pageRef.getParameters().put('pv0', 'null');
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller cia = new ApexPages.Standardcontroller(CarInsurance);
        
        wb_CarInsuranceAmend ci_a = new wb_CarInsuranceAmend(cia);
        date d = system.today();
        
        
        ci_a.CarInsuranceAdditionalCar.car__c = theCar.Id;
        ci_a.RetriveAddtionalCarInfo();
        
        ci_a.NewAdditionalPassengerInsurance();
        
        for ( wb_CI_PassangerRow pr:ci_a.PassengerAdditionalDT) {
            
            pr.thePassenger.Car__c = theCar.id;
            pr.thePassenger.Psgr_InsuranceCompany__c ='華泰';
            pr.thePassenger.Psgr_CommodityName__c='暢行中華';
            pr.thePassenger.Psgr_InsurancePlan__c='B';
            pr.thePassenger.Psgr_CurrentStartDate__c = d;
            pr.thePassenger.OP_CommodityName__c='Pプラン';
            pr.thePassenger.OP_Plan__c='P5';
            pr.thePassenger.OP_CurrentStartDate__c=d;
            
        }
        ci_a.ValidateSaveAddtionalCarasDraft();
        
        
        PageReference pageRef2 = Page.wb_CarInsuranceAmend;
        pageRef2.getParameters().put('id', String.valueOf(CarInsurance.id));
        string pv0 = 'null';
        pageRef2.getParameters().put('pv0', pv0);
        system.debug('pv1:' + ci_a.CarInsuranceAdditionalCar.id);
        pageRef2.getParameters().put('pv1',String.valueOf(ci_a.CarInsuranceAdditionalCar.id));
        Test.setCurrentPage(pageRef2);
        ApexPages.Standardcontroller cia2 = new ApexPages.Standardcontroller(CarInsurance);
        wb_CarInsuranceAmend ci_a2 = new wb_CarInsuranceAmend(cia2);
        ci_a2.ValidateConfirmAddtionalCarasDraft();
        
        
        PageReference pageRef3 = Page.wb_CarInsurance;
        Test.setCurrentPage(pageRef3);        
        ApexPages.Standardcontroller cia3 = new ApexPages.Standardcontroller(CarInsurance);
        wb_CarInsurance ci_a3 = new wb_CarInsurance(cia2);
        ci_a3.thePendingCarsId = ci_a.CarInsuranceAdditionalCar.id;
        ci_a3.PendingCars_Remove();
        
        
        PageReference pageRef4 = Page.wb_CarInsuranceAmend;
        pageRef4.getParameters().put('id', String.valueOf(CarInsurance.id));
        pageRef4.getParameters().put('pv0', 'null');
        Test.setCurrentPage(pageRef4);
        ApexPages.Standardcontroller cia4 = new ApexPages.Standardcontroller(CarInsurance);
        wb_CarInsuranceAmend ci_a4 = new wb_CarInsuranceAmend(cia4);
        d = system.today();
        
        
        ci_a4.CarInsuranceAdditionalCar.car__c = theCar.Id;
        ci_a4.RetriveAddtionalCarInfo();
        
        ci_a4.NewAdditionalPassengerInsurance();
        
        for ( wb_CI_PassangerRow pr:ci_a4.PassengerAdditionalDT) {
            
            pr.thePassenger.Car__c = theCar.id;
            pr.thePassenger.Psgr_InsuranceCompany__c ='華泰';
            pr.thePassenger.Psgr_CommodityName__c='暢行中華';
            pr.thePassenger.Psgr_InsurancePlan__c='B';
            pr.thePassenger.Psgr_CurrentStartDate__c = d;
            pr.thePassenger.OP_CommodityName__c='Pプラン';
            pr.thePassenger.OP_Plan__c='P5';
            pr.thePassenger.OP_CurrentStartDate__c=d;
            pr.fetchPsgr_EndDate();
            
        }
        ci_a4.ValidateSaveAddtionalCarasDraft();
        ci_a4.ValidateSaveAddtionalCar();
        
        // ci_a.ValidateSaveAddtionalCar();
        
    }
    
    static public void Test_wb_CI_PolicyNumber(){
        // NewCarandServices();
        wb_CarInsurance__c CarInsurance = NewCarInsuranceWithDetail();
        
        PageReference pageRef = Page.wb_CI_PolicyNumber;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller cia = new ApexPages.Standardcontroller(CarInsurance);
        
        wb_CI_PolicyNumber ci_pl = new wb_CI_PolicyNumber(cia);
        
        ci_pl.selectedContractCountry='中国';
        ci_pl.fetchStatusOptions();
        ci_pl.selectedStatus='未確定';
        ci_pl.fetchTab();
        ci_pl.fetchCompanies();
        ci_pl.selectedTab = 'two';
        ci_pl.fetchTab();
        ci_pl.fetchCompanies();
        ci_pl.SavePolicyNumber();
        
    }
    
    static public void Test_wb_CI_Searching(){
        
        //  NewCarandServices();
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
        
        wb_CarInsuranceBilling.Billing(CI.id);
        
        PageReference pageRef = Page.wb_CI_Searching;
        Test.setCurrentPage(pageRef);
        
        ApexPages.Standardcontroller cia = new ApexPages.Standardcontroller(theContractCompany);
        wb_CI_Searching ci_pl = new wb_CI_Searching(cia);
        
        ci_pl.CarFilter =theCar.Name;
        ci_pl.createtheList();
        
    }
    
    
    
    
}