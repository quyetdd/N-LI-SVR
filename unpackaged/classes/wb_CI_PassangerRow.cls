global with sharing class wb_CI_PassangerRow {
    
    public string theCountry {get;set;}
    public string theCommissionCurrency {get;set;}
    public boolean FeeCalculatedbyDay {get;set;}
    public integer theLegalNumberofSeats {get;set;}
    public SelectOption[] InsuranceCompanyOptions {get;set;}
    public SelectOption[] InsuranceCompanyCommodityOptions {get;set;}
    Public SelectOption[] InsuranceCompanyCommodityPlanOptions {get;set;}
    Public SelectOption[] OP_CommodityOptions {get;set;}
    Public SelectOption[] OP_CommodityPlanOptions {get;set;}
    public wb_CIC_Passenger__c thePassenger { get; set; }
    public wb_Service__c theService { get; set; }
    
    public string theMessage {get;set;}
    // Car Replacement Billing Amount
    public date ReplacementStartDate {get;set;}
    public decimal thePsgrBillingAmount {get;set;}
    public decimal theOPBillingAmount {get;set;}
    public string theRemainedMemo {get;set;}
    public string theOPRemainedMemo {get;set;}
    public string thePsgrBillingMemo {get;set;}
    public string theOPBillingMemo {get;set;}
    
    public void fetchBillAmount()
    {
        if ( thePassenger.name.indexOf('e')!=-1) {
            if (thePassenger.Psgr_InsuranceFee__c!=null){
                thePsgrBillingAmount = -(thePassenger.Psgr_RemainInsuranceFee__c - thePassenger.Psgr_InsuranceFee__c).setScale(2);
                if ( math.abs(thePsgrBillingAmount) < 0.1 && thePsgrBillingAmount <> 0.00 ){
                    thePassenger.Psgr_InsuranceFee__c =  thePassenger.Psgr_InsuranceFee__c +  thePsgrBillingAmount;
                    thePsgrBillingAmount = 0.00;
                }
      //          system.debug(thePsgrBillingAmount + ' ' + thePassenger.Psgr_CommissionRate__c + ' ' + thePassenger.Psgr_InsuranceCompany__c);
                thePassenger.Psgr_Commission__c =  (thePsgrBillingAmount * (thePassenger.Psgr_CommissionRate__c / 100.0)).setScale(2); 
            }
            else {
                thePsgrBillingAmount = null;
                thePassenger.Psgr_Commission__c = null;
            }
            
            if (thePassenger.OP_InsuranceFee__c!=null) {
                
                if (thePassenger.OP_RemainInsuranceFee__c !=null)
                    theOPBillingAmount = -(thePassenger.OP_RemainInsuranceFee__c - thePassenger.OP_InsuranceFee__c).setScale(2);  
                else
                    theOPBillingAmount = -( 0 - thePassenger.OP_InsuranceFee__c).setScale(2);                      
                    
                if ( math.abs(theOPBillingAmount) < 0.1 && theOPBillingAmount <> 0.00 ){
                    thePassenger.OP_InsuranceFee__c =  thePassenger.OP_InsuranceFee__c +  theOPBillingAmount;
                    theOPBillingAmount = 0.00;
                }
                  thePassenger.OP_Commission__c = (theOPBillingAmount * ( thePassenger.OP_CommissionRate__c / 100.0)).setScale(2);
            }
            else {
                if ( thePassenger.OP_RemainInsuranceFee__c != null ) {
                    theOPBillingAmount=-(thePassenger.OP_RemainInsuranceFee__c).setScale(2);
                    
                    if (  thePassenger.OP_CommissionRate__c == null) {
                        string pname = thePassenger.name;
                        pname = pname.left( pname.length() - 1 ) ;
                        wb_CIC_Passenger__c p = [select OP_CommissionRate__c from wb_CIC_Passenger__c where name =:pname ];
                        if ( p.OP_CommissionRate__c != null )
                            thePassenger.OP_Commission__c =(theOPBillingAmount * ( p.OP_CommissionRate__c / 100.0)).setScale(2);
                        else
                            thePassenger.OP_Commission__c = null;
                            
                    } else
                    	thePassenger.OP_Commission__c =(theOPBillingAmount * ( thePassenger.OP_CommissionRate__c / 100.0)).setScale(2);
                    
                } else {
                    theOPBillingAmount = null;
                    thePassenger.OP_Commission__c = null;
                }
            }
        }
    }
    
    //
    public wb_CI_PassangerRow(wb_CIC_Passenger__c psgr){
         thePassenger = psgr;
    }
    
    public wb_CI_PassangerRow(  wb_CIC_Passenger__c psgr, string c, string cur, integer s) {
       // system.debug( c + ' ' + cur + ' ' + s);
        thePassenger = psgr;
        theCountry = c;
        theCommissionCurrency =cur;
        theLegalNumberofSeats = s;
        FeeCalculatedbyDay = false;
        fetchPlanFeeOnly(s);
        fetchOPPlanFee();
        
    }
    
    public wb_CI_PassangerRow( string c, string cur, integer s,  wb_CIC_Passenger__c psgr) {
        thePassenger = psgr;
        theCountry = c;
        theCommissionCurrency =cur;
        theLegalNumberofSeats = s;
        InsuranceCompanyOptions = getInsuranceCompanyOptions(theCountry);
        InsuranceCompanyCommodityOptions = getInsuranceCompanyCommodityOptions();
        InsuranceCompanyCommodityPlanOptions = getInsuranceCompanyCommodityPlanOptions();
        OP_CommodityOptions = getOP_CommodityOptions();
        OP_CommodityPlanOptions = getOP_CommodityPlanOptions();
        FeeCalculatedbyDay = false;
         string name = thePassenger.name;
        //system.debug('name:' + name);
        if (name.indexOf('e',0)>0) {
            thePsgrBillingAmount = thePassenger.f_PsgrBillingAmount__c;
            theOPBillingAmount =thePassenger.f_OPBillingAmount__c;
            }
    }
    
    public wb_CI_PassangerRow( string c, string cur, integer s,  boolean d, wb_CIC_Passenger__c psgr) {
        thePassenger = psgr;
        theCountry = c;
        theCommissionCurrency =cur;
        theLegalNumberofSeats = s;
        FeeCalculatedbyDay = d;
        InsuranceCompanyOptions = getInsuranceCompanyOptions(theCountry);
        InsuranceCompanyCommodityOptions = getInsuranceCompanyCommodityOptions();
        InsuranceCompanyCommodityPlanOptions = getInsuranceCompanyCommodityPlanOptions();
        OP_CommodityOptions = getOP_CommodityOptions();
        OP_CommodityPlanOptions = getOP_CommodityPlanOptions();
    }
    // Car Replacement 
    public wb_CI_PassangerRow( string c, string cur, integer s,  boolean d, wb_CIC_Passenger__c psgr, date sd, string memo) {
        thePassenger = psgr;
        theRemainedMemo =memo;
        theCountry = c;
        theCommissionCurrency =cur;
        theLegalNumberofSeats = s;
        FeeCalculatedbyDay = d;
        ReplacementStartDate = sd;
        InsuranceCompanyOptions = getInsuranceCompanyOptions(theCountry);
        InsuranceCompanyCommodityOptions = getInsuranceCompanyCommodityOptions();
        InsuranceCompanyCommodityPlanOptions = getInsuranceCompanyCommodityPlanOptions();
        OP_CommodityOptions = getOP_CommodityOptions();
        OP_CommodityPlanOptions = getOP_CommodityPlanOptions();
        
    }
    
    
    public SelectOption[] getInsuranceCompanyOptions(string c) {  
        List<SelectOption>  opt = new  List<SelectOption>();
        opt.add(new SelectOption('','--None--'));  
        for (AggregateResult l : [ select ServiceCompany__c, count(Id) 
                                  FROM wb_Service__c
                                  where Country__c =:c and ServiceClassification__c = '搭乗' 
                                  and Currency__c =:theCommissionCurrency // To limit the Insurance currrent be same as Commission current
                                  and Enable__c = true and  ServiceCompany__c <> null
                                  group by ServiceCompany__c 	]) {  
                                      opt.add(new SelectOption(String.valueOf(l.get('ServiceCompany__c')), 
                                                               String.valueOf(l.get('ServiceCompany__c')) ));  
                                  }                           
        return opt;  
    }
    
    //0
    public void fetchCommodityOptions(){
        // Fetch after Company Name changed
        // Reset Option Values
        thePassenger.Psgr_Service__c = null;
        InsuranceCompanyCommodityOptions = getInsuranceCompanyCommodityOptions();  
        InsuranceCompanyCommodityPlanOptions = getInsuranceCompanyCommodityPlanOptions();
        OP_CommodityOptions = getOP_CommodityOptions();
        OP_CommodityPlanOptions = getOP_CommodityPlanOptions();
        
        
        thePassenger.Psgr_InsurancePlan__c = null;
        InsuranceCompanyCommodityPlanOptions = null;
        
        thePassenger.Psgr_StdDriverSeatFee__c = null;
        thePassenger.Psgr_StdPassengerSeatFee__c = null;
        //thePassenger.Psgr_InsuranceSeat__c= null;
        thePassenger.Psgr_InsuranceFee__c= null;
        thePassenger.Psgr_InsuranceFee__c= null;
        
        thePassenger.OP_Service__c= null;
        thePassenger.OP_CommodityName__c = null;
        OP_CommodityOptions = null;
        thePassenger.OP_Plan__c = null;
        OP_CommodityPlanOptions = null;
        thePassenger.OP_StdDriverSeatFee__c= null;
        thePassenger.OP_StdPassengerSeatFee__c= null;
        thePassenger.OP_InsuranceFee__c= null;
        
    }
    
    public SelectOption[] getInsuranceCompanyCommodityOptions() {  
        List<SelectOption>  opt = new  List<SelectOption>();
        if ( thePassenger.Psgr_InsuranceCompany__c != '--None--' )
        {
            opt.add(new SelectOption('','--None--'));  
            for (AggregateResult l : [ select Service__c, count(id)
                                      from wb_Service__c
                                      where Country__c =:theCountry
                                      and ServiceCompany__c =:thePassenger.Psgr_InsuranceCompany__c
                                      and ServiceClassification__c = '搭乗' and ParentService__c = null 
                                      and DataType__c = 'M'
                                      and Enable__c = true    
                                      group by Service__c	]) {  
                                          opt.add(new SelectOption(String.valueOf(l.get('Service__c')), String.valueOf(l.get('Service__c')) ));  
                                      }        
        } else
        {
            opt.add(new SelectOption('','--None--'));  
        }
        return opt;  
    } 
    
    //1
    public void fetchCompanyCommodityPlan(){
        
        thePassenger.Psgr_InsurancePlan__c = null;
        InsuranceCompanyCommodityPlanOptions = getInsuranceCompanyCommodityPlanOptions();  
        OP_CommodityOptions = getOP_CommodityOptions();
        OP_CommodityPlanOptions = getOP_CommodityPlanOptions();
        
        thePassenger.Psgr_StdDriverSeatFee__c = null;
        thePassenger.Psgr_StdPassengerSeatFee__c = null;
       // thePassenger.Psgr_InsuranceSeat__c= null;
        thePassenger.Psgr_InsuranceFee__c= null;
        thePassenger.Psgr_InsuranceFee__c= null;
        
        thePassenger.OP_Service__c= null;
        thePassenger.OP_CommodityName__c = null;
        
        thePassenger.OP_Plan__c = null;
        
        thePassenger.OP_StdDriverSeatFee__c= null;
        thePassenger.OP_StdPassengerSeatFee__c= null;
        thePassenger.OP_InsuranceFee__c= null;
        
    }
    
    //3
    public void fetchOP_CommodityPlan(){
        OP_CommodityPlanOptions = getOP_CommodityPlanOptions();  
    }        
    
    public SelectOption[] getInsuranceCompanyCommodityPlanOptions() {  
        
        List<SelectOption>  opt = new  List<SelectOption>();
        if ( thePassenger.Psgr_CommodityName__c != '--None--' )
        {
            opt.add(new SelectOption('','--None--'));  
            for (AggregateResult l : [ select Plan__c, count(id)
                                      from wb_Service__c
                                      where Country__c =:theCountry 
                                      and ServiceCompany__c =:thePassenger.Psgr_InsuranceCompany__c 
                                      and Service__c =:thePassenger.Psgr_CommodityName__c
                                      and ServiceClassification__c = '搭乗' 
                                      and DataType__c = 'M'
                                      and Enable__c = true
                                      group by Plan__c	]) {  
                                          opt.add(new SelectOption(String.valueOf(l.get('Plan__c')), String.valueOf(l.get('Plan__c')) ));  
                                      }        
        } else
        {
            opt.add(new SelectOption('','--None--'));  
        }
        return opt;  
    } 
    
    public SelectOption[] getOP_CommodityOptions(){
        
        List<SelectOption>  opt = new  List<SelectOption>();
        if ( thePassenger.Psgr_InsuranceCompany__c <> null && thePassenger.Psgr_CommodityName__c <> null 
            && thePassenger.Psgr_InsurancePlan__c <> null && thePassenger.Psgr_Service__c <> null)
        {
            opt.add(new SelectOption('','--None--'));  
            wb_Service__c s_g = [select Group__c from wb_Service__c where id =:thePassenger.Psgr_Service__c ];
            for (AggregateResult l : [ select Service__c, count(id)
                                      from wb_Service__c
                                      where Country__c =:theCountry 
                                      and ServiceCompany__c =:thePassenger.Psgr_InsuranceCompany__c
                                      and ServiceClassification__c = '搭乗'  
                                      //and ParentService__c=:thePassenger.Psgr_Service__c //S
                                      and ParentService__c=:s_g.Group__c
                                      and DataType__c = 'O' 
                                      and Enable__c = true 
                                      group by Service__c	]) {  
                                          opt.add(new SelectOption(String.valueOf(l.get('Service__c')), String.valueOf(l.get('Service__c')) ));  
                                      }       
        } else
        {
            opt.add(new SelectOption('','--None--'));  
        }
        
        return opt;
    }
    
    public SelectOption[] getOP_CommodityPlanOptions() {  
        
        List<SelectOption>  opt = new  List<SelectOption>();
        if ( thePassenger.OP_CommodityName__c <> Null && thePassenger.Psgr_Service__c <> null )
        {
            opt.add(new SelectOption('','--None--'));  
            //S
            wb_Service__c s_g = [select Group__c from wb_Service__c where id =:thePassenger.Psgr_Service__c ];
            for (AggregateResult l : [ select Plan__c, count(id)
                                      from wb_Service__c
                                      where Country__c =:theCountry 
                                      and ServiceCompany__c =:thePassenger.Psgr_InsuranceCompany__c 
                                      //and ParentService__c=:thePassenger.Psgr_Service__c //S
                                      and ParentService__c=:s_g.Group__c
                                      and DataType__c = 'O' 
                                      and Service__c =:thePassenger.OP_CommodityName__c
                                      and ServiceClassification__c = '搭乗'  
                                      and Enable__c = true 
                                      group by Plan__c	]) {  
                                          opt.add(new SelectOption(String.valueOf(l.get('Plan__c')), String.valueOf(l.get('Plan__c')) ));  
                                      }        
        } else
        {
            opt.add(new SelectOption('','--None--'));  
        }
        return opt;  
    } 


      public void fetchPlanFee()
    {
        
        fetchPlanFeeOnly(theLegalNumberofSeats) ;
        OP_CommodityOptions = getOP_CommodityOptions();
        OP_CommodityPlanOptions = getOP_CommodityPlanOptions();
        
       
    }

    
    public void fetchPlanFeeOnly(integer PassangerSeat, integer DriverSeat){
        if (thePassenger.Psgr_InsuranceCompany__c <> null &&
            thePassenger.Psgr_CommodityName__c <> null &&
            thePassenger.Psgr_InsurancePlan__c <> null ) {
                
                wb_Service__c ServiceType = [SELECT  group__r.maintype__c, DriverSeatInsurance__c
                                             FROM wb_Service__c 
                                             where  Country__c =:theCountry  
                                             and ServiceCompany__c =:thePassenger.Psgr_InsuranceCompany__c 
                                             and Service__c =:thePassenger.Psgr_CommodityName__c
                                             and Plan__c =:thePassenger.Psgr_InsurancePlan__c
                                             and ServiceClassification__c = '搭乗'  
                                             and Enable__c = true 
                                             order by lastmodifieddate desc
                                             limit 1 ];
                
                wb_Service__c Service;
                
           /*     system.debug('0 ServiceType.DriverSeatInsurance__c, FeeCalculatedbyDay, Psgr_InsuranceFee__c:' 
                             + ServiceType.DriverSeatInsurance__c + ' ' + FeeCalculatedbyDay + ' ' + thePassenger.Psgr_InsuranceFee__c
                             + ' ' +  thePassenger.Psgr_StdPassengerSeatFee__c + ' ' + thePassenger.PassagerSeatInsurance__c 
                             + ' ' + thePassenger.Psgr_StdDriverSeatFee__c + ' ' + thePassenger.DriverSeatInsurance__c );
                */
                // the Insurance Fee is applied with Fixed Amount, if DriverSeatInsurance__c is null
                 
                 if ( ServiceType.group__r.maintype__c == '席数') {
                    // Total Insurance Amount will be calculated by multiplying the seat number with fee per seat
                    integer MaxseatService =[  select id from wb_Service__c
                                             where  Country__c =:theCountry  
                                             and ServiceCompany__c =:thePassenger.Psgr_InsuranceCompany__c 
                                             and Service__c =:thePassenger.Psgr_CommodityName__c
                                             and Plan__c =:thePassenger.Psgr_InsurancePlan__c
                                             and ServiceClassification__c = '搭乗' 
                                             and MaxSeat__c <> null
                                             and Enable__c = true].size();
        			
                    if ( MaxseatService == 0 )
                        // The Service Plan will not depend on the Maximum Seat of the Car 
                        Service = [SELECT Id, Currency__c, PassengerFee__c, DriverFee__c , DriverSeatInsurance__c, CommissionRate__c FROM wb_Service__c 
                                   where  Country__c =:theCountry  
                                   and ServiceCompany__c =:thePassenger.Psgr_InsuranceCompany__c 
                                   and Service__c =:thePassenger.Psgr_CommodityName__c
                                   and Plan__c =:thePassenger.Psgr_InsurancePlan__c
                                   and ServiceClassification__c = '搭乗' 
                                   and Enable__c = true
                                   order by lastmodifieddate desc
                                   limit 1 ];
                    else
   					// The Service Plan will depend on the Maximum Seat of the Car 
                        Service = [SELECT Id, Currency__c, PassengerFee__c, DriverFee__c , DriverSeatInsurance__c, CommissionRate__c FROM wb_Service__c 
                                   where  Country__c =:theCountry  
                                   and ServiceCompany__c =:thePassenger.Psgr_InsuranceCompany__c 
                                   and Service__c =:thePassenger.Psgr_CommodityName__c
                                   and Plan__c =:thePassenger.Psgr_InsurancePlan__c
                                   and MaxSeat__c >=:PassangerSeat+DriverSeat
                                   and MinSeat__c <=:PassangerSeat+DriverSeat
                                   and ServiceClassification__c = '搭乗' 
                                   and Enable__c = true
                                   order by MaxSeat__c asc, lastmodifieddate desc
                                   limit 1 ];
 					// To pick up a Plan of the least Maximum Seat which can apply to the Car  
                    theService = Service;
                    if ( thePassenger.DriverSeatInsurance__c == null)
                    thePassenger.DriverSeatInsurance__c = theService.DriverSeatInsurance__c;  // According to the plan, update the driver insurance coverage
                    thePassenger.PassagerSeatInsurance__c= PassangerSeat;
                    
                } else if (ServiceType.group__r.maintype__c == '固定') {
                       // Total Insurance Amount will be calculated by applying a fixed Amount
                    thePassenger.DriverSeatInsurance__c = DriverSeat; // The dirver will be included under a fixed amount plan    
                    thePassenger.PassagerSeatInsurance__c= PassangerSeat;
                    
                    Service = [SELECT Id, Currency__c, PassengerFee__c, DriverFee__c , DriverSeatInsurance__c, CommissionRate__c FROM wb_Service__c 
                               where  Country__c =:theCountry  
                               and ServiceCompany__c =:thePassenger.Psgr_InsuranceCompany__c 
                               and Service__c =:thePassenger.Psgr_CommodityName__c
                               and Plan__c =:thePassenger.Psgr_InsurancePlan__c

                                  and MinSeat__c >=:PassangerSeat+DriverSeat
                               and ServiceClassification__c = '搭乗' 
                               and Enable__c = true
            
                                order by  MinSeat__c asc,
                               lastmodifieddate desc
                               limit 1 ];      
                    // Pick up a Plan with the least MinSeat which can apply to the car
                    theService = Service;
                    
                }
       
                
                if ( theService.Currency__c <> theCommissionCurrency ) {
                    wb_BudgetRate__c Rate = [select Rate__c from wb_BudgetRate__c 
                                             where FromCurrency__c =:theService.Currency__c
                                             and ToCurrency__c =:theCommissionCurrency];
                    
                    thePassenger.Psgr_StdPassengerSeatFee__c = theService.PassengerFee__c * rate.Rate__c;
                    if (theService.DriverFee__c <> null)
                        thePassenger.Psgr_StdDriverSeatFee__c = theService.DriverFee__c * rate.Rate__c;
                    else
                        thePassenger.Psgr_StdDriverSeatFee__c = theService.DriverFee__c;
               
                    
                } else {
                    thePassenger.Psgr_StdPassengerSeatFee__c = theService.PassengerFee__c ;
                    thePassenger.Psgr_StdDriverSeatFee__c = theService.DriverFee__c ;
         
                }
                
 
                
                thePassenger.Psgr_Service__c  = theService.Id;  
                // thePassenger.Psgr_InsuranceFee__c = 0;
                if ( theService.PassengerFee__c != null && FeeCalculatedbyDay == false  ){
                    if ( ServiceType.group__r.maintype__c == '席数' )
                        thePassenger.Psgr_InsuranceFee__c = 
                       // thePassenger.Psgr_StdPassengerSeatFee__c * ( thePassenger.Psgr_InsuranceSeat__c - theService.DriverSeatInsurance__c )+
                         thePassenger.Psgr_StdPassengerSeatFee__c *  thePassenger.PassagerSeatInsurance__c +
                        thePassenger.Psgr_StdDriverSeatFee__c * thePassenger.DriverSeatInsurance__c ;
                    else
                        thePassenger.Psgr_InsuranceFee__c = thePassenger.Psgr_StdPassengerSeatFee__c ;
                    
                } else {
                    thePassenger.Psgr_InsuranceFee__c = null;
                    
                }
                
                if (  FeeCalculatedbyDay == true  ){
                    if (thePassenger.Psgr_CurrentEndDate__c > thePassenger.Psgr_CurrentStartDate__c ) {
                        // Date s = thePassenger.Psgr_CurrentStartDate__c;
                        Date s;
                        if ( thePassenger.name.indexOf('e')!=-1) {
                            s = ReplacementStartDate;
                        } else 
                            s = thePassenger.Psgr_CurrentStartDate__c;
                        
                        Date e = s.addYears(1);
                        e = e.addDays(-1);
                        Date endDat = thePassenger.Psgr_CurrentEndDate__c;
                        integer daysofperiod = integer.valueof(s.daysBetween(e)+1) ;
                        integer days = integer.valueof(s.daysBetween(endDat)+1) ;
                        
            			if (  ServiceType.group__r.maintype__c == '席数' ) {
                            
                        theMessage = String.valueOf((
                            thePassenger.Psgr_StdPassengerSeatFee__c *  thePassenger.PassagerSeatInsurance__c +
                            thePassenger.Psgr_StdDriverSeatFee__c * theService.DriverSeatInsurance__c 
                        )) +':' +
                            String.valueOf(daysofperiod) +':' + String.valueOf(days); 
                        
                        
                            thePassenger.Psgr_InsuranceFee__c = (((
                                thePassenger.Psgr_StdPassengerSeatFee__c *  thePassenger.PassagerSeatInsurance__c  +
                                thePassenger.Psgr_StdDriverSeatFee__c * theService.DriverSeatInsurance__c 
                            ) *  days )/ daysofperiod).setScale(2);
                        } else
                        {
                            theMessage = String.valueOf((
                               thePassenger.Psgr_StdPassengerSeatFee__c
                            )) +':' +
                                String.valueOf(daysofperiod) +':' + String.valueOf(days); 
                            
                            thePassenger.Psgr_InsuranceFee__c = (((
                                thePassenger.Psgr_StdPassengerSeatFee__c 
                            ) *  days )/ daysofperiod).setScale(2);
                            
                        }
                        
                        
                        
                    } else
                        thePassenger.Psgr_InsuranceFee__c = null;
                }
                
                thePassenger.Psgr_CommissionRate__c = Service.CommissionRate__c;
                if( thePassenger.Psgr_InsuranceFee__c != null && thePassenger.Psgr_CommissionRate__c != null)
                 thePassenger.Psgr_Commission__c =   thePassenger.Psgr_InsuranceFee__c * ( thePassenger.Psgr_CommissionRate__c / 100.0 );
                else 
                    thePassenger.Psgr_Commission__c =  null;
                
                
            } else {
                thePassenger.Psgr_InsuranceFee__c = null;
                thePassenger.Psgr_CommissionRate__c = null;
                thePassenger.Psgr_Commission__c = null;
            }
        
        if ( thePassenger.name.indexOf('e')!=-1){
 			fetchBillAmount(); 
         
        }
           
        
    }
  
    public void fetchPlanFeeOnly(integer NumberofSeat)   {
        
      //  system.debug(thePassenger.name + ' ' + thePassenger.Psgr_CommissionRate__c + ' ' + thePassenger.Psgr_InsuranceCompany__c + ' ' + 
      //               thePassenger.Psgr_CommodityName__c + ' ' +  thePassenger.Psgr_InsurancePlan__c  );
        
        if (thePassenger.Psgr_InsuranceCompany__c <> null &&
            thePassenger.Psgr_CommodityName__c <> null &&
            thePassenger.Psgr_InsurancePlan__c <> null ) {
                
                wb_Service__c ServiceType = [SELECT  group__r.maintype__c, DriverSeatInsurance__c
                                             FROM wb_Service__c 
                                             where  Country__c =:theCountry  
                                             and ServiceCompany__c =:thePassenger.Psgr_InsuranceCompany__c 
                                             and Service__c =:thePassenger.Psgr_CommodityName__c
                                             and Plan__c =:thePassenger.Psgr_InsurancePlan__c
                                             and ServiceClassification__c = '搭乗'  
                                             and Enable__c = true 
                                             order by lastmodifieddate desc
                                             limit 1 ];
                
                wb_Service__c Service;
                

                
                // the Insurance Fee is applied with Fixed Amount, if DriverSeatInsurance__c is null
                
                if ( ServiceType.DriverSeatInsurance__c == 0 )
                    thePassenger.DriverSeatInsurance__c = 0 ;
                else
                    thePassenger.DriverSeatInsurance__c = 1; 
                
                thePassenger.PassagerSeatInsurance__c= NumberofSeat - 1;
                
               //  system.debug(thePassenger.name + ' ' + ServiceType.group__r.maintype__c );
                if ( ServiceType.group__r.maintype__c == '席数') {
                    
                    
                    // Total Insurance Amount will be calculated by multiplying the seat number with fee per seat
                    integer MaxseatService =[  select id from wb_Service__c
                                             where  Country__c =:theCountry  
                                             and ServiceCompany__c =:thePassenger.Psgr_InsuranceCompany__c 
                                             and Service__c =:thePassenger.Psgr_CommodityName__c
                                             and Plan__c =:thePassenger.Psgr_InsurancePlan__c
                                             and ServiceClassification__c = '搭乗' 
                                             and MaxSeat__c <> null
                                             and Enable__c = true].size();
                    
                    if ( MaxseatService == 0 )
                        // The Service Plan will not depend on the Maximum Seat of the Car 
                        Service = [SELECT Id, Currency__c, PassengerFee__c, DriverFee__c , DriverSeatInsurance__c, CommissionRate__c FROM wb_Service__c 
                                   where  Country__c =:theCountry  
                                   and ServiceCompany__c =:thePassenger.Psgr_InsuranceCompany__c 
                                   and Service__c =:thePassenger.Psgr_CommodityName__c
                                   and Plan__c =:thePassenger.Psgr_InsurancePlan__c
                                   and ServiceClassification__c = '搭乗' 
                                   and Enable__c = true
                                   order by lastmodifieddate desc
                                   limit 1 ];
                    else
                        // The Service Plan will depend on the Maximum Seat of the Car 
                        Service = [SELECT Id, Currency__c, PassengerFee__c, DriverFee__c , DriverSeatInsurance__c, CommissionRate__c FROM wb_Service__c 
                                   where  Country__c =:theCountry  
                                   and ServiceCompany__c =:thePassenger.Psgr_InsuranceCompany__c 
                                   and Service__c =:thePassenger.Psgr_CommodityName__c
                                   and Plan__c =:thePassenger.Psgr_InsurancePlan__c
                                   and MaxSeat__c >=: thePassenger.DriverSeatInsurance__c + thePassenger.PassagerSeatInsurance__c
                                   and MinSeat__c <=: thePassenger.DriverSeatInsurance__c + thePassenger.PassagerSeatInsurance__c
                                   and ServiceClassification__c = '搭乗' 
                                   and Enable__c = true
                                   order by MaxSeat__c asc, lastmodifieddate desc
                                   limit 1 ];
                    // To pick up a Plan of the least Maximum Seat which can apply to the Car  
                    theService = Service;
                    
                    // thePassenger.DriverSeatInsurance__c = theService.DriverSeatInsurance__c;  // According to the plan, update the driver insurance coverage
                    //thePassenger.PassagerSeatInsurance__c= NumberofSeat - 1;
                    
                } else if (ServiceType.group__r.maintype__c == '固定') {
                    
                    
                    Service = [SELECT Id, Currency__c, PassengerFee__c, DriverFee__c , DriverSeatInsurance__c, CommissionRate__c FROM wb_Service__c 
                               where  Country__c =:theCountry  
                               and ServiceCompany__c =:thePassenger.Psgr_InsuranceCompany__c 
                               and Service__c =:thePassenger.Psgr_CommodityName__c
                               and Plan__c =:thePassenger.Psgr_InsurancePlan__c
                               //    and MinSeat__c >=:NumberofSeat
                               and MinSeat__c >=:thePassenger.DriverSeatInsurance__c + thePassenger.PassagerSeatInsurance__c
                               and ServiceClassification__c = '搭乗' 
                               and Enable__c = true
                               //             order by MaxSeat__c asc, MinSeat__c asc,
                               order by  MinSeat__c asc,
                               lastmodifieddate desc
                               limit 1 ];      
                    // Pick up a Plan with the least MinSeat which can apply to the car
                    theService = Service;
                    
                }
                // Service.CommissionRate__c
               //   system.debug(thePassenger.name + ' ' + Service.CommissionRate__c );
                if ( theService.Currency__c <> theCommissionCurrency ) {
                    wb_BudgetRate__c Rate = [select Rate__c from wb_BudgetRate__c 
                                             where FromCurrency__c =:theService.Currency__c
                                             and ToCurrency__c =:theCommissionCurrency];
                    
                    thePassenger.Psgr_StdPassengerSeatFee__c = theService.PassengerFee__c * rate.Rate__c;
                    if (theService.DriverFee__c <> null)
                        thePassenger.Psgr_StdDriverSeatFee__c = theService.DriverFee__c * rate.Rate__c;
                    else
                        thePassenger.Psgr_StdDriverSeatFee__c = theService.DriverFee__c;
                    
                    
                } else {
                    thePassenger.Psgr_StdPassengerSeatFee__c = theService.PassengerFee__c ;
                    thePassenger.Psgr_StdDriverSeatFee__c = theService.DriverFee__c ;
                    
                }
                
                
                
                thePassenger.Psgr_Service__c  = theService.Id;  
                
                if ( theService.PassengerFee__c != null && FeeCalculatedbyDay == false  ){
                    if (  ServiceType.group__r.maintype__c == '席数' )
                        thePassenger.Psgr_InsuranceFee__c = 
                        // thePassenger.Psgr_StdPassengerSeatFee__c * ( thePassenger.Psgr_InsuranceSeat__c - theService.DriverSeatInsurance__c )+
                        thePassenger.Psgr_StdPassengerSeatFee__c *  thePassenger.PassagerSeatInsurance__c +
                        thePassenger.Psgr_StdDriverSeatFee__c * thePassenger.DriverSeatInsurance__c ;
                    else
                        thePassenger.Psgr_InsuranceFee__c = thePassenger.Psgr_StdPassengerSeatFee__c ;
                    
                } else {
                    thePassenger.Psgr_InsuranceFee__c = null;
                    
                }
                
                if (  FeeCalculatedbyDay == true  ){
                    if (thePassenger.Psgr_CurrentEndDate__c > thePassenger.Psgr_CurrentStartDate__c ) {
                        // Date s = thePassenger.Psgr_CurrentStartDate__c;
                        Date s;
                        if ( thePassenger.name.indexOf('e')!=-1) {
                            s = ReplacementStartDate;
                        } else 
                            s = thePassenger.Psgr_CurrentStartDate__c;
                        
                        Date e = s.addYears(1);
                        e = e.addDays(-1);
                        Date endDat = thePassenger.Psgr_CurrentEndDate__c;
                        integer daysofperiod = integer.valueof(s.daysBetween(e)+1) ;
                        integer days = integer.valueof(s.daysBetween(endDat)+1) ;
                        
                        if ( ServiceType.group__r.maintype__c == '席数' ) {
                            
                            theMessage = String.valueOf((
                                thePassenger.Psgr_StdPassengerSeatFee__c *  thePassenger.PassagerSeatInsurance__c  +
                                thePassenger.Psgr_StdDriverSeatFee__c * theService.DriverSeatInsurance__c 
                            )) +':' +
                                String.valueOf(daysofperiod) +':' + String.valueOf(days); 
                            
                            
                            thePassenger.Psgr_InsuranceFee__c = (((
                                thePassenger.Psgr_StdPassengerSeatFee__c * thePassenger.PassagerSeatInsurance__c  +
                                thePassenger.Psgr_StdDriverSeatFee__c * theService.DriverSeatInsurance__c 
                            ) *  days )/ daysofperiod).setScale(2);
                        } else
                        {
                            theMessage = String.valueOf((
                                thePassenger.Psgr_StdPassengerSeatFee__c
                            )) +':' +
                                String.valueOf(daysofperiod) +':' + String.valueOf(days); 
                            
                            thePassenger.Psgr_InsuranceFee__c = (((
                                thePassenger.Psgr_StdPassengerSeatFee__c 
                            ) *  days )/ daysofperiod).setScale(2);
                            
                        }
                        
                        
                        
                    } else
                        thePassenger.Psgr_InsuranceFee__c = null;
                } 
                
                thePassenger.Psgr_CommissionRate__c = Service.CommissionRate__c;
                //system.debug('671 ' + thePassenger.Psgr_InsuranceFee__c + ' ' + thePassenger.Psgr_CommissionRate__c );
                if ( thePassenger.Psgr_InsuranceFee__c != null && thePassenger.Psgr_CommissionRate__c != null )
                    thePassenger.Psgr_Commission__c = thePassenger.Psgr_InsuranceFee__c * ( thePassenger.Psgr_CommissionRate__c/100.0);
                else
                    thePassenger.Psgr_Commission__c = null;
                
                
                
            } else {
                thePassenger.Psgr_CommissionRate__c = null;
                thePassenger.Psgr_InsuranceFee__c = null;
                thePassenger.Psgr_Commission__c = null;
            }
        
       // system.debug(thePassenger.name + ' ' + thePassenger.Psgr_CommissionRate__c + ' ' + thePassenger.Psgr_InsuranceCompany__c + ' ' + 
      //               thePassenger.Psgr_CommodityName__c + ' ' +  thePassenger.Psgr_InsurancePlan__c  );
        if ( thePassenger.name != null) {
            if ( thePassenger.name.indexOf('e')!=-1){
                fetchBillAmount(); 
                // thePassenger.Psgr_Commission__c = thePsgrBillingAmount * thePassenger.Psgr_CommissionRate__c;
            }
        }
    }
    
     public void fetchPlanFeeOnlyOffLine(integer NumberofSeat, List<wb_Service__c> theServiceMaster )   {
        system.debug('fetchPlanFeeOnlyOffLine' + NumberofSeat + ' ' + theServiceMaster.size());
      //  system.debug(thePassenger.name + ' ' + thePassenger.Psgr_CommissionRate__c + ' ' + thePassenger.Psgr_InsuranceCompany__c + ' ' + 
      //               thePassenger.Psgr_CommodityName__c + ' ' +  thePassenger.Psgr_InsurancePlan__c  );
        
          system.debug( thePassenger.Psgr_InsuranceCompany__c + ' ' + thePassenger.Psgr_CommodityName__c + ' ' + thePassenger.Psgr_InsurancePlan__c);
        if (thePassenger.Psgr_InsuranceCompany__c <> null &&
            thePassenger.Psgr_CommodityName__c <> null &&
            thePassenger.Psgr_InsurancePlan__c <> null ) {
                
                wb_Service__c ServiceType; 
                
                for ( integer i = 0; i < theServiceMaster.size(); i ++){
                    if ( theServiceMaster[i].ServiceCompany__c == thePassenger.Psgr_InsuranceCompany__c &&
                        theServiceMaster[i].Service__c == thePassenger.Psgr_CommodityName__c &&
                        theServiceMaster[i].Plan__c == thePassenger.Psgr_InsurancePlan__c 
                       ) {
                           ServiceType =  theServiceMaster[i];   
                           i = theServiceMaster.size();
                       }
                }
                
                 // system.debug( ServiceType.id + ' ' + ServiceType.group__r.maintype__c + ' ' +  ServiceType.DriverSeatInsurance__c );
                
                if ( ServiceType != null) {
                wb_Service__c Service;
                

                
                // the Insurance Fee is applied with Fixed Amount, if DriverSeatInsurance__c is null
                
                if ( ServiceType.DriverSeatInsurance__c == 0 )
                    thePassenger.DriverSeatInsurance__c = 0 ;
                else
                    thePassenger.DriverSeatInsurance__c = 1; 
                
                thePassenger.PassagerSeatInsurance__c= NumberofSeat - 1;
                
               //  system.debug(thePassenger.name + ' ' + ServiceType.group__r.maintype__c );
                if ( ServiceType.group__r.maintype__c == '席数') {
                    
                    
                    // Total Insurance Amount will be calculated by multiplying the seat number with fee per seat
                    integer MaxseatService=0; 
                    

                    
                    for ( integer i = 0; i < theServiceMaster.size(); i ++){
                        if ( theServiceMaster[i].ServiceCompany__c == thePassenger.Psgr_InsuranceCompany__c &&
                            theServiceMaster[i].Service__c == thePassenger.Psgr_CommodityName__c &&
                            theServiceMaster[i].Plan__c == thePassenger.Psgr_InsurancePlan__c &&
                            theServiceMaster[i].MaxSeat__c <> null
                           ) {
                               MaxseatService ++;    
                               i = theServiceMaster.size();
                           }
                    }
                    
                    system.debug( MaxseatService );
                    if ( MaxseatService == 0 ) {
                        // The Service Plan will not depend on the Maximum Seat of the Car 
                     
                        
                        for ( integer i = 0; i < theServiceMaster.size(); i ++){
                            if ( theServiceMaster[i].ServiceCompany__c == thePassenger.Psgr_InsuranceCompany__c &&
                                theServiceMaster[i].Service__c == thePassenger.Psgr_CommodityName__c &&
                                theServiceMaster[i].Plan__c == thePassenger.Psgr_InsurancePlan__c 
                              
                               ) {
                                   Service = theServiceMaster[i];
                                   i = theServiceMaster.size();
                               }
                        }
                        
                        system.debug(thePassenger.Psgr_InsuranceCompany__c + ' ' + thePassenger.Psgr_CommodityName__c + ' ' + thePassenger.Psgr_InsurancePlan__c );
                        system.debug(Service.id);
                        
                    }
                    else {
                        // The Service Plan will depend on the Maximum Seat of the Car 
          
                        
                        for ( integer i = 0; i < theServiceMaster.size(); i ++){
                            if ( theServiceMaster[i].ServiceCompany__c == thePassenger.Psgr_InsuranceCompany__c &&
                                theServiceMaster[i].Service__c == thePassenger.Psgr_CommodityName__c &&
                                theServiceMaster[i].Plan__c == thePassenger.Psgr_InsurancePlan__c &&
                                theServiceMaster[i].MaxSeat__c  >= thePassenger.DriverSeatInsurance__c + thePassenger.PassagerSeatInsurance__c && 
                                theServiceMaster[i].MinSeat__c <= thePassenger.DriverSeatInsurance__c + thePassenger.PassagerSeatInsurance__c
                               ) {
                                   Service = theServiceMaster[i];
                                   i = theServiceMaster.size();
                               }
                        }
                    }
                    // To pick up a Plan of the least Maximum Seat which can apply to the Car  
                    theService = Service;
                    
                    // thePassenger.DriverSeatInsurance__c = theService.DriverSeatInsurance__c;  // According to the plan, update the driver insurance coverage
                    //thePassenger.PassagerSeatInsurance__c= NumberofSeat - 1;
                    
                } else if (ServiceType.group__r.maintype__c == '固定') {
                    
                    

                    
                    for ( integer i = 0; i < theServiceMaster.size(); i ++){
                        if ( theServiceMaster[i].ServiceCompany__c == thePassenger.Psgr_InsuranceCompany__c &&
                            theServiceMaster[i].Service__c == thePassenger.Psgr_CommodityName__c &&
                            theServiceMaster[i].Plan__c == thePassenger.Psgr_InsurancePlan__c &&
							theServiceMaster[i].MinSeat__c >= thePassenger.DriverSeatInsurance__c + thePassenger.PassagerSeatInsurance__c
                           ) {
                               Service = theServiceMaster[i];
                               i = theServiceMaster.size();
                           }
                    }
                    
                    // Pick up a Plan with the least MinSeat which can apply to the car
                    theService = Service;
                    
                }
                // Service.CommissionRate__c
                  system.debug(theService.id + ' ' + theService.Currency__c + ' ' + theCommissionCurrency);
                if ( theService.Currency__c <> theCommissionCurrency ) {
                    wb_BudgetRate__c Rate = [select Rate__c from wb_BudgetRate__c 
                                             where FromCurrency__c =:theService.Currency__c
                                             and ToCurrency__c =:theCommissionCurrency];
                    
                    thePassenger.Psgr_StdPassengerSeatFee__c = theService.PassengerFee__c * rate.Rate__c;
                    if (theService.DriverFee__c <> null)
                        thePassenger.Psgr_StdDriverSeatFee__c = theService.DriverFee__c * rate.Rate__c;
                    else
                        thePassenger.Psgr_StdDriverSeatFee__c = theService.DriverFee__c;
                    
                    
                } else {
                    thePassenger.Psgr_StdPassengerSeatFee__c = theService.PassengerFee__c ;
                    thePassenger.Psgr_StdDriverSeatFee__c = theService.DriverFee__c ;
                    
                }
                
                
                
                thePassenger.Psgr_Service__c  = theService.Id;  
                
                if ( theService.PassengerFee__c != null && FeeCalculatedbyDay == false  ){
                    if (  ServiceType.group__r.maintype__c == '席数' )
                        thePassenger.Psgr_InsuranceFee__c = 
                        // thePassenger.Psgr_StdPassengerSeatFee__c * ( thePassenger.Psgr_InsuranceSeat__c - theService.DriverSeatInsurance__c )+
                        thePassenger.Psgr_StdPassengerSeatFee__c *  thePassenger.PassagerSeatInsurance__c +
                        thePassenger.Psgr_StdDriverSeatFee__c * thePassenger.DriverSeatInsurance__c ;
                    else
                        thePassenger.Psgr_InsuranceFee__c = thePassenger.Psgr_StdPassengerSeatFee__c ;
                    
                } else {
                    thePassenger.Psgr_InsuranceFee__c = null;
                    
                }
                
                if (  FeeCalculatedbyDay == true  ){
                    if (thePassenger.Psgr_CurrentEndDate__c > thePassenger.Psgr_CurrentStartDate__c ) {
                        // Date s = thePassenger.Psgr_CurrentStartDate__c;
                        Date s;
                        if ( thePassenger.name.indexOf('e')!=-1) {
                            s = ReplacementStartDate;
                        } else 
                            s = thePassenger.Psgr_CurrentStartDate__c;
                        
                        Date e = s.addYears(1);
                        e = e.addDays(-1);
                        Date endDat = thePassenger.Psgr_CurrentEndDate__c;
                        integer daysofperiod = integer.valueof(s.daysBetween(e)+1) ;
                        integer days = integer.valueof(s.daysBetween(endDat)+1) ;
                        
                        if ( ServiceType.group__r.maintype__c == '席数' ) {
                            
                            theMessage = String.valueOf((
                                thePassenger.Psgr_StdPassengerSeatFee__c *  thePassenger.PassagerSeatInsurance__c  +
                                thePassenger.Psgr_StdDriverSeatFee__c * theService.DriverSeatInsurance__c 
                            )) +':' +
                                String.valueOf(daysofperiod) +':' + String.valueOf(days); 
                            
                            
                            thePassenger.Psgr_InsuranceFee__c = (((
                                thePassenger.Psgr_StdPassengerSeatFee__c * thePassenger.PassagerSeatInsurance__c  +
                                thePassenger.Psgr_StdDriverSeatFee__c * theService.DriverSeatInsurance__c 
                            ) *  days )/ daysofperiod).setScale(2);
                        } else
                        {
                            theMessage = String.valueOf((
                                thePassenger.Psgr_StdPassengerSeatFee__c
                            )) +':' +
                                String.valueOf(daysofperiod) +':' + String.valueOf(days); 
                            
                            thePassenger.Psgr_InsuranceFee__c = (((
                                thePassenger.Psgr_StdPassengerSeatFee__c 
                            ) *  days )/ daysofperiod).setScale(2);
                            
                        }
                        
                        
                        
                    } else
                        thePassenger.Psgr_InsuranceFee__c = null;
                } 
                
                thePassenger.Psgr_CommissionRate__c = Service.CommissionRate__c;
                //system.debug('671 ' + thePassenger.Psgr_InsuranceFee__c + ' ' + thePassenger.Psgr_CommissionRate__c );
                if ( thePassenger.Psgr_InsuranceFee__c != null && thePassenger.Psgr_CommissionRate__c != null )
                    thePassenger.Psgr_Commission__c = thePassenger.Psgr_InsuranceFee__c * ( thePassenger.Psgr_CommissionRate__c/100.0);
                else
                    thePassenger.Psgr_Commission__c = null;
                }
                
                
            } else {
                thePassenger.Psgr_CommissionRate__c = null;
                thePassenger.Psgr_InsuranceFee__c = null;
                thePassenger.Psgr_Commission__c = null;
            }
        
       // system.debug(thePassenger.name + ' ' + thePassenger.Psgr_CommissionRate__c + ' ' + thePassenger.Psgr_InsuranceCompany__c + ' ' + 
      //               thePassenger.Psgr_CommodityName__c + ' ' +  thePassenger.Psgr_InsurancePlan__c  );
        if ( thePassenger.name != null) {
            if ( thePassenger.name.indexOf('e')!=-1){
                fetchBillAmount(); 
                // thePassenger.Psgr_Commission__c = thePsgrBillingAmount * thePassenger.Psgr_CommissionRate__c;
            }
        }
    }
    
    public void fetchPlanFeeManual(){
        
        fetchPlanFeeOnly(integer.valueof(thePassenger.PassagerSeatInsurance__c) ,  integer.valueof(thePassenger.DriverSeatInsurance__c));
    }
    
    public void ChangetheLegalNumberofSeats(){
        theLegalNumberofSeats = integer.valueof(thePassenger.PassagerSeatInsurance__c) + integer.valueof(thePassenger.DriverSeatInsurance__c) ;
        fetchPlanFeeOnly(integer.valueof(thePassenger.PassagerSeatInsurance__c) ,  integer.valueof(thePassenger.DriverSeatInsurance__c));
    }

    public void ChangetheNumberofPassagerSeats(){
        theLegalNumberofSeats = integer.valueof(thePassenger.PassagerSeatInsurance__c) +  integer.valueof(thePassenger.DriverSeatInsurance__c);
        fetchPlanFeeOnly(integer.valueof(thePassenger.PassagerSeatInsurance__c) , integer.valueof(thePassenger.DriverSeatInsurance__c));
    }
    
    public void ChangethePsgrInsuranceFee(){
       thePassenger.Psgr_Commission__c = thePassenger.Psgr_InsuranceFee__c * ( thePassenger.Psgr_CommissionRate__c / 100.0 );
    
    }
    
       public void ChangetheOPInsuranceFee(){
       thePassenger.OP_Commission__c = thePassenger.OP_InsuranceFee__c * ( thePassenger.OP_CommissionRate__c / 100.0 );
    
    }

      public void ChangethePsgrCommission(){
       thePassenger.Psgr_CommissionRate__c = (thePassenger.Psgr_Commission__c /  thePassenger.Psgr_InsuranceFee__c )* 100;
    
    }
    
     public void ChangetheOPCommission(){
       thePassenger.OP_CommissionRate__c = (thePassenger.OP_Commission__c /  thePassenger.OP_InsuranceFee__c )* 100;
    
    }

    
    public void fetchOPPlanFee()
    {
         //  system.debug(thePassenger.Psgr_Service__c );
        wb_Service__c s_g = [select Group__c from wb_Service__c where id =:thePassenger.Psgr_Service__c ];
      //  system.debug(' fetchOPPlanFee:' + thePassenger.OP_CommodityName__c + ' ' + thePassenger.OP_Plan__c );
        
        if ( s_g.Group__c <> null && thePassenger.Psgr_InsuranceCompany__c <> null 
            && thePassenger.OP_CommodityName__c <> null && thePassenger.OP_Plan__c <> null) {
                
                wb_Service__c ServiceOPType = [SELECT  ParentService__r.Optiontype__c ,DriverSeatInsurance__c FROM wb_Service__c 
                                               where  Country__c =:theCountry  
                                               and ServiceCompany__c =:thePassenger.Psgr_InsuranceCompany__c 
                                               and Service__c =:thePassenger.OP_CommodityName__c
                                               and Plan__c =:thePassenger.OP_Plan__c
                                               and ParentService__c=:s_g.Group__c
                                               and ServiceClassification__c = '搭乗'  
                                               and Enable__c = true and DataType__c = 'O'
                                               order by lastmodifieddate desc
                                               limit 1 ];
                

                wb_Service__c Service;
                
                if ( ServiceOPType.ParentService__r.Optiontype__c == '席数') {
                    Service = [SELECT Id, Currency__c, PassengerFee__c, DriverFee__c , DriverSeatInsurance__c, CommissionRate__c FROM wb_Service__c 
                               where  Country__c =:theCountry  
                               and ServiceCompany__c =:thePassenger.Psgr_InsuranceCompany__c 
                               and Service__c =:thePassenger.OP_CommodityName__c
                               and Plan__c =:thePassenger.OP_Plan__c
                               //and ParentService__c=:thePassenger.Psgr_Service__c
                               and ParentService__c=:s_g.Group__c and DataType__c = 'O'
                               and ServiceClassification__c = '搭乗' 
                               and Enable__c = true   
                               order by lastmodifieddate desc
                               limit 1 ];                
                } else{
                    integer seat;
                  //  if (thePassenger.Psgr_InsuranceSeat__c==null)
                  //      thePassenger.Psgr_InsuranceSeat__c = 0;
                    
                    
                    Service = [SELECT Id, Currency__c, PassengerFee__c, DriverFee__c , MaxSeat__c, CommissionRate__c FROM wb_Service__c 
                               where  Country__c =:theCountry  
                               and ServiceCompany__c =:thePassenger.Psgr_InsuranceCompany__c 
                               and Service__c =:thePassenger.OP_CommodityName__c
                               and Plan__c =:thePassenger.OP_Plan__c
                               //and ParentService__c=:thePassenger.Psgr_Service__c
                               and ParentService__c=:s_g.Group__c and DataType__c = 'O'
                               and ServiceClassification__c = '搭乗'  
                              // and MaxSeat__c >=:thePassenger.Psgr_InsuranceSeat__c
                               and MaxSeat__c >=:( thePassenger.DriverSeatInsurance__c + thePassenger.PassagerSeatInsurance__c)
                               and Enable__c = true   
                               order by MinSeat__c desc, MaxSeat__c asc, lastmodifieddate desc
                               limit 1 ];       
                }
                
                
                if ( Service.Currency__c <> theCommissionCurrency ) {
                    wb_BudgetRate__c Rate = [select Rate__c from wb_BudgetRate__c 
                                             where FromCurrency__c =:Service.Currency__c
                                             and ToCurrency__c =:theCommissionCurrency];
                    
                    thePassenger.OP_StdPassengerSeatFee__c = Service.PassengerFee__c * rate.Rate__c;
                    thePassenger.OP_Service__c  = Service.Id;   
                    thePassenger.OP_StdDriverSeatFee__c = Service.DriverFee__c * rate.Rate__c;
                    
                } else {
                    thePassenger.OP_StdPassengerSeatFee__c = Service.PassengerFee__c ;
                    thePassenger.OP_Service__c  = Service.Id;   
                    thePassenger.OP_StdDriverSeatFee__c = Service.DriverFee__c ;
                }
                
                if (  FeeCalculatedbyDay == true  ){
                    if (thePassenger.OP_CurrentEndDate__c > thePassenger.OP_CurrentStartDate__c ) {
                        // Date s = thePassenger.OP_CurrentStartDate__c;
                        Date s;
                        if ( thePassenger.name.indexOf('e')!=-1) {
                            s = ReplacementStartDate;
                        } else 
                            s = thePassenger.OP_CurrentStartDate__c;
                        
                        Date e = s.addYears(1);
                        e = e.addDays(-1);
                        Date endDat = thePassenger.OP_CurrentEndDate__c;
                        
                        integer daysofperiod = integer.valueof(s.daysBetween(e)+1) ;
                        integer days = integer.valueof(s.daysBetween(endDat)+1) ;
                        
                        if ( ServiceOPType.ParentService__r.Optiontype__c == '席数') {
                            
                            thePassenger.OP_InsuranceFee__c = 
                                ((( thePassenger.OP_StdPassengerSeatFee__c *  thePassenger.PassagerSeatInsurance__c +
                                  thePassenger.OP_StdDriverSeatFee__c * thePassenger.DriverSeatInsurance__c) *  days )/ daysofperiod ).setScale(2);
                        } else {
                            thePassenger.OP_InsuranceFee__c =  ( (thePassenger.OP_StdPassengerSeatFee__c *  days ) / daysofperiod).setScale(2);
                        }
                        
                        
                    } else
                        thePassenger.OP_InsuranceFee__c = null;
                } else {
                    
                    if ( ServiceOPType.ParentService__r.Optiontype__c == '席数') {
                        
                        thePassenger.OP_InsuranceFee__c = 
                            thePassenger.OP_StdPassengerSeatFee__c * thePassenger.PassagerSeatInsurance__c +
                            thePassenger.OP_StdDriverSeatFee__c * thePassenger.DriverSeatInsurance__c ;
                    } else {
                        thePassenger.OP_InsuranceFee__c =   thePassenger.OP_StdPassengerSeatFee__c;
                    }
                    
                }
                
                thePassenger.OP_CommissionRate__c = Service.CommissionRate__c;
                if ( thePassenger.OP_InsuranceFee__c != null && thePassenger.OP_CommissionRate__c != null )
                 thePassenger.OP_Commission__c =  thePassenger.OP_InsuranceFee__c * ( thePassenger.OP_CommissionRate__c / 100.0 );
                else 
                thePassenger.OP_Commission__c = null;
                
            } else {
                thePassenger.OP_InsuranceFee__c = null;
                 thePassenger.OP_CommissionRate__c = null;
                thePassenger.OP_Commission__c = null;
            }
        if ( thePassenger.name != null) {
        if ( thePassenger.name.indexOf('e')!=-1) {
                  fetchBillAmount();
            //thePassenger.OP_Commission__c = theOPBillingAmount * thePassenger.OP_CommissionRate__c;
        }
        }
    }
    
    public void fetchOPPlanFeeOffLine( List<wb_Service__c> PsgrServiceMaster )
    {
        //  system.debug(thePassenger.Psgr_Service__c );
        wb_Service__c s_g; // = [select Group__c from wb_Service__c where id =:thePassenger.Psgr_Service__c ];
        for( integer i=0;i < PsgrServiceMaster.size(); i++){
            if ( PsgrServiceMaster[i].id == thePassenger.Psgr_Service__c){
                s_g =  PsgrServiceMaster[i];
                i = PsgrServiceMaster.size();
            }
        }
        //  system.debug(' fetchOPPlanFee:' + thePassenger.OP_CommodityName__c + ' ' + thePassenger.OP_Plan__c );
        
        if ( s_g <> null) {
        if ( s_g.Group__c <> null && thePassenger.Psgr_InsuranceCompany__c <> null 
            && thePassenger.OP_CommodityName__c <> null && thePassenger.OP_Plan__c <> null) {
                
                wb_Service__c ServiceOPType;/* = [SELECT  ParentService__r.Optiontype__c ,DriverSeatInsurance__c FROM wb_Service__c 
where  Country__c =:theCountry  
and ServiceCompany__c =:thePassenger.Psgr_InsuranceCompany__c 
and Service__c =:thePassenger.OP_CommodityName__c
and Plan__c =:thePassenger.OP_Plan__c
and ParentService__c=:s_g.Group__c
and ServiceClassification__c = '搭乗'  
and Enable__c = true and DataType__c = 'O'
order by lastmodifieddate desc
limit 1 ];*/
                
                for( integer i=0;i < PsgrServiceMaster.size(); i++){
                    if ( PsgrServiceMaster[i].ServiceCompany__c == thePassenger.Psgr_InsuranceCompany__c &&
                        PsgrServiceMaster[i].Service__c == thePassenger.OP_CommodityName__c &&
                        PsgrServiceMaster[i].Plan__c == thePassenger.OP_Plan__c &&
                        PsgrServiceMaster[i].ParentService__c == s_g.Group__c &&
                        PsgrServiceMaster[i].DataType__c == 'O'
                       ){
                           ServiceOPType =  PsgrServiceMaster[i];
                           i = PsgrServiceMaster.size();
                       }
                }
                
                wb_Service__c Service;
                
                if ( ServiceOPType.ParentService__r.Optiontype__c == '席数') {
                    /*
Service = [SELECT Id, Currency__c, PassengerFee__c, DriverFee__c , DriverSeatInsurance__c, CommissionRate__c FROM wb_Service__c 
where  Country__c =:theCountry  
and ServiceCompany__c =:thePassenger.Psgr_InsuranceCompany__c 
and Service__c =:thePassenger.OP_CommodityName__c
and Plan__c =:thePassenger.OP_Plan__c
//and ParentService__c=:thePassenger.Psgr_Service__c
and ParentService__c=:s_g.Group__c and DataType__c = 'O'
and ServiceClassification__c = '搭乗' 
and Enable__c = true   
order by lastmodifieddate desc
limit 1 ];    */
                    
                    for( integer i=0;i < PsgrServiceMaster.size(); i++){
                        if ( PsgrServiceMaster[i].ServiceCompany__c == thePassenger.Psgr_InsuranceCompany__c &&
                            PsgrServiceMaster[i].Service__c == thePassenger.OP_CommodityName__c &&
                            PsgrServiceMaster[i].Plan__c == thePassenger.OP_Plan__c &&
                            PsgrServiceMaster[i].ParentService__c == s_g.Group__c &&
                            PsgrServiceMaster[i].DataType__c == 'O'
                           ){
                               Service =  PsgrServiceMaster[i];
                               i = PsgrServiceMaster.size();
                           }
                    }
                    
                } else{
                    integer seat;
                    //  if (thePassenger.Psgr_InsuranceSeat__c==null)
                    //      thePassenger.Psgr_InsuranceSeat__c = 0;
                    
                    /*
Service = [SELECT Id, Currency__c, PassengerFee__c, DriverFee__c , MaxSeat__c, CommissionRate__c FROM wb_Service__c 
where  Country__c =:theCountry  
and ServiceCompany__c =:thePassenger.Psgr_InsuranceCompany__c 
and Service__c =:thePassenger.OP_CommodityName__c
and Plan__c =:thePassenger.OP_Plan__c
//and ParentService__c=:thePassenger.Psgr_Service__c
and ParentService__c=:s_g.Group__c and DataType__c = 'O'
and ServiceClassification__c = '搭乗'  
// and MaxSeat__c >=:thePassenger.Psgr_InsuranceSeat__c
and MaxSeat__c >=:( thePassenger.DriverSeatInsurance__c + thePassenger.PassagerSeatInsurance__c)
and Enable__c = true   
order by MinSeat__c desc, MaxSeat__c asc, lastmodifieddate desc
limit 1 ];       */
                    
                    for( integer i=0;i < PsgrServiceMaster.size(); i++){
                        if ( PsgrServiceMaster[i].ServiceCompany__c == thePassenger.Psgr_InsuranceCompany__c &&
                            PsgrServiceMaster[i].Service__c == thePassenger.OP_CommodityName__c &&
                            PsgrServiceMaster[i].Plan__c == thePassenger.OP_Plan__c &&
                            PsgrServiceMaster[i].ParentService__c == s_g.Group__c &&
                            PsgrServiceMaster[i].DataType__c == 'O' &&
                            PsgrServiceMaster[i].MaxSeat__c >=( thePassenger.DriverSeatInsurance__c + thePassenger.PassagerSeatInsurance__c)
                           ){
                               Service =  PsgrServiceMaster[i];
                               i = PsgrServiceMaster.size();
                           }
                    }
                    
                }
                
                
                if ( Service.Currency__c <> theCommissionCurrency ) {
                    wb_BudgetRate__c Rate = [select Rate__c from wb_BudgetRate__c 
                                             where FromCurrency__c =:Service.Currency__c
                                             and ToCurrency__c =:theCommissionCurrency];
                    
                    thePassenger.OP_StdPassengerSeatFee__c = Service.PassengerFee__c * rate.Rate__c;
                    thePassenger.OP_Service__c  = Service.Id;   
                    thePassenger.OP_StdDriverSeatFee__c = Service.DriverFee__c * rate.Rate__c;
                    
                } else {
                    thePassenger.OP_StdPassengerSeatFee__c = Service.PassengerFee__c ;
                    thePassenger.OP_Service__c  = Service.Id;   
                    thePassenger.OP_StdDriverSeatFee__c = Service.DriverFee__c ;
                }
                
                if (  FeeCalculatedbyDay == true  ){
                    if (thePassenger.OP_CurrentEndDate__c > thePassenger.OP_CurrentStartDate__c ) {
                        // Date s = thePassenger.OP_CurrentStartDate__c;
                        Date s;
                        if ( thePassenger.name.indexOf('e')!=-1) {
                            s = ReplacementStartDate;
                        } else 
                            s = thePassenger.OP_CurrentStartDate__c;
                        
                        Date e = s.addYears(1);
                        e = e.addDays(-1);
                        Date endDat = thePassenger.OP_CurrentEndDate__c;
                        
                        integer daysofperiod = integer.valueof(s.daysBetween(e)+1) ;
                        integer days = integer.valueof(s.daysBetween(endDat)+1) ;
                        
                        if ( ServiceOPType.ParentService__r.Optiontype__c == '席数') {
                            
                            thePassenger.OP_InsuranceFee__c = 
                                ((( thePassenger.OP_StdPassengerSeatFee__c *  thePassenger.PassagerSeatInsurance__c +
                                   thePassenger.OP_StdDriverSeatFee__c * thePassenger.DriverSeatInsurance__c) *  days )/ daysofperiod ).setScale(2);
                        } else {
                            thePassenger.OP_InsuranceFee__c =  ( (thePassenger.OP_StdPassengerSeatFee__c *  days ) / daysofperiod).setScale(2);
                        }
                        
                        
                    } else
                        thePassenger.OP_InsuranceFee__c = null;
                } else {
                    
                    if ( ServiceOPType.ParentService__r.Optiontype__c == '席数') {
                        
                        thePassenger.OP_InsuranceFee__c = 
                            thePassenger.OP_StdPassengerSeatFee__c * thePassenger.PassagerSeatInsurance__c +
                            thePassenger.OP_StdDriverSeatFee__c * thePassenger.DriverSeatInsurance__c ;
                    } else {
                        thePassenger.OP_InsuranceFee__c =   thePassenger.OP_StdPassengerSeatFee__c;
                    }
                    
                }
                
                thePassenger.OP_CommissionRate__c = Service.CommissionRate__c;
                if ( thePassenger.OP_InsuranceFee__c != null && thePassenger.OP_CommissionRate__c != null )
                    thePassenger.OP_Commission__c =  thePassenger.OP_InsuranceFee__c * ( thePassenger.OP_CommissionRate__c / 100.0 );
                else 
                    thePassenger.OP_Commission__c = null;
                
            } 
         else {
                thePassenger.OP_InsuranceFee__c = null;
                thePassenger.OP_CommissionRate__c = null;
                thePassenger.OP_Commission__c = null;
            }
        }
        
        if ( thePassenger.name != null) {
            if ( thePassenger.name.indexOf('e')!=-1) {
                fetchBillAmount();
                //thePassenger.OP_Commission__c = theOPBillingAmount * thePassenger.OP_CommissionRate__c;
            }
        }
    }
    
    
    public void fetchPsgr_EndDate(){
        
        if ( FeeCalculatedbyDay == true){
           // fetchPlanFee();
           //system.debug('fetchPsgr_EndDate:FeeCalculatedbyDay ' + thePassenger.PassagerSeatInsurance__c + ' ' + thePassenger.DriverSeatInsurance__c );
            fetchPlanFeeOnly(integer.valueof(thePassenger.PassagerSeatInsurance__c) ,  integer.valueof(thePassenger.DriverSeatInsurance__c));
        } else {
            Date s = thePassenger.Psgr_CurrentStartDate__c;
            s = s.addYears(1);
            s = s.addDays(-1);
            thePassenger.Psgr_CurrentEndDate__c = s;
            
        }
        
    }
    public void fetchOP_EndDate(){
        if ( FeeCalculatedbyDay == true){
            fetchOPPlanFee();
        } else {
            if ( thePassenger.OP_CurrentStartDate__c != null ) {
            Date s = thePassenger.OP_CurrentStartDate__c;
            s = s.addYears(1);
            s = s.addDays(-1);
            thePassenger.OP_CurrentEndDate__c = s;
            }
        }
    }
    
    
}