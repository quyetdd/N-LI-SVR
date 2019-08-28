public class wb_Individual {
    private ApexPages.StandardController standardController;
    public string MyHome='/a0n/o'; 
    public wb_Individual__c Individual {get;set;}
    public List<wb_Individual__c> CurrentFamilyMembers {get;set;}
    public List<wb_Individual__c> NewFamilyMembers {get;set;}
    public List<wb_Individual__c> WholeFamily {get;set;}
    public integer NoofFamilyMembers {get;set;}
    
    public String FormTag { get; set; }
    public List<wb_Individual__c> searchresults {get;set;}
    public List<String> str_searchresults {get;set;}
    public List<SelectOption> str_searchresultOptions {get;set;}
    public string searchString{get;set;}
    public Account WorkFor{get;set;}
    
    public List<wb_Service__c> MDService {get;set;}
    public List<aTableRow> theEmployeeRows { get; set; }
    
    public wb_MembershipDetail__c MembershipPeriod { get; set; }
    public class aTableRow {
        public Boolean IsSelected { get; set; }
        public Boolean HavingFamily { get; set; }
        public string FamilyMessage { get; set; }
        public wb_Individual__c theEmployee { get; set; }
        public Id MyService { get; set; }
        public List<wb_Service__c> theService { get; set; }
        
        public SelectOption[] ServiceOptions {get; set;}
        
        public SelectOption[] getServiceOptions() {  
            
            List<SelectOption>  opt = new  List<SelectOption>();
            opt.add(new SelectOption('','--None--'));  
            
            if (theService != null) {
            for (  wb_Service__c s: theService) {
                if ( s.DataType__c =='単身' || s.DataType__c =='家族' )
                    opt.add(new SelectOption(s.id, s.Service__c + s.DataType__c));
            }
            }
            
            return opt;  
        }  
        
        
        public aTableRow(Boolean b, wb_Individual__c em, List<wb_Service__c> Service, string ServiceID ) {
            theEmployee = em;
            HavingFamily = b;
            if ( HavingFamily == true)
                FamilyMessage = '家族有り';
            else
                FamilyMessage = '家族無し';
            theService = Service;
            ServiceOptions = getServiceOptions();
            if ( ServiceID != null ) {
            if (ServiceID.length() > 0)
                MyService = ServiceID;
            }
        }
    }
    
    public void fetchSelectedList(){
        
    }
    
    public List<wb_Service__c> getServiceMaster(){
        
        return [SELECT id, Service__c, CardPrefix__c, Currency__c, ServiceFee__c,  
                DataType__c
                FROM wb_Service__c
                where ServiceClassification__c = '会員' and Enable__c = true];
        
    }
    
    public string CallerRowID { get; set; }
    public string CallerRowIndex  { get; set; }
    public string CallerServiceID  { get; set; }
    public string CallerWorkingCompID { get; set; }
    public string CallerStartDate { get; set; }
    public string CallerMode { get; set; }
    public string CallerDateRequest { get; set; }
    public wb_Individual(ApexPages.StandardController stdController){
        string Id = ApexPages.currentPage().getParameters().get('Id');
        
        //system.debug('id:' +Id);
        
        this.standardController = stdController;
        Individual = (wb_Individual__c) stdController.getRecord();
        
        GetMyselfandFamily();
        
        NewFamilyMembers = new List<wb_Individual__c>();
        
        
    }
    
    public wb_Individual(){
        CallerRowID = apexpages.currentpage().getparameters().get('pv0');
        CallerRowIndex = apexpages.currentpage().getparameters().get('pv1');
        CallerServiceID = apexpages.currentpage().getparameters().get('pv2');
        CallerWorkingCompID = apexpages.currentpage().getparameters().get('pv3');
        CallerStartDate = apexpages.currentpage().getparameters().get('pv4');
        CallerMode = apexpages.currentpage().getparameters().get('pv5');
        CallerDateRequest = apexpages.currentpage().getparameters().get('pv6');
        //system.debug('id:' +Id);
        //system.debug('pv:' +CallerRowID + ':' + CallerRowIndex + ':' + CallerServiceID + ':' + CallerWorkingCompID +':' + CallerStartDate);
        MDService = getServiceMaster();
        system.debug(MDService);
        MembershipPeriod = new wb_MembershipDetail__c();
        //MembershipPeriod.MembershipStartDate__c = CallerStartDate;
        // String mm=CallerStartDate.subString(0,2);
        // String dd=CallerStartDate.subString(6,8);
        // String yy=CallerStartDate.subString(0,4);
        if (CallerStartDate.length()>0){
            String[] newdates = CallerStartDate.split('/');
            MembershipPeriod.MembershipStartDate__c = Date.newInstance(integer.valueOf(newdates[0]), 
                                                                       integer.valueOf(newdates[1]), 
                                                                       integer.valueOf(newdates[2]));
        }
        //if ()
        if (CallerWorkingCompID.length() > 0 ){
            if ( [ select id from account where id =:CallerWorkingCompID].size() > 0 )
                WorkFor = [select id, name from account where id =:CallerWorkingCompID];
        }

        Individual = new wb_Individual__c();
        if ( WorkFor != null) 
            Individual.WorkingCompany__c = WorkFor.id;             
        
        
        NewFamilyMembers = new List<wb_Individual__c>();
    }
    
     
     
    public void GetMyselfandFamily(){
        
        if ( Individual.id != null ) {
            Individual =[SELECT PostalCode__c, Parent__c, Complaint__c, //Jurisdiction__c, 
                         DateOfBirth__c, Member__r.f_MemberNo__c, // CurrentMemberNo__c, 
                         Name, 
                         Mobile__c, ChronicDisease__c, //AffiliationDistrict__c, 
                         WorkingCompany__r.Jurisdiction__c,
                         Sex__c, Position__c, FamilyRelationship__c, FamilyNo__c, 
                         LastNameRoma__c, LastNameKana__c, CountryCallingCodes__c, //Country__c, 
                         FirstNameRoma__c, FirstNameKana__c, 
                         //Classification__c, 
                         WorkingCompany__c, HealthCheckSystemNo__c, Address__c, //MembershipStartDate__c, 
                        // MembershipEndDate__c, 
                         MailDelivery__c, EmailAddress__c, Id, AC_Information__c,
                         Note__c
                         // DeptAfterWithdrawal__c, 
                         // ReturningHomeCountryCoverage__c ,
                         // PositionAfterWithdrawal__c, 
                         // CompanyAfterWithdrawal__c 
                         FROM wb_Individual__c where id =:Individual.id ];
            
            RefreshFamily();
            
        }
        
        else {
            
            Individual = new wb_Individual__c(FamilyNo__c ='0');
            WholeFamily = new List<wb_Individual__c>();
            
        }
    }
    
    public void RefreshFamily(){
        
        WholeFamily = new List<wb_Individual__c>();
        GetCurrentFamilyMembers();
        CombineCurrentnNewMembers();
        
    } 
    
    public void CombineCurrentnNewMembers(){
        WholeFamily = new List<wb_Individual__c>();
        
        if ( CurrentFamilyMembers != null ) {
            for ( wb_Individual__c f:CurrentFamilyMembers){
                WholeFamily.add(f);
            }
        }
        if ( NewFamilyMembers != null ) {
            for ( wb_Individual__c f:NewFamilyMembers){
                WholeFamily.add(f);
            }
        }
        
        NoofFamilyMembers = WholeFamily.size();
    }
    
    public void GetCurrentFamilyMembers(){
        CurrentFamilyMembers = new List<wb_Individual__c>();
        CurrentFamilyMembers = [select id, Parent__c, Name, Sex__c, FirstNameKana__c, LastNameKana__c,
                                FirstNameRoma__c, LastNameRoma__c, DateOfBirth__c, Address__c, EmailAddress__c,
                                MailDelivery__c,
                                //Tel__c, Fax__c, 
                                FamilyNo__c, FamilyRelationship__c
                                from wb_Individual__c where Parent__c =:Individual.id ];
    }
    
     
    
    public void NewFamilyMember() {
        
        if ( Individual.name <> null && Individual.id == null ) {
            Individual.FamilyNo__c ='0';
            upsert Individual;
        }
        
        
        if (Individual.id <> null){
            GetCurrentFamilyMembers();
            
            Integer n = CurrentFamilyMembers.size() + NewFamilyMembers.size();
            
            
            NewFamilyMembers.add( new wb_Individual__c(Parent__c=Individual.id, FamilyNo__c =  string.valueOf( n + 1)) );
            CombineCurrentnNewMembers();
            
        }
        
        return;
    }
    
    
    public PageReference validate()
    {
        
        if(Individual.Name == null )
            Individual.Name.addError('氏名を入力してください!');
        return null;    
        
    }
    
    public PageReference UpdateRecords(){
        
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        
        if (Individual.id == null) {
            Individual.FamilyNo__c ='0';
            insert Individual;
            
            
            return new PageReference(sfdcBaseURL +MyHome);
            
        }
        else {
            update Individual;
            update CurrentFamilyMembers;
            insert NewFamilyMembers;
            
            //update Family;
            
            // return new PageReference('https://cs6.salesforce.com/' + Individual.id);
            return new PageReference(sfdcBaseURL +'/'+ Individual.id);
        }
        
    }
    
    public void UpdateRecordsAndStay(){
        
        
        if (Individual.id == null) {
            Individual.FamilyNo__c ='0';
            insert Individual;
            
            
            return ;
            
        }
        else {
            update Individual;
            //update CurrentFamilyMembers;
            upsert NewFamilyMembers;
            return ;
        }
        
    }
     
    
    public PageReference Cancel(){
        
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        
        if (Individual.id == null) {
            
            return new PageReference(sfdcBaseURL +MyHome);
            
        }
        else {
            
            return new PageReference(sfdcBaseURL +'/'+ Individual.id);
        }
        
    }
    
    public PageReference Home(){
        
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        
        return new PageReference(sfdcBaseURL +MyHome);
        
    }
    
    public PageReference Edit(){
        
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        
        system.debug(sfdcBaseURL +'/apex/wb_individual_Edit?id'+ Individual.id );
        
        return new PageReference(sfdcBaseURL +'/apex/wb_individual_Edit?id='+ Individual.id);
        
        
    }
    
    public PageReference validateAndUpdate()
    {
        // Validate and redisplay if errors
        validate();
        if(ApexPages.hasMessages(ApexPages.Severity.Error))
            return null;
        
        return  UpdateRecords();
    }
    
    // performs the keyword search
    public PageReference search() {
        runSearch();
        return null;
    }
    // prepare the query and issue the search command
    private void runSearch() {
        // TODO prepare query string for complex serarches & prevent injections
        if (WorkFor != null)
            searchresults = performSearch( WorkFor.name);    
        else
            searchresults = performSearch( null);
        
        theEmployeeRows = new List<aTableRow>();
        List<id> Parent=new List<id>();
        
        // str_searchresults = new List<string>();
        // str_searchresultOptions = new List<SelectOption>();
        if ( searchresults != null) {
            for ( wb_Individual__c r:searchresults){
                theEmployeeRows.add(new aTableRow(false, r, MDService, CallerServiceID));
                Parent.add(r.id);
                //str_searchresultOptions.add(new SelectOption (r.id,r.name));
            }
        }
        
        
        AggregateResult[] AgR = [SELECT Parent__c, count(id)
                                 FROM wb_Individual__c
                                 where Parent__c in: Parent
                                 group by Parent__c];
        
        for (AggregateResult c:AgR){
            for( aTableRow r:theEmployeeRows){
                if ( r.theEmployee.id == c.get('Parent__c'))   {
                    if ((Integer) c.get('expr0') > 0 ) {
                        r.HavingFamily = true;
                        r.FamilyMessage = '家族有り';
                    }
                    
                }
            }
        }            
        // system.debug('searchresults:' + searchresults.size() + ' :' + str_searchresults.size());
    } 
    
    // run the search and return the records found. 
    private List<wb_Individual__c> performSearch(string searchString) {
        
        
        List<wb_Individual__c> WorkingCompanyIndividualList;
        
        String soqlW = 'select id, name, Member__r.f_MemberNo__c, WorkingCompany__r.name from wb_Individual__c';
        // String soqlW = 'select id, name, WorkingCompany__r.name from wb_Individual__c';
        
        if(searchString != '' && searchString != null) {
            soqlW = soqlW +  ' where WorkingCompany__r.name =  \'' + searchString +'\' ';
            
        } else
        {
            soqlW = soqlW +  ' where Parent__c = null ';
        }
        
        //  soqlW = soqlW + ' limit 2 ';
        
        System.debug(soqlW);
        
        WorkingCompanyIndividualList = database.query(soqlW);
        
        List<wb_Individual__c> IndividualList =new List<wb_Individual__c>();
        
        IndividualList.addAll(WorkingCompanyIndividualList);
        
        return IndividualList;
        
    }
    
    // used by the visualforce page to send the link to the right dom element
    public string getFormTag() {
        return System.currentPageReference().getParameters().get('frm');
    }
    
    // used by the visualforce page to send the link to the right dom element for the text box
    public string getTextBox() {
        return System.currentPageReference().getParameters().get('txt');
    }
    
    
}