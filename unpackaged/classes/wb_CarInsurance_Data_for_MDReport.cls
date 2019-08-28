public class wb_CarInsurance_Data_for_MDReport {
    /*
wb_CarInsurance_Data_for_MDReport R = new wb_CarInsurance_Data_for_MDReport() ;
R.Fill_by_ContractCompanyID('001N000000Mn7N8IAJ');
System.debug(JSON.serializePretty(R.datalist));
*/
    ApexPages.StandardController Controller;
    
    Account theAccount;    
    
    public string myName {get;set;}
    
    public List<datarow> datalist  {get;set;}
    
    public class datarow {
        public string No {get;set;}
        public string ContractCompany {get;set;}
        public id CarInsurancedCarID {get;set;}
        public string UsingCompany {get;set;} //利用会社 wb_CarInsurancedCars__c.UsingCompany__c
        public string RegistryNumber {get;set;} //登録番号  wb_CarInsurancedCars__c.RegistryNumber__c
        public string LegalNumberofSeats {get;set;} //法定座席数 wb_CarInsurancedCars__c.LegalNumberofSeats__c
        public string Ownership {get;set;} //所有区分 	wb_CarInsurancedCars__c.Ownership__c
        
        public string Psgr_InsuranceCompany {get;set;} //(搭乗）保険会社名 wb_CIC_Passenger__c.Psgr_InsuranceCompany__c
        
        public string Psgr_InsurancePlan {get;set;} //(搭乗）保険プラン wb_CIC_Passenger__c.Psgr_InsurancePlan__c
        public string Psgr_CurrentEndDate {get;set;} //(搭乗）現保険終期 	wb_CIC_Passenger__c.Psgr_CurrentEndDate__c
        
        public string Psgr_CommodityName {get;set;} //（搭乗）商品名称 wb_CIC_Passenger__c.Psgr_CommodityName__c
        public string Psgr_InsuranceFee {get;set;} //（搭乗）保険料 wb_CIC_Passenger__c.Psgr_InsuranceFee__c
        public string OP_Plan {get;set;} //（OP）保険プラン wb_CIC_Passenger__c.OP_Plan__c
        public string OP_InsuranceFee {get;set;} //（OP）保険料 wb_CIC_Passenger__c.OP_InsuranceFee__c
        
        
        public string Vlt_InsuranceCompany {get;set;} //(任意）保険会社名 wb_CIC_Compulsory__c.Vlt_InsuranceCompany__c
        public string Vlt_EndDate {get;set;} //（任意）保険終期 wb_CIC_Compulsory__c.Vlt_EndDate__c
        public string Vlt_InsuranceAmount {get;set;} //（（任意）保険料 wb_CIC_Compulsory__c.Vlt_InsuranceAmount__c       
        public string Cps_InsuranceCompany {get;set;} //(強制）保険会社名 wb_CIC_Compulsory__c.Cps_InsuranceCompany
        public string Cps_EndDate {get;set;} //（強制）保険終期 wb_CIC_Compulsory__c.Cps_EndDate
        public string Cps_InsuranceAmount {get;set;} //（強制）保険料　wb_CIC_Compulsory__c.Cps_InsuranceAmount__c
        public string Agent {get;set;} //契約店 wb_CarInsurance__c.Agent__c
        public string AcctPIC {get;set;} //担当（計上） wb_CarInsurance__c.AcctPIC__c
        public string CICName {get;set;} //担当（計上） wb_CarInsurancedCars__c.Name
        
        datarow (Id cicid, string n, string CC, string UC, string RN, string LNS, string O, 
                 string CPSC, string CPSED, string VIC, string VED, string A,
                 string CpsInsuranceAmount, string VltInsuranceAmount,
                 string theAcctPIC,  string CICN
                ){
                    CarInsurancedCarID = cicid;
                    No = n;
                    ContractCompany =CC ;     
                    UsingCompany =UC;
                    RegistryNumber =RN;
                    LegalNumberofSeats=LNS;
                    Ownership = O;
                    Cps_InsuranceCompany=CPSC;
                    Cps_EndDate=CPSED;
                    Vlt_InsuranceCompany=VIC;
                    Vlt_EndDate=VED;
                    Agent=A;
                    Cps_InsuranceAmount = CpsInsuranceAmount;
                    Vlt_InsuranceAmount = Vlt_InsuranceAmount;
                    AcctPIC = theAcctPIC;
                    CICName = CICN;
                }
        
        
        datarow (Id cicid, string n, string CC, string UC, string RN, string LNS, string O, string 
                 PIP, string PED, string CPSC, string CPSED, string VIC, string VED, string A,
                 string PsgrInsuranceCompany, string CpsInsuranceAmount, string VltInsuranceAmount,
                 string theAcctPIC,  string CICN
                ){
                    CarInsurancedCarID = cicid;
                    No = n;
                    ContractCompany =CC ;     
                    UsingCompany =UC;
                    RegistryNumber =RN;
                    LegalNumberofSeats=LNS;
                    Ownership = O;
                    Psgr_InsurancePlan =PIP;
                    Psgr_CurrentEndDate=PED;
                    Cps_InsuranceCompany=CPSC;
                    Cps_EndDate=CPSED;
                    Vlt_InsuranceCompany=VIC;
                    Vlt_EndDate=VED;
                    Agent=A;
                    Psgr_InsuranceCompany= PsgrInsuranceCompany;
                    Cps_InsuranceAmount = CpsInsuranceAmount;
                    Vlt_InsuranceAmount = Vlt_InsuranceAmount;
                    AcctPIC = theAcctPIC;
                    CICName = CICN;
                }
        
        datarow (Id cicid, string n, string CC, string UC, string RN, string LNS, string O, string 
                 PIP, string PED,  string A,
                 string PsgrInsuranceCompany,
                 string theAcctPIC,
                 string PsgrCommodityName, string PsgrInsuranceFee, string OPPlan, string OPInsuranceFee,
                 string CICN
                ){
                    CarInsurancedCarID = cicid;
                    No = n;
                    ContractCompany =CC ;     
                    UsingCompany =UC;
                    RegistryNumber =RN;
                    LegalNumberofSeats=LNS;
                    Ownership = O;
                    Psgr_InsurancePlan =PIP;
                    Psgr_CurrentEndDate=PED;
                    Agent=A;
                    Psgr_InsuranceCompany= PsgrInsuranceCompany;
                    AcctPIC = theAcctPIC;
                    Psgr_CommodityName = PsgrCommodityName;
                    Psgr_InsuranceFee = PsgrInsuranceFee;
                    OP_Plan = OPPlan;
                    OP_InsuranceFee = OPInsuranceFee;
                    CICName = CICN;
                }
        
        
        datarow (Id cicid, string n, string CC, string UC, string RN, string LNS, string O, string 
                 PIP, string PED, string CPSC, string CPSED, string VIC, string VED, string A,
                 string PsgrInsuranceCompany, string CpsInsuranceAmount, string VltInsuranceAmount,
                 string theAcctPIC,
                 string PsgrCommodityName, string PsgrInsuranceFee, string OPPlan, string OPInsuranceFee,
                 string CICN
                ){
                    CarInsurancedCarID = cicid;
                    No = n;
                    ContractCompany =CC ;     
                    UsingCompany =UC;
                    RegistryNumber =RN;
                    LegalNumberofSeats=LNS;
                    Ownership = O;
                    Psgr_InsurancePlan =PIP;
                    Psgr_CurrentEndDate=PED;
                    Cps_InsuranceCompany=CPSC;
                    Cps_EndDate=CPSED;
                    Vlt_InsuranceCompany=VIC;
                    Vlt_EndDate=VED;
                    Agent=A;
                    Psgr_InsuranceCompany= PsgrInsuranceCompany;
                    Cps_InsuranceAmount = CpsInsuranceAmount;
                    Vlt_InsuranceAmount = Vlt_InsuranceAmount;
                    AcctPIC = theAcctPIC;
                    Psgr_CommodityName = PsgrCommodityName;
                    Psgr_InsuranceFee = PsgrInsuranceFee;
                    OP_Plan = OPPlan;
                    OP_InsuranceFee = OPInsuranceFee;
                    CICName = CICN;
                }
        
    }
    
    public wb_CarInsurance_Data_for_MDReport(ApexPages.StandardController stdController){
        this.Controller = stdController;
        theAccount = (Account) Controller.getRecord();
        Fill_by_ContractCompanyID( theAccount.id );
        
    }
    
    public wb_CarInsurance_Data_for_MDReport(){
        string  id = ApexPages.currentPage().getParameters().get('Id');
        Fill_by_ContractCompanyID(id);
    } 
    
    public void Fill_by_ContractCompanyID( id ContractCompID ){
        system.debug('ContractCompID:' + ContractCompID);
        datalist =  new List<datarow>();
        List<datarow> psgrlist = new List<datarow>();
        
        for ( wb_CIC_Passenger__c p:[select CarInsurancedCar__c, CarInsurancedCar__r.CarInsurance__r.ContractCompany__r.name,
                                     CarInsurancedCar__r.UsingCompany__r.name,
                                     CarInsurancedCar__r.RegistryNumber__c, 
                                     CarInsurancedCar__r.LegalNumberofSeats__c,
                                     CarInsurancedCar__r.Ownership__c, Psgr_InsuranceCompany__c, 
                                     Psgr_InsurancePlan__c, Psgr_CurrentEndDate__c,
                                     CarInsurancedCar__r.CarInsurance__r.Agent__c,
                                     CarInsurancedCar__r.CarInsurance__r.AcctPIC__c,
                                     Psgr_CommodityName__c, Psgr_InsuranceFee__c, OP_Plan__c, OP_InsuranceFee__c, CarInsurancedCar__r.name
                                     from wb_CIC_Passenger__c 
                                     where 	CarInsurancedCar__r.CarInsurance__r.ContractCompany__c =:ContractCompID 
                                     and CarInsurancedCar__r.CarInsurance__r.Status__c='確定' 
                                     and Psgr_CurrentEndDate__c > today
                                     and ( Psgr_CancelDate__c = null or Psgr_CancelDate__c > today )
                                     order by CarInsurancedCar__r.RegistryNumber__c, CarInsurancedCar__c]){
                                         
                                         psgrlist.add( new datarow( p.CarInsurancedCar__c,
                                                                   '1', 
                                                                   p.CarInsurancedCar__r.CarInsurance__r.ContractCompany__r.name,
                                                                   p.CarInsurancedCar__r.UsingCompany__r.name,
                                                                   p.CarInsurancedCar__r.RegistryNumber__c,
                                                                   string.valueof(p.CarInsurancedCar__r.LegalNumberofSeats__c),
                                                                   p.CarInsurancedCar__r.Ownership__c,
                                                                   p.Psgr_InsurancePlan__c,
                                                                   string.valueof(p.Psgr_CurrentEndDate__c),
                                                                   p.CarInsurancedCar__r.CarInsurance__r.Agent__c,
                                                                   p.Psgr_InsuranceCompany__c,
                                                                   p.CarInsurancedCar__r.CarInsurance__r.AcctPIC__c ,
                                                                   p.Psgr_CommodityName__c,       
                                                                   string.valueOf(p.Psgr_InsuranceFee__c),        
                                                                   p.OP_Plan__c,       
                                                                   string.valueOf(p.OP_InsuranceFee__c),
                                                                   p.CarInsurancedCar__r.name
                                                                  ) );
                                     }
        
        List<datarow> cpslist = new List<datarow>();
        
        for ( wb_CIC_Compulsory__c c:[select CarInsurancedCar__c, CarInsurancedCar__r.CarInsurance__r.ContractCompany__r.name,
                                      CarInsurancedCar__r.UsingCompany__r.name,
                                      CarInsurancedCar__r.RegistryNumber__c, 
                                      CarInsurancedCar__r.LegalNumberofSeats__c,
                                      CarInsurancedCar__r.Ownership__c, Vlt_InsuranceCompany__c, Vlt_EndDate__c,
                                      Cps_InsuranceCompany__c,Cps_CurrentEndDate__c, Cps_InsuranceAmount__c, Vlt_InsuranceAmount__c,
                                      CarInsurancedCar__r.CarInsurance__r.Agent__c,
                                      CarInsurancedCar__r.CarInsurance__r.AcctPIC__c,
                                      CarInsurancedCar__r.name
                                      from wb_CIC_Compulsory__c 
                                      where 	CarInsurancedCar__r.CarInsurance__r.ContractCompany__c =:ContractCompID 
                                      and CarInsurancedCar__r.CarInsurance__r.Status__c='確定' 
                                      and Vlt_EndDate__c > today
                                      and ( Vlt_CancelDate__c = null or Vlt_CancelDate__c > today )
                                      order by CarInsurancedCar__r.RegistryNumber__c, CarInsurancedCar__c]) {
                                          cpslist.add( new datarow( c.CarInsurancedCar__c,
                                                                   '1', 
                                                                   c.CarInsurancedCar__r.CarInsurance__r.ContractCompany__r.name,
                                                                   c.CarInsurancedCar__r.UsingCompany__r.name,
                                                                   c.CarInsurancedCar__r.RegistryNumber__c,
                                                                   string.valueof(c.CarInsurancedCar__r.LegalNumberofSeats__c),
                                                                   c.CarInsurancedCar__r.Ownership__c,
                                                                   c.Cps_InsuranceCompany__c,
                                                                   string.valueof(c.Cps_CurrentEndDate__c),
                                                                   c.Vlt_InsuranceCompany__c,
                                                                   string.valueof(c.Vlt_EndDate__c),
                                                                   c.CarInsurancedCar__r.CarInsurance__r.Agent__c,
                                                                   string.valueof(c.Cps_InsuranceAmount__c),
                                                                   string.valueof(c.Vlt_InsuranceAmount__c),
                                                                   c.CarInsurancedCar__r.CarInsurance__r.AcctPIC__c,
                                                                   c.CarInsurancedCar__r.name
                                                                  ) );
                                          
                                      }
        
        integer i, j;
        j = 0;
        
        system.debug('i j size :' + psgrlist.size() + ' ' + cpslist.size());
        
        for ( i = 0; i < psgrlist.size();  )
        {
            //  system.debug('i j :' + i + ' ' + j + ' ' + psgrlist[i].RegistryNumber + ' ' +  cpslist[j].RegistryNumber );
            
            if ( j < cpslist.size() ) {
                if ( psgrlist[i].RegistryNumber > cpslist[j].RegistryNumber) {
                    // Add cpslist to the output
                    datalist.add(new datarow(cpslist[j].CarInsurancedCarID,
                                             cpslist[j].No,
                                             cpslist[j].ContractCompany,
                                             cpslist[j].UsingCompany,
                                             cpslist[j].RegistryNumber,
                                             cpslist[j].LegalNumberofSeats,
                                             cpslist[j].Ownership,
                                             cpslist[j].Cps_InsuranceCompany,
                                             cpslist[j].Cps_EndDate,
                                             cpslist[j].Vlt_InsuranceCompany,
                                             cpslist[j].Vlt_EndDate,
                                             cpslist[j].Agent,
                                             cpslist[j].Cps_InsuranceAmount,
                                             cpslist[j].Vlt_InsuranceAmount,
                                             cpslist[j].AcctPIC,
                                             cpslist[j].CICName
                                            ) );
                    j++;
                    
                    
                } else if ( psgrlist[i].RegistryNumber == cpslist[j].RegistryNumber) {

                        // Merge psgrlist and cpslist
                        datalist.add(new datarow(psgrlist[i].CarInsurancedCarID,
                                                 psgrlist[i].No,
                                                 psgrlist[i].ContractCompany,
                                                 psgrlist[i].UsingCompany,
                                                 psgrlist[i].RegistryNumber,
                                                 psgrlist[i].LegalNumberofSeats,
                                                 psgrlist[i].Ownership,
                                                 psgrlist[i].Psgr_InsurancePlan,
                                                 psgrlist[i].Psgr_CurrentEndDate,
                                                 cpslist[j].Cps_InsuranceCompany,
                                                 cpslist[j].Cps_EndDate,
                                                 cpslist[j].Vlt_InsuranceCompany,
                                                 cpslist[j].Vlt_EndDate,
                                                 psgrlist[i].Agent,
                                                 psgrlist[i].Psgr_InsuranceCompany,
                                                 cpslist[j].Cps_InsuranceAmount,
                                                 cpslist[j].Vlt_InsuranceAmount,
                                                 cpslist[j].AcctPIC,
                                                 psgrlist[i].Psgr_CommodityName,
                                                 psgrlist[i].Psgr_InsuranceFee,
                                                 psgrlist[i].OP_Plan,
                                                 psgrlist[i].OP_InsuranceFee,
                                                 cpslist[j].CICName
                                                ) );
                        i++;
                        j++;
             
                } else if ( psgrlist[i].RegistryNumber < cpslist[j].RegistryNumber) {
                    datalist.add(new datarow( psgrlist[i].CarInsurancedCarID,
                                                 psgrlist[i].No,
                                                 psgrlist[i].ContractCompany,
                                                 psgrlist[i].UsingCompany,
                                                 psgrlist[i].RegistryNumber,
                                                 psgrlist[i].LegalNumberofSeats,
                                                 psgrlist[i].Ownership,
                                                 psgrlist[i].Psgr_InsurancePlan,
                                                 psgrlist[i].Psgr_CurrentEndDate,
                                                 psgrlist[i].Agent,
                                                 psgrlist[i].Psgr_InsuranceCompany,
                                                 psgrlist[i].AcctPIC,
                                                 psgrlist[i].Psgr_CommodityName,
                                                 psgrlist[i].Psgr_InsuranceFee,
                                                 psgrlist[i].OP_Plan,
                                                 psgrlist[i].OP_InsuranceFee,
                                                   psgrlist[i].CICName
                                                )  );
                    i++;
                }
            } else {
                datalist.add(new datarow( psgrlist[i].CarInsurancedCarID,
                                                 psgrlist[i].No,
                                                 psgrlist[i].ContractCompany,
                                                 psgrlist[i].UsingCompany,
                                                 psgrlist[i].RegistryNumber,
                                                 psgrlist[i].LegalNumberofSeats,
                                                 psgrlist[i].Ownership,
                                                 psgrlist[i].Psgr_InsurancePlan,
                                                 psgrlist[i].Psgr_CurrentEndDate,
                                                 psgrlist[i].Agent,
                                                 psgrlist[i].Psgr_InsuranceCompany,
                                                 psgrlist[i].AcctPIC,
                                                 psgrlist[i].Psgr_CommodityName,
                                                 psgrlist[i].Psgr_InsuranceFee,
                                                 psgrlist[i].OP_Plan,
                                                 psgrlist[i].OP_InsuranceFee,
                                                   psgrlist[i].CICName
                                                ) );
                i++;
            }
            
            system.debug('i j :' + i + ' ' + j + ' ' );
        }
        
        
        
    }
    
  
    
}