public class wb_CI_CompulsoryRow {
    
    public string theCountry {get;set;}
    public string theCommissionCurrency {get;set;}
    public integer theLegalNumberofSeats {get;set;}
    
    public SelectOption[] Cps_InsuranceCompanyOptions {get;set;}
    public SelectOption[] Vlt_InsuranceCompanyOptions {get;set;}
    
    public wb_CIC_Compulsory__c theCompulsory { get; set; }
    
    public wb_CI_CompulsoryRow(wb_CIC_Compulsory__c cps ){
         theCompulsory = cps;
    }
    
    public wb_CI_CompulsoryRow( string c, string cur, integer s,  wb_CIC_Compulsory__c cps) {
        theCompulsory = cps;
        theCountry = c;
        theCommissionCurrency =cur;
        theLegalNumberofSeats = s;
        Cps_InsuranceCompanyOptions = getCps_InsuranceCompanyOptions();
        Vlt_InsuranceCompanyOptions = getVlt_InsuranceCompanyOptions();    
        
    }
    
    public SelectOption[] getCps_InsuranceCompanyOptions() {  
        List<SelectOption>  opt = new  List<SelectOption>();
        opt.add(new SelectOption('','--None--'));  
        for (AggregateResult l : [ select ServiceCompany__c, count(Id) 
                                  FROM wb_Service__c
                                  where  ServiceClassification__c = '強制' and Country__c =:theCountry
                                  and Currency__c =:theCommissionCurrency // To limit the Insurance currrent be same as Commission current
                                  group by ServiceCompany__c 	]) {  
                                      opt.add(new SelectOption(String.valueOf(l.get('ServiceCompany__c')), String.valueOf(l.get('ServiceCompany__c')) ));  
                                  }                           
        return opt;  
    } 
    
    public SelectOption[] getVlt_InsuranceCompanyOptions() {  
        
        List<SelectOption>  opt = new  List<SelectOption>();
        opt.add(new SelectOption('','--None--'));  
        for (AggregateResult l : [ select ServiceCompany__c, count(Id) 
                                  FROM wb_Service__c
                                  where  ServiceClassification__c = '任意' and Country__c =:theCountry  
                                  and Currency__c =:theCommissionCurrency // To limit the Insurance currrent be same as Commission current
                                  group by ServiceCompany__c 	]) {  
                                      opt.add(new SelectOption(String.valueOf(l.get('ServiceCompany__c')), String.valueOf(l.get('ServiceCompany__c')) ));  
                                  }                           
        return opt;  
    } 
    
    public void fetchComplusoryInsuranceFee()
    {
        if ( theCompulsory.Cps_InsuranceCompany__c <> null ) {
            
            
            
            wb_Service__c Service = [SELECT Id, Currency__c,
                                     Cps_MedicalCost__c, Cps_AfterDeathImpediment__c, Cps_NoLbtAfterDeathMedicalCost__c, Cps_NoLbtAfterDeathImpediment__c, 
                                     Cps_NoLbtPropertyLoss__c, Cps_PropertyLoss__c, // Cps_ServiceFee__c, 
                                     CommissionRate__c, ContactNumber__c
                                     FROM wb_Service__c 
                                     where  ServiceCompany__c =:theCompulsory.Cps_InsuranceCompany__c and Country__c =:theCountry  
                                     and ServiceClassification__c = '強制'  and Enable__c = true
                                     limit 1 ];
            theCompulsory.Cps_Currency__c = Service.Currency__c;
            
            decimal ex_rate;
            if ( Service.Currency__c <> theCommissionCurrency ) {
                wb_BudgetRate__c rate = [SELECT ToCurrency__c, Rate__c, FromCurrency__c 
                                         FROM wb_BudgetRate__c where FromCurrency__c =:Service.Currency__c and ToCurrency__c=:theCommissionCurrency];
                ex_rate = rate.Rate__c;
            } else {
                ex_rate =1;
            }
            
            
            theCompulsory.Cps_AfterDeathImpediment__c = Service.Cps_AfterDeathImpediment__c;
            theCompulsory.Cps_MedicalCost__c  = Service.Cps_MedicalCost__c;   
            theCompulsory.Cps_PropertyLoss__c = Service.Cps_PropertyLoss__c;
            theCompulsory.Cps_NoLbtAfterDeathImpediment__c = Service.Cps_NoLbtAfterDeathImpediment__c;
            theCompulsory.Cps_NoLbtAfterDeathMedicalCost__c  = Service.Cps_NoLbtAfterDeathMedicalCost__c;   
            theCompulsory.Cps_NoLbtPropertyLoss__c = Service.Cps_NoLbtPropertyLoss__c;
            // theCompulsory.Cps_InsuranceAmount__c = Service.Cps_ServiceFee__c * ex_rate;
            theCompulsory.Cps_CommissionRate__c = Service.CommissionRate__c; 
            //  theCompulsory.Cps_Commission__c = theCompulsory.Cps_InsuranceAmount__c * ( Service.CommissionRate__c/100);
            theCompulsory.Cps_Service__c = Service.ID;
        } else {
            theCompulsory.Cps_Currency__c=null;
            theCompulsory.Cps_AfterDeathImpediment__c =null;
            theCompulsory.Cps_MedicalCost__c  = null;   
            theCompulsory.Cps_PropertyLoss__c = null;
            theCompulsory.Cps_NoLbtAfterDeathImpediment__c = null;
            theCompulsory.Cps_NoLbtAfterDeathMedicalCost__c  = null; 
            theCompulsory.Cps_NoLbtPropertyLoss__c = null;
            theCompulsory.Cps_InsuranceAmount__c = null;
            theCompulsory.Cps_CommissionRate__c = null; 
            theCompulsory.Cps_Commission__c=null;
            theCompulsory.Cps_Service__c = null;
        }
        
    }
    
