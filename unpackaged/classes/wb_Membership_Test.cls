@isTest
public class wb_Membership_Test {
    static public Account theCompanyJapan {get;set;} 
    static public Account theCompanyHongKong {get;set;} 
    static public Account theCompanyChina {get;set;} 
    static public Account theCompanyIndia {get;set;} 
    static public List<wb_Service__c> Service {get;set;} 
    static public List<wb_Currency__c> Curr {get;set;}
    static public List<wb_BudgetRate__c> BudgetRate {get;set;} 
    static public wb_Individual__c IndA {get;set;} 
    static public wb_Individual__c IndB {get;set;} 
    static public wb_Individual__c IndC {get;set;} 
    static public wb_Individual__c IndD {get;set;} 
    static public wb_Individual__c IndE {get;set;} 
    static public wb_Individual__c IndF {get;set;} 
    static public wb_Individual__c IndG {get;set;} 
    static public wb_Individual__c IndH {get;set;} 
    static public wb_Individual__c IndI {get;set;}
    static public wb_Individual__c IndJ {get;set;} 
    
    public wb_Membership_Test(){
        Service = createService();
    }
    
    static void GetCancalledMemberHistory( List<wb_MembershipDetail__c> dl){
        system.debug(dl);
        List<Id> cid = new List<Id>();
        for ( wb_MembershipDetail__c d:dl){
            if (d.MembershipStopDate__c != null)
                cid.add(d.Individual__c);
        }
        if ( cid.size() > 0) {
            List< wb_Member__c> MemberCancelled = [select id, Individual__c, AdmissionFee__c, EndDate__c, r_EffectiveUntil__c                        
                                                   from wb_Member__c where Individual__c =:cid];
            
            List<Id> mid = new List<Id>();
            for ( wb_Member__c c:MemberCancelled){
                mid.add(c.id);
            }
            
            List<wb_MemberHistory__c> MemberCancelledHist = [ select CancellationDate__c, member__c, MemberType__c, MembershipStopDate__c,
                                                             MembershipStartDate__c, MembershipDetail__c, MembershipEndDate__c,
                                                             MemberNo__c, Classification__c, ReplacedWith__c,
                                                             //f_EffectiveUntil__c, 
                                                             EffectiveUntil__c
                                                             from wb_MemberHistory__c 
                                                             where member__c =:mid];
            
            system.debug(MemberCancelled);
            system.debug(MemberCancelledHist);
        }
    }
    
    static void GetMemberHistory( List<wb_MembershipDetail__c> dl){
        system.debug(dl);
        List<Id> cid = new List<Id>();
        for ( wb_MembershipDetail__c d:dl){
            // if (d.MembershipStopDate__c != null)
            cid.add(d.Individual__c);
        }
        if ( cid.size() > 0) {
            List< wb_Member__c> Member = [select id, Individual__c, AdmissionFee__c, MembershipDetail__c, WorkingCompany__c,f_MemberNo__c, EndDate__c, r_EffectiveUntil__c                        
                                          from wb_Member__c where Individual__c =:cid];
            
            List<Id> mid = new List<Id>();
            for ( wb_Member__c c:Member){
                mid.add(c.id);
            }
            
            List<wb_MemberHistory__c> MemberHist = [ select CancellationDate__c, member__c, MemberType__c, MembershipStopDate__c,
                                                    MembershipStartDate__c, MembershipDetail__c, MembershipEndDate__c,
                                                    MemberNo__c, Classification__c, ReplacedWith__c,
                                                    // f_EffectiveUntil__c,
                                                    EffectiveUntil__c
                                                    from wb_MemberHistory__c 
                                                    where member__c =:mid];
            
            system.debug(Member);
            system.debug(MemberHist);
        }
    }
    
    static public wb_Membership createMembershipContract(Account ContractComp){
        wb_Membership MS = new wb_Membership();
        MS.start_Edit();
        MS.Membership.ContractCountry__c='香港';
        MS.Membership.ContractDistrict__c='香港';
        MS.Membership.BillingDistrict__c='香港';
        MS.Membership.Currency__c ='JPY';
        MS.ChangeCurrency();
        MS.Membership.ContractDate__c = system.today();
        MS.ChangeOfContractDate();
        MS.Membership.ApplicationDate__c= system.today();
        MS.Membership.Classification__c='会社';
        MS.Membership.ContractCompany__c=ContractComp.id;
        MS.GetGroupDiscountPercentage();
        MS.Membership.BillingCompany__c=ContractComp.id;
        //  insert MS.Membership;       
        // MS.Membership = MS.getContractHeader(MS.Membership.id);
        return MS;
    }
    
    static public integer IndividualCount {get;set;}
    
    static public wb_Membership MembershipContractAdd( wb_Membership MS,string Type, integer Qty){
        wb_Service__c theService;
        if (Type == '入会金'){
            MS.theMembershipDetail[0].theRow.Membership__c = MS.Membership.id;
            MS.theMembershipDetail[0].selectedValue = '1';
            MS.theMembershipDetail[0].fetchServiceOptions();
            
            for (wb_Service__c s:Service) {
                if (s.DATATYPE__C =='入会金')
                    theService = s;
            }
            MS.theMembershipDetail[0].theRow.Service__c = theService.id;
            MS.theMembershipDetail[0].theRow.Quantity__c= Qty;
            MS.theMembershipDetail[0].fetchServiceFee();
            
        }
        else if (Type == '単身'){
            integer ps = MS.MembershipDetailsParent.size();
            //   system.debug(ps);
            for (wb_Service__c s:Service) {
                if (s.SERVICE__C == 'Global Member' && s.DATATYPE__C=='単身' )
                    theService = s;
            }
            //system.debug(theService);
            for (integer i = 1 ; i <= Qty; i ++ ) {
                MS.add_empty_row();
                // system.debug( MS.theMembershipDetail.size() +','+ i);
                
                if ( IndividualCount == null )
                    IndividualCount = 1;
                else
                    IndividualCount ++;
                
                wb_Individual__c Ind = createMember(string.valueOf(IndividualCount), MS.Membership.ContractCompany__c);
                MS.theIndividualList =Ind.Id;
                MS.theServiceList=theService.Id;
                MS.theStartRowIndex= ps + i - 1;
                MS.theStartRowID='';
                MS.UpdateAndInsertRow_at();
                
            }
            
        } 
        else if (Type == '家族'){
            integer ps = MS.MembershipDetailsParent.size();
            for (wb_Service__c s:Service) {
                if (s.SERVICE__C == 'Global Member' && s.DATATYPE__C=='家族' )
                    theService = s;
            }
            for (integer i = 1 ; i <= Qty; i ++ ) {
                MS.add_empty_row();
                
                if ( IndividualCount == null )
                    IndividualCount = 1;
                else
                    IndividualCount ++;
                
                wb_Individual__c IndF = createMember(string.valueOf(IndividualCount), MS.Membership.ContractCompany__c);
                wb_Individual__c IndF_W = createFamily(IndF.Id, string.valueOf(IndividualCount + '-Wife'));
                MS.theIndividualList =IndF.Id;
                MS.theServiceList=theService.Id;
                MS.theStartRowIndex= ps + i - 1;
                MS.theStartRowID='';
                MS.UpdateAndInsertRow_at();
                //   MS.theMembershipDetail[ps + i - 1 ].theRow.MembershipStartDate__c = system.today();
                //    MS.theMembershipDetail[ps + i - 1 ].fetchEndDate();
                MS.theMembershipDetail[ps + i - 1 ].fetchFamily();
            }
        }
        else if (Type == '無記名'){
            integer ps = MS.MembershipDetailsParent.size();
            for (wb_Service__c s:Service) {
                if (s.SERVICE__C == 'Biz Trip Pass' && s.DATATYPE__C=='無記名' )
                    theService = s;
            }
            
            MS.add_empty_row();
            MS.theMembershipDetail[ps].selectedValue = '3';
            MS.theMembershipDetail[ps].fetchServiceOptions();
            MS.theMembershipDetail[ps].theRow.Service__c = theService.id;
            MS.theMembershipDetail[ps].theRow.WorkingCompany__c = MS.Membership.ContractCompany__c;
            MS.theMembershipDetail[ps].theRow.Quantity__c= 1;
            //   MS.theMembershipDetail[ps].theRow.MembershipStartDate__c = system.today();
            //   MS.theMembershipDetail[ps].fetchEndDate();
            
        }
        
        //system.debug(MS.MembershipDetailsParent);
        return MS;
    }
    
