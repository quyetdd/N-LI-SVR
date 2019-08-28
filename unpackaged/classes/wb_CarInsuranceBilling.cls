global with sharing class wb_CarInsuranceBilling {
    
    public List<BillingClass> BillingList;
    
    public class BillingClass{
        String ContractID {get; set;}
        Id ServiceID {get; set;}
  //      String Plan {get; set;}
 //       Decimal Amount {get; set;}
        Id ObjectId {get; set;}
 //       String ObjectName {get; set;}
        String Service {get; set;}
        Decimal ServiceAmount {get; set;}
        Decimal ServiceCommission {get; set;}
//        Id OptionID {get; set;}
        String Option {get; set;}
        Decimal OptionAmount {get; set;}
        Decimal OptionCommission {get; set;}
        Decimal TotalAmount {get; set;}
        //Decimal CommissionAmount {get; set;}
        
        public BillingClass(string c, 	Id objId,  string s, decimal sa, decimal scm,
                            string o, decimal oa, decimal ocm ){
                                this.ContractID =c;
                                this.ObjectId=objId;
                                // this.ServiceID = sid;
                                this.Service =s;
                                this.ServiceAmount =sa;
                                this.ServiceCommission = scm;
                                // this.OptionID = oid;
                                this.Option =o;
                                this.OptionAmount =oa;
                                 this.OptionCommission = ocm;
                                
                                if (sa == null)
                                    this.TotalAmount = oa;
                                else if ( oa == null )
                                    this.TotalAmount =sa;
                                else
                                    this.TotalAmount =sa +oa;
                            }
       
        public BillingClass(string c, 	Id objId,  string s, decimal sa,
                            string o, decimal oa ){
                                this.ContractID =c;
                                this.ObjectId=objId;
                                // this.ServiceID = sid;
                                this.Service =s;
                                this.ServiceAmount =sa;
                                // this.OptionID = oid;
                                this.Option =o;
                                this.OptionAmount =oa;
                                this.TotalAmount =sa +oa;
                            }

/*
        public BillingClass(string c,  string b, decimal p){
            this.ContractID =c;
            this.Service =b;
            this.ServiceAmount =p;            
            this.TotalAmount = p;
        }
*/        
        public BillingClass(string c,  string b, decimal p, decimal cm){
            this.ContractID =c;
            this.Service =b;
            this.ServiceAmount =p;            
            this.TotalAmount = p;
            this.ServiceCommission = cm;
        }

        
        public BillingClass(string c, Id ObjId, string b, decimal p){
            this.ContractID =c;
            this.ObjectId = ObjId;
            this.Service =b;
            this.ServiceAmount =p;            
            this.TotalAmount = p;
        } 
        
        public BillingClass(string c, Id ObjId, string b, decimal p, decimal cm){
            this.ContractID =c;
            this.ObjectId = ObjId;
            this.Service =b;
            this.ServiceAmount =p;            
            this.TotalAmount = p;
            this.ServiceCommission = cm;
        }
   
    }
    
    Webservice static string  Billing( ID c_id) {
        
        wb_CarInsurance__c 	carIns = [SELECT Status__c, ContractCountry__c, ContractDistrict__c, ContractCompany__c, CommissionCurrency__c, id 
                                      FROM wb_CarInsurance__c where id =:c_id]; 
        Date d;
        // Use the system date as billing date
        d = date.today();
        List<BillingClass> BillingList;
        
        
        BillingList = new List<BillingClass>();
        
        AggregateResult[] AgR = [SELECT CarInsurancedCar__r.CarInsurance__c, 
                                 CarInsurancedCar__c,
                                // CarInsurancedCar__r.Car__r.name,         
                                 Psgr_Service__c, 
                                 Psgr_CommodityName__c , Psgr_InsurancePlan__c, 
                                 OP_Service__c, OP_CommodityName__c ,OP_Plan__c, 
                                 sum(Psgr_InsuranceFee__c), sum(OP_InsuranceFee__c),
                                 sum(Psgr_Commission__c), sum(OP_Commission__c)
                                 FROM wb_CIC_Passenger__c
                                 where CarInsurancedCar__r.CarInsurance__c =:carIns.id
                                 group by CarInsurancedCar__r.CarInsurance__c, CarInsurancedCar__c, //CarInsurancedCar__r.Car__r.name,  
                                 Psgr_Service__c, Psgr_CommodityName__c,Psgr_InsurancePlan__c ,
                                 OP_Service__c, OP_CommodityName__c ,OP_Plan__c];
        
        for (AggregateResult SalesList : AgR) { 
            if (SalesList.get('OP_Service__c')!=null) {
                BillingList.add(new BillingClass(String.valueOf(SalesList.get('CarInsurance__c')),
                                                 (Id) (SalesList.get('CarInsurancedCar__c')),
                                                // (Id) (SalesList.get('Psgr_Service__c')),  
                                                 String.valueOf(SalesList.get('Psgr_CommodityName__c')) +
                                                 String.valueOf(SalesList.get('Psgr_InsurancePlan__c')) ,   
                                                 (Decimal) SalesList.get('expr0'),
                                                 (Decimal) SalesList.get('expr2'),
                                             //    (Id) (SalesList.get('OP_Service__c')),  
                                                 String.valueOf(SalesList.get('OP_CommodityName__c')) +
                                                 String.valueOf(SalesList.get('OP_Plan__c')) ,   
                                                 (Decimal) SalesList.get('expr1'),
                                                 (Decimal) SalesList.get('expr3')
                                                ));
                
            }        
            else   {
                BillingList.add(new BillingClass(String.valueOf(SalesList.get('CarInsurance__c')),
                                                 (Id) (SalesList.get('CarInsurancedCar__c')),
                                              //   (Id) (SalesList.get('Psgr_Service__c')),  
                                                 String.valueOf(SalesList.get('Psgr_CommodityName__c')) +
                                                 String.valueOf(SalesList.get('Psgr_InsurancePlan__c')) ,   
                                                 (Decimal) SalesList.get('expr0'),
                                                 (Decimal) SalesList.get('expr2')
                                                ));
            }   
        }
        
        
        AgR = [SELECT CarInsurancedCar__r.CarInsurance__c, CarInsurancedCar__c,
               sum(Cps_InsuranceAmount__c), 
               sum(Cps_Commission__c)
               FROM wb_CIC_Compulsory__c
               where CarInsurancedCar__r.CarInsurance__c =:carIns.id
               //and Cps_Service__c <> null
               group by CarInsurancedCar__r.CarInsurance__c, CarInsurancedCar__c 
              having sum(Cps_InsuranceAmount__c) <> 0]; 
        for (AggregateResult SalesList : AgR) { 
            BillingList.add(new BillingClass(String.valueOf(SalesList.get('CarInsurance__c')),
                                             (Id) (SalesList.get('CarInsurancedCar__c')),  
                                             '強制' ,   
                                             (Decimal) SalesList.get('expr0'),
                                             (Decimal) SalesList.get('expr1')
                                            ));
        }
        
        AgR = [SELECT CarInsurancedCar__r.CarInsurance__c, CarInsurancedCar__c,
               sum(Vlt_InsuranceAmount__c),
               sum(Vlt_Commission__c)              
               FROM wb_CIC_Compulsory__c
               where CarInsurancedCar__r.CarInsurance__c =:carIns.id
              // and Vlt_Service__c <> null
               and  Vlt_InsuranceAmount__c != null 
               group by CarInsurancedCar__r.CarInsurance__c, CarInsurancedCar__c
              having sum(Vlt_InsuranceAmount__c) <> 0]; 
        for (AggregateResult SalesList : AgR) { 
            BillingList.add(new BillingClass(String.valueOf(SalesList.get('CarInsurance__c')),
                                             (Id) (SalesList.get('CarInsurancedCar__c')),
                                             '任意' ,   
                                             (Decimal) SalesList.get('expr0'),
                                             (Decimal) SalesList.get('expr1')
                                            ));
        }
        
        
        for ( wb_CarInsurancedCars__c Car:[select id from wb_CarInsurancedCars__c where CarInsurance__c =:carIns.id order by name ])
        {
            for (BillingClass BList : BillingList) { 
                if (BList.ObjectId == Car.id) {
                    wb_ReceivableServiceFee__c NewBilling = new wb_ReceivableServiceFee__c( Classification__c= '車保険',
                                                                                           Date__c=d, 
                                                                                           CarInsurance__c=carIns.id, 
                                                                                           CarInsurancedCar__c=BList.ObjectId,
                                                                                           Country__c = carIns.ContractCountry__c, 
                                                                                           District__c = carIns.ContractDistrict__c,
                                                                                           //  Service__c = BList.ServiceID,
                                                                                           ServiceName__c = BList.Service, 
                                                                                           Currency__c = carIns.CommissionCurrency__c,
                                                                                           ServiceAmount__c = BList.ServiceAmount,
                                                                                           ServiceCommission__c = BList.ServiceCommission,
                                                                                           //   Option__c = BList.OptionID,
                                                                                           OptionName__c = BList.Option,
                                                                                           OptionAmount__c = BList.OptionAmount,
                                                                                           OptionCommission__c = BList.OptionCommission,
                                                                                           TotalAmount__c = BList.TotalAmount,
                                                                                            
                                                                                           //ObjectName__c =  BList.ObjectName,
                                                                                           InvoicingCompany__c = carIns.ContractCompany__c
                                                                                          );   
                    
                    
                    try{
                        insert NewBilling;
                    } catch (System.QueryException e){
                        
                        System.debug(e);
                    }
                }
            }
        }
        
        
        carIns.Status__c = '確定';
        
        try{
            update carIns;
        } catch (System.QueryException e){
            System.debug(e);
        }
        
      
            return '契約の確定と売る上げ作成が完了';
      
    }
    
    
    public boolean  BillingAddtionCar( ID c_id) {
        wb_CarInsurancedCars__c car = [select id, CarInsurance__c 
                                       from wb_CarInsurancedCars__c where id =:c_id];
        
        wb_CarInsurance__c 	carIns = [SELECT Status__c, ContractCountry__c, ContractDistrict__c, ContractCompany__c, CommissionCurrency__c, id 
                                      FROM wb_CarInsurance__c where id =:car.CarInsurance__c]; 
        Date d;
        // Use the system date as billing date
        d = date.today();
        List<BillingClass> BillingList;
        
        
        BillingList = new List<BillingClass>();
        
        // Exchange Passanger
        AggregateResult[] AgR = [SELECT CarInsurancedCar__r.CarInsurance__c, 
                                 CarInsurancedCar__c,         
                                 Psgr_Service__c, 
                                 Psgr_CommodityName__c , Psgr_InsurancePlan__c, 
                                 OP_Service__c, OP_CommodityName__c ,OP_Plan__c,
                                 sum(f_PsgrBillingAmount__c) , 
                                 sum(f_OPBillingAmount__c),
                                 sum(Psgr_Commission__c),
								 sum(OP_Commission__c)                                 
                                 FROM wb_CIC_Passenger__c
                                 where CarInsurancedCar__c =:car.id
                                 and  Name  like '%e' // all car exchange record
                                 group by CarInsurancedCar__r.CarInsurance__c, CarInsurancedCar__c,  
                                 Psgr_Service__c, Psgr_CommodityName__c,Psgr_InsurancePlan__c ,
                                 OP_Service__c, OP_CommodityName__c ,OP_Plan__c
                                 having sum(f_PsgrBillingAmount__c) <> 0 
                                 or   sum(f_OPBillingAmount__c) <> 0
                                ];
        
        for (AggregateResult SalesList : AgR) { 
            if (SalesList.get('OP_Service__c')!=null) {
                BillingList.add(new BillingClass(String.valueOf(SalesList.get('CarInsurance__c')),
                                                  (Id) (SalesList.get('CarInsurancedCar__c')),
                                              
                                                 String.valueOf(SalesList.get('Psgr_CommodityName__c')) +
                                                 String.valueOf(SalesList.get('Psgr_InsurancePlan__c')) ,   
                                                 (Decimal) SalesList.get('expr0'),
                                              (Decimal) SalesList.get('expr2'),
                                                 String.valueOf(SalesList.get('OP_CommodityName__c')) +
                                                 String.valueOf(SalesList.get('OP_Plan__c')) ,   
                                                 (Decimal) SalesList.get('expr1'),
                                                   (Decimal) SalesList.get('expr3')
                                                ));
                
            }        
            else   {
                BillingList.add(new BillingClass(String.valueOf(SalesList.get('CarInsurance__c')),
                                                 (Id) (SalesList.get('CarInsurancedCar__c')),
                                                // (Id) (SalesList.get('Psgr_Service__c')),  
                                                 String.valueOf(SalesList.get('Psgr_CommodityName__c')) +
                                                 String.valueOf(SalesList.get('Psgr_InsurancePlan__c')) ,   
                                                 (Decimal) SalesList.get('expr0')
                                                ));
            }   
        }
        
        
        // Normal Passanger
         AgR = [SELECT CarInsurancedCar__r.CarInsurance__c, 
                                 CarInsurancedCar__c,         
                                 Psgr_Service__c, 
                                 Psgr_CommodityName__c , Psgr_InsurancePlan__c, 
                                 OP_Service__c, OP_CommodityName__c ,OP_Plan__c, 
                                 sum(Psgr_InsuranceFee__c), sum(OP_InsuranceFee__c),
                 				 sum(Psgr_Commission__c), sum(OP_Commission__c) 
                                 FROM wb_CIC_Passenger__c
                                 where CarInsurancedCar__c =:car.id
                                 and (not Name like '%e') // to skip all car exchange record
                                 group by CarInsurancedCar__r.CarInsurance__c, CarInsurancedCar__c,  
                                 Psgr_Service__c, Psgr_CommodityName__c,Psgr_InsurancePlan__c ,
                                 OP_Service__c, OP_CommodityName__c ,OP_Plan__c
                                 having sum(Psgr_InsuranceFee__c) <> 0 or  sum(OP_InsuranceFee__c) <> 0
                                ];
        
        for (AggregateResult SalesList : AgR) { 
            if (SalesList.get('OP_Service__c')!=null) {
                BillingList.add(new BillingClass(String.valueOf(SalesList.get('CarInsurance__c')),
                                                  (Id) (SalesList.get('CarInsurancedCar__c')),
                                              
                                                 String.valueOf(SalesList.get('Psgr_CommodityName__c')) +
                                                 String.valueOf(SalesList.get('Psgr_InsurancePlan__c')) ,   
                                                 (Decimal) SalesList.get('expr0'),
                                              (Decimal) SalesList.get('expr2'),
                                                 String.valueOf(SalesList.get('OP_CommodityName__c')) +
                                                 String.valueOf(SalesList.get('OP_Plan__c')) ,   
                                                 (Decimal) SalesList.get('expr1'),
                                                 (Decimal) SalesList.get('expr3')
                                                ));
                
            }        
            else   {
                BillingList.add(new BillingClass(String.valueOf(SalesList.get('CarInsurance__c')),
                                                 (Id) (SalesList.get('CarInsurancedCar__c')),
                                                // (Id) (SalesList.get('Psgr_Service__c')),  
                                                 String.valueOf(SalesList.get('Psgr_CommodityName__c')) +
                                                 String.valueOf(SalesList.get('Psgr_InsurancePlan__c')) ,   
                                                 (Decimal) SalesList.get('expr0'),
                                                   (Decimal) SalesList.get('expr2')
                                                ));
            }   
        }
        
         // Compulsory
        AgR = [SELECT CarInsurancedCar__r.CarInsurance__c,CarInsurancedCar__c, 
               sum(Cps_InsuranceAmount__c), sum(Cps_Commission__c)
               FROM wb_CIC_Compulsory__c
              // where CarInsurancedCar__r.CarInsurance__c =:car.id
               where CarInsurancedCar__c =:car.id
               //and Cps_Service__c <> null
               group by CarInsurancedCar__r.CarInsurance__c, CarInsurancedCar__c
              having sum(Cps_InsuranceAmount__c) <> 0]; 
        for (AggregateResult SalesList : AgR) { 
            BillingList.add(new BillingClass(String.valueOf(SalesList.get('CarInsurance__c')),
                                             (Id) (SalesList.get('CarInsurancedCar__c')),  
                                             '強制' ,   
                                             (Decimal) SalesList.get('expr0'),
                                               (Decimal) SalesList.get('expr1')
                                            ));
        }
        //Voluntary
        AgR = [SELECT CarInsurancedCar__r.CarInsurance__c, CarInsurancedCar__c,
               sum(Vlt_InsuranceAmount__c),
               sum(Vlt_Commission__c)
               FROM wb_CIC_Compulsory__c
               where CarInsurancedCar__c =:car.id
               //and Vlt_Service__c <> null
               and  Vlt_InsuranceAmount__c != null 
               group by CarInsurancedCar__r.CarInsurance__c , CarInsurancedCar__c
              having sum(Vlt_InsuranceAmount__c) <> 0]; 
        for (AggregateResult SalesList : AgR) { 
            BillingList.add(new BillingClass(String.valueOf(SalesList.get('CarInsurance__c')),
                                              (Id) (SalesList.get('CarInsurancedCar__c')), 
                                             '任意' ,   
                                             (Decimal) SalesList.get('expr0'),
                                             (Decimal) SalesList.get('expr1')
                                            ));
        }
        
 
        for (BillingClass BList : BillingList) { 
            
            wb_ReceivableServiceFee__c NewBilling = new wb_ReceivableServiceFee__c( Classification__c= '車保険',
                                                                                   Date__c=d, 
                                                                                   CarInsurance__c=carIns.id, 
                                                                                   CarInsurancedCar__c=BList.ObjectId,
                                                                                   Country__c = carIns.ContractCountry__c, 
                                                                                   District__c = carIns.ContractDistrict__c,
                                                                                   Service__c = BList.ServiceID,
                                                                                   ServiceName__c = BList.Service, 
                                                                                   Currency__c = carIns.CommissionCurrency__c,
                                                                                   ServiceAmount__c = BList.ServiceAmount,
                                                                                    ServiceCommission__c = BList.ServiceCommission,
                                                                                   //Option__c = BList.OptionID,
                                                                                   OptionName__c = BList.Option,
                                                                                   OptionAmount__c = BList.OptionAmount,
                                                                                   OptionCommission__c = BList.OptionCommission,
                                                                                   TotalAmount__c = BList.TotalAmount,
                                                                                  
                                                                                   // =  BList.ObjectName,
                                                                                   InvoicingCompany__c = carIns.ContractCompany__c );   
            
            
            try{
                insert NewBilling;
            } catch (System.QueryException e){
                
                System.debug(e);
                return false;
            }
        }
        /*
        carIns.Status__c = '確定';
        
        try{
            update carIns;
        } catch (System.QueryException e){
            System.debug(e);
            return false;
        }*/
        
        return true;
    }
    
    Webservice static string  CancelBilling( ID c_id) {
        
        if ( [select id from wb_CarInsurancedCars__c where ( Name like '%r%' or Name like '%A%') and CarInsurance__r.id =:c_id].size() == 0 ) {
            
            wb_CarInsurance__c carIns = [SELECT  Status__c, ContractCountry__c, ContractDistrict__c, ContractCompany__c, CommissionCurrency__c, Id 
                                         FROM wb_CarInsurance__c where id =:c_id]; 
            Date d;
            // Use the system date as billing date
            d = date.today();
            List<BillingClass> BillingList;
            
            BillingList = new List<BillingClass>();
            
            AggregateResult[] AgR = [SELECT CarInsurancedCar__r.CarInsurance__c, 
                                     CarInsurancedCar__c ,    
                                     Psgr_Service__c, 
                                     Psgr_CommodityName__c , Psgr_InsurancePlan__c, 
                                     OP_Service__c, OP_CommodityName__c ,OP_Plan__c, 
                                     sum(Psgr_InsuranceFee__c), sum(OP_InsuranceFee__c) ,
                                     sum(Psgr_Commission__c), sum(OP_Commission__c) 
                                     FROM wb_CIC_Passenger__c
                                     where CarInsurancedCar__r.CarInsurance__c =:carIns.id
                                     group by CarInsurancedCar__r.CarInsurance__c, CarInsurancedCar__c,  
                                     Psgr_Service__c, Psgr_CommodityName__c,Psgr_InsurancePlan__c ,
                                     OP_Service__c, OP_CommodityName__c ,OP_Plan__c];
            
            
            
            for (AggregateResult SalesList : AgR) { 
                
                if (SalesList.get('OP_Service__c')!=null) {
                    BillingList.add(new BillingClass(String.valueOf(SalesList.get('CarInsurance__c')),
                                                     (Id) (SalesList.get('CarInsurancedCar__c')),
                                                     // (Id) (SalesList.get('Psgr_Service__c')),  
                                                     String.valueOf(SalesList.get('Psgr_CommodityName__c')) +
                                                     String.valueOf(SalesList.get('Psgr_InsurancePlan__c')) ,   
                                                     -(Decimal) SalesList.get('expr0'),
                                                     -(Decimal) SalesList.get('expr2'),
                                                     // (Id) (SalesList.get('OP_Service__c')),  
                                                     String.valueOf(SalesList.get('OP_CommodityName__c')) +
                                                     String.valueOf(SalesList.get('OP_Plan__c')) ,   
                                                     -(Decimal) SalesList.get('expr1'),
                                                     -(Decimal) SalesList.get('expr3')
                                                    ));
                    
                }        
                else   {
                    BillingList.add(new BillingClass(String.valueOf(SalesList.get('CarInsurance__c')),
                                                     (Id) (SalesList.get('CarInsurancedCar__c')),
                                                     //(Id) (SalesList.get('Psgr_Service__c')),  
                                                     String.valueOf(SalesList.get('Psgr_CommodityName__c')) +
                                                     String.valueOf(SalesList.get('Psgr_InsurancePlan__c')) ,   
                                                     -(Decimal) SalesList.get('expr0'),
                                                     -(Decimal) SalesList.get('expr2')
                                                    ));
                }   
            }
            
            
            AgR = [SELECT CarInsurancedCar__r.CarInsurance__c, CarInsurancedCar__c,
                   sum(Cps_InsuranceAmount__c),
                   sum(Cps_Commission__c)
                   FROM wb_CIC_Compulsory__c
                   where CarInsurancedCar__r.CarInsurance__c =:carIns.id
                   and Cps_Service__c <> null
                   group by CarInsurancedCar__r.CarInsurance__c, CarInsurancedCar__c ]; 
            for (AggregateResult SalesList : AgR) { 
                BillingList.add(new BillingClass(String.valueOf(SalesList.get('CarInsurance__c')),
                                                 (Id) (SalesList.get('CarInsurancedCar__c')),  
                                                 '強制' ,   
                                                 - (Decimal) SalesList.get('expr0'),
                                                 - (Decimal) SalesList.get('expr1')
                                                ));
            }
            
            AgR = [SELECT CarInsurancedCar__r.CarInsurance__c, CarInsurancedCar__c,
                   sum(Vlt_InsuranceAmount__c), sum(Vlt_Commission__c)
                   FROM wb_CIC_Compulsory__c
                   where CarInsurancedCar__r.CarInsurance__c =:carIns.id
                   and  Vlt_Service__c <> null and Vlt_InsuranceAmount__c <> null 
                   group by CarInsurancedCar__r.CarInsurance__c, CarInsurancedCar__c ]; 
            for (AggregateResult SalesList : AgR) { 
                BillingList.add(new BillingClass(String.valueOf(SalesList.get('CarInsurance__c')),
                                                 (Id) (SalesList.get('CarInsurancedCar__c')),  
                                                 '任意' ,   
                                                 - (Decimal) SalesList.get('expr0'),
                                                 - (Decimal) SalesList.get('expr1')
                                                ));
            }
            
            
            for ( wb_CarInsurancedCars__c Car:[select id from wb_CarInsurancedCars__c where CarInsurance__c =:carIns.id order by name ]) {  
                for (BillingClass BList : BillingList) { 
                    if (BList.ObjectId == Car.id) {
                        wb_ReceivableServiceFee__c NewBilling = new wb_ReceivableServiceFee__c( Classification__c= '車保険',
                                                                                               Date__c=d, 
                                                                                               CarInsurance__c=carIns.id, 
                                                                                               CarInsurancedCar__c=BList.ObjectId,
                                                                                               Country__c = carIns.ContractCountry__c, 
                                                                                               District__c = carIns.ContractDistrict__c,
                                                                                               // Service__c = BList.ServiceID,
                                                                                               ServiceName__c = BList.Service, 
                                                                                               Currency__c = carIns.CommissionCurrency__c,
                                                                                               ServiceAmount__c = BList.ServiceAmount,
                                                                                               ServiceCommission__c = BList.ServiceCommission,
                                                                                               //Option__c = BList.OptionID,
                                                                                               // OptionName__c = BList.Option,
                                                                                               OptionAmount__c = BList.OptionAmount,
                                                                                               OptionCommission__c = BList.OptionCommission,
                                                                                               TotalAmount__c = BList.TotalAmount,
                                                                                               
                                                                                               // =  BList.ObjectName,
                                                                                               InvoicingCompany__c = carIns.ContractCompany__c );   
                        
                        
                        
                        try{
                            insert NewBilling;
                        } catch (System.QueryException e){
                            
                            System.debug(e);
                        }
                    }
                }
            }
            
            carIns.Status__c = 'キャンセル';
            
            try{
                update carIns;
                
            } catch (System.QueryException e){
                System.debug(e);
            }
            
            return '契約のキャンセルが完了';
        } else
        {
            return '増車、入れ替えなどの契約をキャンセルできない';
        }
    }
    
}