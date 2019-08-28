public class wb_BudgetRateExt {
    
    private ApexPages.StandardController standardController;
    public List<wb_BudgetRate__c> BudgetRate {get;set;}
    public integer selectedYear {get;set;}
    public wb_BudgetRate__c currentDateRage {get;set;}
    public date selectedYearStartDate {get;set;}
    public date selectedYearEndDate {get;set;}
    
    public wb_BudgetRateExt(ApexPages.StandardController stdController){
        this.standardController = stdController;
        currentDateRage = new wb_BudgetRate__c();
        integer currYear = System.Today().year();
        currentDateRage.BudgetYear__c = currYear;
        currentDateRage.FromDate__c = Date.newInstance(currYear,4,1);
        currentDateRage.ToDate__c= Date.newInstance(currYear +1,3,31);

        
        BudgetRate = [select id, Rate__c, //CeilingUnit__c, 
                      YearCeilingUnit__c, MonthCeilingUnit__c, FromDate__c,ToDate__c,ToCurrency__c,FromCurrency__c, BudgetYear__c
                      from wb_BudgetRate__c 
                      where FromDate__c=:currentDateRage.FromDate__c and ToDate__c =:currentDateRage.ToDate__c
                     order by ToCurrency__c];

    }
    
    public PageReference fetchBudgetRates(){
        
        integer currYear;
        currYear =  Integer.Valueof(currentDateRage.BudgetYear__c) ;
        currentDateRage.FromDate__c = Date.newInstance(currYear,4,1);
        currentDateRage.ToDate__c= Date.newInstance(currYear +1,3,31);
        BudgetRate = [select Rate__c, //CeilingUnit__c, 
                      YearCeilingUnit__c, MonthCeilingUnit__c, FromDate__c,ToDate__c,ToCurrency__c,FromCurrency__c, BudgetYear__c, id
                      from wb_BudgetRate__c 
                      where FromDate__c=: currentDateRage.FromDate__c and ToDate__c =:  currentDateRage.ToDate__c
                      order by ToCurrency__c];
        
        AggregateResult[] AgR = [select ToCurrency__c, count(id)
                                    from wb_BudgetRate__c 
                                    group by ToCurrency__c
                                    order by ToCurrency__c];
        
        for (AggregateResult r:AgR ) {
            boolean found = false;
            for ( wb_BudgetRate__c br:BudgetRate) {
                if ( String.valueOf(r.get('ToCurrency__c') )== br.ToCurrency__c  ){
                    found = true;
                    continue;   
                }
            }
            if (found==false)
            {
               wb_BudgetRate__c b = new wb_BudgetRate__c(Rate__c=null,FromDate__c =  currentDateRage.FromDate__c,
                                         ToDate__c = currentDateRage.ToDate__c,
                                         ToCurrency__c = String.valueOf(r.get('ToCurrency__c')),
                                         FromCurrency__c = 'USD',
                                         BudgetYear__c = currYear
                                        );
                BudgetRate.add(b);
            }
        }
        return null;
    }
    
    
    public PageReference SaveRecords(){
        
		upsert BudgetRate;
        
        //return new PageReference('https://cs6.salesforce.com/a0J/o');
        return null;
    }

    
    
    public List<SelectOption> getYearsOptions() {
        List<SelectOption> options = new List<SelectOption>();
        
        integer currentYear = System.Today().year();
        
        selectedYear=currentYear;
        for ( integer y = currentYear - 5 ; y <= currentYear + 2; y ++ ){
            options.add(new SelectOption(String.valueof(y),String.valueof(y)));  
        }
      
        return options;
    }
    
    public SelectOption[] YearsOptions;
    
}