    static public wb_Membership createMembershipContract(Account ContractComp, integer NoMembershipFee, integer NoOfMember){
        
        wb_Membership MS = new wb_Membership();
        MS.start_Edit();
        MS.Membership.ContractCountry__c='香港';
        MS.Membership.ContractDistrict__c='香港';
        MS.Membership.BillingDistrict__c='香港';
        MS.Membership.Currency__c ='JPY';
        MS.ChangeCurrency();
        MS.Membership.ContractDate__c = system.today();
        MS.ChangeOfContractDate();
        MS.Membership.ApplicationDate__c= system.today();
        MS.Membership.Classification__c='会社';
        MS.Membership.ContractCompany__c=ContractComp.id;
        MS.GetGroupDiscountPercentage();
        MS.Membership.BillingCompany__c=ContractComp.id;
        insert MS.Membership;       
        MS.Membership = MS.getContractHeader(MS.Membership.id);
        // 入会金
        MS.theMembershipDetail[0].theRow.Membership__c = MS.Membership.id;
        MS.theMembershipDetail[0].selectedValue = '1';
        MS.theMembershipDetail[0].fetchServiceOptions();
        wb_Service__c theService;
        for (wb_Service__c s:Service) {
            if (s.DATATYPE__C =='入会金')
                theService = s;
        }
        MS.theMembershipDetail[0].theRow.Service__c = theService.id;
        MS.theMembershipDetail[0].theRow.Quantity__c= NoMembershipFee;
        MS.theMembershipDetail[0].fetchServiceFee();
        
        for (wb_Service__c s:Service) {
            if (s.SERVICE__C == 'Global Member' && s.DATATYPE__C=='単身' )
                theService = s;
        }
        
        for (integer i = 1 ; i <= NoOfMember; i ++ ) {
            MS.add_empty_row();
            wb_Individual__c Ind = createMember(string.valueOf(i), ContractComp.id);
            MS.theIndividualList =Ind.Id;
            MS.theServiceList=theService.Id;
            MS.theStartRowIndex=i;
            MS.theStartRowID='';
            MS.UpdateAndInsertRow_at();
            MS.theMembershipDetail[i].theRow.MembershipStartDate__c = system.today();
            MS.theMembershipDetail[i].fetchEndDate();
        }
        return MS;
    }
    
    
    @isTest static void test_Debug(){
        
        theCompanyHongKong = CreateCompany('ウェルビー Holding',
                                           'WellBe Holding Ltd',
                                           'アジア',
                                           '香港',
                                           '香港',
                                           '香港',
                                           'HKD');
        Service = createService();
        Curr = CreateCurrency();
        BudgetRate = CreateBudgetRate();
        
        
        wb_Membership MSHongKong = createMembershipContract(theCompanyHongKong);
        
        MSHongKong = MembershipContractAdd(MSHongKong,'入会金',2);
        
        MSHongKong = MembershipContractAdd(MSHongKong,'単身',1);
        
        MSHongKong.ValidateAndUpdate();
        
        MSHongKong.Confirm();
        MSHongKong.start_Amend();
        MSHongKong.AmendmentAdditionItemMode = true;
        MSHongKong.AutoAddEmptyAmendRowModeNoOff();
        system.debug(MSHongKong.theBeingAmendedMembershipDetail.size());
        MSHongKong.theBeingAmendedMembershipDetail[0].selectedValue = '2';
        MSHongKong.theBeingAmendedMembershipDetail[0].fetchServiceOptions();
        
        wb_Service__c theService;
        for (wb_Service__c s:Service) {
            if (s.SERVICE__C == 'Global Member' && s.DATATYPE__C=='単身' )
                theService = s;
        } 
        
        MSHongKong.theBeingAmendedMembershipDetail[0].theRow.Service__c=theService.id;
        MSHongKong.theBeingAmendedMembershipDetail[0].fetchServiceFeeOnly();
        MSHongKong.PendingAmendRowId = MSHongKong.theBeingAmendedMembershipDetail[0].theRow.Id;
        MSHongKong.PendingAmendRowIdx='0';
        MSHongKong.CalculatePendingAmendRowBalanceAmount();
        MSHongKong.theBeingAmendedMembershipDetail[0].theRow.WorkingCompany__c = theCompanyHongKong.Id;
        wb_Individual__c B = createMember('B', theCompanyHongKong.Id);
        MSHongKong.theBeingAmendedMembershipDetail[0].theRow.Individual__c=B.id;
        MSHongKong.AmendmentAdditionItemMode = false;
        MSHongKong.AutoAddEmptyAmendRowModeNoOff();
        MSHongKong.SaveAmendasDraft();
        system.debug(MSHongKong.theBeingAmendedMembershipDetail[0].theRow);
        MSHongKong.PendingAmendRowId=MSHongKong.theBeingAmendedMembershipDetail[0].theRow.Id;
        MSHongKong.PendingAmendRowIdx='0';
        MSHongKong.ConfirmPendingRow();
    }
    
    
    @isTest static void test_ChangeWorkingCompany(){
        theCompanyHongKong = CreateCompany('ウェルビー Holding',
                                           'WellBe Holding Ltd',
                                           'アジア',
                                           '香港',
                                           '香港',
                                           '香港',
                                           'HKD');
        Service = createService();
        Curr = CreateCurrency();
        BudgetRate = CreateBudgetRate();
        
        
        wb_Membership MSHongKong = createMembershipContract(theCompanyHongKong);
        
        MSHongKong = MembershipContractAdd(MSHongKong,'入会金',2);
        
        MSHongKong = MembershipContractAdd(MSHongKong,'単身',1);
        
        MSHongKong.ValidateAndUpdate();
        
        MSHongKong.Confirm();
        MSHongKong.start_Amend();
        system.debug(MSHongKong.MembershipDetailsParent);
        
        MSHongKong.theChangeeRowID = MSHongKong.theMembershipDetail[1].theRow.Id;
        MSHongKong.ChangeConfirmedRow();
        system.debug(MSHongKong.BeingAmendedMembershipDetailsParent);
        
        
        MSHongKong.theBeingAmendedMembershipDetail[0].theRow.MembershipStopDate__c=date.parse('2018/11/30');
        MSHongKong.PendingAmendRowId = MSHongKong.theBeingAmendedMembershipDetail[0].theRow.Id;
        MSHongKong.PendingAmendRowIdx='0';
        MSHongKong.RefreshPendingReplacerStartDate();
        system.debug(MSHongKong.BeingAmendedMembershipDetailsParent);
        
        Account theCompanyVietnam = CreateCompany('ウェルビー ベトナム',
                                                  'WellBe Vietnam Ltd',
                                                  'アジア',
                                                  'ベトナム',
                                                  'ハノイ',
                                                  'ハノイ',
                                                  'VTN');
        
        theCompanyVietnam.ParentId = theCompanyHongKong.id;
        update theCompanyVietnam;
        Account a = [select Id, Region_and_Area__c, CountryName__c,Jurisdiction__c, CountryCd__c //, CountryCode__c 
                     from Account where Id =:theCompanyVietnam.Id];
        system.debug(a);
        MSHongKong.theBeingAmendedMembershipDetail[1].theRow.WorkingCompany__c = theCompanyVietnam.id;
        system.debug(MSHongKong.BeingAmendedMembershipDetailsParent);
        MSHongKong.PendingAmendRowId = MSHongKong.theBeingAmendedMembershipDetail[1].theRow.Id;
        MSHongKong.PendingAmendRowIdx=string.valueof(1);
        MSHongKong.ConfirmPendingRow();
        
        wb_Membership__c theMembership = MSHongKong.Membership;
        
        MSHongKong = new wb_Membership();
        MSHongKong.Membership = theMembership;
        MSHongKong.start_View();
        system.debug(MSHongKong.MembershipDetailsParent);
        
        
        List<wb_MembershipDetail__c> c = new  List<wb_MembershipDetail__c>();
        c.add( MSHongKong.MembershipDetailsParent[2]);
        system.debug(c);
        GetMemberHistory(c);
        
    }
    
    
    @isTest static void test_CancallationChanges(){
        theCompanyHongKong = CreateCompany('ウェルビー Holding',
                                           'WellBe Holding Ltd',
                                           'アジア',
                                           '香港',
                                           '香港',
                                           '香港',
                                           'HKD');
        Service = createService();
        Curr = CreateCurrency();
        BudgetRate = CreateBudgetRate();
        
        
        wb_Membership MSHongKong = createMembershipContract(theCompanyHongKong);
        
        MSHongKong = MembershipContractAdd(MSHongKong,'入会金',2);
        
        MSHongKong = MembershipContractAdd(MSHongKong,'単身',1);
        
        MSHongKong.ValidateAndUpdate();
        
        MSHongKong.Confirm();
        MSHongKong.start_Amend();
        
        
        //解約
        integer a_ridx = 0; 
        MSHongKong.theCancalRowID = MSHongKong.theMembershipDetail[1].theRow.Id;
        MSHongKong.CancelConfirmedRow();
        date StopDate =  MSHongKong.theBeingAmendedMembershipDetail[a_ridx].theRow.MembershipStartDate__c;
        StopDate = StopDate.addDays(40);
        MSHongKong.theBeingAmendedMembershipDetail[a_ridx].theRow.MembershipStopDate__c=StopDate;
        MSHongKong.PendingAmendRowId = MSHongKong.theBeingAmendedMembershipDetail[a_ridx].theRow.Id;
        MSHongKong.PendingAmendRowIdx=string.valueof(a_ridx);
        
        MSHongKong.RefreshPendingReplacerStartDate();
        
        MSHongKong.PendingAmendRowIdx=string.valueof(a_ridx);
        
        List<wb_MembershipDetail__c> c = new  List<wb_MembershipDetail__c>();
        c.add( MSHongKong.theBeingAmendedMembershipDetail[a_ridx].theRow);
        MSHongKong.ConfirmPendingRow();
        GetCancalledMemberHistory(c);
        
        wb_Membership__c m = MSHongKong.Membership;
        MSHongKong = new wb_Membership();
        
        MSHongKong.Membership = m;
        MSHongKong.start_View();        
        
        MSHongKong.start_Amend();
        
        system.debug(MSHongKong.MembershipDetailsParent);
        MSHongKong.theChangeStopDateRowID = MSHongKong.theMembershipDetail[1].theRow.Id;
        MSHongKong.ChangeStopDateRow();
        for ( wb_MembershipDetailRow r:MSHongKong.theBeingAmendedMembershipDetail){
            system.debug( r.noofmonth +',' + r.theRow);
        }
        system.debug(MSHongKong.BeingAmendedMembershipDetailsParent);
        MSHongKong.theBeingAmendedMembershipDetail[1].theRow.MembershipStopDate__c =  date.parse('2018/09/30');
        MSHongKong.PendingAmendRowId='';
        MSHongKong.PendingAmendRowIdx='1';
        MSHongKong.RefreshPendingStopDateChangeRefund();
        for ( wb_MembershipDetailRow r:MSHongKong.theBeingAmendedMembershipDetail){
            system.debug( r.noofmonth +',' + r.theRow);
        }
        system.debug(MSHongKong.BeingAmendedMembershipDetailsParent);
        MSHongKong.PendingAmendRowId = '';
        MSHongKong.PendingAmendRowIdx=string.valueof(1);
        MSHongKong.ConfirmPendingRow();
        
        m = MSHongKong.Membership;
        
        List<wb_MembershipDetail__c> theDetail = [select id, 
                                                  name, 
                                                  PreviousRecord__c, f_NameforOrdering__c, f_NameforOrderingTxt__c,
                                                  PendingAction__c, Classification__c
                                                  from wb_MembershipDetail__c 
                                                  where Membership__c =:m.Id
                                                  order by f_NameforOrdering__c, id];
        system.debug(theDetail);
        
        MSHongKong = new wb_Membership();
        
        MSHongKong.Membership = m;
        MSHongKong.start_View();
        system.debug(MSHongKong.MembershipDetailsParent);
        system.debug(MSHongKong.BeingAmendedMembershipDetailsParent);
        
        c = new  List<wb_MembershipDetail__c>();
        c.add( MSHongKong.MembershipDetailsParent[2]);
        GetCancalledMemberHistory(c);
        
        
        
        
    }
    
   
    @isTest static void test_AdmissionFeePool(){
        //createtestCompany();
        theCompanyJapan = CreateCompany('ウェルビーマーケティングジャパン',
                                        'WellBe Marketing Japan',
                                        'アジア',
                                        '日本',
                                        '東京',
                                        '東京',
                                        'JPN');
        theCompanyChina = CreateCompany( 'ウェルビーマーケティングチャイナ',
                                        'WellBe Marketing China',
                                        'アジア',
                                        '中国',
                                        '上海',
                                        '上海',
                                        'CHN');
        theCompanyIndia = CreateCompany ( 'ウェルビーマーケティングインド',
                                         'WellBe Marketing India',
                                         'アジア',
                                         'インド',
                                         'ニューデリー',
                                         'ニューデリー',
                                         'IND'
                                        );
        Service = createService();
        Curr = CreateCurrency();
        BudgetRate = CreateBudgetRate();
        theCompanyChina.ParentID = theCompanyJapan.Id;
        theCompanyIndia.ParentID = theCompanyJapan.Id;
        update theCompanyChina;
        update theCompanyIndia;
        
        wb_Membership MSChina = createMembershipContract(theCompanyChina, 10, 5);
        MSChina.ValidateAndUpdate();
        MSChina.Confirm();
        
        
        MSChina.getContractDetail();
        
        
        wb_Membership_Remaining_MBQty AdmissionFeePool = new wb_Membership_Remaining_MBQty();
        
        AdmissionFeePool.ContractCompanyId = theCompanyChina.Id;
        AdmissionFeePool.ContractCompany = theCompanyChina;
        AdmissionFeePool.GetRemainingMBQty();
        
        
        MSChina.start_Amend();
        
        
        //解約
        integer a_ridx = 0; 
        MSChina.theCancalRowID = MSChina.theMembershipDetail[1].theRow.Id;
        MSChina.CancelConfirmedRow();
        date StopDate =  MSChina.theBeingAmendedMembershipDetail[a_ridx].theRow.MembershipStartDate__c;
        StopDate = StopDate.addDays(10);
        MSChina.theBeingAmendedMembershipDetail[a_ridx].theRow.MembershipStopDate__c=StopDate;
        MSChina.PendingAmendRowId = MSChina.theBeingAmendedMembershipDetail[a_ridx].theRow.Id;
        MSChina.PendingAmendRowIdx=string.valueof(a_ridx);
        //   system.debug(MSChina.theBeingAmendedMembershipDetail[a_ridx].theRow.MembershipStopDate__c);
        MSChina.RefreshPendingReplacerStartDate();
        //   system.debug(MSChina.theBeingAmendedMembershipDetail[a_ridx].theRow.MembershipStopDate__c);
        MSChina.PendingAmendRowIdx=string.valueof(a_ridx);
        //  system.debug(MSChina.theBeingAmendedMembershipDetail[a_ridx].theRow.MembershipStopDate__c);
        MSChina.ConfirmPendingRow();
        // system.debug(MSChina.theBeingAmendedMembershipDetail[a_ridx].theRow.MembershipStopDate__c);
        
        
        MSChina.getContractDetail();
        
        wb_Membership MSIndia = createMembershipContract(theCompanyIndia, 8, 2);
        MSIndia.ValidateAndUpdate();
        MSIndia.Confirm();
        
        AdmissionFeePool = new wb_Membership_Remaining_MBQty();
        
        AdmissionFeePool.ContractCompanyId = theCompanyJapan.Id;
        AdmissionFeePool.ContractCompany = theCompanyJapan;
        AdmissionFeePool.GetRemainingMBQty();
        // system.debug(AdmissionFeePool.theRemainingMBQty);
        //  system.debug(AdmissionFeePool.theMDs);
    }
    
    
    @isTest static void test_edit(){
        
        theCompanyHongKong = CreateCompany('ウェルビー Holding',
                                           'WellBe Holding Ltd',
                                           'アジア',
                                           '香港',
                                           '香港',
                                           '香港',
                                           'HKD');
        //system.debug(theCompanyHongKong);
        Service = createService();
        Curr = CreateCurrency();
        BudgetRate = CreateBudgetRate();
        
        
        wb_Membership MSHongKong = createMembershipContract(theCompanyHongKong);
        MSHongKong = MembershipContractAdd(MSHongKong,'入会金',10);
        //   system.debug(MSHongKong.MembershipDetailsParent);
        
        
        
        MSHongKong = MembershipContractAdd(MSHongKong,'単身',5);
        //system.debug(MSHongKong.MembershipDetailsParent);
        
        MSHongKong.removeEmptyRow();
        MSHongKong = MembershipContractAdd(MSHongKong,'家族',2);
        //    system.debug(MSHongKong.MembershipDetailsParent);
        MSHongKong.removeEmptyRow();
        MSHongKong = MembershipContractAdd(MSHongKong,'無記名',null);
        //    system.debug(MSHongKong.MembershipDetailsParent);
        
        MSHongKong.Membership.Currency__c ='JPY';
        MSHongKong.ChangeCurrency();
        MSHongKong.GetGroupDiscountPercentage();
        MSHongKong.removeEmptyRow();
        // system.debug(MSHongKong.MembershipDetailsParent);
        // system.debug(MSHongKong.MembershipDetailsChild);
        MSHongKong.ValidateAndUpdate();
        // system.debug(MSHongKong.MembershipDetailsParent);
        // system.debug(MSHongKong.MembershipDetailsChild);
        
        
        PageReference pageRef = Page.wb_Membership_Edit;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(new wb_Membership__c());
        
        sc = new ApexPages.Standardcontroller(new wb_Membership__c());
        wb_Membership MS = new wb_Membership(sc);
        MS.Membership = MSHongKong.Membership;
        
        MS.start_View();
        //  system.debug(MS.MembershipDetailsParent);
        //   system.debug(MS.MembershipDetailsChild);
        
        MS.removeEmptyRow();
        MS.theMembershipDetail[2].IsSelected = true;
        MS.DeleteSelectedRows();
        MS.ValidateMembershipFee();
        MS.ValidateAndUpdate();
        
        
        MS.GenerateMemeberNo();
        MS.Confirm();
        
        new ApexPages.Standardcontroller(new wb_Membership__c());
        sc = new ApexPages.Standardcontroller(new wb_Membership__c());
        MS = new wb_Membership(sc);
        MS.Membership = MSHongKong.Membership;
        MS.start_View(); 
        
        MS.CancelRefund();
        MS.BatchSave();
        MS.Home();
        
    }
    
    
    @isTest static void test_amend(){
        
        theCompanyHongKong = CreateCompany('ウェルビー Holding',
                                           'WellBe Holding Ltd',
                                           'アジア',
                                           '香港',
                                           '香港',
                                           '香港',
                                           'HKD');
        Service = createService();
        Curr = CreateCurrency();
        BudgetRate = CreateBudgetRate();
        
        
        wb_Membership MSHongKong = createMembershipContract(theCompanyHongKong);
        
        MSHongKong = MembershipContractAdd(MSHongKong,'入会金',10);
        // system.debug(MSHongKong.MembershipDetailsParent);
        
        MSHongKong = MembershipContractAdd(MSHongKong,'単身',5);
        // system.debug(MSHongKong.MembershipDetailsParent);
        
        MSHongKong.removeEmptyRow();
        MSHongKong = MembershipContractAdd(MSHongKong,'家族',2);
        
        MSHongKong.ValidateAndUpdate();
        // system.debug(MSHongKong.MembershipDetailsParent);
        // system.debug(MSHongKong.MembershipDetailsChild);
        MSHongKong.Confirm();
        
        
        
        MSHongKong.start_Amend();
        
        
        //変更
        MSHongKong.theChangeeRowID = MSHongKong.theMembershipDetail[1].theRow.Id;
        MSHongKong.ChangeConfirmedRow();
        system.debug(MSHongKong.BeingAmendedMembershipDetailsParent);
        
        MSHongKong.theBeingAmendedMembershipDetail[0].theRow.MembershipStopDate__c=system.today();
        MSHongKong.PendingAmendRowId = MSHongKong.theBeingAmendedMembershipDetail[0].theRow.Id;
        MSHongKong.PendingAmendRowIdx='0';
        MSHongKong.RefreshPendingReplacerStartDate();
        
        // MS.CalculatePendingAmendRowBalanceAmount();
        wb_Service__c theService;
        for (wb_Service__c s:Service) {
            if (s.SERVICE__C == 'Global Member' && s.DATATYPE__C=='家族' )
                theService = s;
        } 
        
        MSHongKong.theBeingAmendedMembershipDetail[1].theRow.Service__c=theService.id;
        //   system.debug(MSHongKong.theBeingAmendedMembershipDetail[1].theRow);
        MSHongKong.PendingAmendRowId='';       
        MSHongKong.PendingAmendRowIdx = '1';
        MSHongKong.CalculatePendingAmendRowBalanceAmount();
        
        
        //交替
        MSHongKong.theExchangeeRowID =  MSHongKong.theMembershipDetail[1].theRow.Id;
        MSHongKong.ExchangeConfirmedRow();
        MSHongKong.theBeingAmendedMembershipDetail[2].theRow.MembershipStopDate__c=system.today();
        MSHongKong.PendingAmendRowId = MSHongKong.theBeingAmendedMembershipDetail[2].theRow.Id;
        MSHongKong.PendingAmendRowIdx='2';
        MSHongKong.RefreshPendingReplacerStartDate();
        MSHongKong.theBeingAmendedMembershipDetail[3].theRow.Service__c=theService.id;
        MSHongKong.theBeingAmendedMembershipDetail[3].fetchServiceFee();
        wb_Individual__c B = createMember('B', theCompanyHongKong.Id);
        MSHongKong.theBeingAmendedMembershipDetail[3].theRow.Individual__c=B.id;
        
        
        MSHongKong.SaveAmendasDraft();
        
        //解約
        MSHongKong.theCancalRowID = MSHongKong.theMembershipDetail[1].theRow.Id;
        MSHongKong.CancelConfirmedRow();
        MSHongKong.theBeingAmendedMembershipDetail[4].theRow.MembershipStopDate__c=system.today();
        MSHongKong.PendingAmendRowId = MSHongKong.theBeingAmendedMembershipDetail[4].theRow.Id;
        MSHongKong.PendingAmendRowIdx='4';
        MSHongKong.RefreshPendingReplacerStartDate();
        //  system.debug(MSHongKong.BeingAmendedMembershipDetailsParent);
        MSHongKong.PendingAmendRowId =  MSHongKong.theBeingAmendedMembershipDetail[4].theRow.Id;
        MSHongKong.PendingAmendRowIdx = '4';
        MSHongKong.DeletePendingAmendRow();
        
        
        
        MSHongKong.theCancalRowID = MSHongKong.theMembershipDetail[1].theRow.Id;
        MSHongKong.CancelConfirmedRow();
        //  system.debug(MSHongKong.BeingAmendedMembershipDetailsParent);
        MSHongKong.theBeingAmendedMembershipDetail[4].theRow.MembershipStopDate__c=system.today();
        MSHongKong.PendingAmendRowId = MSHongKong.theBeingAmendedMembershipDetail[4].theRow.Id;
        MSHongKong.PendingAmendRowIdx='4';
        MSHongKong.RefreshPendingReplacerStartDate();
        MSHongKong.GenerateMemeberNoforBeingAmendingRow();
        //   system.debug(MSHongKong.BeingAmendedMembershipDetailsParent);
        
        MSHongKong.ConfirmSelectedPendingRow();
        
        
        MSHongKong.theCancalRowID = MSHongKong.theMembershipDetail[1].theRow.Id;
        MSHongKong.CancelConfirmedRow();
        // MSHongKong.theBeingAmendedMembershipDetail[4].theRow.MembershipStopDate__c=system.today();
        //   MSHongKong.PendingAmendRowId = MSHongKong.theBeingAmendedMembershipDetail[4].theRow.Id;
        //   MSHongKong.PendingAmendRowIdx='4';
        //  MSHongKong.RefreshPendingReplacerStartDate();
        MSHongKong.DeleteSelectedPendingAmendRow();
        
        
        
    }
    
    
    @isTest static void test_Clone(){
        
        theCompanyHongKong = CreateCompany('ウェルビー Holding',
                                           'WellBe Holding Ltd',
                                           'アジア',
                                           '香港',
                                           '香港',
                                           '香港',
                                           'HKD');
        Service = createService();
        Curr = CreateCurrency();
        BudgetRate = CreateBudgetRate();
        
        
        wb_Membership MSHongKong = createMembershipContract(theCompanyHongKong);
        
        MSHongKong = MembershipContractAdd(MSHongKong,'入会金',10);
        // system.debug(MSHongKong.MembershipDetailsParent);
        
        MSHongKong = MembershipContractAdd(MSHongKong,'単身',5);
        // system.debug(MSHongKong.MembershipDetailsParent);
        
        MSHongKong.removeEmptyRow();
        MSHongKong = MembershipContractAdd(MSHongKong,'家族',2);
        MSHongKong.removeEmptyRow();
        MSHongKong = MembershipContractAdd(MSHongKong,'無記名',2);
        
        
        MSHongKong.ValidateAndUpdate();
        // system.debug(MSHongKong.MembershipDetailsParent);
        // system.debug(MSHongKong.MembershipDetailsChild);
        MSHongKong.Confirm();
        
        wb_MembershipClone Clone = new wb_MembershipClone(MSHongKong.membership.id);
        Clone.start_continue();
    }
    
    
    
