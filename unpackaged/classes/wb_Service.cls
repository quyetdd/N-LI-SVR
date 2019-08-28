public class wb_Service {
    
    ApexPages.StandardController stdController;

    public SelectOption[] ServiceClassificationOptions {get;set;}
    public string selectedServiceClassification {get;set;}
    
    public ServiceGroup ServiceGroupOtn {get;set;}
    
    public void fetchCurrencyOptions(){
        if (ServiceGroupOtn.selectedCountry=='--New--'){
            ServiceGroupOtn.MyStatus = '--New--';
            PSGService = new PassengerService(selectedServiceClassification);
        }
        else{
            ServiceGroupOtn.MyStatus = '';
            ServiceGroupOtn.CurrencyOptions= ServiceGroupOtn.getCurrencyOptions();
            ServiceGroupOtn.InsuranceCompanyOptions = ServiceGroupOtn.getInsuranceCompanyOptions();
            ServiceGroupOtn.ServiceOptions = ServiceGroupOtn.getServiceOptions();
            ServiceGroupOtn.GroupOptions = ServiceGroupOtn.getServiceGroupOptions();
        }
        
    }
    public void fetchInsuranceCompanyOptions(){
        if (ServiceGroupOtn.selectedCurrency=='--New--'){
            ServiceGroupOtn.MyStatus = '--New--';
            PSGService = new PassengerService(selectedServiceClassification,ServiceGroupOtn.selectedCountry);
        }
        else{
            ServiceGroupOtn.MyStatus = '';
            ServiceGroupOtn.InsuranceCompanyOptions= ServiceGroupOtn.getInsuranceCompanyOptions();
            ServiceGroupOtn.ServiceOptions = ServiceGroupOtn.getServiceOptions();
            ServiceGroupOtn.GroupOptions = ServiceGroupOtn.getServiceGroupOptions();
        }
        
    }
    
    public void fetchServiceOptions(){
        if (ServiceGroupOtn.selectedInsuranceCompany=='--New--'){
            ServiceGroupOtn.MyStatus = '--New--';
            PSGService = new PassengerService(selectedServiceClassification,
                                              ServiceGroupOtn.selectedCountry,
                                              ServiceGroupOtn.selectedCurrency);
        }
        else{
            ServiceGroupOtn.MyStatus = '';
            ServiceGroupOtn.ServiceOptions = ServiceGroupOtn.getServiceOptions();
            ServiceGroupOtn.GroupOptions = ServiceGroupOtn.getServiceGroupOptions();
        }
    }
    
    public void fetchServiceGroupOptions(){
        
        if (  ServiceGroupOtn.selectedService == '--New--')    {               
            ServiceGroupOtn.MyStatus = '--New--';
            system.debug('fetchServiceGroupOptions :' + ServiceGroupOtn.selectedServiceClassification + ' ' +
                         ServiceGroupOtn.selectedCountry + ' ' +
                         ServiceGroupOtn.selectedCurrency +' ' +
                         ServiceGroupOtn.selectedInsuranceCompany + ' ' +
                         ServiceGroupOtn.selectedService 
                        );
            
            PSGService = new PassengerService(selectedServiceClassification,
                                              ServiceGroupOtn.selectedCountry,
                                              ServiceGroupOtn.selectedCurrency,
                                              ServiceGroupOtn.selectedInsuranceCompany);
        }
        else{
            ServiceGroupOtn.MyStatus = '';
            
           system.debug('fetchServiceGroupOptions :' + ServiceGroupOtn.selectedServiceClassification + ' ' +
                        ServiceGroupOtn.selectedCountry + ' ' +
                        ServiceGroupOtn.selectedCurrency +' ' +
                        ServiceGroupOtn.selectedInsuranceCompany + ' ' +
                        ServiceGroupOtn.selectedService 
                       );
            
            if ([select id from wb_Service__c
                 where Enable__c = true 
                 and ServiceClassification__c =:ServiceGroupOtn.selectedServiceClassification
                 and Country__c =:ServiceGroupOtn.selectedCountry
                 and Currency__c=:ServiceGroupOtn.selectedCurrency
                 and ServiceCompany__c=:ServiceGroupOtn.selectedInsuranceCompany
                 and Service__c =:ServiceGroupOtn.selectedService
                 and DataType__c ='M'
                 and Group__c = null
                ].size()>1)
            {
                PSGService = new PassengerService(selectedServiceClassification,
                                                  ServiceGroupOtn.selectedCountry,
                                                  ServiceGroupOtn.selectedCurrency,
                                                  ServiceGroupOtn.selectedInsuranceCompany,
                                                  ServiceGroupOtn.selectedService,
                                                  null
                                                 );
            } else
            {
                if ( [select Group__c, count(id) from wb_Service__c where Enable__c = true 
                      and ServiceClassification__c =:ServiceGroupOtn.selectedServiceClassification
                      and Country__c =:ServiceGroupOtn.selectedCountry
                      and Currency__c=:ServiceGroupOtn.selectedCurrency
                      and ServiceCompany__c=:ServiceGroupOtn.selectedInsuranceCompany
                      and Service__c =:ServiceGroupOtn.selectedService
                      and DataType__c ='M' and Group__c <> null
                      group by Group__c ].size() == 1 ){
                          AggregateResult r = [select Group__c, count(id) from wb_Service__c where Enable__c = true 
                                               and ServiceClassification__c =:ServiceGroupOtn.selectedServiceClassification
                                               and Country__c =:ServiceGroupOtn.selectedCountry
                                               and Currency__c=:ServiceGroupOtn.selectedCurrency
                                               and ServiceCompany__c=:ServiceGroupOtn.selectedInsuranceCompany
                                               and Service__c =:ServiceGroupOtn.selectedService
                                               and DataType__c ='M' and Group__c <> null
                                               group by Group__c ];
                          
                          PSGService = new PassengerService(selectedServiceClassification,
                                                            ServiceGroupOtn.selectedCountry,
                                                            ServiceGroupOtn.selectedCurrency,
                                                            ServiceGroupOtn.selectedInsuranceCompany,
                                                            ServiceGroupOtn.selectedService,
                                                            string.valueof(r.get('Group__c'))
                                                           );
                          
                      }
                
            }
            ServiceGroupOtn.GroupOptions = ServiceGroupOtn.getServiceGroupOptions();
            
            ServiceGroupOtn.CommissionRate = ServiceGroupOtn.getCommissionRate();
        }
        
    }
    
    public class ServiceGroup{
        public string MyStatus {get;set;}
        public SelectOption[] CountryOptions {get;set;}
        public SelectOption[] CurrencyOptions {get;set;}
        public SelectOption[] InsuranceCompanyOptions {get;set;}
        public decimal CommissionRate {get;set;}
        public SelectOption[] ServiceOptions {get;set;}
        public SelectOption[] GroupOptions {get;set;}
        public string selectedServiceClassification {get;set;}
        public string selectedCountry {get;set;}
        public string selectedCurrency {get;set;}
        public string selectedInsuranceCompany {get;set;}
        public string selectedService {get;set;}
        public string selectedGroupID {get;set;}
  		
        
        ServiceGroup(string Classification){
            selectedServiceClassification = Classification;
            CountryOptions = getCountryOptions();
        }        
        
        public SelectOption[] getCountryOptions() {  
            
            List<SelectOption>  opt = new  List<SelectOption>();
            opt.add(new SelectOption('','--None--'));  
            if ( selectedServiceClassification != null ){
                for (AggregateResult l : [ SELECT Country__c, count(id)
                                          FROM wb_Service__c
                                          where Enable__c = true    
                                          and ServiceClassification__c =:selectedServiceClassification
                                          and Country__c <> null
                                          group by Country__c	]) {  
                                              opt.add(new SelectOption(String.valueOf(l.get('Country__c')), 
                                                                       String.valueOf(l.get('Country__c')) ));  
                                          }       
            }
            opt.add(new SelectOption('--New--','--新規--'));  
            return opt;  
        }
        
        
        public SelectOption[] getCurrencyOptions() {  
            List<SelectOption>  opt = new  List<SelectOption>();
            opt.add(new SelectOption('','--None--'));  
            if ( selectedCountry != null){
                for (AggregateResult l : [ SELECT Currency__c, count(id)
                                          FROM wb_Service__c
                                          where Enable__c = true 
                                          and ServiceClassification__c =:selectedServiceClassification
                                          and Country__c =:selectedCountry
                                          and  Currency__c <> null     
                                          group by Currency__c	]) {  
                                              opt.add(new SelectOption(String.valueOf(l.get('Currency__c')), 
                                                                       String.valueOf(l.get('Currency__c')) ));  
                                          }      
            }
            opt.add(new SelectOption('--New--','--新規--')); 
            return opt;  
        }
        
        
        
        public SelectOption[] getInsuranceCompanyOptions() {  
            List<SelectOption>  opt = new  List<SelectOption>();
            opt.add(new SelectOption('','--None--')); 
            if (selectedCurrency!=null){
                for (AggregateResult l : [ SELECT ServiceCompany__c, count(id)
                                          FROM wb_Service__c
                                          where Enable__c = true 
                                          and ServiceClassification__c =:selectedServiceClassification
                                          and Country__c =:selectedCountry
                                          and Currency__c=:selectedCurrency
                                          and ServiceCompany__c <> null
                                          group by ServiceCompany__c	]) {  
                                              opt.add(new SelectOption(String.valueOf(l.get('ServiceCompany__c')), 
                                                                       String.valueOf(l.get('ServiceCompany__c')) ));  
                                          }   
            }
            opt.add(new SelectOption('--New--','--新規--')); 
            return opt;  
        }        
        
        ServiceGroup(string Classification, string Country, string Cur, string InsuranceCompany ){
            selectedServiceClassification = Classification;
            selectedCountry = Country;
            selectedCurrency = Cur;
            selectedInsuranceCompany = InsuranceCompany;
            ServiceOptions = getServiceOptions();
            GroupOptions = new List<SelectOption>();
        }
        
        public SelectOption[] getServiceOptions() {  
            List<SelectOption>  opt = new  List<SelectOption>();
            opt.add(new SelectOption('','--None--')); 
            if (selectedInsuranceCompany!=null){
                for (AggregateResult l : [ SELECT Service__c, count(id)
                                          FROM wb_Service__c
                                          where Enable__c = true 
                                          and ServiceClassification__c =:selectedServiceClassification
                                          and Country__c =:selectedCountry
                                          and Currency__c=:selectedCurrency
                                          and ServiceCompany__c=:selectedInsuranceCompany
                                          and Service__c <> null
                                          and DataType__c ='M'
                                          group by Service__c	]) {  
                                              opt.add(new SelectOption(String.valueOf(l.get('Service__c')), 
                                                                       String.valueOf(l.get('Service__c')) ));  
                                          }   
            }
            opt.add(new SelectOption('--New--','--新規--'));
            return opt;  
        }
        
        public Decimal getCommissionRate(){
            if ( selectedServiceClassification != null 
                && selectedCountry != null && selectedCurrency != null 
                && selectedInsuranceCompany != null && selectedService != null
               ) {
                   wb_Service__c cm = [ SELECT CommissionRate__c
                                       FROM wb_Service__c
                                       where Enable__c = true 
                                       and ServiceClassification__c =:selectedServiceClassification
                                       and Country__c =:selectedCountry
                                       and Currency__c=:selectedCurrency
                                       and ServiceCompany__c=:selectedInsuranceCompany
                                       and Service__c =:selectedService
                                       and DataType__c ='M'
                                      // and  Group__r.Plan__c != null
                                       limit 1];
                   
                   return cm.CommissionRate__c;
               } else return null;
            
        }
        
        public SelectOption[] getServiceGroupOptions() {  
            
            
            List<SelectOption>  opt = new  List<SelectOption>();
            opt.add(new SelectOption('','--None--')); 
            if (selectedService!=null){
         
                for (AggregateResult l : [ SELECT Group__c, Group__r.Plan__c, count(id)
                                          FROM wb_Service__c
                                          where Enable__c = true 
                                          and ServiceClassification__c =:selectedServiceClassification
                                          and Country__c =:selectedCountry
                                          and Currency__c=:selectedCurrency
                                          and ServiceCompany__c=:selectedInsuranceCompany
                                          and Service__c =:selectedService
                                          and DataType__c ='M'
                                          and  Group__r.Plan__c != null
                                          group by Group__c, Group__r.Plan__c	]) {  
                                              opt.add(new SelectOption(String.valueOf(l.get('Group__c')), 
                                                                       String.valueOf(l.get('Plan__c')) ));  
                                          }   
            }
            opt.add(new SelectOption('--New--','--新規--')); 
            return opt;  
        }
        
    }
    
    public BLService BL{get;set;}
    public class BLService{
        public List<wb_Service__c> AllInsurance {get;set;}
        public List<wb_Service__c> AllItem {get;set;}
        public List<wb_Service__c> Item {get;set;}
        
        public SelectOption[] InsuranceOptions {get;set;}
        public String selectedInsurance {get;set;}
        public wb_Service__c new_pservice {get;set;}
        
        public BLService(){
            AllInsurance = new List<wb_Service__c>();
            AllInsurance = getAllInsurance();
            AllItem = new List<wb_Service__c>();
            AllItem = [SELECT Id, Service__c, ServiceCompany__c, Name, ParentService__c, ServiceClassification__c 
                         FROM wb_Service__c 
                         where ServiceClassification__c ='BL' and ServiceCompany__c ='ALL' and ParentService__c != null];
            InsuranceOptions = getInsuranceOptions();
        }
        
        public List<wb_Service__c> getAllInsurance(){
            return [SELECT Id, Service__c, ServiceCompany__c, Name, ParentService__c, ServiceClassification__c 
                         FROM wb_Service__c 
                         where ServiceClassification__c ='BL' and ServiceCompany__c ='ALL' and ParentService__c = null];
        }
        
        public SelectOption[] getInsuranceOptions() {  
            
            List<SelectOption>  opt = new  List<SelectOption>();
            opt.add(new SelectOption('','--None--'));  
           
                for (wb_Service__c l : AllInsurance ) {  
                                              opt.add(new SelectOption(String.valueOf(l.id), 
                                                                       String.valueOf(l.Service__c) ));  
                                          }       
            
            opt.add(new SelectOption('--New--','--新規--'));  
            return opt;  
        }
        
        public void fetchInsuranceItem(){
           // system.debug('fetchInsuranceItem for:' + selectedInsurance);
           
            if ( selectedInsurance =='--New--') {
                new_pservice = new wb_Service__c( ParentService__c = null, 
                                        ServiceClassification__c ='BL', 
                                        ServiceCompany__c ='ALL');
            } else {
                Item = new List<wb_Service__c>();
                for ( wb_Service__c i:AllItem){
                    if ( i.ParentService__c == selectedInsurance) {
                        wb_Service__c c = i.clone(true,true,false,false);
                        item.add(c);
                    }
                }
            }
        }
        
        public void AddNewInsurance(){
            if ( new_pservice.Service__c != null ){
                insert new_pservice;
                AllInsurance = getAllInsurance();
                InsuranceOptions = getInsuranceOptions();
            }
        }
        
        public void AddNewInsuranceItem(){
            item.add( new wb_Service__c( ParentService__c = selectedInsurance, 
                                        ServiceClassification__c ='BL', 
                                        ServiceCompany__c ='ALL')
            );
        } 
        
        public string InsuranceItemRemoveId {get;set;}
        public integer InsuranceItemRemoveIndex {get;set;}
        
        public void InsuranceItemRemove(){
            
            wb_Service__c[] i_remove;
            
            if (InsuranceItemRemoveId != ''){
                if( item[InsuranceItemRemoveIndex-1].id ==InsuranceItemRemoveId ) {
                    i_remove = [select id from wb_Service__c where id =:InsuranceItemRemoveId];
                    delete i_remove;
                    
                    item.remove(InsuranceItemRemoveIndex-1);
                }
            } else
            {
                item.remove(InsuranceItemRemoveIndex-1);
            }
        }
        
        public void SaveInsuranceItem(){
            for ( wb_Service__c i:item)
            {   
       
                    string pname='';
                    for (wb_Service__c p: AllInsurance) {
                        if (p.id==i.ParentService__c)
                            pname = p.Service__c;
                    }
                     i.name = pname +':' + i.Service__c;
                
            }
            upsert item;
        }
        
        
    }
    


    
    public PassengerService PSGService {get;set;}
    
    public class PassengerService {
        
        public list<wb_Service__c> PsgrMain {get;set;}
        public wb_Service__c PsgrGroup {get;set;}
        public list<wb_Service__c> PsgrOption {get;set;}
        public string MyServiceClassification {get;set;}
        public string MyCountry {get;set;}
        public string MyCur {get;set;}
        public string MyInsuranceCompany {get;set;}
        public string MyService {get;set;}
        public string myPlan {get;set;}
       
        
        
        PassengerService( string ServiceClassification, 
                         string country, 
                         string cur, 
                         string InsuranceCompany, 
                         string Service, 
                         string selectedGroupID ){
                             system.debug(' PassengerService: ' + ServiceClassification + ' ' + country + ' ' + cur + ' ' +
                                          InsuranceCompany +' ' + Service + ' ' +selectedGroupID
                                         );
                             PsgrMain = new list<wb_Service__c>();  
                             
                             if ( selectedGroupID <> null) {
                                 PsgrOption = new list<wb_Service__c>(); 
                                 PsgrGroup = [select id, Country__c, ServiceClassification__c, 
                                              ServiceCompany__c, Service__c, Plan__c, 
                                              MainType__c, OptionType__c, CommissionRate__c, Currency__c 
                                              from wb_Service__c 
                                              where Enable__c = true and DataType__c ='G' and Id=:selectedGroupID];
                                 
                                 MyServiceClassification = PsgrGroup.ServiceClassification__c;
                                 MyCountry =  PsgrGroup.Country__c;
                                 MyCur = PsgrGroup.Currency__c;
                                 MyInsuranceCompany = PsgrGroup.ServiceCompany__c;
                                 MyService=  PsgrGroup.Service__c;
                                 myPlan=  PsgrGroup.Plan__c;
                                 
                                 if (PsgrGroup == null)
                                     PsgrGroup = new wb_Service__c(ServiceClassification__c=ServiceClassification,
                                                                   Country__c=country,Currency__c=cur,
                                                                   ServiceCompany__c=InsuranceCompany,
                                                                   Enable__c = true , DataType__c ='G', CommissionRate__c = null
                                                                  );
                                 PsgrMain =[SELECT id, ServiceClassification__c, Country__c, ServiceCompany__c, Service__c, 
                                            Plan__c, 
                                            DriverSeatInsurance__c, MinSeat__c,MaxSeat__c,
                                            PassengerFee__c, DriverFee__c, Group__r.Plan__c, DataType__c 
                                            FROM wb_Service__c
                                            where Enable__c = true and DataType__c ='M' 
                                            and ServiceClassification__c =:ServiceClassification
                                            and Country__c=:country
                                            and Currency__c=:cur
                                            and ServiceCompany__c=:InsuranceCompany
                                            and Group__c=:PsgrGroup.ID
                                            order by Plan__c, Group__r.Plan__c];
                                 
                                 PsgrOption=[SELECT id, ServiceClassification__c, Country__c, ServiceCompany__c, Service__c, Plan__c, MaxSeat__c, MinSeat__c,
                                             DriverSeatInsurance__c, PassengerFee__c, DriverFee__c, DataType__c 
                                             FROM wb_Service__c
                                             where Enable__c = true and DataType__c ='O' 
                                             and ServiceClassification__c =:ServiceClassification
                                             and Country__c=:country
                                             and Currency__c=:cur
                                             and ServiceCompany__c=:InsuranceCompany
                                             and ParentService__c=:PsgrGroup.ID
                                             order by Plan__c];
                             } else {

                                 PsgrGroup = new wb_Service__c(ServiceClassification__c=ServiceClassification,
                                                               Country__c=country,Currency__c=cur,
                                                               ServiceCompany__c=InsuranceCompany,
                                                               Enable__c = true , DataType__c ='G', CommissionRate__c = null, name='FIX',
                                                               Service__c = Service
                                                              );
                                 
                                 PsgrMain =[SELECT id, ServiceClassification__c, Country__c, ServiceCompany__c, Service__c, 
                                            Plan__c, 
                                            DriverSeatInsurance__c, MinSeat__c,MaxSeat__c,
                                            PassengerFee__c, DriverFee__c, Group__r.Plan__c, DataType__c 
                                            FROM wb_Service__c
                                            where Enable__c = true and DataType__c ='M' 
                                            and ServiceClassification__c =:ServiceClassification
                                            and Country__c=:country
                                            and Currency__c=:cur
                                            and ServiceCompany__c=:InsuranceCompany
                                     		and Service__c =:Service
                                            order by Plan__c];
                             }
                             
                             
                           

                             
                             
                         }
        
        PassengerService( string ServiceClassification ){
            MyServiceClassification = ServiceClassification;                             
            PsgrGroup = new wb_Service__c(ServiceClassification__c=ServiceClassification,
                                          Enable__c = true , DataType__c ='G', CommissionRate__c = null
                                         );
            PsgrMain = new list<wb_Service__c>(); 
            PsgrOption = new list<wb_Service__c>();
            
        }
        
        PassengerService( string ServiceClassification, string country ){
            MyServiceClassification = ServiceClassification;   
            MyCountry = country;
            PsgrGroup = new wb_Service__c(ServiceClassification__c=ServiceClassification,
                                          Country__c=country,
                                          Enable__c = true , DataType__c ='G', CommissionRate__c = null
                                         );
            PsgrMain = new list<wb_Service__c>(); 
            PsgrOption = new list<wb_Service__c>();
            
        }
        PassengerService( string ServiceClassification, string country, string cur ){
            MyServiceClassification = ServiceClassification;   
            MyCountry = country;
            MyCur=cur;
            PsgrGroup = new wb_Service__c(ServiceClassification__c=ServiceClassification,
                                          Country__c=country,Currency__c=cur,
                                          Enable__c = true , DataType__c ='G', CommissionRate__c = null
                                         );
            PsgrMain = new list<wb_Service__c>(); 
            PsgrOption = new list<wb_Service__c>();
            
        }
        
        PassengerService( string ServiceClassification, 
                         string country, 
                         string cur,  
                         string InsuranceCompany ){
                             MyServiceClassification = ServiceClassification;   
                             MyCountry = country;
                             MyCur=cur;
                             MyInsuranceCompany=InsuranceCompany;
                             PsgrGroup = new wb_Service__c(ServiceClassification__c=ServiceClassification,
                                                           Country__c=country,Currency__c=cur,
                                                           ServiceCompany__c=InsuranceCompany,
                                                           Enable__c = true , DataType__c ='G', CommissionRate__c = null
                                                          );
                             PsgrMain = new list<wb_Service__c>(); 
                             PsgrOption = new list<wb_Service__c>();
                             
                         }
        
        PassengerService( string ServiceClassification, string country, string cur, 
                         string InsuranceCompany, string Service ){
                             MyServiceClassification = ServiceClassification;
                             MyCountry=country;
                             MyCur=cur;
                             MyInsuranceCompany=InsuranceCompany;
                             MyService=Service;
                             
                             PsgrGroup = new wb_Service__c(ServiceClassification__c=ServiceClassification,
                                                           Country__c=country,Currency__c=cur,
                                                           ServiceCompany__c=InsuranceCompany,
                                                           Service__c = Service,
                                                           Enable__c = true , DataType__c ='G', CommissionRate__c = null
                                                          );
                             PsgrMain = new list<wb_Service__c>(); 
                             PsgrOption = new list<wb_Service__c>();
                             
                         }
        
        public void NewMainService(){
            if (PsgrGroup.Country__c == null) {
                PsgrGroup.Country__c.addError('必須な項目'); 
                return;
            }
            if (PsgrGroup.Currency__c == null) {
                PsgrGroup.Currency__c.addError('必須な項目'); 
                return;
            }   
            
            if (PsgrGroup.ServiceCompany__c == null) {
                PsgrGroup.ServiceCompany__c.addError('必須な項目'); 
                return;
            } 
            
            if (PsgrGroup.Service__c == null) {
                PsgrGroup.Service__c.addError('必須な項目'); 
                return;
            }
            if (PsgrGroup.MainType__c == null) {
                PsgrGroup.MainType__c.addError('必須な項目'); 
                return;
            } 
            PsgrMain.add( new  wb_Service__c(ServiceClassification__c=MyServiceClassification,
                                             Country__c=Mycountry,Currency__c=Mycur,
                                             ServiceCompany__c=MyInsuranceCompany,
                                             Service__c = PsgrGroup.Service__c,
                                             Enable__c = true , DataType__c ='M'
                                            ) );
        }
        
        public void AddMainService(){
            PsgrMain.add( new  wb_Service__c(ServiceClassification__c=MyServiceClassification,
                                             Country__c=Mycountry,Currency__c=Mycur,
                                             ServiceCompany__c=MyInsuranceCompany,
                                             Service__c = PsgrGroup.Service__c,
                                             Enable__c = true , DataType__c ='M'
                                            ) );
        }
        
        public void NewOpService(){
            if (PsgrGroup.Country__c == null) {
                PsgrGroup.Country__c.addError('必須な項目'); 
                return;
            }
            if (PsgrGroup.Currency__c == null) {
                PsgrGroup.Currency__c.addError('必須な項目'); 
                return;
            }   
            
            if (PsgrGroup.ServiceCompany__c == null) {
                PsgrGroup.ServiceCompany__c.addError('必須な項目'); 
                return;
            } 
            if (PsgrGroup.Plan__c == null) {
                PsgrGroup.Plan__c.addError('必須な項目'); 
                return;
            }
            if (PsgrGroup.OptionType__c == null) {
                PsgrGroup.OptionType__c.addError('必須な項目'); 
                return;
            } 
            PsgrOption.add( new  wb_Service__c(ServiceClassification__c=MyServiceClassification,
                                               Country__c=Mycountry,Currency__c=Mycur,
                                               ServiceCompany__c=MyInsuranceCompany,
                                               Enable__c = true , DataType__c ='O',
                                               Service__c = PsgrGroup.Plan__c,
                                               ParentService__c = PsgrGroup.id
                                              ) );
        }
        
         public void AddOpService(){

             

             
            PsgrOption.add( new  wb_Service__c(ServiceClassification__c = MyServiceClassification,
                                               Country__c= MyCountry,
                                               Currency__c= MyCur,
                                               ServiceCompany__c=MyInsuranceCompany,
                                               Enable__c = true , DataType__c ='O',
                                               Service__c = myPlan
                                              ) );
        }
        public void SaveNew(){
            
            if(ApexPages.hasMessages(ApexPages.Severity.Error)){
                return;
            } else {
                PsgrGroup.name = PsgrGroup.Service__c + PsgrGroup.Plan__c;
                if ( PsgrGroup.id == null)
                    insert PsgrGroup;
                else
                    update PsgrGroup;
                for (wb_Service__c m:PsgrMain )
                {
                    m.Group__c = PsgrGroup.id;
                    m.name = m.Service__c + m.Plan__c;
                    m.CommissionRate__c = PsgrGroup.CommissionRate__c;
                    if (m.id == null)
                        insert m;
                    else
                        update m;
                }
                for (wb_Service__c o:PsgrOption )
                {
                    o.ParentService__c = PsgrGroup.id;
                    o.name = o.Service__c + o.Plan__c;
                     o.CommissionRate__c = PsgrGroup.CommissionRate__c;
                    if (o.id == null)
                    insert o;
                    else
                        update o;
                }
            }
            

            
        }
        
         public void UpdateRecord(){
            
            if(ApexPages.hasMessages(ApexPages.Severity.Error)){
                return;
            } else {
                //PsgrGroup.name = PsgrGroup.Service__c + PsgrGroup.Plan__c;
                
              //  if (PsgrGroup.id = null)
               // if (PsgrGroup.DataType__c == 'G')
                    upsert PsgrGroup;
                
                for (wb_Service__c m:PsgrMain )
                { if (PsgrGroup <> null )
                    m.Group__c = PsgrGroup.id;
                    m.name = m.Service__c + m.Plan__c;
                  	m.CommissionRate__c = PsgrGroup.CommissionRate__c;
                    upsert m;
                }
                if ( PsgrOption <> null ) {
                    for (wb_Service__c o:PsgrOption )
                    {
                        o.ParentService__c = PsgrGroup.id;
                        o.name = o.Service__c + o.Plan__c;
                         o.CommissionRate__c = PsgrGroup.CommissionRate__c;
                        upsert o;
                    }
                }
            }
            
            
        }
        
        public void Disable(){
            if (PsgrGroup.id <> null){
                PsgrGroup.Enable__c = false;
                update PsgrGroup;
                
                for (wb_Service__c m:PsgrMain )
                {
                    m.Enable__c = false;
                    update m;
                }
                
                for (wb_Service__c o:PsgrOption )
                {
                    o.Enable__c = false;
                    update o;
                }
            }
        }
        
    }
    
    
    public void GetPsgService(){
        
        //id gid = ServiceGroupOtn.selectedGroupID;
        if (ServiceGroupOtn.selectedGroupID <> '--New--')
            PSGService = new PassengerService(selectedServiceClassification,
                                              ServiceGroupOtn.selectedCountry,
                                              ServiceGroupOtn.selectedCurrency,
                                              ServiceGroupOtn.selectedInsuranceCompany,
                                              ServiceGroupOtn.selectedService,
                                              ServiceGroupOtn.selectedGroupID
                                             );
        else {
            ServiceGroupOtn.MyStatus='--New--';
            if (PSGService.PsgrMain <> null && PSGService.PsgrGroup <> null){
                if (PSGService.PsgrOption == null )
                PSGService.PsgrOption = new list<wb_Service__c>();
            }
            /*
            PSGService = new PassengerService(selectedServiceClassification,
                                              ServiceGroupOtn.selectedCountry,
                                              ServiceGroupOtn.selectedCurrency,
                                              ServiceGroupOtn.selectedInsuranceCompany,
                                              ServiceGroupOtn.selectedService); */
        }
        
    }
    
    
    
    
    public SelectOption[] getServiceClassificationOptions() {  
        List<SelectOption>  opt = new  List<SelectOption>();
        opt.add(new SelectOption('','--None--')); 
        for (AggregateResult l : [ SELECT ServiceClassification__c, count(id)
                                  FROM wb_Service__c
                                  where ServiceClassification__c <> null
                                  group by ServiceClassification__c	]) {  
                                      opt.add(new SelectOption(String.valueOf(l.get('ServiceClassification__c')), 
                                                               String.valueOf(l.get('ServiceClassification__c')) ));  
                                  }                           
        return opt;  
    }
    
    public void fetchServiceGroupOtn(){
        if (selectedServiceClassification=='搭乗')
            ServiceGroupOtn = new ServiceGroup(selectedServiceClassification);
        
        if (selectedServiceClassification=='BL')
            BL = new BLService();
		
    }
    
    
    
    public PageReference AddNewOption(){
        return null;
    }
    
    public wb_Service(ApexPages.StandardController stdController){
        
        this.stdController = stdController;
        wb_Service__c theService = (wb_Service__c) stdController.getRecord();
        
        ServiceClassificationOptions = getServiceClassificationOptions();
        
        
        
    }
    
    public PageReference Cancel(){
        
        PageReference returnPage = new PageReference(ApexPages.currentPage().getParameters().get('retURL'));
        return returnPage;
        
    }
    
}