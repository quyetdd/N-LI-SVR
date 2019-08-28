global with sharing class wb_MDContractInvoice {
    public wb_Membership__c theContract {get;set;} 
    public  List<wb_MembershipDetail__c> theContractDetail {get;set;} 
    public string filename  {get;set;}
    
    public String xlsHeader{
        get{
            String strHeader = '';
            strHeader += '<?xml version="1.0"?>';
            strHeader += '<?mso-application progid="Excel.Sheet"?>';
            return strHeader;
        }
    }
    
    public void getURLparameters(){
        
        if (apexpages.currentpage() != null ) {
            if (apexpages.currentpage().getparameters().get('Id') !='') {
                Id theId = apexpages.currentpage().getparameters().get('Id');
                theContract = [select Id, Name from wb_Membership__c where id=:theId];
            }
        }
    }
        

    
    public wb_MDContractInvoice() {
        
        getURLparameters();
        
        If (theContract != null){
            filename  = 'MDContractData' + theContract.name + '.xls' ;
        } else
            filename  = 'MDContractData.xls';
        
        
      //  wb_Membership__c c = [select Id from wb_Membership__c where id ='a0o5D000000Q41X'];
        
        getHeader(theContract);
        getDetail(theContract);
    }
    
    public wb_MDContractInvoice( wb_Membership__c c ) {
               
        
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
                       Sales__r.Name, 
                       Sales__r.SeiMeiRoma__c,  
                       InternalAffairs__r.Name,
                       InternalAffairs__r.SeiMeiRoma__c,
                       
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
                             Individual__r.name,
                             Individual__r.FirstNameRoma__c,  MemberNo__c, 
                             MembershipPlan__c,  MembershipEndDate__c,  Individual__r.Address__c,   Individual__r.Tel__c, 
                             Individual__r.Mobile__c,  
                             Individual__r.EmailAddress__c, Individual__r.MailDelivery__c,
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
                             WorkingCompany__r.NaimuTanto__r.Name
                             from wb_MembershipDetail__c
                             where Membership__c =: c.id];
        
    }
    
}