    @isTest static void test_scenarioExchange(){
        
        theCompanyJapan = CreateCompany('ウェルビー JPN',
                                        'WellBe JAPAN',
                                        'アジア',
                                        '日本',
                                        '東京',
                                        '東京',
                                        'JPY');
        
        Service = createService();
        Curr = CreateCurrency();
        BudgetRate = CreateBudgetRate();
        
        wb_Membership MSJAPAN = createMembershipContract(theCompanyJapan);
        MSJAPAN.Membership.ContractExpiryDate__c = date.parse('2018/09/30');
        MSJAPAN.ChangeContractExpiryDate();
        
        MSJAPAN = MembershipContractAdd(MSJAPAN,'入会金',10);
        //  system.debug(MSJAPAN.MembershipDetailsParent);
        
        MSJAPAN = MembershipContractAdd(MSJAPAN,'単身',1);
        
        MSJAPAN.removeEmptyRow();
        MSJAPAN = MembershipContractAdd(MSJAPAN,'家族',1);
        system.debug(MSJAPAN.MembershipDetailsParent);
        system.debug(MSJAPAN.MembershipDetailsChild);
        MSJAPAN.ValidateAndUpdate();
        MSJAPAN.Confirm();
        
        wb_Membership__c theMembership = MSJAPAN.Membership;
        
        MSJAPAN.Cancel();
        
        // Amend
        // system.debug(theMembership);
        MSJAPAN = new wb_Membership();
        MSJAPAN.Membership = theMembership;
        MSJAPAN.start_Amend();
        system.debug(MSJAPAN.MembershipDetailsParent);
        //  system.debug(MSJAPAN.Membership);
        //MSJAPAN.AmendmentAdditionItemMode = true;
        // MSJAPAN.AutoAddEmptyAmendRowModeNoOff();
        
        integer a_ridx = 0; 
        wb_Service__c theService;
        
        
        //1 交替 Global Plus Member 
        for (wb_Service__c s:Service) {
            if (s.SERVICE__C == 'Global Plus Member' && s.DATATYPE__C=='単身' )
                theService = s;
        }
        // 1 交替 Global Plus Member
        MSJAPAN.theExchangeeRowID =  MSJAPAN.theMembershipDetail[1].theRow.Id;
        //   system.debug(MSJAPAN.BeingAmendedMembershipDetailsParent);
        MSJAPAN.ExchangeConfirmedRow();
        system.debug(MSJAPAN.BeingAmendedMembershipDetailsParent);
        
        MSJAPAN.theBeingAmendedMembershipDetail[a_ridx].theRow.MembershipStopDate__c=date.parse('2017/11/01');
        MSJAPAN.PendingAmendRowId = MSJAPAN.theBeingAmendedMembershipDetail[a_ridx].theRow.Id;
        MSJAPAN.PendingAmendRowIdx=string.valueof(a_ridx);
        //   system.debug(MSJAPAN.BeingAmendedMembershipDetailsParent);
        MSJAPAN.RefreshPendingReplacerStartDate();
        //     system.debug(MSJAPAN.BeingAmendedMembershipDetailsParent);
        a_ridx = a_ridx + 1; //at Row 2
        MSJAPAN.theBeingAmendedMembershipDetail[a_ridx].theRow.Service__c=theService.id;
        MSJAPAN.theBeingAmendedMembershipDetail[a_ridx].fetchServiceFeeOnly();
        MSJAPAN.PendingAmendRowId = MSJAPAN.theBeingAmendedMembershipDetail[a_ridx].theRow.Id;
        MSJAPAN.PendingAmendRowIdx=string.valueof(a_ridx);
        MSJAPAN.CalculatePendingAmendRowBalanceAmount();
        MSJAPAN.theBeingAmendedMembershipDetail[a_ridx].theRow.WorkingCompany__c = theCompanyJapan.Id;
        wb_Individual__c D = createMember('D', theCompanyJapan.Id);
        MSJAPAN.theBeingAmendedMembershipDetail[a_ridx].theRow.Individual__c=D.id;
        
        system.debug(MSJAPAN.BeingAmendedMembershipDetailsParent);
        //    system.debug(MSJAPAN.BeingAmendedMembershipDetailsChild);
        MSJAPAN.PendingAmendRowIdx=string.valueof(a_ridx);
        MSJAPAN.ConfirmPendingRow();
        system.debug(MSJAPAN.BeingAmendedMembershipDetailsParent);
        
        MSJAPAN = new wb_Membership();
        MSJAPAN.Membership = theMembership;
        MSJAPAN.start_View();
        system.debug(MSJAPAN.MembershipDetailsParent);
        
        List<wb_MembershipDetail__c> Dtl = [select id, Name, Individual__c, MemberName__c, MemberNo__c, Member__c 
                                            from wb_MembershipDetail__c 
                                            where Membership__c =:theMembership.id];
        system.debug(Dtl);
        
        
    }
    
    
    @isTest static void test_scenarioChange(){
        
        theCompanyJapan = CreateCompany('ウェルビー JPN',
                                        'WellBe JAPAN',
                                        'アジア',
                                        '日本',
                                        '東京',
                                        '東京',
                                        'JPY');
        
        Service = createService();
        Curr = CreateCurrency();
        BudgetRate = CreateBudgetRate();
        
        wb_Membership MSJAPAN = createMembershipContract(theCompanyJapan);
        MSJAPAN.Membership.ContractExpiryDate__c = date.parse('2018/09/30');
        MSJAPAN.ChangeContractExpiryDate();
        
        MSJAPAN = MembershipContractAdd(MSJAPAN,'入会金',10);
        //  system.debug(MSJAPAN.MembershipDetailsParent);
        
        MSJAPAN = MembershipContractAdd(MSJAPAN,'単身',1);
        
        MSJAPAN.removeEmptyRow();
        MSJAPAN = MembershipContractAdd(MSJAPAN,'家族',1);
        system.debug(MSJAPAN.MembershipDetailsParent);
        system.debug(MSJAPAN.MembershipDetailsChild);
        MSJAPAN.ValidateAndUpdate();
        MSJAPAN.Confirm();
        
        wb_Membership__c theMembership = MSJAPAN.Membership;
        
        MSJAPAN.Cancel();
        
        // Amend
        // system.debug(theMembership);
        MSJAPAN = new wb_Membership();
        MSJAPAN.Membership = theMembership;
        MSJAPAN.start_Amend();
        system.debug(MSJAPAN.MembershipDetailsParent);
        //  system.debug(MSJAPAN.Membership);
        //MSJAPAN.AmendmentAdditionItemMode = true;
        // MSJAPAN.AutoAddEmptyAmendRowModeNoOff();
        
        integer a_ridx = 0; 
        wb_Service__c theService;
        
        
        // 2 変更 at Row 3
        MSJAPAN.theChangeeRowID = MSJAPAN.theMembershipDetail[1].theRow.Id;
        MSJAPAN.ChangeConfirmedRow();
        //     system.debug(MSJAPAN.BeingAmendedMembershipDetailsParent);
        
        MSJAPAN.theBeingAmendedMembershipDetail[a_ridx].theRow.MembershipStopDate__c=date.parse('2017/11/01');
        a_ridx = a_ridx + 1; // at Row 4
        MSJAPAN.PendingAmendRowId = MSJAPAN.theBeingAmendedMembershipDetail[a_ridx].theRow.Id;
        MSJAPAN.PendingAmendRowIdx=string.valueof(a_ridx);
        MSJAPAN.RefreshPendingReplacerStartDate();
        
        for (wb_Service__c s:Service) {
            if (s.SERVICE__C == 'Global Member' && s.DATATYPE__C=='家族' )
                theService = s;
        } 
        
        MSJAPAN.theBeingAmendedMembershipDetail[a_ridx].theRow.Service__c=theService.id;
        MSJAPAN.PendingAmendRowId='';       
        MSJAPAN.PendingAmendRowIdx = string.valueof(a_ridx);
        MSJAPAN.CalculatePendingAmendRowBalanceAmount();
        MSJAPAN.AmendmentAdditionItemMode = false;
        MSJAPAN.AutoAddEmptyAmendRowModeNoOff();
        system.debug(MSJAPAN.BeingAmendedMembershipDetailsParent);
        MSJAPAN.ConfirmSelectedPendingRow();
        system.debug(MSJAPAN.BeingAmendedMembershipDetailsParent);
        
        MSJAPAN = new wb_Membership();
        MSJAPAN.Membership = theMembership;
        MSJAPAN.start_View();
        system.debug(MSJAPAN.MembershipDetailsParent);
        
        List<wb_MembershipDetail__c> Dtl = [select id, Name, Individual__c, MemberName__c, MemberNo__c, Member__c 
                                            from wb_MembershipDetail__c 
                                            where Membership__c =:theMembership.id];
        system.debug(Dtl);
        
        

        
    }
    
    
    
