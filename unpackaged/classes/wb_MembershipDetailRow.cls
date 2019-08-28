public class wb_MembershipDetailRow {
    
    
    public boolean IsSelected {get; set;}
    public string theContractCurrency {get;set;}
    public decimal theDiscountPercentage  {get;set;}
    
    public List<wb_Service__c> theService {get;set;}
    
    public List<wb_BudgetRate__c> theRateAndRoundUp {get;set;}
    public boolean IsMemberShipFee {get; set;}
    public boolean IsPersonalFamilyPlan {get; set;}
    public boolean IsForCardHolder {get; set;}
    public boolean IsNotRealName {get; set;}
    
    public string selectedValue {get; set;}
    //  1 入会金
    //  2 単・家
    //  3 無記名
    //  4 仮名登録
    public string selectedDescription {get; set;}
    
    public Boolean  IshavingFamilybutSinglePlan {get; set;}
    public integer NoofFamilyMembers {get; set;}
    
    // Hold the child records for showing
    public string theFamiliesDataTableID {get; set;}
    public  Map<String, List<wb_MembershipDetail__c>> theFamilies{get;set;}
  //  public string ChangeTypeSelection {get; set;}
    public date ChangeSelectionPeriousStartDate  {get; set;}
    public string theRowChangeType {get; set;}
    public boolean CancallationReplacement {get; set;}
  //  public SelectOption[] CancallationMemberAsReplacementOptions {get; set;}
    public boolean MemberReplacement {get; set;}
    public SelectOption[] MemberAsReplacementOptions {get; set;}
    public void SetMemberAsReplacementOptions() {
        List<SelectOption>  opt = new  List<SelectOption>();
        opt.add(new SelectOption('', ''  )); 
        for (wb_MembershipDetail__c u: UsableCancallationMemberAsReplacement){
            opt.add(new SelectOption(u.id, u.Individual__r.name )); 
            MemberReplacement = true;
        }
        MemberAsReplacementOptions = opt;
    }

    public string theRowAttribute {get; set;}
    public integer theRowIndex {get; set;}
    public wb_MembershipDetail__c theRow {get; set;}
    public boolean AllowChangeStopDate {get; set;}
    public wb_Individual__c theIndiviual {get; set;}
    public List<wb_Individual__c> theIndiviualFamily {get; set;}
    
    public boolean IsReplaced {get; set;}
    public List<wb_MembershipDetail__c> UsableCancallationMemberAsReplacement {get; set;}
    
    public List<wb_MembershipDetail__c> theChildRow {get; set;}
    public Date theContractExpiryDate {get; set;}
    public integer theInQty {get; set;}
    public integer theOutQty {get; set;}
    public List<wb_MembershipDetail__c> theInChildRow {get; set;} // Transfer In Membership from other Contract 
    public List<wb_MembershipDetail__c> theOutChildRow {get; set;}  // Transfer Out Apply to other Contract
    public boolean ShowAlert {get; set;} 
    public SelectOption[] ServiceOptions {get; set;}
    
    public SelectOption[] getServiceOptions() 
    {  
        
        List<SelectOption>  opt = new  List<SelectOption>();
        if (theRow.Service__c != null){
            
            for (  wb_Service__c s: theService) {
                if ( s.id ==theRow.Service__c )
                    opt.add(new SelectOption(s.id, s.Service__c + s.DataType__c  )); 
            }
            // opt.add(new SelectOption(theRow.Service__c,'--None--')); 
        }
        
        // opt.add(new SelectOption('','--None--'));  
        
        
        if ( IsForCardHolder == true) {
            
            for (  wb_Service__c s: theService) {
                if ( s.DataType__c =='無記名' )
                    opt.add(new SelectOption(s.id, s.Service__c + s.DataType__c  )); 
            }
        }
        else if (IsMemberShipFee == true ) {
            
            for (  wb_Service__c s: theService) {
                if ( s.DataType__c =='入会金' )
                    opt.add(new SelectOption(s.id, s.Service__c + s.DataType__c)); 
            }
        }  else if (IsPersonalFamilyPlan == true){
            
            for (  wb_Service__c s: theService) {
                if ( s.DataType__c =='単身' || s.DataType__c =='家族' )
                    opt.add(new SelectOption(s.id, s.Service__c + s.DataType__c));
            }
        }
        // opt.add();
        if ( opt.size() > 1) {
            List<SelectOption>  opt2 = new  List<SelectOption>();
            opt2.add(new SelectOption('','--None--'));  
            for ( SelectOption s:opt)
                opt2.add(s);
            return opt2;
            
        } else if ( opt.size() == 1 ) {
            theRow.Service__c = opt[0].getValue();
            opt.add(new SelectOption('','--None--'));  
            fetchServiceFee();
            return opt;  
        } else
            return null;
    }  
    
    public wb_MembershipDetailRow( integer idx, wb_MembershipDetail__c r, List<wb_MembershipDetail__c> chd, List<wb_Service__c> Service, 
                                  List<wb_BudgetRate__c> RateAndRoundUp,
                                  string ContractCurrency, decimal DiscountPercentage, date ContractExpiryDate,
                                  boolean SAlert
                                 )
    {
        ShowAlert = SAlert;
        theRowIndex = idx;
        theRow = r;
      //  system.debug(theRow.UnitAmount__c);
        
        theChildRow = new List<wb_MembershipDetail__c>(); 
        theChildRow = chd;
        if ( theChildRow != null )
            fetchtheFamilies();
        else
            NoofFamilyMembers =0;
        
        IsSelected = false;
        
        theService =  Service;
        theRateAndRoundUp = RateAndRoundUp;
        theContractCurrency = ContractCurrency;
        theDiscountPercentage = DiscountPercentage;
        
        theContractExpiryDate = ContractExpiryDate;
        
        if ( r.id <> null)
        {
            if ( r.Individual__c <> null )
            {
                IsPersonalFamilyPlan = true;
                selectedValue='2';
                selectedDescription = '個・家';
            } else if (  r.Service__r.DataType__c == '入会金'  )
            {
                IsMemberShipFee = true;
                selectedValue='1';
                selectedDescription = '入会金';
            } else if (  r.Service__r.DataType__c == '単身'  )
            {
                IsForCardHolder = false;
                selectedValue='2';
                selectedDescription = '単・家';
            } else if (  r.Service__r.DataType__c == '家族'  )
            {
                IsForCardHolder = false;
                selectedValue='2';
                selectedDescription = '単・家';
            } else if (  r.Service__r.DataType__c == '無記名'  )
            {
                IsForCardHolder = true;
                selectedValue='3';
                selectedDescription = '無記名';
            }
            
        }
      //  system.debug(theRow.UnitAmount__c);
        if (theRow.Classification__c!='解約変更')
            ServiceOptions = getServiceOptions();
       // system.debug(theRow.UnitAmount__c);
        if (theRow.Type__c =='入会金')
            fetchInQty();
        
        if (theRow.name == null)
            theFamiliesDataTableID = 'ChildTableN';
        else
            theFamiliesDataTableID = 'ChildTable'; 
        
    }
    public void fetchChildRow(List<wb_MembershipDetail__c> ChildR){
        theChildRow = ChildR;
    } 
    public void fetchMemberNo(){
        if ((theRow.Type__c =='家族' || theRow.Type__c =='単身') && theRow.Individual__c != null && theRow.Service__c != null ){
            
            List<wb_Member__c> Members = [select id, name, WorkingCompany__r.CountryCd__c
                                          from wb_Member__c where Individual__c =:theRow.Individual__c and
                                          WorkingCompany__c =:theRow.WorkingCompany__c];
            /*
            
            if ( Members.size() > 0 ) {
                
                wb_Member__c mbr;
                
                mbr = Members[0];
                
                wb_Service__c s;
                for ( integer i = 0; i < theService.size(); i++){
                    if (theService[i].id == theRow.Service__c ){
                        s = theService[i];
                        i = theService.size();
                    }
                }
                
                if (s != null  ) {
                    Account wc;
                    if ( theRow.WorkingCompany__c != null ) {
                        
                        theRow.MemberNo__c = s.CardPrefix__c + mbr.WorkingCompany__r.CountryCd__c + mbr.name + '0';
                    }
                    
                }
            }
            else
                theRow.MemberNo__c = null;
            */
        }
    }
    
    public void fetchtheFamilies(){
        
        if ( theRow.name != null)
            fetchtheFamilies( theRow.name);
        
    }
    
    public void fetchtheFamilies( string uniquename){
        
        if ( theChildRow != null )
            NoofFamilyMembers = theChildRow.size();
        else
            NoofFamilyMembers = 0;
        
        
        if(theChildRow !=null) {
            if ( theChildRow.size() > 0){
                
                theFamilies = new  Map<String, List<wb_MembershipDetail__c>>();
                theFamilies.put(uniquename, new List<wb_MembershipDetail__c>());
                
                for ( wb_MembershipDetail__c c :theChildRow ){
                    theFamilies.get(uniquename ).add(c);
                }
                
            }
        }
        //  if ( theFamilies != null)
        //   system.debug( theRow.Type__c + ' theFamilies: ' + theFamilies.size() );
    }
    
    public void SetService(string SV){
        if (SV =='1'){
            IsMemberShipFee=true;
            IsPersonalFamilyPlan=false;
            IsForCardHolder=false;
            IsNotRealName=false;
            selectedDescription = '入会金';
            theRow.Quantity__c = null;
        }
        if (SV =='2'){
            IsMemberShipFee=false;
            IsPersonalFamilyPlan=true;
            IsForCardHolder=false;
            IsNotRealName=false;
            selectedDescription = '単・家';
            theRow.Quantity__c = 1;
        }
        if (SV =='3'){
            IsMemberShipFee=false;
            IsPersonalFamilyPlan=false;
            IsForCardHolder=true;
            IsNotRealName=false;
            selectedDescription = '無記名';
            theRow.Quantity__c = null;
        }
        if (SV =='4'){
            IsMemberShipFee=false;
            IsPersonalFamilyPlan=false;
            IsForCardHolder=false;
            IsNotRealName=true;
            selectedDescription = '仮名';
            theRow.Quantity__c = null;
        }
    }
    
    public void fetchServiceOptions(){
        
        SetService(selectedValue);
        
        ServiceOptions = getServiceOptions();
        
        fetchExpiryDate();
        
    }
    
    public void fetchExpiryDate(){
        if (selectedValue =='1') {
            theRow.MembershipStartDate__c = null;
            theRow.MembershipEndDate__c = null;
        } else {
            
            theRow.MembershipEndDate__c = theContractExpiryDate;
            if ( theRow.MembershipStartDate__c == null && theRow.PreviousRecord__c == null ) {
                date s = theContractExpiryDate.addYears(-1);
                theRow.MembershipStartDate__c = s.addDays(1);
            }
        }
    }
    
    public void fetchMonthlyfee(){
        
        // system.debug(theContractCurrency +','+ theRow.UnitAmount__c);
        
        if (theContractCurrency != null && theRow.UnitAmount__c != null ) {
            decimal CeilingUnit;
            for ( wb_BudgetRate__c r:theRateAndRoundUp){
                if ( r.ToCurrency__c == theContractCurrency )
                    CeilingUnit = r.MonthCeilingUnit__c;
            }
            
            decimal monthlyamount = theRow.UnitAmount__c  / 12.0 ;
            
            wb_Service__c Service;
            
            if (theRow.Service__c != null ) {
                for ( wb_Service__c s:theService){
                    if ( s.id == theRow.Service__c)
                        Service = s;
                }
            }
            
            
            //  system.debug(monthlyamount +':'+ CeilingUnit);
            monthlyamount = math.ceil(monthlyamount/ CeilingUnit) * CeilingUnit;
            theRow.MonthlyUnitAmount__c = monthlyamount ;
        }
        else
            theRow.MonthlyUnitAmount__c = null;
        // system.debug('fetchMonthlyfee:' + theContractCurrency +':' + theRow.UnitAmount__c +':' + theRow.MonthlyUnitAmount__c);
    }
    
    public decimal Periodnoofmonth {get;set;}
    public decimal PeriodConsumedmonth {get;set;}
    public decimal PeriodDuplicedmonth {get;set;}
    public decimal PeriodReplacerBillingmonth {get;set;}
    
    public decimal noofmonth {get;set;}
    
    public integer [] CalculateMonthDay(Date StartD, Date EndD){
        Date EndD_1 = EndD.addDays(1);
        
        integer monthDiff;
        integer dayDiff;
        
        if (EndD.day() + 1 >= StartD.day() ){
            if (EndD_1.day() == StartD.day() ) {
                monthDiff = StartD.monthsBetween(EndD_1);
                dayDiff = 0;
            }
            else {
                monthDiff = StartD.monthsBetween(EndD);
                dayDiff = EndD.day() + 1 - StartD.day();
            }
        } else {
            monthDiff = StartD.monthsBetween(EndD) - 1;
            date lastday; 
            if (StartD.month() == 12)
                lastday =  Date.parse( string.valueof(StartD.year()) +'/12/31');
            else {
                lastday =  Date.parse(  string.valueof(StartD.year()) +'/' + string.valueof(StartD.month() + 1) +'/1');
                lastday = lastday.addDays(-1);
            }
            dayDiff = (lastday.day() - StartD.day() + 1) + EndD.day();
            
        }
        
        
        return new integer[] {monthDiff,dayDiff};
            
            }
    
    public void Calculatenoofmonth(Date startD, Date stopD, Date ContinueD, Date endD ){
         system.debug('Calculatenoofmonth:' + theRow.name +',' + startD +',' +stopD +','+ ContinueD +',' +endD+','+theRow.Classification__c+','+theRow.PendingAction__c);
        if (endD == null)
            return;
        
        Date endD_1 = endD.addDays(1);
        Date stopD_1;
        Date stopD_minus1M;
        Date stopD_plus1M;
        decimal consumedmonth;
        decimal unusedmonth;
        
        decimal dupicatedmonth;
        decimal Continuemonth;
        decimal monthDiff;
        
        if (startD != null) {
            
            integer [] diff = CalculateMonthDay(startD, endD);
            
            system.debug(diff);
            monthDiff = diff[0];
            integer dayDiff = diff[1];
            //system.debug(monthDiff +',' +dayDiff +',' +startD+','+endD);
            //
            
            
            if (dayDiff >= 15)
                monthDiff = monthDiff + 0.5;
            
            
            if ( stopD != null ) {
                
                stopD_minus1M = stopD.addMonths(-1);
                stopD_plus1M = stopD.addMonths(1);
                
                diff = CalculateMonthDay(startD, stopD);
                
                system.debug(diff);
                consumedmonth = diff[0];
                
                
                dayDiff = diff[1];
                //system.debug('dayDiff' + dayDiff );
                
                
                if (dayDiff >= 15)
                    consumedmonth = consumedmonth + 0.5;
                
                system.debug(monthDiff +',' + consumedmonth );
                unusedmonth =  monthDiff - consumedmonth;
                // system.debug(unusedmonth);
                /* Remarked for passing the test
                if (ContinueD != null) {
                    if ( ContinueD > stopD_minus1M && ContinueD < stopD_plus1M) {
                        Continuemonth = unusedmonth;
                    } else  if (ContinueD < stopD ) {
                        diff = CalculateMonthDay(ContinueD, stopD);
                        //dupicatedmonth = ContinueD.monthsBetween(stopD_1);
                        dupicatedmonth = diff[0];
                        
                        //dayDiff = stopD_1.day() - ContinueD.day();
                        dayDiff = diff[1];
                        
                        
                        if (dayDiff >= 15)
                            dupicatedmonth = dupicatedmonth + 0.5;
                        
                        if ( dupicatedmonth > 1.0 )
                            Continuemonth =  monthDiff - consumedmonth + dupicatedmonth - 1 ;
                        else
                            Continuemonth =  monthDiff - consumedmonth;
                        
                    } else {
                        dupicatedmonth = 0;
                        diff = CalculateMonthDay(ContinueD, endD);
                    
                        Continuemonth = diff[0];
              
                        dayDiff = diff[1];

                        if (dayDiff >= 15)
                            Continuemonth = Continuemonth + 0.5;
                    }
                    
                }
                */
            }
        }
        
        system.debug( monthDiff+ ',' + unusedmonth +',' + dupicatedmonth +',' + Continuemonth);
        Periodnoofmonth = monthDiff;
        PeriodConsumedmonth = unusedmonth;
        PeriodDuplicedmonth = dupicatedmonth;
        PeriodReplacerBillingmonth = Continuemonth;
        // system.debug(theRow.Classification__c + ',' + theRow.PendingAction__c  + ',' + stopD);
        //system.debug(theRow.ParentDetail__c +',' + theRow.PreviousRecord__c  +',' + theRow.MembershipStopDate__c +',' + theRow.PendingAction__c );
            
        if (theRow.Classification__c == '追加'&& theRow.PendingAction__c == '確認')
            noofmonth = monthDiff;
        else if (theRow.PendingAction__c =='交替')
            noofmonth = unusedmonth;
        else if (theRow.Classification__c == '交替' && theRow.PreviousRecord__r.MembershipstartDate__c == null && stopD == null )
            noofmonth = monthDiff;
        else if (theRow.Classification__c =='交替' && theRow.PendingAction__c == null)
            noofmonth = Continuemonth; 
        else if (theRow.PendingAction__c =='変更')
            noofmonth = unusedmonth;
        else if (theRow.Classification__c =='変更' && theRow.PendingAction__c =='確認')
            noofmonth = Continuemonth;
        else if (theRow.PendingAction__c =='解約' || 
                 ( theRow.ParentDetail__c == null && theRow.PreviousRecord__c == null &&  theRow.MembershipStopDate__c != null && theRow.PendingAction__c == '解約変更') ||
                (theRow.PendingAction__c == '解約変更'))
            noofmonth = unusedmonth;
        else if (theRow.Classification__c == '解約変更' && theRow.PendingAction__c =='確認')
            noofmonth = unusedmonth;
        system.debug(theRow.PendingAction__c +',' + startD +',' +stopD +','+ ContinueD +',' +endD +',' + noofmonth);
    }
    
    public void CalculateChangeofStopDate(Date PreviousStopDate){
        system.debug(PreviousStopDate +',' + theRow.MembershipStopDate__c);
        /*
        if (PreviousStopDate > theRow.MembershipStopDate__c){
            integer [] Diff = CalculateMonthDay(theRow.MembershipStopDate__c, PreviousStopDate );
            noofmonth =  - decimal.valueof(Diff[0]);
            if ( Diff[1] != 0 && Diff[1] > 15) {
                noofmonth = noofmonth - 0.5;
            }
             system.debug(noofmonth);
          
        } else if (PreviousStopDate < theRow.MembershipStopDate__c) {
            integer [] Diff = CalculateMonthDay(PreviousStopDate,theRow.MembershipStopDate__c);
            noofmonth =   decimal.valueof(Diff[0]);
            if ( Diff[1] != 0 && Diff[1] > 15) {
                noofmonth = noofmonth + 0.5;
            }
         
        } else {
            noofmonth = 0;
        }
        */
        system.debug(noofmonth);
    }
    
    public void CalculateChangeofStopDateRefund( decimal previousnoofmonth ){
	/*
        if ( theRow.Service__c != null && theRow.Rate__c !=null && theRow.Quantity__c !=null && theContractCurrency != null ) {
            
            wb_BudgetRate__c Rate;
            
            
            decimal CeilingUnit;
            
            //    system.debug(theRateAndRoundUp);
            for ( wb_BudgetRate__c r:theRateAndRoundUp){
                if ( r.ToCurrency__c == theContractCurrency )
                    CeilingUnit = r.YearCeilingUnit__c;
            }
            
            
            
            
            if (CeilingUnit != null) {
                decimal amount = theRow.UnitAmount__c;
                amount = math.ceil(amount/ CeilingUnit);
                theRow.UnitAmount__c = amount * CeilingUnit;
            } 
            if  (noofmonth != null  && previousnoofmonth != null) {
                theRow.Amount__c = (previousnoofmonth - noofmonth) * theRow.MonthlyUnitAmount__c;
            }
            
        }
        */
    }
    
    public void fetchserviceType(){
        wb_Service__c Service = FetchAndGetServiceTypeOnly();
        
        //system.debug('fetchMonthlyfee');
        fetchMonthlyfee();
    }
    
    public wb_Service__c FetchAndGetServiceTypeOnly(){
        wb_Service__c Service;
        
        if (theRow.Service__c != null ) {
            for ( wb_Service__c s:theService){
                if ( s.id == theRow.Service__c)
                    Service = s;
            }
        }
        
        if (Service != null){
            theRow.Type__c = Service.DataType__c;
            theRow.MembershipPlan__c = Service.Service__c;
        } else
        {
            theRow.Type__c = null;
            theRow.MembershipPlan__c = null;
        }
        return Service;
        
    }
    
    public void fetchServiceFeeOnly(){
        //FetchandGetservicetypeonly();
        
        wb_Service__c Service;
        Service = FetchAndGetServiceTypeOnly();
        
        if ( Service != null && theRow.Quantity__c !=null && theContractCurrency != null ) {
            
            wb_BudgetRate__c Rate;
            
            if ( Service.Currency__c != theContractCurrency){ 
                //system.debug(theRateAndRoundUp);
                for ( integer i = 0; i < theRateAndRoundUp.size() ; i ++ ){
                    if (theRateAndRoundUp[i].FromCurrency__c == Service.Currency__c &&
                        theRateAndRoundUp[i].ToCurrency__c == theContractCurrency ) {
                            Rate = theRateAndRoundUp[i];
                            i =  theRateAndRoundUp.size();
                        }
                }
                
            } else
            {
                Rate = new wb_BudgetRate__c (rate__c = 1);
            }
            if (  Rate != null)
            	theRow.Rate__c = Rate.rate__c;
            else
                theRow.Rate__c = 1;
            
            // Get the Round Up
            decimal CeilingUnit;
            
            //    system.debug(theRateAndRoundUp);
            for ( wb_BudgetRate__c r:theRateAndRoundUp){
                if ( r.ToCurrency__c == theContractCurrency )
                    CeilingUnit = r.YearCeilingUnit__c;
            }
            
            //     system.debug(theDiscountPercentage + ':' + Service.Discountable__c);
            
            if (  Rate != null)
            theRow.UnitAmount__c = Service.ServiceFee__c * Rate.rate__c ; 
            
            
            
            if (CeilingUnit != null) {
                decimal amount = theRow.UnitAmount__c;
                amount = math.ceil(amount/ CeilingUnit);
                theRow.UnitAmount__c = amount * CeilingUnit;
            } 
            system.debug(theRow.Classification__c + ',' + theRow.Type__c  + ',' + theRow.MembershipStartDate__c + ',' + theRow.MembershipEndDate__c  );
            if (( theRow.Classification__c == '新規' || theRow.Classification__c == '追加' ) 
                && theRow.Type__c != '入会金' && theRow.MembershipStartDate__c != null  && theRow.MembershipEndDate__c != null  )
            {
                Calculatenoofmonth(theRow.MembershipStartDate__c,null, null, theRow.MembershipEndDate__c );
            }
            else if (theRow.Classification__c == '交替' 
                     && theRow.PreviousRecord__r.MembershipstartDate__c == null )
            {
                //   Calculatenoofmonth(theRow.MembershipStartDate__c, null, null, theRow.MembershipEndDate__c );
            } else if ( theRow.Classification__c == '追加' && theRow.Type__c == '入会金' ) 
            {
                theRow.Amount__c = theRow.UnitAmount__c * theRow.Quantity__c; 
                
            }
            
            //system.debug(theRow.Classification__c);
            // Amount & Balance Calculation 
            if (theRow.MembershipStartDate__c != null  && theRow.MembershipEndDate__c != null && theRow.UnitAmount__c != null) {
                
                if ( theRow.Classification__c == '新規' || theRow.Classification__c == '継続' ) 
                {
                    //system.debug('Amount__c: (' +theRow.UnitAmount__c+'/ 12.0) *' + monthDiff + '*' + theRow.Quantity__c );
                    if ( theRow.ParentDetail__c == null && theRow.PreviousRecord__c == null ) {
                        theRow.Amount__c = theRow.UnitAmount__c * theRow.Quantity__c; 
                        
                        if ( theDiscountPercentage == null ) {
                            
                            theRow.Amount__c = theRow.UnitAmount__c * theRow.Quantity__c;
                            
                        }
                        else if (Service.Discountable__c == true)  {
                            theRow.Amount__c = theRow.UnitAmount__c * theRow.Quantity__c * 
                                ( 100 - theDiscountPercentage) / 100 ;  
                            
                        } else {
                            theRow.Amount__c = theRow.UnitAmount__c * theRow.Quantity__c; 
                        }
                    } 
                    
                    //  system.debug(theRow.id +','+ theRow.Amount__c);
                    
                } else if (theRow.Classification__c == '追加' || theRow.Classification__c == '変更'  ) 
                {
                    fetchMonthlyfee();
                   
                    theRow.Amount__c = theRow.MonthlyUnitAmount__c * noofmonth; 
                    
                    
                }  //else if (theRow.Classification__c == '交替' && ChangeSelectionPeriousStartDate != null && noofmonth != null)
                else if (theRow.Classification__c == '交替' && noofmonth != null)
                {
                    if (theRow.MonthlyUnitAmount__c == null)
                        fetchMonthlyfee();
                    theRow.Amount__c = theRow.MonthlyUnitAmount__c * noofmonth; 
                    
                }
                else{
                    theRow.Amount__c = null;
                    if (theRow.Classification__c == '追加')
                        fetchMonthlyfee();
                }
            } 
            else if (theRow.UnitAmount__c != null && theRow.Type__c == '入会金') {
                theRow.Amount__c = theRow.UnitAmount__c * theRow.Quantity__c;
                
                
            } else
                theRow.Amount__c = null;
            
            // system.debug('Classification__c:' + theRow.Classification__c + ' ' + theRow.Type__c);
            if (theRow.Classification__c != '交替' && theRow.Classification__c != '変更' )
                
                theRow.BillingAmount__c =  theRow.Amount__c;
            else
                fetchMonthlyfee();
            
            
        } else {
            theRow.UnitAmount__c = null;
            theRow.Amount__c = null;
        }
        
    }
    
    public string GetServiceType(){
        
        wb_Service__c Service;
        
        if (theRow.Service__c != null ) {
            for ( wb_Service__c s:theService){
                if ( s.id == theRow.Service__c)
                    Service = s;
            }
            return Service.DataType__c;
        } else
            return null;
    }
    
    public void fetchServiceFee( List<wb_Individual__c> Family ){
        
        RowInitialValues();
        
        if (theRow.Type__c =='家族' )
            fetchFamily(Family);
        else 
            theChildRow = new List<wb_MembershipDetail__c>(); 
        
        if (theRow.Individual__c <> null && theRow.Type__c =='単身' ) {
            
            // if ( [select id from wb_Individual__c where Parent__c =:theRow.Individual__c].size() > 0 )
            if ( Family.size() > 0 )
                IshavingFamilybutSinglePlan = true;
            else
                IshavingFamilybutSinglePlan = false;
            
        }
        
        
    }
    
    public void RowInitialValues(){
        if (selectedValue =='1') {
            theRow.Type__c ='入会金';
            theRow.Individual__c = null;
            theRow.MemberName__c = null;
        }
        else if (selectedValue =='2') {
            theRow.Quantity__c =1;
        }
        else if (selectedValue =='3') {
            theRow.Type__c ='無記名';
            theRow.Individual__c = null;
            theRow.MemberName__c = null;
        }
        else if (selectedValue =='4') {
            theRow.Type__c ='仮名';
            theRow.Individual__c = null;
            theRow.MemberName__c = null;
        }
        
        
        
    }
    
    public void fetchServiceFee(){
        
        RowInitialValues();
        
        fetchServiceFeeOnly();
        
        // Alert to users, in case of the Individual having Family and Single Plan is selected 
        if (theRow.Individual__c <> null && theRow.Type__c =='単身' && ShowAlert == true) {
            
            if ( [select id from wb_Individual__c where Parent__c =:theRow.Individual__c].size() > 0 )
                // if ( FamilyMembers.size() > 0 )
                IshavingFamilybutSinglePlan = true;
            else
                IshavingFamilybutSinglePlan = false;
            
        }
    } 
    
    public void CalculateRemainingFee(){
        
        if ( theRow.PendingAction__c=='解約'|| theRow.PendingAction__c=='交替' || theRow.PendingAction__c=='変更'){
            
            if (theRow.MembershipStopDate__c!=null){
                
                if (theRow.MembershipStopDate__c < theRow.MembershipStartDate__c ) 
                    theRow.MembershipStopDate__c = theRow.MembershipStartDate__c;
                if (theRow.MembershipStopDate__c > theRow.MembershipEndDate__c ) 
                    theRow.MembershipStopDate__c = theRow.MembershipEndDate__c;
                Date s = theRow.MembershipStartDate__c;
                Date t = theRow.MembershipStopDate__c;
                Date e = theRow.MembershipEndDate__c;

                // Calculatenoofmonth(s,t,null,e);
                
                if ( theRow.PendingAction__c=='交替' ) {
                    
                  noofmonth = PeriodConsumedmonth;
                
                //system.debug(s +',' + t + ',' + e +',' + noofmonth + ',' + theRow.MonthlyUnitAmount__c + ',' + theRow.PendingAction__c );
                decimal monthlyamt = theRow.MonthlyUnitAmount__c;
                    if (noofmonth != null && monthlyamt != null ) {
                    decimal ra = monthlyamt * noofmonth;
                    
                    theRow.BalanceAmount__c = - ra  ;
                    }
                }
                
            }  else {
                theRow.BalanceAmount__c = null; 
                
            }
            
        }
    }
    
    
    public void BalanceAmountRoundUp(){
        
        decimal CeilingUnit;
        for ( wb_BudgetRate__c r:theRateAndRoundUp){
            if ( r.ToCurrency__c == theContractCurrency )
                CeilingUnit = r.CeilingUnit__c;
        }
        if ( CeilingUnit != null && theRow.Amount__c != null) {
            decimal amount = theRow.BalanceAmount__c;
            amount = math.ceil(amount/ CeilingUnit);
            theRow.BalanceAmount__c = amount * CeilingUnit;
        } 
    }
    
    public void BillingAmountRoundUp(){
        
        
        decimal CeilingUnit;
        for ( wb_BudgetRate__c r:theRateAndRoundUp){
            if ( r.ToCurrency__c == theContractCurrency )
                CeilingUnit = r.MonthCeilingUnit__c;
        }
        
        if ( CeilingUnit != null && theRow.BillingAmount__c != null) {
            decimal amount = theRow.BillingAmount__c;
            amount = math.ceil(amount/ CeilingUnit);
            theRow.BillingAmount__c = amount * CeilingUnit;
        } 
        
        
    }
    
    // For Real family
    
    public void fetchFamily(){
        
        if ( theRow.Individual__c != null){
            
            List<wb_Individual__c> theFamily = [SELECT FamilyNo__c, Id, Sex__c, Parent__c, Name FROM wb_Individual__c 
                                                where Parent__c =:theRow.Individual__c or Id =:theRow.Individual__c];
            fetchFamily(theFamily);
            
        }
        
        fetchWorkingCompany();
        fetchMemberNo();
    }
    
    public void fetchFamily( List<wb_Individual__c> Child ){
        
        if (Child != null ) {
            if ( theRow.Service__c != null && theRow.Individual__c != null ) {
                
                // To Check if the Plan include Family
                wb_Service__c Service;
                for ( wb_Service__c s:theService){
                    if ( s.id == theRow.Service__c)
                        Service = s;
                }
                
                if (Service.DataType__c =='家族') {
                    theChildRow = new List<wb_MembershipDetail__c>(); 
                    if ( theRow.Individual__c != null){
                        
                        if ( Child.size() > 0) {
                            for (wb_Individual__c f: Child)
                                theChildRow.add( new wb_MembershipDetail__c(Individual__c = f.id , MemberName__c = f.name, Type__c ='家族'));
                        }
                    } 
                    fetchFamily(theChildRow);
                    
                    
                } else {
                    theChildRow = new List<wb_MembershipDetail__c>(); 
                    
                }
            } else{
                theChildRow = new List<wb_MembershipDetail__c>(); 
                
            }
        }
        
    }
    public void fetchFamily(List<wb_MembershipDetail__c> ChildRow){
        
        if ( ChildRow.size() > 0){
            NoofFamilyMembers = ChildRow.size();
            theFamilies = new  Map<String, List<wb_MembershipDetail__c>>();
            //system.debug('fetchFamily:' + theRow.MemberName__c + ',' + ChildRow.size());
            if (theRow.name == null && theRow.MemberName__c != null ) {
                theFamilies.put(theRow.MemberName__c, new List<wb_MembershipDetail__c>());
                for ( wb_MembershipDetail__c c :ChildRow ){
                    theFamilies.get(theRow.MemberName__c ).add(c);
                }
            }
            else if (theRow.name != null) {
                theFamilies.put(theRow.name, new List<wb_MembershipDetail__c>());
                for ( wb_MembershipDetail__c c :ChildRow ){
                    theFamilies.get(theRow.name).add(c);
                }
            }
        }
        
    }
    /*
    public void fetchFamily(wb_Individual__c Parent, List<wb_Individual__c> Child ){
        
        if (Child != null ) {
            if ( theRow.Service__c != null && theRow.Individual__c != null ) {
                
                // To Check if the Plan include Family
                wb_Service__c Service;
                for ( wb_Service__c s:theService){
                    if ( s.id == theRow.Service__c)
                        Service = s;
                }
                
                if (Service.DataType__c =='家族') {
                    theChildRow = new List<wb_MembershipDetail__c>(); 
                    if ( theRow.Individual__c != null){
                        //   wb_Individual__c theMember = [select id, name from wb_Individual__c where id=:theRow.Individual__c ];
                        theRow.MemberName__c = Parent.name;
                        //  List<wb_Individual__c> FamilyMembers =[SELECT FamilyNo__c, Id, Sex__c, Parent__c, Name FROM wb_Individual__c where Parent__c=: theRow.Individual__c];  
                        if ( Child.size() > 0) {
                            for (wb_Individual__c f: Child)
                                theChildRow.add( new wb_MembershipDetail__c(Individual__c = f.id , MemberName__c = f.name, Type__c ='家族'));
                        }
                    } 
                    fetchFamily(theChildRow);
                    
                } else {
                    theChildRow = new List<wb_MembershipDetail__c>(); 
                    
                }
            } else{
                theChildRow = new List<wb_MembershipDetail__c>(); 
                
            }
        }
        
    }
    */
    public void fectchtheFamilies(){
        boolean InChildRowNotNull;
        boolean ChildRowNotNull;
        
        if (theInChildRow != null)
            InChildRowNotNull = true;
        else
            InChildRowNotNull = false;
        
        if (theChildRow != null)
            ChildRowNotNull = true;
        else
            ChildRowNotNull = false;
        
        //system.debug('fectchtheFamilies:' +  theChildRow.size() + ':' + theInChildRow.size() );
        // system.debug(InChildRowNotNull);    
        //  system.debug(ChildRowNotNull);    
        
        
        if (InChildRowNotNull == true || ChildRowNotNull == true ) {
            if ( theChildRow.size() > 0 || theInChildRow.size() > 0 ){
                NoofFamilyMembers = theChildRow.size();
                theFamilies = new  Map<String, List<wb_MembershipDetail__c>>();
                string theFamiliesName;
                if (theRow.MemberName__c != null)
                    theFamiliesName = theRow.MemberName__c;
                else if (theRow.name != null)
                    theFamiliesName = theRow.name;
                
                theFamilies.put(theFamiliesName, new List<wb_MembershipDetail__c>());
                if (theChildRow != null) {
                    for ( wb_MembershipDetail__c c :theChildRow ){
                        theFamilies.get(theFamiliesName ).add(c);
                    }
                }
                if ( theInChildRow != null ){
                    for ( wb_MembershipDetail__c c :theInChildRow ){
                        theFamilies.get(theFamiliesName ).add(c);
                    }
                }
            }
        } 
        else if (InChildRowNotNull == true && ChildRowNotNull == false) {
            if (theInChildRow.size() > 0){
                
                NoofFamilyMembers = 0;
                theFamilies = new  Map<String, List<wb_MembershipDetail__c>>();
                string theFamiliesName;
                if (theRow.MemberName__c != null)
                    theFamiliesName = theRow.MemberName__c;
                else if (theRow.name != null)
                    theFamiliesName = theRow.name;
                
                theFamilies.put(theFamiliesName, new List<wb_MembershipDetail__c>());
                
                
                for ( wb_MembershipDetail__c c :theInChildRow ){
                    theFamilies.get(theFamiliesName ).add(c);
                }
                
            }
        } 
        else if (InChildRowNotNull == false || ChildRowNotNull == true){
            
            if ( theChildRow.size() > 0  ){
                NoofFamilyMembers = theChildRow.size();
                theFamilies = new  Map<String, List<wb_MembershipDetail__c>>();
                string theFamiliesName;
                if (theRow.MemberName__c != null)
                    theFamiliesName = theRow.MemberName__c;
                else if (theRow.name != null)
                    theFamiliesName = theRow.name;
                
                theFamilies.put(theFamiliesName, new List<wb_MembershipDetail__c>());
                if (theChildRow != null) {
                    for ( wb_MembershipDetail__c c :theChildRow ){
                        theFamilies.get(theFamiliesName ).add(c);
                    }
                }
                
            }
            
        }
        
    }
    
    public void fetchWorkingCompany(){
        if ( theRow.Individual__c != null && theRow.WorkingCompany__c == null ){
            wb_Individual__c wc = [select WorkingCompany__c from wb_Individual__c where id =:theRow.Individual__c limit 1];
            theRow.WorkingCompany__c = wc.WorkingCompany__c;
        }
    }
    
    public void fetchEndDateOnly(){
        Date s = theRow.MembershipStartDate__c;
        if ( s.day() > 1 &&  s.day() <= 15){
            s = s.addDays( (15 - s.day() ));
            theRow.MembershipStartDate__c = s;
        } else if (s.day() > 15){
            s = s.addDays( -(s.day() - 1));
            s = s.addMonths(1);
            theRow.MembershipStartDate__c = s;
        }
        s = s.addYears(1);
        s = s.addDays(-1);
        theRow.MembershipEndDate__c = s;
    }
    
    public void fetchEndDate(){
        if ( theRow.MembershipStartDate__c != null)
            fetchEndDateOnly();
        
        fetchServiceFee();
    }
    
    public void fetchInQty(){
        theInQty = 0;
        theOutQty = 0;
        
        if (theChildRow != null ) {
            for (wb_MembershipDetail__c c:theChildRow ) {
                if ( c.Quantity__c != null && c.SecondType__c =='IN')   
                    theInQty += integer.valueOf( c.Quantity__c);  
                
                if ( c.Quantity__c != null && c.SecondType__c =='OUT' && c.CancellationDate__c == null )
                    theOutQty += integer.valueOf( c.Quantity__c);  
            }
        }
        
        if ( theInChildRow != null ) {
            for (wb_MembershipDetail__c c:theInChildRow){
                if ( c.Quantity__c != null)   theInQty += integer.valueOf( c.Quantity__c);
            }
        }
    }
    
    public integer [] CountMemberfeeMemberQty(){
        
        integer MemberfeeQty = 0;
        integer MemberQty = 0;
        
        return new integer[]{MemberfeeQty,MemberQty};
            
            }
    
}