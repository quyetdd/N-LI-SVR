public class wb_Ichiroheian_to_CarInsurance {
    ApexPages.StandardController stdController;
    public Account theCompany  {get;set;}
    
    public String selectedValue { get; set; }  
    public Ichiroheian__c FromDate { get; set; }
    public Ichiroheian__c ToDate { get; set; }
    
    public List<Ichiroheian__c> theIchiroheian {get;set;}
    
    public List<aSelectiveRow> theIchiroheianRows { get; set; }
    public class aSelectiveRow {
        public Boolean isSelected { get; set; }
        public string isDone { get; set; }
        public Ichiroheian__c theIchiroheian { get; set; }
        public aSelectiveRow(Boolean b, Ichiroheian__c theRow) {
            theIchiroheian = theRow;
            isSelected = b;
        }
    }
    
    public List<wb_Vehicle__c> theCars {get;set;}
    public wb_CarInsurance__c theHeader {get;set;}
    public List<wb_CarInsurancedCars__c> theDetail {get;set;} 
    public List<wb_CIC_Passenger__c> thePsgr {get;set;} 
    public List<wb_CIC_Compulsory__c> theCps {get;set;} 

    
    
    public CarInsurance theCarInsurance {get;set;}
    
    public class CarInsurance {
        public wb_CarInsurance__c Header  { get; set; }
        public List<CarInsuranceDetail> Detail  { get; set; }
        
        public CarInsurance(wb_CarInsurance__c h){
            Header = h;
            Detail = new List<CarInsuranceDetail>();
        }
    }
        
    public class CarInsuranceDetail {
        public wb_Vehicle__c theCar { get; set; }
        public wb_CarInsurancedCars__c theRow { get; set; }
        public List<wb_CI_PassangerRow> PRowBatch { get; set; }
        public List<wb_CI_CompulsoryRow> CRowBatch { get; set; }
        public CarInsuranceDetail(wb_CarInsurancedCars__c row){
            theRow = row;
        }
        /*
        public CarInsuranceDetail(wb_Vehicle__c car, 
                                  string Psgr_InsuranceCompany,
                                  string Psgr_CommodityName, 
                                  string Psgr_InsurancePlan,
                                  date Psgr_InitialStartDate,
                                  date Psgr_CurrentStartDate,
                                  date 	Psgr_CurrentEndDate,
                                  string OP_CommodityName,
                                  string OP_Plan,
                                  date OP_InitialStartDate,
                                  date OP_CurrentStartDate,
                                  date OP_CurrentEndDate
                                 ){
                                
                                     theRow = new wb_CarInsurancedCars__c ( RegistryNumber__c = car.name, UsingCompany__c = car.UsingCompany__c, FrameNo__c = car.FrameNo__c,
                                                                        Model__c = car.Model__c, Ownership__c = car.Ownership__c, 
                                                                        LegalNumberofSeats__c = Car.LegalNumberofSeats__c, EngineNo__c	= car.EngineNumber__c );
                                     if ( Car.id != null)
                                         theRow.Car__c = Car.id;
                                     
       
                                 } */
        
        public CarInsuranceDetail( string Country,
                                  string CommissionCurrency,
                                  wb_Vehicle__c car,
                                  wb_CarInsurancedCars__c row, 
                                  wb_CIC_Passenger__c p){
                                      theCar=Car;
                                      theRow = Row;
                                      PRowBatch = new List<wb_CI_PassangerRow>();
                                      PRowBatch.add(new wb_CI_PassangerRow(p));
                                      PRowBatch[0].theCountry = Country;
                                      PRowBatch[0].theCommissionCurrency =CommissionCurrency;
                                      PRowBatch[0].theLegalNumberofSeats = Integer.valueOf( Row.LegalNumberofSeats__c);
                                      PRowBatch[0].FeeCalculatedbyDay = false;
                                      
                                  }
        
        
        public CarInsuranceDetail( string Country,
                                  string CommissionCurrency,
                                  wb_Vehicle__c car,
                                  wb_CarInsurancedCars__c row, 
                          
                                  wb_CIC_Compulsory__c c

                                 ){
                                     
                                     theCar=Car;
                                     theRow = Row;
                                      
                                     CRowBatch = new List<wb_CI_CompulsoryRow>();
             
                                     CRowBatch.add( new wb_CI_CompulsoryRow (c));
                                     CRowBatch[0].theCountry = Country;         
                                     CRowBatch[0].theCommissionCurrency = CommissionCurrency;       
                                     CRowBatch[0].theLegalNumberofSeats = Integer.valueOf( Row.LegalNumberofSeats__c);
                                     
                                 }
    }
    
    
    public wb_Ichiroheian_to_CarInsurance(ApexPages.StandardController stdController){
        this.stdController = stdController;
        theCompany = (Account) this.stdController.getRecord();
        theCompany = [select id, name from account where id =:theCompany.id];
        
        FromDate = new Ichiroheian__c();
        ToDate = new Ichiroheian__c();
        
        selectedValue = '1';
        theIchiroheian = new List<Ichiroheian__c>();          

        theIchiroheianRows = new  List<aSelectiveRow>();
        for ( Ichiroheian__c i:theIchiroheian){
            theIchiroheianRows.add( new aSelectiveRow (false, i) );
        }
        
        
    }
    
    public void GetIchiroheian(){
        theIchiroheian = new List<Ichiroheian__c>();    
       // system.debug(selectedValue);
        
        String SOQL, WhereS;
        date df, dt;
        
        df =  FromDate.InsuranceShuki__c;
        dt = ToDate.InsuranceShuki__c;
        
        WhereS = ' KeiyakuCompanyName__c =\'' +theCompany.id + '\'  ' ;
        
        if ( selectedValue == '1'){
            
            
            if ( df != null )
                WhereS += ' and InsuranceShuki__c >=' + DateTime.newInstance(df.year(),df.month(),df.day()).format('yyyy-MM-dd') ;
            if ( dt != null)
                WhereS += ' and  InsuranceShuki__c <=' + DateTime.newInstance(dt.year(),dt.month(),dt.day()).format('yyyy-MM-dd') ;
            	WhereS+= ' and CancelDate__c = null ';
        }
        
        if ( selectedValue == '2'){
            if (  df != null &&  dt != null ) {
                WhereS += ' and (( VI_InsuranceShuki__c >=' 
                    + DateTime.newInstance(df.year(),df.month(),df.day()).format('yyyy-MM-dd') + ' and  VI_InsuranceShuki__c <=' 
                    + DateTime.newInstance(dt.year(),dt.month(),dt.day()).format('yyyy-MM-dd') +' and VI_InsuranceCancel__c=null )' ;
                WhereS += ' OR ( OI_InsuranceShuki__c >=' + DateTime.newInstance(df.year(),df.month(),df.day()).format('yyyy-MM-dd') 
                    + ' and  OI_InsuranceShuki__c <=' + DateTime.newInstance(dt.year(),dt.month(),dt.day()).format('yyyy-MM-dd') +' and OI_InsuranceCancel__c = null ) )';
            } else if (  df != null ) {
                WhereS += ' and (( VI_InsuranceShuki__c >=' + DateTime.newInstance(df.year(),df.month(),df.day()).format('yyyy-MM-dd')  +' and VI_InsuranceCancel__c=null )' ;
                WhereS += ' OR ( OI_InsuranceShuki__c >=' + DateTime.newInstance(df.year(),df.month(),df.day()).format('yyyy-MM-dd') + +' and OI_InsuranceCancel__c=null ) )';
            } else if (dt != null ){
                WhereS += ' and ((   VI_InsuranceShuki__c <=' + DateTime.newInstance(dt.year(),dt.month(),dt.day()).format('yyyy-MM-dd') +' and VI_InsuranceCancel__c=null )' ;
                WhereS += ' OR (   OI_InsuranceShuki__c <=' + DateTime.newInstance(dt.year(),dt.month(),dt.day()).format('yyyy-MM-dd') +' and OI_InsuranceCancel__c=null ) )';
            }
        }
        
        SOQL = ' SELECT Id, Name, CarModel__c, OwnerKubun__c, Seat__c,EngineNo__c, CarNo__c,ShiyoCompanyName__c, KeiyakuCompanyName__c, ShiyoCompanyName__r.name, ';
        SOQL += 'IchiroHeianNo__c, WOInsuranceCompany__c, ';
        SOQL += 'WOCommodityName__c, InsurancePlan__c, InsuranceShiki__c, PresentInsuranceShiki__c, InsuranceShuki__c, '; 
        SOQL += 'WOCommodityNameAlpha__c, WOInsurancePlanAlpha__c, WOInsuranceShikiAlpha__c, WOPresentInsuranceShikiAlpha__c, WOInsuranceShukiAlpha__c, ';
        SOQL +='KeiyakuCountry__c,WOAgency__c,OI_CompanyName__c, OI_InsuranceShiki__c, OI_InsuranceShuki__c, VI_CompanyName__c, VI_InsuranceShiki__c, VI_InsuranceShuki__c ';
        SOQL +='FROM Ichiroheian__c';
        SOQL += ' where Name != null and IchiroHeianNo__c != null and ( ' +WhereS  + ' ) order by WOCommodityName__c, Name ';
        
        system.debug(SOQL); 
        
        
        theIchiroheian = database.query(SOQL);     
        theIchiroheianRows = new  List<aSelectiveRow>();
        
        WhereS = '';
        
        for ( Ichiroheian__c i:theIchiroheian){
            theIchiroheianRows.add( new aSelectiveRow (false, i) );
            if ( WhereS != '') 
                WhereS += ' OR ';
            WhereS +=  ' Pattern__c like \'%' + i.IchiroHeianNo__c + '%\'';
        }
       
        
        if ( theIchiroheian.size() > 0 ) {
            SOQL = ' SELECT name, Pattern__c from wb_CarInsurancedCars__c where CarInsurance__r.ContractCompany__c =\'' +theCompany.id + '\'  ' ;
            SOQL += ' AND ( ' + WhereS + ' ) ';
            List<wb_CarInsurancedCars__c> AlreadyDone = database.query(SOQL);   
            system.debug( SOQL);
            if ( AlreadyDone.size() > 0) {
                for ( wb_CarInsurancedCars__c a:AlreadyDone){
                    for ( aSelectiveRow i :theIchiroheianRows){
            
                        string Pattern = a.Pattern__c;
                        if ( i.theIchiroheian.IchiroHeianNo__c != null ) {
                            if ( Pattern.indexOf( String.valueof(i.theIchiroheian.IchiroHeianNo__c)) > 0 ) {
                                
                                if ( i.isDone == null)
                                    i.isDone = a.name;
                                else 
                                    i.isDone += a.name;
                                
                            }
                        }
                        
                    }
                }
            }
            
        }
        
     //   system.debug(theIchiroheian.size());
        //  List<wb_Vehicle__c> RegisteredCars = database.query(SOQL);      
    }
    
    public void IchiroheianSelectAll(){
      for (aSelectiveRow r: theIchiroheianRows)    
          r.isSelected = true;
        
        IchiroheianSelectedSummary();
    }

    public GroupnCount theSelectedSummary{ get; set; }
    
    public  class element{
        public string theString { get; set; }
        public integer theCount { get; set; }
        
        element(string s){
            theString = s;
            theCount=1;
        }
    }
    
    public class GroupnCount {
        
        public List<element> Rows  { get; set; }
        
        public GroupnCount(){
            Rows = new List<element>();
        }
        
        public void AddtoGroupingList(string s){
            
            integer i;
            
            for ( i =0; i < Rows.size();i++){
                if ( Rows[i].theString == s){
                    Rows[i].theCount ++;
                    i= Rows.size();
                }
                
                if ( i != Rows.size() ){
                    if ( Rows[i].theString > s ) {
                        Rows.add(i, new element( s) );
                    }
                }
            }
            
            if (Rows.size() == 0)
                Rows.add(new element( s) );
            
            if ( i == Rows.size()  && Rows[i-1].theString < s )
                 Rows.add(new element( s) );
        }
    }
    
    public void IchiroheianSelectedSummary(){
        theSelectedSummary = new GroupnCount();
        
        for (aSelectiveRow r: theIchiroheianRows) {
            if ( r.isSelected == true) {
               //   system.debug(selectedValue + ' ' + r.theIchiroheian.InsuranceShuki__c);
                if ( selectedValue == '1') {
                    date InsuranceShuki = r.theIchiroheian.InsuranceShuki__c;
                    theSelectedSummary.AddtoGroupingList(string.valueof(InsuranceShuki));
                }
            }
        }
     //   system.debug(theSelectedSummary.Rows.size());
    }
    
    public void Convert_to_New(){
        
        String SOQL, WhereS;
        
        WhereS='';
        
        for ( aSelectiveRow r:theIchiroheianRows){
            if (r.isSelected == true && r.theIchiroheian.ShiyoCompanyName__c != null){
                if ( WhereS !='') 
                    whereS += ' OR ';
                whereS += ' ( Name =\'' + r.theIchiroheian.Name + '\' and UsingCompany__c = \'' +  r.theIchiroheian.ShiyoCompanyName__c + '\') '  ;
            } 
        }
        
        SOQL = ' SELECT id, Name, UsingCompany__c, FrameNo__c, Model__c, Ownership__c, LegalNumberofSeats__c, EngineNumber__c FROM wb_Vehicle__c where Name != null and ( ' +WhereS  + ' ) ';
        
        system.debug(SOQL);
        List<wb_Vehicle__c> RegisteredCars = database.query(SOQL);      
        
        theCars =  new List<wb_Vehicle__c>();
        
        theHeader = new wb_CarInsurance__c ( ContractCompany__c = theCompany.id , Status__c ='未確定', 
                                                                 
                                                                   ContractDate__c = system.today());
            
        theCarInsurance = new CarInsurance(theHeader);
        
        theDetail = new List<wb_CarInsurancedCars__c>();
        thePsgr = new list<wb_CIC_Passenger__c>();
        theCps = new List<wb_CIC_Compulsory__c>();
        
         wb_Vehicle__c Car;
        wb_CarInsurancedCars__c CIC;
                
        // Loop for the Selected Row
        for ( aSelectiveRow r:theIchiroheianRows){
            if (r.isSelected == true ){
                boolean found=false;
                if ( theCarInsurance.Header.ContractCountry__c == null) {
                    theCarInsurance.Header.ContractCountry__c = r.theIchiroheian.KeiyakuCountry__c;
                    AggregateResult AgR =[ SELECT Currency__c, Country__c, ServiceClassification__c, count(ID)
                                            FROM wb_Service__c
                                            where ServiceClassification__c ='搭乗' and Country__c !=null and enable__c = true and Country__c =:theCarInsurance.Header.ContractCountry__c 
                                            group by Currency__c, Country__c, ServiceClassification__c
                                            order by count(ID) desc limit 1 ];
                    theCarInsurance.Header.CommissionCurrency__c = String.valueOf(AgR.get('Currency__c'));
                    
                }
                if ( theCarInsurance.Header.Agent__c == null)
                    theCarInsurance.Header.Agent__c = r.theIchiroheian.WOAgency__c;
                
                // Check if the Car is in system
                for (integer rci = 0; rci < RegisteredCars.size() ; rci ++){
                    if ( RegisteredCars[rci].Name == r.theIchiroheian.Name ){
                        found = true;
                        
                        Car = RegisteredCars[rci];
                        
                        theCars.add( Car);
                        
                         CIC = new wb_CarInsurancedCars__c ( RegistryNumber__c = Car.name, UsingCompany__c = Car.UsingCompany__c, 
                                                                                   FrameNo__c = Car.FrameNo__c,
                                                                                   Model__c = Car.Model__c, Ownership__c = Car.Ownership__c, 
                                                                                   LegalNumberofSeats__c = Car.LegalNumberofSeats__c, EngineNo__c= Car.EngineNumber__c,
                                                                                   Pattern__c='継続' +';' + r.theIchiroheian.IchiroHeianNo__c);
                        system.debug( 'Add Car to Detail' +  Car.name ); 
                        theDetail.add(CIC);
                        /* 
                        theCarInsurance.Detail.add( 
                            new CarInsuranceDetail( RegisteredCars[rci],
                                                   r.theIchiroheian.WOInsuranceCompany__c,
                                                   r.theIchiroheian.WOCommodityName__c, r.theIchiroheian.InsurancePlan__c,
                                                   r.theIchiroheian.InsuranceShiki__c, r.theIchiroheian.PresentInsuranceShiki__c, r.theIchiroheian.InsuranceShuki__c,
                                                   r.theIchiroheian.WOCommodityNameAlpha__c, r.theIchiroheian.WOInsurancePlanAlpha__c,
                                                   r.theIchiroheian.WOInsuranceShikiAlpha__c, r.theIchiroheian.WOPresentInsuranceShikiAlpha__c,r.theIchiroheian.WOInsuranceShukiAlpha__c) );
*/
                       // theCars.add( RegisteredCars[rci]);
                        rci =  RegisteredCars.size();
                    }
                }
                
                if ( found == false){
                    
                    Car =  new wb_Vehicle__c (Name=r.theIchiroheian.Name,
                                                               UsingCompany__c =r.theIchiroheian.ShiyoCompanyName__c,
                                                               FrameNo__c = r.theIchiroheian.CarNo__c,
                                                               Model__c=  r.theIchiroheian.CarModel__c,
                                                               Ownership__c = r.theIchiroheian.OwnerKubun__c,
                                                               LegalNumberofSeats__c= r.theIchiroheian.Seat__c,
                                                               EngineNumber__c= r.theIchiroheian.EngineNo__c
                                                              );
                     theCars.add( Car );
                     CIC = new wb_CarInsurancedCars__c ( RegistryNumber__c = Car.name, UsingCompany__c = Car.UsingCompany__c, FrameNo__c = Car.FrameNo__c,
                                                                               Model__c = Car.Model__c, Ownership__c = Car.Ownership__c, 
                                                                               LegalNumberofSeats__c = Car.LegalNumberofSeats__c, EngineNo__c	= Car.EngineNumber__c,
                                                                              Pattern__c='継続' +';' + r.theIchiroheian.IchiroHeianNo__c);
                    theDetail.add(CIC);
                    

                }
                
                date PresentInsuranceShiki;
                date InsuranceShuki = r.theIchiroheian.InsuranceShuki__c;
                if ( InsuranceShuki != null){
                    PresentInsuranceShiki = InsuranceShuki.addDays(1);
                    InsuranceShuki = InsuranceShuki.addYears(1);
                }
                
                date WOPresentInsuranceShikiAlpha;
                date WOInsuranceShukiAlpha = r.theIchiroheian.WOInsuranceShukiAlpha__c;
                if ( WOInsuranceShukiAlpha != null){
                    WOPresentInsuranceShikiAlpha = WOInsuranceShukiAlpha.addDays(1);
                    WOInsuranceShukiAlpha = WOInsuranceShukiAlpha.addYears(1);
                }
                
                
                if ( selectedValue == '1'){
                    wb_CIC_Passenger__c psgr = new wb_CIC_Passenger__c ( Psgr_InsuranceCompany__c =  r.theIchiroheian.WOInsuranceCompany__c,
                                                                        Psgr_CommodityName__c = r.theIchiroheian.WOCommodityName__c,   
                                                                        Psgr_InsurancePlan__c = r.theIchiroheian.InsurancePlan__c,
                                                                        Psgr_InitialStartDate__c = r.theIchiroheian.InsuranceShiki__c, 
                                                                        Psgr_CurrentStartDate__c = PresentInsuranceShiki,
                                                                        Psgr_CurrentEndDate__c = InsuranceShuki,
                                                                        OP_CommodityName__c =  r.theIchiroheian.WOCommodityNameAlpha__c,  
                                                                        OP_Plan__c = r.theIchiroheian.WOInsurancePlanAlpha__c,
                                                                        OP_InitialStartDate__c = r.theIchiroheian.WOInsuranceShikiAlpha__c, 
                                                                        OP_CurrentStartDate__c = WOPresentInsuranceShikiAlpha, 
                                                                        OP_CurrentEndDate__c = WOInsuranceShukiAlpha
                                                                       );
                    thePsgr.add(psgr);
                    theCarInsurance.Detail.add(  new CarInsuranceDetail( theCarInsurance.Header.ContractCountry__c,
                                                                        theCarInsurance.Header.CommissionCurrency__c,
                                                                        Car,
                                                                        CIC,
                                                                        psgr
                                                                       ));
                    
                    
                    
                }
                
                if ( selectedValue == '2'){
                    
                    date Cps_CurrentStartDate;
                    date Cps_CurrentEndDate = r.theIchiroheian.OI_InsuranceShuki__c;
                    if ( Cps_CurrentEndDate != null){
                        Cps_CurrentStartDate = Cps_CurrentEndDate.addDays(1);
                        Cps_CurrentEndDate = Cps_CurrentEndDate.addYears(1);
                    }
                    
                    date Vlt_StartDate;
                    date Vlt_EndDate = r.theIchiroheian.VI_InsuranceShuki__c;
                    
                    if ( Vlt_EndDate != null){
                        Vlt_StartDate = Vlt_EndDate.addDays(1);
                        Vlt_EndDate = Vlt_EndDate.addYears(1);
                    }
                        
                        wb_CIC_Compulsory__c cps= new wb_CIC_Compulsory__c (Cps_InsuranceCompany__c = r.theIchiroheian.OI_CompanyName__c, 
                                                                            Cps_CurrentStartDate__c = Cps_CurrentStartDate, 
                                                                            Cps_CurrentEndDate__c =Cps_CurrentEndDate,
                                                                            Vlt_InsuranceCompany__c =  r.theIchiroheian.VI_CompanyName__c, 
                                                                            Vlt_StartDate__c = Vlt_StartDate, 
                                                                            Vlt_EndDate__c = Vlt_EndDate
                                                                           );
                        theCps.add(cps);
                        
                        theCarInsurance.Detail.add(  new CarInsuranceDetail( theCarInsurance.Header.ContractCountry__c,
                                                                            theCarInsurance.Header.CommissionCurrency__c,
                                                                            Car,
                                                                            CIC,
                                                                            cps )
                                                  );
                        
                    }
                   
                
                
            }
        }
        
        
        List<wb_Service__c> PsgrService = [ SELECT  ServiceCompany__c, Service__c, Plan__c, MaxSeat__c, MinSeat__c, Currency__c, PassengerFee__c, DriverFee__c,
                                           DriverSeatInsurance__c,CommissionRate__c, group__r.maintype__c, ParentService__c, DataType__c, ParentService__r.Optiontype__c
                                           FROM wb_Service__c
                                           where  Country__c =:theCarInsurance.Header.ContractCountry__c  
                                           and ServiceClassification__c = '搭乗'  
                                           and Enable__c = true 
                                           order by ServiceCompany__c, Service__c, Plan__c, lastmodifieddate desc
                                          ];
        
        
        for ( CarInsuranceDetail d:theCarInsurance.Detail ) {
            if (d.PRowBatch != null) {
            d.PRowBatch[0].fetchPlanFeeOnlyOffLine( Integer.valueof( d.theCar.LegalNumberofSeats__c) , PsgrService);
            d.PRowBatch[0].fetchOPPlanFeeOffLine(PsgrService);
            }
        }
        
        List<wb_Service__c> CpsService =[SELECT Id, ServiceCompany__c, Currency__c,
                                         Cps_MedicalCost__c, Cps_AfterDeathImpediment__c, Cps_NoLbtAfterDeathMedicalCost__c, Cps_NoLbtAfterDeathImpediment__c, 
                                         Cps_NoLbtPropertyLoss__c, Cps_PropertyLoss__c, 
                                         CommissionRate__c, ContactNumber__c
                                         FROM wb_Service__c 
                                         where Country__c =:theCarInsurance.Header.ContractCountry__c  
                                         and ServiceClassification__c = '強制'  and Enable__c = true
                                         order by ServiceCompany__c ];
        
        for ( CarInsuranceDetail d:theCarInsurance.Detail ) {
            if ( d.CRowBatch != null ) {
                if ( d.CRowBatch[0].theCompulsory.Cps_InsuranceCompany__c != null)
                    d.CRowBatch[0].fetchComplusoryInsuranceFeeOffline(  CpsService);
            }
            
        }
        
        List<wb_Service__c> VltService = [SELECT Id, Currency__c, ServiceCompany__c, CommissionRate__c
                                          FROM wb_Service__c 
                                          where Country__c =:theCarInsurance.Header.ContractCountry__c  
                                          and ServiceClassification__c = '任意'  and Enable__c = true order by ServiceCompany__c];
        
        for ( CarInsuranceDetail d:theCarInsurance.Detail ) {
            if (d.CRowBatch != null ){ 
            if ( d.CRowBatch[0].theCompulsory.Vlt_InsuranceCompany__c != null)
                d.CRowBatch[0].fetchVoluntaryInsuranceFeeOffLine(  VltService);
            }
            
        }
        

        
    }
    
    public void fetchCarInfo(){
        for ( CarInsuranceDetail d:theCarInsurance.Detail){
            d.theRow.FrameNo__c = d.theCar.FrameNo__c;
            d.theRow.Model__c = d.theCar.Model__c;
            d.theRow.Ownership__c = d.theCar.Ownership__c;
            d.theRow.LegalNumberofSeats__c = d.theCar.LegalNumberofSeats__c;
            d.theRow.EngineNo__c	= d.theCar.EngineNumber__c;
        }
    }
    
    public void SaveConvertion(){
        upsert theCars;
        
        for ( CarInsuranceDetail d:theCarInsurance.Detail){
            if ( d.theRow.Car__c == null)
                d.theRow.Car__c = d.theCar.id;
        }
        

        upsert theHeader;
        
        theHeader = [select id, name, CommissionCurrency__c, AffiliationDistrict__c,
                     ContractDate__c, ContractDistrict__c, Agent__c, ContractCompany__c, Attribute__c,
                     Status__c
                     from wb_CarInsurance__c where id=: theHeader.id ];
        
        integer i = 1;
        for ( wb_CarInsurancedCars__c d:theDetail){
            d.CarInsurance__c = theHeader.id;
            d.Name =  theHeader.name +'-' + i;
            i ++;
        }
        upsert theDetail;
        
   
        for ( CarInsuranceDetail d:theCarInsurance.Detail){
            if ( d.PRowBatch != null) {
                //d.theRow.Car__c = d.theCar.id;
                i = 1;
                for ( wb_CI_PassangerRow pb: d.PRowBatch){
                    pb.thePassenger.CarInsurancedCar__c = d.theRow.id;
                    pb.thePassenger.name = d.theRow.name + i;
                    pb.thePassenger.Car__c = d.theCar.id;
                    i ++;
                }
            }
        }
        
        for ( CarInsuranceDetail d:theCarInsurance.Detail){
            if ( d.CRowBatch != null) {
                //d.theRow.Car__c = d.theCar.id;
                i = 1;
                for ( wb_CI_CompulsoryRow cb: d.CRowBatch){
                    cb.theCompulsory.CarInsurancedCar__c = d.theRow.id;
                     cb.theCompulsory.name = d.theRow.name + i;
                    cb.theCompulsory.Car__c = d.theCar.id;
                    i ++;
                }
            }
        }
       
        if ( thePsgr.size() > 0)
            upsert thePsgr;
        if ( theCps.size() > 0)
            upsert theCps;
        
        
      //      public List<wb_CIC_Passenger__c> thePsgr {get;set;} 
   // public List<wb_CIC_Compulsory__c> theCps {get;set;} 
        
    }
    /*
    public boolean NotExist( string name, string ShiyoCompanyName ){
        
        for (wb_Vehicle__c c:theCars ){
            system.debug( c.Name + ' ' + name + ' ' +c.UsingCompany__c + ' ' + ShiyoCompanyName );
            if ( c.Name == name && c.UsingCompany__c==ShiyoCompanyName  )
                return false;
        }
        return true;
    } */
    
}