    @isTest static void test_scenario(){
        
        theCompanyJapan = CreateCompany('ウェルビー JPN',
                                        'WellBe JAPAN',
                                        'アジア',
                                        '日本',
                                        '東京',
                                        '東京',
                                        'JPY');
        
        Service = createService();
        Curr = CreateCurrency();
        BudgetRate = CreateBudgetRate();
        
        wb_Membership MSJAPAN = createMembershipContract(theCompanyJapan);
        MSJAPAN.Membership.ContractExpiryDate__c = date.parse('2018/09/30');
        MSJAPAN.ChangeContractExpiryDate();
        
        MSJAPAN = MembershipContractAdd(MSJAPAN,'入会金',10);
        //  system.debug(MSJAPAN.MembershipDetailsParent);
        
        MSJAPAN = MembershipContractAdd(MSJAPAN,'単身',3);
        
        MSJAPAN.removeEmptyRow();
        MSJAPAN = MembershipContractAdd(MSJAPAN,'家族',1);
        system.debug(MSJAPAN.MembershipDetailsParent);
        system.debug(MSJAPAN.MembershipDetailsChild);
        MSJAPAN.ValidateAndUpdate();
        MSJAPAN.Confirm();
        
        wb_Membership__c theMembership = MSJAPAN.Membership;
        
        MSJAPAN.Cancel();
        
        // Amend
        // system.debug(theMembership);
        MSJAPAN = new wb_Membership();
        MSJAPAN.Membership = theMembership;
        MSJAPAN.start_Amend();
        system.debug(MSJAPAN.MembershipDetailsParent);
        //  system.debug(MSJAPAN.Membership);
        MSJAPAN.AmendmentAdditionItemMode = true;
        MSJAPAN.AutoAddEmptyAmendRowModeNoOff();
        
        integer a_ridx = 0; 
        wb_Service__c theService;
        for (wb_Service__c s:Service) {
            if (s.SERVICE__C == 'Global Member' && s.DATATYPE__C=='単身' )
                theService = s;
        }
        MSJAPAN.theBeingAmendedMembershipDetail[a_ridx].selectedValue = '2';
        MSJAPAN.theBeingAmendedMembershipDetail[a_ridx].fetchServiceOptions();
        MSJAPAN.theStartRowIndex=a_ridx;
        MSJAPAN.theStartRowID='';
        wb_Individual__c B = createMember('B', theCompanyJapan.Id);
        MSJAPAN.theIndividualList=B.id;
        MSJAPAN.theServiceList=theService.id;
        MSJAPAN.theStartDate = date.parse('2017/11/01');
        MSJAPAN.UpdateTo='AMEND';
        MSJAPAN.UpdateAndInsertRow_at();
        MSJAPAN.theBeingAmendedMembershipDetail[a_ridx].theRow.MembershipStartDate__c=date.parse('2017/11/01');
        MSJAPAN.theBeingAmendedMembershipDetail[a_ridx].fetchServiceFee();
        
        
        //1 交替 Global Plus Member 
        for (wb_Service__c s:Service) {
            if (s.SERVICE__C == 'Global Plus Member' && s.DATATYPE__C=='単身' )
                theService = s;
        }
        a_ridx = a_ridx + 1; // 1 交替 Global Plus Member
        MSJAPAN.theExchangeeRowID =  MSJAPAN.theMembershipDetail[1].theRow.Id;
        //   system.debug(MSJAPAN.BeingAmendedMembershipDetailsParent);
        MSJAPAN.ExchangeConfirmedRow();
        //   system.debug(MSJAPAN.BeingAmendedMembershipDetailsParent);
        MSJAPAN.theBeingAmendedMembershipDetail[a_ridx].theRow.MembershipStopDate__c=date.parse('2017/11/01');
        MSJAPAN.PendingAmendRowId = MSJAPAN.theBeingAmendedMembershipDetail[1].theRow.Id;
        MSJAPAN.PendingAmendRowIdx=string.valueof(a_ridx);
        //   system.debug(MSJAPAN.BeingAmendedMembershipDetailsParent);
        MSJAPAN.RefreshPendingReplacerStartDate();
        //     system.debug(MSJAPAN.BeingAmendedMembershipDetailsParent);
        a_ridx = a_ridx + 1; //at Row 2
        MSJAPAN.theBeingAmendedMembershipDetail[a_ridx].theRow.Service__c=theService.id;
        MSJAPAN.theBeingAmendedMembershipDetail[a_ridx].fetchServiceFeeOnly();
        MSJAPAN.PendingAmendRowId = MSJAPAN.theBeingAmendedMembershipDetail[a_ridx].theRow.Id;
        MSJAPAN.PendingAmendRowIdx=string.valueof(a_ridx);
        MSJAPAN.CalculatePendingAmendRowBalanceAmount();
        
        wb_Individual__c D = createMember('D', theCompanyJapan.Id);
        MSJAPAN.theBeingAmendedMembershipDetail[a_ridx].theRow.Individual__c=D.id;
        
        //    system.debug(MSJAPAN.BeingAmendedMembershipDetailsParent);
        //    system.debug(MSJAPAN.BeingAmendedMembershipDetailsChild);
        MSJAPAN.PendingAmendRowIdx=string.valueof(a_ridx);
        MSJAPAN.ConfirmPendingRow();
        system.debug(MSJAPAN.BeingAmendedMembershipDetailsParent);
        //   system.debug(MSJAPAN.BeingAmendedMembershipDetailsChild);
        
        a_ridx = a_ridx + 1;// 2 変更 at Row 3
        MSJAPAN.theChangeeRowID = MSJAPAN.theMembershipDetail[1].theRow.Id;
        MSJAPAN.ChangeConfirmedRow();
        //     system.debug(MSJAPAN.BeingAmendedMembershipDetailsParent);
        
        MSJAPAN.theBeingAmendedMembershipDetail[a_ridx].theRow.MembershipStopDate__c=date.parse('2017/11/01');
        a_ridx = a_ridx + 1; // at Row 4
        MSJAPAN.PendingAmendRowId = MSJAPAN.theBeingAmendedMembershipDetail[a_ridx].theRow.Id;
        MSJAPAN.PendingAmendRowIdx=string.valueof(a_ridx);
        MSJAPAN.RefreshPendingReplacerStartDate();
        
        for (wb_Service__c s:Service) {
            if (s.SERVICE__C == 'Global Member' && s.DATATYPE__C=='家族' )
                theService = s;
        } 
        
        MSJAPAN.theBeingAmendedMembershipDetail[a_ridx].theRow.Service__c=theService.id;
        MSJAPAN.PendingAmendRowId='';       
        MSJAPAN.PendingAmendRowIdx = string.valueof(a_ridx);
        MSJAPAN.CalculatePendingAmendRowBalanceAmount();
        MSJAPAN.AmendmentAdditionItemMode = false;
        MSJAPAN.AutoAddEmptyAmendRowModeNoOff();
        MSJAPAN.ConfirmSelectedPendingRow();
        
        
        
        MSJAPAN.AmendmentAdditionItemMode = true;
        MSJAPAN.AutoAddEmptyAmendRowModeNoOff();
        
        //新規　
        a_ridx = a_ridx + 1; // at Row 5
        for (wb_Service__c s:Service) {
            if (s.SERVICE__C == 'Global Member' && s.DATATYPE__C=='単身' )
                theService = s;
        }
        MSJAPAN.theBeingAmendedMembershipDetail[a_ridx].selectedValue = '2';
        MSJAPAN.theBeingAmendedMembershipDetail[a_ridx].fetchServiceOptions();
        MSJAPAN.theStartRowIndex=a_ridx;
        MSJAPAN.theStartRowID='';
        wb_Individual__c E = createMember('E', theCompanyJapan.Id);
        MSJAPAN.theIndividualList=E.id;
        MSJAPAN.theServiceList=theService.id;
        MSJAPAN.theStartDate = date.parse('2018/01/05');
        MSJAPAN.UpdateTo='AMEND';
        MSJAPAN.UpdateAndInsertRow_at();
        MSJAPAN.theBeingAmendedMembershipDetail[a_ridx].theRow.MembershipStartDate__c=date.parse('2018/01/05');
        MSJAPAN.theBeingAmendedMembershipDetail[a_ridx].fetchServiceFee();
        MSJAPAN.PendingAmendRowId =  MSJAPAN.theBeingAmendedMembershipDetail[5].theRow.Id;
        MSJAPAN.PendingAmendRowIdx=string.valueof(a_ridx);
        MSJAPAN.ConfirmPendingRow();
        
        // 解約
        a_ridx = a_ridx + 1; // at Row 6
        MSJAPAN.theCancalRowID = MSJAPAN.theMembershipDetail[1].theRow.Id;
        MSJAPAN.CancelConfirmedRow();
        MSJAPAN.theBeingAmendedMembershipDetail[a_ridx].theRow.MembershipStopDate__c=system.today();
        MSJAPAN.PendingAmendRowId = MSJAPAN.theBeingAmendedMembershipDetail[a_ridx].theRow.Id;
        MSJAPAN.PendingAmendRowIdx=string.valueof(a_ridx);
        MSJAPAN.RefreshPendingReplacerStartDate();
        MSJAPAN.PendingAmendRowIdx=string.valueof(a_ridx);
        MSJAPAN.ConfirmPendingRow();
        
        
    }
    
    
    