    public void fetchComplusoryInsuranceFeeOffline( List<wb_Service__c> ServiceMaster )
    {
        if ( theCompulsory.Cps_InsuranceCompany__c <> null ) {
            

            wb_Service__c Service;
            for ( integer i=0; i < ServiceMaster.size(); i++ ){
                if (ServiceMaster[i].ServiceCompany__c== theCompulsory.Cps_InsuranceCompany__c){
                    Service = ServiceMaster[i];
                    i = ServiceMaster.size();
                }
            }
            
            if ( Service != null ){
                theCompulsory.Cps_Currency__c = Service.Currency__c;
                system.debug( theCompulsory.Cps_Currency__c + ' ' +Service.Currency__c + ' ' + theCommissionCurrency);
                decimal ex_rate;
                if ( Service.Currency__c <> theCommissionCurrency ) {
                    wb_BudgetRate__c rate = [SELECT ToCurrency__c, Rate__c, FromCurrency__c 
                                             FROM wb_BudgetRate__c where FromCurrency__c =:Service.Currency__c and ToCurrency__c=:theCommissionCurrency];
                    ex_rate = rate.Rate__c;
                } else {
                    ex_rate =1;
                }
                
                
                theCompulsory.Cps_AfterDeathImpediment__c = Service.Cps_AfterDeathImpediment__c;
                theCompulsory.Cps_MedicalCost__c  = Service.Cps_MedicalCost__c;   
                theCompulsory.Cps_PropertyLoss__c = Service.Cps_PropertyLoss__c;
                theCompulsory.Cps_NoLbtAfterDeathImpediment__c = Service.Cps_NoLbtAfterDeathImpediment__c;
                theCompulsory.Cps_NoLbtAfterDeathMedicalCost__c  = Service.Cps_NoLbtAfterDeathMedicalCost__c;   
                theCompulsory.Cps_NoLbtPropertyLoss__c = Service.Cps_NoLbtPropertyLoss__c;
                // theCompulsory.Cps_InsuranceAmount__c = Service.Cps_ServiceFee__c * ex_rate;
                theCompulsory.Cps_CommissionRate__c = Service.CommissionRate__c; 
                //  theCompulsory.Cps_Commission__c = theCompulsory.Cps_InsuranceAmount__c * ( Service.CommissionRate__c/100);
                theCompulsory.Cps_Service__c = Service.ID;
            }
        } else {
            theCompulsory.Cps_Currency__c=null;
            theCompulsory.Cps_AfterDeathImpediment__c =null;
            theCompulsory.Cps_MedicalCost__c  = null;   
            theCompulsory.Cps_PropertyLoss__c = null;
            theCompulsory.Cps_NoLbtAfterDeathImpediment__c = null;
            theCompulsory.Cps_NoLbtAfterDeathMedicalCost__c  = null; 
            theCompulsory.Cps_NoLbtPropertyLoss__c = null;
            theCompulsory.Cps_InsuranceAmount__c = null;
            theCompulsory.Cps_CommissionRate__c = null; 
            theCompulsory.Cps_Commission__c=null;
            theCompulsory.Cps_Service__c = null;
        }
        
    }
    
    
    public void fetchVoluntaryInsuranceFee()
    {
        wb_Service__c Service = [SELECT Id, Currency__c,  CommissionRate__c
                                 FROM wb_Service__c 
                                 where  ServiceCompany__c =:theCompulsory.Vlt_InsuranceCompany__c and Country__c =:theCountry  
                                 and ServiceClassification__c = '任意'  and Enable__c = true
                                 limit 1 ];
        theCompulsory.VLT_SERVICE__C = Service.id;
        theCompulsory.Vlt_Currency__c = Service.Currency__c;
        theCompulsory.Vlt_CommissionRate__c = Service.CommissionRate__c;
        
    }
    
