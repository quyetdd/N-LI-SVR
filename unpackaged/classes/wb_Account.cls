public class wb_Account {
    private ApexPages.StandardController standardController;
    public string MyHome='/001/o';
    public Account theAccount {get; set;}
    public List<wb_CountryDistrict__c> CountryDistrict {get; set;}
    
    public SelectOption[] RegionOptions {get; set;}
    public SelectOption[] CountryOptions {get; set;}
    public SelectOption[] AffiliationOptions {get; set;}
    public SelectOption[] JurisdictionOptions {get; set;}
   
    public List<AggregateResult> theCountryCodeList {get; set;}
    
    public wb_Account(ApexPages.StandardController stdController){
        this.standardController = stdController;
        theAccount = (Account) stdController.getRecord();
        if (theAccount.id != null)
        theAccount = getAccount(theAccount.id);
        
        theCountryCodeList = GetCountryCodeList();
    }
    
    public Account getAccount(id theID){
        return [SELECT BlEigyoTanto__c, BlInsuranceCompanyName__c, BlShimei__c, BlEmail__c, BlKeiyaku__c, 
                //Email__c, 
                Sales_PIC_Romaji__c, 
                Tax_Identification_Number__c, NaimuTanto__c, NaimuBusho__c, EigyoTanto__c, EigyoBusho__c, Note_2__c, Region_and_Area__c, 
                GroupStandardCompany__c, SubShimei__c, SubYakushoku__c, SubTantoEmail__c, SubBusho__c, Shimei__c, TantoEmail__c, 
                Yakushoku__c, Busho__c, MainCustomerCompany__c, BigShareholder__c, ContentOfBusiness__c, CompanyCd__c, Name, 
                CompanyNameKana__c, CompanyNameEng__c, Fax, Id, CompanySummary__c, AccountNumber, CompanyPopularName__c, OfficeAdd__c, 
               // UseHealthCheckUpInfo__c, 
                ExtNo__c, CapitalContributionRatio__c, GroupName__c, 
                //Classification__c, 
                MainInsuranceCompany__c, 
                MainFinancingBank__c, ImportComm__c, AffiliatedCompanyName__c, CountryCode__c, CountryCd__c, CountryName__c, 
                CountryCallingCodes__c, LetterOfAttorneyGet__c, WbHumanNetwork__c, ShozokuArea__c, ExpandOverseasSituation__c, 
                ProductionItem__c, TaxIncentives__c, Jurisdiction__c, OrgMechNo__c, President__c, CarOwnedNum__c, CarInsuranceNote__c, 
                VehicleShimei__c, VehicleEmail__c, ParentCompanyCd__c, DateOfFoundation__c, Capital__c, OfficePostcd__c, 
                MoverAndShakerNote__c, MoverAndShakerOldSchool__c, MoverAndShakerYakushoku__c, MoverAndShakerShimei__c, 
                MoverAndShakerHobby__c, MoverAndShakerBusho__c, HeadquartersEigyoTanto__c, HeadquartersEigyoBusho__c ,
                ParentId,Phone,Industry ,NumberOfEmployees ,Description,DeleteDate__c,
                Company_MC_Plan__c,Notes_for_Claim_and_Payment__c,Inspection_Items_by_HQ_Personnel__c,Special_Price_Application__c,PersonalInfoDisclosure__c,Notes_for_MC__c
                FROM Account where id =:theID];
    }
    
    public List<AggregateResult> GetCountryCodeList(){
        return [SELECT Country__c, CountryCode__c, count(id) 
                FROM wb_CountryDistrict__c
                where Service__c='MD会員'
                group by Country__c, CountryCode__c
                order by Country__c ];
    }
    
    public void fetchCountryCode(){
        system.debug(theAccount.CountryName__c);
        for ( AggregateResult a:theCountryCodeList){
             system.debug(a.get('Country__c'));
            if ( a.get('Country__c')==theAccount.CountryName__c){
                system.debug(theAccount.CountryCode__c);
                  system.debug(a.get('Country__c') + ':'+ a.get('CountryCode__c'));
                theAccount.CountryCode__c=String.valueOf( a.get('CountryCode__c'));
                system.debug(theAccount.CountryCode__c);
                return;
            }
        }
        return;
    }
    
    public PageReference Save(){
        upsert theAccount;
        
        if (theAccount.id != null) {
            
            String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
            return new PageReference(sfdcBaseURL+'/' +  theAccount.id);
        }
        else {
            String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
            return new PageReference(sfdcBaseURL+MyHome);
            // return new PageReference(sfdcBaseURL+'/a0f/o');
            
        }
    }
    
    public void getCountryDistrict(){
        CountryDistrict = [SELECT Region__c, Country__c, Jurisdiction__c, Affiliation__c 
                           FROM wb_CountryDistrict__c
                           where Service__c = 'MD'
                           order by id ];
    }
    
    public void getRegionOption(){
        
    }
    
    public void getCountryOption(){
        
    }
    
    public void getJurisdictionOption(){
        
    }
    
    public void getAffiliationOption(){
        
    }
}