    @isTest static void test_scenario_AdmissionfeeExchange(){
        system.debug(ApexPages.hasMessages(ApexPages.Severity.Error));
        theCompanyJapan = CreateCompany('ウェルビー JPN',
                                        'WellBe JAPAN',
                                        'アジア',
                                        '日本',
                                        '東京',
                                        '東京',
                                        'JPY');
        
        Service = createService();
        Curr = CreateCurrency();
        BudgetRate = CreateBudgetRate();
        
        wb_Membership MSJAPAN = createMembershipContract(theCompanyJapan);
        MSJAPAN.Membership.ContractExpiryDate__c = date.parse('2018/09/30');
        MSJAPAN.ChangeContractExpiryDate();
        
        MSJAPAN = MembershipContractAdd(MSJAPAN,'入会金',10);
        MSJAPAN = MembershipContractAdd(MSJAPAN,'単身',1);
        MSJAPAN.removeEmptyRow();
        MSJAPAN = MembershipContractAdd(MSJAPAN,'家族',1);
        system.debug(ApexPages.hasMessages(ApexPages.Severity.Error));
        MSJAPAN.ValidateAndUpdate();
        system.debug(ApexPages.hasMessages(ApexPages.Severity.Error));
        MSJAPAN.Confirm();
        system.debug(ApexPages.hasMessages(ApexPages.Severity.Error));
        MSJAPAN.start_View();
        
        Id AdmissionFeeID = MSJAPAN.MembershipDetailsParent[0].Id;
        
        system.debug(ApexPages.hasMessages(ApexPages.Severity.Error));
        wb_Membership MSJAPAN2 = createMembershipContract(theCompanyJapan);
        system.debug(ApexPages.hasMessages(ApexPages.Severity.Error));
        MSJAPAN2.Membership.ContractExpiryDate__c = date.parse('2018/09/30');
        MSJAPAN2.ChangeContractExpiryDate();
        
        integer rid = 0;
        MSJAPAN2.theMembershipDetail[rid].selectedValue = '1';
        MSJAPAN2.theMembershipDetail[rid].fetchServiceOptions();
        wb_Service__c theService;
        for (wb_Service__c s:Service) {
            if (s.DATATYPE__C =='入会金')
                theService = s;
        }
        MSJAPAN2.theMembershipDetail[rid].theRow.Service__c = theService.id;
        
        MSJAPAN2.theStartRowID='';
        MSJAPAN2.theStartRowIndex=1; // Starting from 1 ..
        MSJAPAN2.theRemainingMembershipQtyList= AdmissionFeeID + ','+'1';
        
        MSJAPAN2.AddRemainingMembershipQty();
        system.debug(MSJAPAN2.Membership);
        system.debug(MSJAPAN2.MembershipDetailsParent);
        system.debug(ApexPages.hasMessages(ApexPages.Severity.Error));
        MSJAPAN2.ValidateAndUpdate();
        system.debug(ApexPages.hasMessages(ApexPages.Severity.Error));
        system.debug(MSJAPAN2.Membership);
        system.debug(MSJAPAN2.MembershipDetailsParent);
        MSJAPAN2.Confirm();
        MSJAPAN2.start_View();
        //    system.debug(MSJAPAN2.Membership);
        system.debug(MSJAPAN2.MembershipDetailsParent);
        system.debug(MSJAPAN2.MemberFeeChild);
        //    system.debug(MSJAPAN2.MembershipDetailsChild);
        system.debug(MSJAPAN2.MemberFeeChildIn);
        //     system.debug(MSJAPAN2.MemberFeeChildOut);
        
        MSJAPAN.start_View();
        system.debug(MSJAPAN.MembershipDetailsParent);
        system.debug(MSJAPAN.MemberFeeChild);
        //   system.debug(MSJAPAN.MembershipDetailsChild);
        //  system.debug(MSJAPAN.MemberFeeChildIn);
        system.debug(MSJAPAN.MemberFeeChildOut);
        
        
        
        
    }
    