    public void fetchVoluntaryInsuranceFeeOffLine(List<wb_Service__c> ServiceMaster)
    {
        wb_Service__c Service;
        for (integer i = 0; i < ServiceMaster.size(); i++ ){
            if ( ServiceMaster[i].ServiceCompany__c == theCompulsory.Vlt_InsuranceCompany__c){
                Service =  ServiceMaster[i];
                i = ServiceMaster.size();
            }
        }
        theCompulsory.VLT_SERVICE__C = Service.id;
        theCompulsory.Vlt_Currency__c = Service.Currency__c;
        theCompulsory.Vlt_CommissionRate__c = Service.CommissionRate__c;
        
    }
    
    
    public void fetchCpsCommissionFee()
    {
        if ( theCompulsory.Cps_InsuranceAmount__c != null && theCompulsory.Cps_CommissionRate__c != null)
            theCompulsory.Cps_Commission__c = (theCompulsory.Cps_CommissionRate__c/100) * theCompulsory.Cps_InsuranceAmount__c; 
        else
            theCompulsory.Cps_Commission__c = null; 
    }
    
    public void fetchCpsCommissionRate()
    {
        theCompulsory.Cps_CommissionRate__c = (theCompulsory.Cps_Commission__c/theCompulsory.Cps_InsuranceAmount__c)*100; 
    }
    
    public void fetchVltCommissionFee()
    { 
        if ( theCompulsory.Vlt_InsuranceAmount__c != null && theCompulsory.Vlt_CommissionRate__c != null )
            theCompulsory.Vlt_Commission__c = (theCompulsory.Vlt_CommissionRate__c/100) * theCompulsory.Vlt_InsuranceAmount__c; 
        else
            theCompulsory.Vlt_Commission__c = null; 
        
        //if (( theCompulsory.Vlt_CommissionRate__c != null) && (theCompulsory.Vlt_CommissionRate__c != null ))
        //theCompulsory.Vlt_Commission__c = (theCompulsory.Vlt_CommissionRate__c/100) * theCompulsory.Vlt_InsuranceAmount__c; 
    }
    
    public void fetchVltCommissionRate()
    {   decimal a = theCompulsory.Vlt_InsuranceAmount__c;
     decimal c = theCompulsory.Vlt_Commission__c;
     theCompulsory.Vlt_CommissionRate__c = (c/a)*100; 
    }
    
    public void fetchCps_EndDate(){
        Date s = theCompulsory.Cps_CurrentStartDate__c;
        s = s.addYears(1);
        s = s.addDays(-1);
        theCompulsory.Cps_CurrentEndDate__c = s;
        //theCompulsory.Cps_CancelDate__c = s;
    }
    
    public void fetchVlt_EndDate(){
        if (theCompulsory.Vlt_StartDate__c != null) {
            Date s = theCompulsory.Vlt_StartDate__c;
            s = s.addYears(1);
            s = s.addDays(-1);
            theCompulsory.Vlt_EndDate__c = s;
            //theCompulsory.Vlt_CancelDate__c = s;
        } else {
            theCompulsory.Vlt_EndDate__c = null;
            //theCompulsory.Vlt_CancelDate__c = null;
        }
        
    }
    
}