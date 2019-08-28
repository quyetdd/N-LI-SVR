public class wb_MedicalInsurance {
     
    string TheContractNo;
    
    public List<wb_MembershipDetail__c> theMembershipDetail {get;set;}
    
    public wb_MedicalInsurance__c MedicalInsurance {get;set;}

    public wb_MedicalInsuranceDetail__c Common {get;set;}
    
    public List<aTableRow> theMembershipDetailRows { get; set; }
    public class aTableRow {
        public Boolean isSelected { get; set; }
        public wb_MembershipDetail__c theMembershipDetail { get; set; }
        public aTableRow(Boolean b, wb_MembershipDetail__c md) {
            theMembershipDetail = md;
            isSelected = b;
        }
    }
    
    public List<aMDITableRow> theMedicalInsuranceDetailRows { get; set; }
    public class aMDITableRow {
        public string MemberNo { get; set; }
        public string AffiliationDistrict { get; set; }
        public wb_MedicalInsuranceDetail__c theMedicalInsuranceDetail { get; set; }
        public aMDITableRow(string m, string ad, wb_MedicalInsuranceDetail__c datarow) {
            MemberNo = m;
            AffiliationDistrict = ad;
            theMedicalInsuranceDetail = datarow;
        }
    }

    
    public SelectOption[] InsuranceCompanyOptions;
    
    public SelectOption[] getInsuranceCompanyOptions(){
        
        List<SelectOption> options = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult =
            wb_MedicalInsuranceDetail__c.InsuranceCompany__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        options.add(new SelectOption('', '--None--'));
        
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }    
        return options;
    }
    
    public SelectOption[] InsuranceOptions;
    
    public SelectOption[] getInsuranceOptions(){
        
        List<SelectOption> options = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult =
            wb_MedicalInsuranceDetail__c.Insurance__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        options.add(new SelectOption('', '--None--'));
        
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }    
        return options;
    }
    
    public SelectOption[] HandlingByOptions;
    
    public SelectOption[] getHandlingByOptions(){
        
        List<SelectOption> options = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult =
            wb_MedicalInsuranceDetail__c.HandlingBy__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        options.add(new SelectOption('', '--None--'));
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }    
        return options;
    }
    
    public SelectOption[] InsurancePlanOptions;
    
    public SelectOption[] getInsurancePlanOptions(){
        
        List<SelectOption> options = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult =
            wb_MedicalInsuranceDetail__c.InsurancePlan__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('', '--None--'));
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }    
        return options;
    }
    
    public SelectOption[] PolicyAvailabilityOptions;
    
    public SelectOption[] getPolicyAvailabilityOptions(){
        
        List<SelectOption> options = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult =
            wb_MedicalInsuranceDetail__c.PolicyAvailability__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('', '--None--'));
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }    
        return options;
    }
    
    public SelectOption[] MedicalSettlementOptions;
    
    public SelectOption[] getMedicalSettlementOptions(){
        
        List<SelectOption> options = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult =
            wb_MedicalInsuranceDetail__c.MedicalSettlement__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('', '--None--'));
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }    
        return options;
    }
    
    public SelectOption[] InsuranceCurrencyOptions;
    
    public SelectOption[] getInsuranceCurrencyOptions(){
        
        List<SelectOption> options = new List<SelectOption>();
        
     	options.add(new SelectOption('', '--None--'));
        for (wb_Currency__c c : [SELECT Name, CurrencySymbol__c 
                                 FROM wb_Currency__c order by Name
                                ]) {      
                                    options.add(new SelectOption(c.CurrencySymbol__c, c.Name + ' ' + c.CurrencySymbol__c));
                                }
        return options;
    }
    
    public boolean ShowSelected { get; set; }
    
    public wb_MedicalInsurance(){
        
        TheContractNo  = System.currentPageReference().getParameters().get('ContractID');
        theMembershipDetail = [select id, name, 
                               Individual__r.Name, Individual__c,
                               Membership__r.ContractDistrict__c, WorkingCompany__c, WorkingCompany__r.name,
                               Membership__r.ContractCompany__c,
                               MemberNo__c, ParentDetail__c
                               from wb_MembershipDetail__c 
                               where Membership__c = :TheContractNo  and Type__c in ('家族','単身')];
        
        theMembershipDetailRows = new List<aTableRow>();
        for(wb_MembershipDetail__c p:theMembershipDetail) {
            if ( p.ParentDetail__c == null) {
            	theMembershipDetailRows.add(new aTableRow(false, p));
                for (wb_MembershipDetail__c c:theMembershipDetail){
                    if ( c.ParentDetail__c == p.id ){
                        theMembershipDetailRows.add(new aTableRow(false, c));
                    }
                }
            }
        }
        
        MedicalInsurance = new wb_MedicalInsurance__c();
    

		Common = new wb_MedicalInsuranceDetail__c();    

		ShowSelected = false;        
    }
    
      public PageReference getSelected()
    {

        theMedicalInsuranceDetailRows = new List<aMDITableRow>();
        
        for(aTableRow r : theMembershipDetailRows) {
            
            if ( r.isSelected == true) {
                
                wb_MedicalInsuranceDetail__c nr = new wb_MedicalInsuranceDetail__c();
                nr.Individual__c = r.theMembershipDetail.Individual__c;
                nr.WorkingCompany__c = r.theMembershipDetail.WorkingCompany__c;
                string m = r.theMembershipDetail.MemberNo__c;
                string cd =  r.theMembershipDetail.Membership__r.ContractDistrict__c;
                theMedicalInsuranceDetailRows.add( new aMDITableRow(m, cd, nr ));
            }
            
        }
        
        return null;
    }
    
     public PageReference SelectAll()
    {
        for(aTableRow r : theMembershipDetailRows) {
             r.isSelected = true;
        }
        return null;
    }
    
       public PageReference UnSelectAll()
    {
         for(aTableRow r : theMembershipDetailRows) {
             r.isSelected = false;
        }
        return null;
    }
    
    public PageReference StartMedicalInsurance()
    {
        theMedicalInsuranceDetailRows = new List<aMDITableRow>();
        
        for(aTableRow r : theMembershipDetailRows) {
            
            if ( r.isSelected == true) {
                
                wb_MedicalInsuranceDetail__c nr = new wb_MedicalInsuranceDetail__c();
                nr.Individual__c = r.theMembershipDetail.Individual__c;
                nr.WorkingCompany__c = r.theMembershipDetail.WorkingCompany__c;
                string m = r.theMembershipDetail.MemberNo__c;
                string cd =  r.theMembershipDetail.Membership__r.ContractDistrict__c;
                theMedicalInsuranceDetailRows.add( new aMDITableRow(m, cd, nr ));
            }
            
        }
        
        ShowSelected = true;
        return null;
    }
    
     public PageReference ReturnToMDContract()
    {
        
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        return new PageReference(sfdcBaseURL +'/apex/wb_Membership_View?id='+ TheContractNo );
    }
    
    public PageReference CopyfromCommon()
    {
        for(aMDITableRow r : theMedicalInsuranceDetailRows) {
            r.theMedicalInsuranceDetail.InsuranceCompany__c = Common.InsuranceCompany__c;
            r.theMedicalInsuranceDetail.Insurance__c = Common.Insurance__c;
            r.theMedicalInsuranceDetail.InsurancePlan__c = Common.InsurancePlan__c;
            r.theMedicalInsuranceDetail.HandlingBy__c = Common.HandlingBy__c;
            r.theMedicalInsuranceDetail.Priority__c = Common.Priority__c;
            r.theMedicalInsuranceDetail.PolicyNumber__c = Common.PolicyNumber__c;
            r.theMedicalInsuranceDetail.PolicyAvailability__c = Common.PolicyAvailability__c;
            r.theMedicalInsuranceDetail.StorageLocation__c = Common.StorageLocation__c;
            r.theMedicalInsuranceDetail.MedicalSettlement__c = Common.MedicalSettlement__c;
            r.theMedicalInsuranceDetail.InsuranceStartDate__c = Common.InsuranceStartDate__c;
            r.theMedicalInsuranceDetail.InsuranceEndDate__c = Common.InsuranceEndDate__c;
            r.theMedicalInsuranceDetail.InsuranceCurrency__c = Common.InsuranceCurrency__c;
            r.theMedicalInsuranceDetail.InjuryDeathCost__c = Common.InjuryDeathCost__c;
            r.theMedicalInsuranceDetail.TreatmentCost__c = Common.TreatmentCost__c;
            r.theMedicalInsuranceDetail.TreatmentRescueCost__c = Common.TreatmentRescueCost__c;
            r.theMedicalInsuranceDetail.DiseaseCost__c = Common.DiseaseCost__c;
            r.theMedicalInsuranceDetail.DiseaseDeathCost__c = Common.DiseaseDeathCost__c;
            r.theMedicalInsuranceDetail.RescueCost__c = Common.RescueCost__c;
            r.theMedicalInsuranceDetail.DamagesCost__c = Common.DamagesCost__c;
            r.theMedicalInsuranceDetail.BaggageCost__c = Common.BaggageCost__c;
            r.theMedicalInsuranceDetail.HomeCountryCoverage__c = Common.HomeCountryCoverage__c;
            r.theMedicalInsuranceDetail.Remark__c = Common.Remark__c;
        
        }
        
        return null;
    }
    
    public PageReference SelectAgain()
    {
        ShowSelected = false;  
        return null;
    }
    
    
    public PageReference Cancel()
    {

        return null;
    }
    
     public PageReference SavetoMedicalInsurance()
    {
        wb_MedicalInsurance__c h = new wb_MedicalInsurance__c();
        h.MedicalDivision__c = MedicalInsurance.MedicalDivision__c;
        insert h;
        h = [ select id, name from wb_MedicalInsurance__c where id =:h.id ];
        
        integer i = 1;
        for(aMDITableRow r : theMedicalInsuranceDetailRows)
        {
			r.theMedicalInsuranceDetail.MedicalInsurance__c = h.id;   
            r.theMedicalInsuranceDetail.name = h.name + '-' + i;
            insert r.theMedicalInsuranceDetail;
            i++;
        }

   		String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        return new PageReference(sfdcBaseURL+'/'+ h.id);
         //return new PageReference('https://cs6.salesforce.com/'  + h.id);
    }



}