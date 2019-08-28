public class wb_Membership_Invoice {
    
    public wb_Membership__c theContract {get;set;} 
  
    
    public List<wb_MembershipDetail__c> theContractDetail {get;set;} 
    public List<wb_MedicalInsuranceDetail__c> theMedicalInsuranceDetail {get;set;} 
    
	public AggregateResult[] BillingAmount  {get;set;} 


	public wb_Membership_InvoiceExport theInvoice  {get;set;}     

    
  //  public List<wb_ContractMemberInsurance> theContractDetailInsurance {get;set;} 

    
    public string filename  {get;set;}
    
    public String xlsHeader{
        get{
            String strHeader = '';
            strHeader += '<?xml version="1.0"?>';
            strHeader += '<?mso-application progid="Excel.Sheet"?>';
            return strHeader;
        }
    }
    
    public string SaveOption  {get;set;}
    public void getURLparameters(){
        
        if (apexpages.currentpage() != null ) {
            if (apexpages.currentpage().getparameters().get('Id') !='') {
                Id theId = apexpages.currentpage().getparameters().get('Id');
                theContract = [select Id, Name from wb_Membership__c where id=:theId];
            }
            if (apexpages.currentpage().getparameters().get('pv0') !='') {
                SaveOption = apexpages.currentpage().getparameters().get('pv0');
            }
        }
    }
    
    
    
    public wb_Membership_Invoice() {
        
        getURLparameters();
        
        If (theContract != null){
            filename  = 'MDContractData' + theContract.name + '.xls' ;
        } else
            filename  = 'MDContractData.xls';
        
        
        //  wb_Membership__c c = [select Id from wb_Membership__c where id ='a0o5D000000Q41X'];
        
        getHeader(theContract);
        getDetail(theContract);
        getInsurances();
        BillingAmount = getBillingAmount(theContract);
        decimal SubTotal1 = 0;
        decimal SubTotal2 = 0;
        system.debug(BillingAmount);
        for( AggregateResult ar:BillingAmount){
            if (ar.get('BillingAmount') != null) {
                if (ar.get('MembershipPlan__c') !='Global Member'){
                    SubTotal1 = SubTotal1 + Decimal.ValueOf(string.valueof(ar.get('BillingAmount')));
                } else {
                    SubTotal2 = SubTotal2 + Decimal.ValueOf(string.valueof(ar.get('BillingAmount')));
                }
            }
        }
		system.debug(SubTotal1 + ':' + SubTotal2);
	 	theInvoice  = new wb_Membership_InvoiceExport(theContract, SubTotal1, SubTotal2, theContractDetail, theMedicalInsuranceDetail); 
        
        system.debug(theInvoice);
        
       // InvoiceHeader = new H(theContract, SubTotal1, SubTotal2);
    }
    
    public wb_Membership_Invoice( wb_Membership__c c ) {
        
        getHeader(c);
        getDetail(c);
        getInsurances();
    }
    
    public void getHeader(wb_Membership__c c){
        theContract = [select Id,
                       ContractDistrict__c,
                       Name,
                       //  ContractCompany__c,
                       ContractCompany__r.CompanyCd__c,
                       //  ContractCompany__r.name,
                       ContractExpiryDate__c,
                       ContractCompany__r.EigyoTanto__c,
                       ContractCompany__r.NaimuTanto__c,
                       ContractCompany__r.Jurisdiction__c,
                       ContractCompany__r.ShozokuArea__c,
                       
                       Sales__c,
                       InternalAffairs__c,
                       DiscountType__c,
                       DiscountPercentage__c,
                       ContractCompany__r.Id,
                       ContractCompany__r.Name,
                       ContractCompany__r.CompanyNameEng__c,
                       ContractCompany__r.OfficeAdd__c,
                       ContractCompany__r.Phone,
                       ContractCompany__r.Fax,
                       ContractCompany__r.President__c,
                       ContractCompany__r.Shimei__c,
                       ContractCompany__r.Busho__c,
                       ContractCompany__r.Yakushoku__c,
                       ContractCompany__r.SubShimei__c,
                       ContractCompany__r.SubBusho__c,
                       ContractCompany__r.SubYakushoku__c,
                       // ContractCompany__r.EigyoTanto__c
                       ContractCompany__r.GroupName__c,
                       ContractCompany__r.Tax_Identification_Number__c,
                       ContractCompany__r.TaxIncentives__c,
                       
                       BillingCompany__c,
                       BillingCompany__r.name,
                       
                       Sales__r.Name, 
                       Sales__r.SeiMeiRoma__c,  
                       Sales__r.Email__c,
                       InternalAffairs__r.Name,
                       InternalAffairs__r.SeiMeiRoma__c,
                       InternalAffairs__r.Email__c,
                       
                       // CompanyKeiyakuNo__r.SeikyuCompanyName__r.Name, 
                       //   CompanyKeiyakuNo__r.SeikyuCompanyName__r.CompanyNameEng__c, 
                       ContractCompany__r.AffiliatedCompanyName__r.Name,
                       ContractCompany__r.AffiliatedCompanyName__r.AffiliatedCompanyNameEng__c,
                       ContractCompany__r.GroupName__r.Name,
                       ContractCompany__r.GroupName__r.GroupNameEng__c
                       
                       from wb_Membership__c where id =: c.id];
    }
    
    public void getDetail(wb_Membership__c c){
        theContractDetail = [select Id, Name, 
                             f_NameforOrdering__c,
                             Individual__c, Individual__r.Old_Id__c,
                             Individual__r.name,
                             Individual__r.FirstNameRoma__c,
                             Individual__r.LastNameRoma__c,
                             MemberNo__c, 
                             MembershipPlan__c,  MembershipEndDate__c,  Individual__r.Address__c,   Individual__r.Tel__c, 
                             Individual__r.Mobile__c,  
                             Individual__r.EmailAddress__c, Individual__r.MailDelivery__c,
                             f_FamilyWorkingCompany__c,
                             WorkingCompany__r.Id, 
                             WorkingCompany__r.Name, 
                             WorkingCompany__r.CompanyNameEng__c,
                             WorkingCompany__r.OfficeAdd__c, 
                             WorkingCompany__r.Phone,
                             WorkingCompany__r.Fax, 
                             WorkingCompany__r.President__c, 
                             WorkingCompany__r.Shimei__c, 
                             WorkingCompany__r.Busho__c, 
                             WorkingCompany__r.Yakushoku__c, 
                             WorkingCompany__r.SubShimei__c, 
                             WorkingCompany__r.SubBusho__c,
                             WorkingCompany__r.SubYakushoku__c,
                             WorkingCompany__r.EigyoTanto__r.SeiMeiRoma__c, 
                             WorkingCompany__r.EigyoTanto__r.Name, 
                             WorkingCompany__r.NaimuTanto__r.SeiMeiRoma__c, 
                             WorkingCompany__r.NaimuTanto__r.Name,
                             Type__c,
                             Membership__r.Currency__c,
                             Quantity__c,
                             UnitAmount__c, ParentDetail__r.UnitAmount__c,
                             BillingAmount__c,
                             MembershipStartDate__c,
                             Service__r.Abbreviation__c
                             from wb_MembershipDetail__c
                             where Membership__c =: c.id
                             and  ( Type__c !='無記名' or ParentDetail__c != null)
                             order by Individual__c
                            ];
        
    }
    
    public  AggregateResult[] getBillingAmount(wb_Membership__c c){
        return [select Type__c, MembershipPlan__c, sum(BillingAmount__c) BillingAmount
                FROM wb_MembershipDetail__c 
                where Membership__c =:c.id and ParentDetail__c = null
                group by Type__c, MembershipPlan__c];
    }
    
    public void getInsurances(){
        
        List <Id> IndIds = new List <Id>();
        
        for (wb_MembershipDetail__c d:theContractDetail){
            IndIds.add(d.Individual__c);
        }
        
        theMedicalInsuranceDetail =   [SELECT Individual__c,InsuranceEndDate__c,InsuranceStartDate__c,Name,old_Id__c 
                                       FROM wb_MedicalInsuranceDetail__c
                                       where InsuranceEndDate__c >= today and Individual__c =:IndIds
                                       order by Individual__c
                                      ];
        /*
        theContractDetailInsurance = new List<wb_ContractMemberInsurance>();
        
        integer i = 0;
        integer j = 0;
        
        for ( ;i <theContractDetail.size(); i++){
            List<wb_MedicalInsuranceDetail__c> MI = new List<wb_MedicalInsuranceDetail__c>();
            for (;j<theMedicalInsuranceDetail.size() && theContractDetail[i].Individual__c>=theMedicalInsuranceDetail[j].Individual__c;){
                if ( theContractDetail[i].Individual__c == theMedicalInsuranceDetail[j].Individual__c){
                    MI.add(theMedicalInsuranceDetail[j]);
                    j++;
                } else
                    j++;
            }
            // theContractDetailInsurance.add( new ContractMemberInsurance(theContractDetail[i],MI));
            theContractDetailInsurance.add( new wb_ContractMemberInsurance(theContractDetail[i],MI));
        }
        */
    }
    
    public void saveAttachment(){
        
        system.debug(SaveOption);
        
        if (SaveOption == 'YES'){
            
            
            PageReference Invoice =  Page.wb_Membership_InvoiceExport;
            
            Invoice.getParameters().put('id',theContract.id); 
            Invoice.setRedirect(true);
            
            // Take the PDF content
            // Blob b = pdf.getContent();
            Attachment attach = new Attachment();
            Blob body;
            try {
                
                // returns the output of the page as a PDF
                body = Invoice.getContent();
                system.debug('body should be fine');
                
                // need to pass unit test -- current bug    
            } catch (VisualforceException e) {
                system.debug('in the catch block');
                body = Blob.valueOf('Some Text');
            }
            
            
            Date myDate = system.today();
            string sToday = DateTime.newInstance(
                myDate.year(), myDate.month(), myDate.day()
            ).format('yyyyMMdd'); 
            attach.Body = body;
            // add the user entered name
            attach.Name =  'Invoice-' + theContract.name + '-' + sToday + '.xls';
            attach.IsPrivate = false;
            // attach the pdf to the account
            attach.ParentId = theContract.ContractCompany__c;
            insert attach;
            system.debug(attach);
            
            
        }
        
    }
    
}