    public static wb_Member__c CreateMember(){
        
        theCompanyHongKong = CreateCompany('ウェルビー Holding',
                                           'WellBe Holding Ltd',
                                           'アジア',
                                           '香港',
                                           '香港',
                                           '香港',
                                           'HKD');
        Service = createService();
        Curr = CreateCurrency();
        BudgetRate = CreateBudgetRate();
        
        
        wb_Membership MSHongKong = createMembershipContract(theCompanyHongKong);
        MSHongKong = MembershipContractAdd(MSHongKong,'入会金',1);
        
        MSHongKong.removeEmptyRow();
        MSHongKong = MembershipContractAdd(MSHongKong,'家族',1);
        MSHongKong.ValidateAndUpdate();
        MSHongKong.GenerateMemeberNo();
        MSHongKong.Confirm();
        if ( MSHongKong.theMembershipDetail[1].therow.Member__c != null){
            return [select id, f_MemberNo__c from wb_Member__c where Id =:MSHongKong.theMembershipDetail[1].therow.Member__c];
        } else
            return null;
        
    }    
    static void CreateMasters(){
        createtestCompany();
        Service = createService();
        Curr = CreateCurrency();
        BudgetRate = CreateBudgetRate();
        IndA = createMember('A', theCompanyJapan.Id);
        wb_Individual__c IndA_W = createFamily(IndA.Id, 'A Wife');
        IndB = createMember('B', theCompanyJapan.Id);
        wb_Individual__c IndB_W = createFamily(IndB.Id, 'B Wife');
        IndC = createMember('C', theCompanyJapan.Id);
        wb_Individual__c IndC_W = createFamily(IndC.Id, 'C Wife');
        IndD = createMember('D', theCompanyJapan.Id);
        wb_Individual__c IndD_W = createFamily(IndD.Id, 'D Wife');
        IndE = createMember('E', theCompanyJapan.Id);
        wb_Individual__c IndE_W = createFamily(IndE.Id, 'E Wife');
        IndF = createMember('F', theCompanyJapan.Id);
        wb_Individual__c IndF_W = createFamily(IndF.Id, 'F Wife');
        IndG = createMember('G', theCompanyJapan.Id);
        wb_Individual__c IndG_W = createFamily(IndG.Id, 'G Wife');
        IndH = createMember('H', theCompanyJapan.Id);
        wb_Individual__c IndH_W = createFamily(IndH.Id, 'H Wife');
        IndI = createMember('I', theCompanyJapan.Id);
        wb_Individual__c IndI_W = createFamily(IndI.Id, 'I Wife');
        IndJ = createMember('J', theCompanyJapan.Id);
        wb_Individual__c IndJ_W = createFamily(IndJ.Id, 'J Wife');
        
    }
    
