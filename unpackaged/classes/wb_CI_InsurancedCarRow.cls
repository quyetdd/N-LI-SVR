global with sharing class  wb_CI_InsurancedCarRow {
    
    public Boolean IsSelected { get; set; }
    
    public Boolean IsAmendable { get; set; }
    public Boolean IsHavingPendingChildAction { get; set; }
    public Boolean IsPending { get; set; }
    public wb_CarInsurancedCars__c theCar { get; set; }
  //  public  List<wb_CIC_Passenger__c> thePassengers　{ get; set; }
  //  public  List<wb_CIC_Compulsory__c> theCIC_Compulsoris { get; set; }
      
    public string MyProduct { get; set; }

    public List<string> MyPsgrRow { get; set; }
 //   public string MyCpsProduct { get; set; }
    public List<string> MyCpsRow { get; set; }
    
    public integer f_EffectiveInsurance { get; set; }
    
    
    public wb_CI_InsurancedCarRow( wb_CarInsurancedCars__c car) {
        
        theCar = car;
        MyProduct='';
        f_EffectiveInsurance = 0;
        date td = date.today();
        
  
        // IsAmendable = CheckAmendable(Car.id);
        IsAmendable = true;

    }
    

    public wb_CI_InsurancedCarRow( wb_CarInsurancedCars__c car, List<wb_CIC_Passenger__c> Passengers, List<wb_CIC_Compulsory__c> CIC_Compulsoris) {
        
        theCar = car;
        MyProduct='';
  //      MyCpsProduct='';
        MyPsgrRow = new List<string>();
        MyCpsRow = new List<string>();
            
        f_EffectiveInsurance = 0;
        date td = date.today();
        
        datetime d;
        for(wb_CIC_Passenger__c p:Passengers)
        {
                        
            if (p.CarInsurancedCar__c == theCar.id ){
                
                if (p.Psgr_InsuranceCompany__c!= null) {
                    d = p.Psgr_CurrentEndDate__c;
                    if ( d != null) {
                        MyProduct += p.Psgr_InsuranceCompany__c + p.Psgr_CommodityName__c + p.Psgr_InsurancePlan__c + 
                        '(' +  String.valueof(d.year()) +'/'+ String.valueof(d.month()) +'/'+ String.valueof(d.day()) + ')' ;
                       
                        MyPsgrRow.add(p.Psgr_InsuranceCompany__c + p.Psgr_CommodityName__c + p.Psgr_InsurancePlan__c + 
                        '(' +  String.valueof(d.year()) +'/'+ String.valueof(d.month()) +'/'+ String.valueof(d.day()) + ')');
                    }
                    else {
                        if ( p.OP_CurrentEndDate__c!= null ) {
                            d = p.OP_CurrentEndDate__c;
                            MyProduct += p.OP_CommodityName__c +  p.OP_Plan__c
                                +'(' +  String.valueof(d.year()) +'/'+ String.valueof(d.month()) +'/'+ String.valueof(d.day()) + ')' ;
             
                            MyPsgrRow.add(p.OP_CommodityName__c +  p.OP_Plan__c
                                          +'(' +  String.valueof(d.year()) +'/'+ String.valueof(d.month()) +'/'+ String.valueof(d.day()) + ')');
                        }
                    }
                }
                MyProduct +=  '\n';
                        
                
                if ( //( p.Psgr_CurrentEndDate__c >=  td && ( p.Psgr_CancelDate__c == null || p.Psgr_CancelDate__c  >=  td)  ) ||
                     //( p.OP_CurrentEndDate__c >=  td && ( p.OP_CancelDate__c == null || p.OP_CancelDate__c  >=  td)  )
                     (p.Psgr_CurrentEndDate__c != null && p.Psgr_CancelDate__c == null) ||
                     (p.OP_CurrentEndDate__c  != null &&  p.OP_CancelDate__c == null)
                    )
                {
                    f_EffectiveInsurance ++;
                }
                
            }
        }
        
        for(wb_CIC_Compulsory__c c:CIC_Compulsoris)
        {
            
            if (c.CarInsurancedCar__c == theCar.id ){
                
                if (c.Cps_InsuranceCompany__c!= null) {
                    MyProduct += c.Cps_InsuranceCompany__c ;
      //              MyCpsProduct  += c.Cps_InsuranceCompany__c ;
                    if ( c.Cps_CurrentEndDate__c != null ) {
                        d =  c.Cps_CurrentEndDate__c;
                    MyCpsRow.add(c.Cps_InsuranceCompany__c   +'(' +  String.valueof(d.year()) +'/'+ String.valueof(d.month()) +'/'+ String.valueof(d.day()) + ')');
                    } else
                        MyCpsRow.add(c.Cps_InsuranceCompany__c  );
                }
                
                if (c.Vlt_InsuranceCompany__c!= null) {
                  
                    MyProduct += c.Vlt_InsuranceCompany__c ;
   //                 MyCpsProduct += c.Vlt_InsuranceCompany__c ;
                    
                    if ( c.Vlt_EndDate__c !=null){
                        d = c.Vlt_EndDate__c;
                          MyCpsRow.add(c.Vlt_InsuranceCompany__c   +'(' +  String.valueof(d.year()) +'/'+ String.valueof(d.month()) +'/'+ String.valueof(d.day()) + ')' );
                    } else
                        MyCpsRow.add(c.Vlt_InsuranceCompany__c);
                    
                 
                }
                MyProduct +=  '\n';
  //              MyCpsProduct += '\n';
            }
            
            if (// ( c.Cps_CurrentEndDate__c >=  td && ( c.Cps_CancelDate__c == null || c.Cps_CancelDate__c  >=  td)  )
                 c.Cps_CurrentEndDate__c != null && c.Cps_CancelDate__c == null  
               )
            {
                f_EffectiveInsurance ++;
            }
            
            if ( //( c.Vlt_EndDate__c >=  td && ( c.Vlt_CancelDate__c == null || c.Vlt_CancelDate__c  >=  td)  )
                c.Vlt_EndDate__c!= null && c.Vlt_CancelDate__c == null
               )
            {
                f_EffectiveInsurance ++;
            }
            
        }
        
        // IsAmendable = CheckAmendable(Car.id);
        IsAmendable = CheckAmendable(Passengers, CIC_Compulsoris);
        
        // To prevent the Parent Rocord from being further edited while the Child Record is in pending status
        if ( Car.id != null) {
            if ([select id from wb_CarInsurancedCars__c 
                 where OriginalCar__c =:Car.id and PendingAction__c <> null ].size() > 0)
                IsHavingPendingChildAction = true;
            else
                IsHavingPendingChildAction = false;
        } else
             IsHavingPendingChildAction = false;
        
        if (Car.PendingAction__c == null) {
            IsPending = false;
        } else {
            IsPending = true;
        }
    }
    
    
    

    public boolean CheckAmendable(  List<wb_CIC_Passenger__c> Ps, List<wb_CIC_Compulsory__c> Cs ){
         // system.debug('CheckAmendable' + theCar.RegistryNumber__c + ' ' + Ps.size()  + ' ' + Cs.size() );
        if (Ps.size() == 0 && Cs.size() == 0 ){
              return true;
        }
        for (wb_CIC_Passenger__c p:Ps ){
            if ( p.CarInsurancedCar__c == theCar.id) {
                if ((p.Psgr_CancelDate__c == null && p.Psgr_CurrentStartDate__c != null) ||
                    (p.OP_CancelDate__c == null && p.OP_CurrentStartDate__c != null) )
                    return true;
            }
        }
        
        
        
        for (wb_CIC_Compulsory__c c:Cs ){
            if (c.CarInsurancedCar__c == theCar.id ){
               // system.debug(theCar.RegistryNumber__c + ' ' + c.Cps_CurrentStartDate__c + ' ' + c.Cps_CurrentEndDate__c + ' ' +  c.Cps_CancelDate__c  + ' '
                //             + c.Vlt_StartDate__c + ' ' + c.Vlt_EndDate__c + ' ' +  c.Vlt_CancelDate__c 
                //            );
               // if ((c.Cps_CurrentStartDate__c != null && c.Cps_CurrentEndDate__c >= date.today()&& c.Cps_CancelDate__c == null)
                //    || (c.Vlt_StartDate__c != null && c.Vlt_EndDate__c >= date.today() && c.Vlt_CancelDate__c == null )) 
                    if ((c.Cps_CurrentStartDate__c != null && c.Cps_CurrentEndDate__c != null && c.Cps_CancelDate__c == null)
                        || (c.Vlt_StartDate__c != null && c.Vlt_EndDate__c != null  && c.Vlt_CancelDate__c == null )) 
                    return true;
            }
        }
        
        return false;
    }
    

    
}