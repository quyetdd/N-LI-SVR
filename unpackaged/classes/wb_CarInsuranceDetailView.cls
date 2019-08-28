public class wb_CarInsuranceDetailView {
    ApexPages.StandardController stdController;
    public wb_CarInsurance__c theCarInsurance {get;set;}
    public List<wb_CI_InsurancedCarRow> InsurancedCarsList {get;set;}
    public List<wb_CI_InsurancedCarRow> InsurancedCarsNoEffList {get;set;}
    
    List<wb_CarInsurancedCars__c> Cars{get;set;}
    List<wb_CIC_Passenger__c> Passengers{get;set;}
    List<wb_CIC_Compulsory__c> Compulsoris{get;set;}


    public wb_CarInsuranceDetailView(ApexPages.StandardController stdController){
        this.stdController = stdController;
                  theCarInsurance = (wb_CarInsurance__c) stdController.getRecord();
        
        
        if ( theCarInsurance.id != null ) {
            theCarInsurance = [select Name, Status__c, Agent__c ,AffiliationDistrict__c,ContractDate__c,
                            ContractCompany__c,ContractCompany__r.name,
                            ContractDistrict__c,ContractCountry__c, Attribute__c, CommissionCurrency__c, 
                            AcctPIC__c
                            from wb_CarInsurance__c where id =: theCarInsurance.Id];
            
            LIST<wb_CarInsurancedCars__c> InsurancedCars = [SELECT id, Name, UsingCompany__c, EngineNo__c, Car__c, CarInsurance__c, Model__c, FrameNo__c,
                              LegalNumberofSeats__c,  Ownership__c,  FirstRegistryDate__c,
                              ReplacedDate__c, //f_EffectiveInsurance__c,
                              PendingAction__c, Pattern__c
                              FROM wb_CarInsurancedCars__c 
                              where  CarInsurance__c =: theCarInsurance.Id ];
            //system.debug( InsurancedCars.size());
            InsurancedCarsList = new List<wb_CI_InsurancedCarRow>();
            InsurancedCarsNoEffList = new List<wb_CI_InsurancedCarRow>();
            
            List<wb_CI_InsurancedCarRow> theCarsList = GetCarsList(theCarInsurance.id);
            
           // system.debug( theCarsList.size());
            for ( wb_CI_InsurancedCarRow car:theCarsList){
                if (car.IsAmendable == true && car.IsPending ==false)
                    InsurancedCarsList.add( car);
                else
                    InsurancedCarsNoEffList.add(car);
            }
            
           // system.debug(InsurancedCarsList.size() + ' ' + InsurancedCarsNoEffList.size() );
            /*
            for (wb_CarInsurancedCars__c c:InsurancedCars){
               
                wb_CI_InsurancedCarRow car = new wb_CI_InsurancedCarRow(c);
                if (car.IsAmendable == true && car.IsPending ==false)
                    InsurancedCarsList.add( car);
                else
                    InsurancedCarsNoEffList.add(car);
                 system.debug('C V:' + c.Name + ' ' + car.IsAmendable + ' ' + car.IsPending + car.MyProduct);
            } */
            
         //   status = CarInsurance.Status__c;
        } 
    }
    
    public List<wb_CI_InsurancedCarRow> GetCarsList(string id){
           Cars = new List<wb_CarInsurancedCars__c>();
        //List<wb_CarInsurancedCars__c> 
            Cars = [SELECT id, Name, UsingCompany__c, EngineNo__c, Car__c, 
                                              CarInsurance__c, Model__c, FrameNo__c,
                                              LegalNumberofSeats__c,  Ownership__c,  FirstRegistryDate__c,
                                              ReplacedDate__c,// f_EffectiveInsurance__c,
                                              PendingAction__c,OriginalCar__c , RegistryNumber__c, Pattern__c
                                              FROM wb_CarInsurancedCars__c 
                                              where CarInsurance__c =: Id
                                              order by RegistryNumber__c, id];
         Passengers = new List<wb_CIC_Passenger__c>();
        //List<wb_CIC_Passenger__c>
            Passengers = [select Psgr_InsuranceCompany__c,Psgr_CommodityName__c, Psgr_InsurancePlan__c,
                                                OP_CommodityName__c, OP_Plan__c, Psgr_CurrentEndDate__c, OP_CurrentEndDate__c,Psgr_CancelDate__c ,
                                                Psgr_CurrentStartDate__c,OP_CancelDate__c,OP_CurrentStartDate__c,CarInsurancedCar__c, CarInsurancedCar__r.id
                                                from wb_CIC_Passenger__c 
                                                where CarInsurancedCar__r.CarInsurance__c =:id
                                                order by CarInsurancedCar__r.id];
         Compulsoris = new  list<wb_CIC_Compulsory__c>();
       // list<wb_CIC_Compulsory__c>
            Compulsoris = [select Cps_InsuranceCompany__c,Vlt_InsuranceCompany__c, Cps_CurrentStartDate__c,
                                                  Cps_CurrentEndDate__c,Cps_CancelDate__c,Vlt_StartDate__c,Vlt_EndDate__c,Vlt_CancelDate__c, CarInsurancedCar__c , CarInsurancedCar__r.id
                                                  from wb_CIC_Compulsory__c 
                                                  where CarInsurancedCar__r.CarInsurance__c =:id
                                                  order by CarInsurancedCar__r.id];
        
        List<wb_CI_InsurancedCarRow> theCarList = new List<wb_CI_InsurancedCarRow>();
        
        List<wb_CIC_Passenger__c> Ps = new List<wb_CIC_Passenger__c>();
        List<wb_CIC_Compulsory__c> Cs = new List<wb_CIC_Compulsory__c>();
        integer cari=0, psgri=0, cpsi=0;
        integer psgrip, cpsip;

        
        for ( cari=0; cari < Cars.size(); cari ++ ){
         //   system.debug(  'cars' + cari + ' ' + cars[cari].RegistryNumber__c + ' ' + Passengers.size() + ' ' + Compulsoris.size() );
            Ps = new List<wb_CIC_Passenger__c>();
            Cs = new List<wb_CIC_Compulsory__c>();
            
            for (psgri= 0 ; psgri < Passengers.size(); psgri ++ )
            {
                if ( Passengers[psgri].CarInsurancedCar__r.id == cars[cari].id){
                    wb_CIC_Passenger__c newp = new wb_CIC_Passenger__c();
                    newp = Passengers[psgri].clone(true);
                    Ps.add(newp);     
                } //else {
                 //   psgrip = psgri;
                 //   psgri = Passengers.size();
              //  }
                
            }
            
          //  if (psgri == Passengers.size() + 1 )
        //        psgri = psgrip;
            
            for (cpsi = 0 ; cpsi < Compulsoris.size(); cpsi ++ )
            {
                if ( Compulsoris[cpsi].CarInsurancedCar__r.id == cars[cari].id){
                    wb_CIC_Compulsory__c newc = new wb_CIC_Compulsory__c();
                    newc = Compulsoris[cpsi].clone(true);
                    Cs.add(newc);     
                }// else {
                //    cpsip = cpsi;
                //    cpsi = Compulsoris.size();
               // }
                
            }
            
        //    if (cpsi == Compulsoris.size() + 1 )
        //        cpsi = cpsip;
            
            //system.debug('cars: ' + cars[cari].name + ' ' + Ps.size()  + ' ' + psgrip + ' ' + psgri + ' ' + Passengers.size());
            //theCarList.add(new wb_CI_InsurancedCarRow(cars[cari], Passengers, Compulsoris));
            theCarList.add(new wb_CI_InsurancedCarRow(cars[cari], Ps, Cs));
        }
        
        return theCarList;
    }
    
    
    
}