    static public void createtestCompany(){
        
        
        theCompanyJapan = new Account ( Name = 'ウェルビーマーケティングジャパン',
                                       CompanyNameEng__c ='WellBe Marketing Japan',
                                       Region_and_Area__c='アジア',
                                       CountryName__c='日本',
                                       Jurisdiction__c='東京',
                                       ShozokuArea__c='東京' 
                                       // CountryCode__c='JPN'
                                      );
        insert theCompanyJapan;
        
        theCompanyChina = new Account ( Name = 'ウェルビーマーケティングチャイナ',
                                       CompanyNameEng__c ='WellBe Marketing China',
                                       Region_and_Area__c='アジア',
                                       CountryName__c='中国',
                                       Jurisdiction__c='上海',
                                       ShozokuArea__c='上海'
                                       // CountryCode__c='CHN'
                                      );
        insert theCompanyChina;
        
        theCompanyIndia = new Account ( Name = 'ウェルビーマーケティングインド',
                                       CompanyNameEng__c ='WellBe Marketing India',
                                       Region_and_Area__c='アジア',
                                       CountryName__c='インド',
                                       Jurisdiction__c='ニューデリー',
                                       ShozokuArea__c='ニューデリー'
                                       //  CountryCode__c='IND'
                                      );
        
        // return theCompany;
    }
    
    static public Account CreateCompany(string theName,string CompanyNameEng,string Region_and_Area,
                                        string CountryName,string Jurisdiction,string ShozokuArea, string CountryCode  )
    {
        Account theCompany = new Account ( Name = theName,
                                          CompanyNameEng__c =CompanyNameEng,
                                          Region_and_Area__c=Region_and_Area,
                                          CountryName__c=CountryName,
                                          Jurisdiction__c=Jurisdiction,
                                          ShozokuArea__c=ShozokuArea
                                          // CountryCode__c=CountryCode
                                         );
        insert theCompany;
        return theCompany;
        
    }
    
    static wb_Individual__c createMember( string Nm, Id WComp){
        wb_Individual__c theIndividual = new wb_Individual__c ( Name = Nm,
                                                               Sex__c ='男',
                                                               WorkingCompany__c=WComp,
                                                               FamilyNo__c='0'
                                                              );
        insert theIndividual;
        return theIndividual;
    }
    
    static wb_Individual__c createFamily(Id PId, string Nm){
        
        wb_Individual__c theIndividual = new wb_Individual__c ( Name = Nm,
                                                               Sex__c ='女',
                                                               FamilyRelationship__c='妻',
                                                               FamilyNo__c='1',
                                                               Parent__c=PId
                                                              );
        insert theIndividual;
        return theIndividual;
        
    }
    
    static public List<wb_Service__c> createService(){
        
        List<wb_Service__c> Service = new List<wb_Service__c>();
        
        Service.add( new wb_Service__c ( SERVICE__C = 'Global',CARDPREFIX__C='',CURRENCY__C='USD',SERVICEFEE__C=120,
                                        DISCOUNTABLE__C=FALSE,DATATYPE__C='入会金',SERVICECLASSIFICATION__C='会員',
                                        ENABLE__C=TRUE));
        Service.add( new wb_Service__c ( SERVICE__C = 'Biz Trip Pass',CARDPREFIX__C='1',CURRENCY__C='USD',SERVICEFEE__C=300,
                                        DISCOUNTABLE__C=TRUE,DATATYPE__C='無記名',SERVICECLASSIFICATION__C='会員',
                                        ENABLE__C=TRUE));
        Service.add( new wb_Service__c ( SERVICE__C = 'Global Member',CARDPREFIX__C='1',CURRENCY__C='USD',SERVICEFEE__C=100,
                                        DISCOUNTABLE__C=FALSE,DATATYPE__C='家族',SERVICECLASSIFICATION__C='会員',
                                        ENABLE__C=TRUE));
        Service.add( new wb_Service__c ( SERVICE__C = 'Global Member',CARDPREFIX__C='1',CURRENCY__C='USD',SERVICEFEE__C=60,
                                        DISCOUNTABLE__C=FALSE,DATATYPE__C='単身',SERVICECLASSIFICATION__C='会員',
                                        ENABLE__C=TRUE));
        Service.add( new wb_Service__c ( SERVICE__C = 'Global Plus Member',CARDPREFIX__C='1',CURRENCY__C='USD',SERVICEFEE__C=500,
                                        DISCOUNTABLE__C=TRUE,DATATYPE__C='家族',SERVICECLASSIFICATION__C='会員',
                                        ENABLE__C=TRUE));
        Service.add( new wb_Service__c ( SERVICE__C = 'Global Plus Member',CARDPREFIX__C='1',CURRENCY__C='USD',SERVICEFEE__C=300,
                                        DISCOUNTABLE__C=TRUE,DATATYPE__C='単身',SERVICECLASSIFICATION__C='会員',
                                        ENABLE__C=TRUE));
        insert Service;
        return Service;
    }
    
    static public List<wb_Currency__c> CreateCurrency(){
        List<wb_Currency__c> Curr = new List<wb_Currency__c>();
        Curr.add( new wb_Currency__c( CurrencySymbol__c='USD', Name='USD') );
        Curr.add( new wb_Currency__c( CurrencySymbol__c='JPY', Name='JPY') );
        insert Curr;
        return Curr;
    }
    
    static public List<wb_BudgetRate__c> CreateBudgetRate(){
        List<wb_BudgetRate__c> BRate = new List<wb_BudgetRate__c>();
        BRate.add( new wb_BudgetRate__c(FROMCURRENCY__C='USD',TOCURRENCY__C='JPY',
                                        FROMDATE__C=date.valueOf('2017-04-01'),TODATE__C=date.valueOf('2018-03-31'),RATE__C=110.7,
                                        YEARCEILINGUNIT__C=100.0,MONTHCEILINGUNIT__C=10.0));
        BRate.add( new wb_BudgetRate__c(FROMCURRENCY__C='USD',TOCURRENCY__C='JPY',
                                        FROMDATE__C=date.valueOf('2018-04-01'),TODATE__C=date.valueOf('2019-03-31'),RATE__C=112.75,
                                        YEARCEILINGUNIT__C=100.0,MONTHCEILINGUNIT__C=10.0));
        BRate.add( new wb_BudgetRate__c(FROMCURRENCY__C='USD',TOCURRENCY__C='USD',
                                        FROMDATE__C=date.valueOf('2017-04-01'),TODATE__C=date.valueOf('2018-03-31'),RATE__C=1,
                                        YEARCEILINGUNIT__C=null,MONTHCEILINGUNIT__C=null));
        BRate.add( new wb_BudgetRate__c(FROMCURRENCY__C='USD',TOCURRENCY__C='USD',
                                        FROMDATE__C=date.valueOf('2018-04-01'),TODATE__C=date.valueOf('2019-03-31'),RATE__C=1,
                                        YEARCEILINGUNIT__C=null,MONTHCEILINGUNIT__C=null));
        
        
        insert BRate;
        
        return BRate;
    }
    
    static List<wb_CountryDistrict__c> CreateCountryDistrict(){
        List<wb_CountryDistrict__c> CountryDistrict = new List<wb_CountryDistrict__c>();
        CountryDistrict.add( new wb_CountryDistrict__c(REGION__C='アジア',COUNTRY__C='中国',JURISDICTION__C='北京',
                                                       AFFILIATION__C='北京',SERVICE__C='MD'));
        CountryDistrict.add( new wb_CountryDistrict__c(REGION__C='アジア',COUNTRY__C='中国',JURISDICTION__C='上海',
                                                       AFFILIATION__C='上海',SERVICE__C='MD'));
        CountryDistrict.add( new wb_CountryDistrict__c(REGION__C='アジア',COUNTRY__C='中国',JURISDICTION__C='香港',
                                                       AFFILIATION__C='香港',SERVICE__C='MD'));
        CountryDistrict.add( new wb_CountryDistrict__c(REGION__C='アジア',COUNTRY__C='日本',JURISDICTION__C='東京',
                                                       AFFILIATION__C='東京',SERVICE__C='MD'));
        CountryDistrict.add( new wb_CountryDistrict__c(REGION__C='アジア',COUNTRY__C='インド',JURISDICTION__C='ニューデリー',
                                                       AFFILIATION__C='ニューデリー',SERVICE__C='MD'));
        
        CountryDistrict.add( new wb_CountryDistrict__c(District__c='東京',SERVICE__C='MD契約'));
        CountryDistrict.add( new wb_CountryDistrict__c(District__c='香港',SERVICE__C='MD契約'));
        CountryDistrict.add( new wb_CountryDistrict__c(District__c='ニューデリー',SERVICE__C='MD契約'));
        
        insert CountryDistrict;
        return CountryDistrict;
    }
    
}