trigger AffiliatedHospital_SortOrder on AffiliatedHospital__c  (before insert, before update) {
    

  //  Set < String > LocationSet = new Set < String > ();


    
    if (Trigger.isInsert)
    {
        Set < String > LocationSet = new Set < String > ();
     	//List<AffiliatedHospital__c> LastSeed = New AffiliatedHospital__c()
        for(AffiliatedHospital__c newAffiliatedHospital : Trigger.new)
        { 
            if( !LocationSet.contains(string.valueof(newAffiliatedHospital.Contract_Country__c) + string.valueof(newAffiliatedHospital.Contract_Region__c)
                                      + string.valueof(newAffiliatedHospital.Contract_Zone__c) + string.valueof(newAffiliatedHospital.Contract_Category__c)))
            {
                LocationSet.add(string.valueof(newAffiliatedHospital.Contract_Country__c) + string.valueof(newAffiliatedHospital.Contract_Region__c)
                                      + string.valueof(newAffiliatedHospital.Contract_Zone__c) + string.valueof(newAffiliatedHospital.Contract_Category__c));
            }

        }
        
        AggregateResult[] LastOrder = [select Contract_Country__c Contract_Country, Contract_Region__c Contract_Region,
                                       Contract_Zone__c Contract_Zone, Contract_Category__c Contract_Category,
                                       Max(Hospital_Sort_Order__c) LastOrder
                                       from AffiliatedHospital__c
                                       where f_orderingcondition__c =:LocationSet
                                       group by Contract_Country__c, Contract_Region__c,
                                       Contract_Zone__c, Contract_Category__c
                                       order by Contract_Country__c, Contract_Region__c,
                                       Contract_Zone__c, Contract_Category__c ];
        

		List <Integer> LocationOrder = new List <Integer>();
        Map<String,Integer> LocationeMap = new Map<String,Integer>();
        for (integer i=0; i < LastOrder.size(); i ++ ){
            
            LocationeMap.put( string.valueof(LastOrder[i].get('Contract_Country')) + String.valueof(LastOrder[i].get('Contract_Region')) 
                             + String.valueof(LastOrder[i].get('Contract_Zone'))  + String.valueof(LastOrder[i].get('Contract_Category'))
                             ,i);
            LocationOrder.add(Integer.Valueof(LastOrder[i].get('LastOrder')));
        }
        
        for(AffiliatedHospital__c newAffiliatedHospital : Trigger.new)
        { 
            if(LocationeMap.containsKey(string.valueof(newAffiliatedHospital.Contract_Country__c) + string.valueof(newAffiliatedHospital.Contract_Region__c)
                                      + string.valueof(newAffiliatedHospital.Contract_Zone__c) + string.valueof(newAffiliatedHospital.Contract_Category__c)))
            {
                //get the index
                Integer index = LocationeMap.get(string.valueof(newAffiliatedHospital.Contract_Country__c) + string.valueof(newAffiliatedHospital.Contract_Region__c)
                                                 + string.valueof(newAffiliatedHospital.Contract_Zone__c) + string.valueof(newAffiliatedHospital.Contract_Category__c));
               // system.debug(index);
                //system.debug(LocationOrder[index]);
                newAffiliatedHospital.Hospital_Sort_Order__c = LocationOrder[index] + 10;
                LocationOrder[index] = LocationOrder[index] + 10;                           
                //do something if myaccount exists
            }
        }
        
    }
    
        // Handle Update
    if (Trigger.isUpdate)
    {
        Set < String > LocationSet = new Set < String > ();
        integer count = 0;
        for(AffiliatedHospital__c updatedAffiliatedHospital : Trigger.new)
        {
            AffiliatedHospital__c origAffiliatedHospital = Trigger.Old[count]; // Get the original value
            
            // Only bother if the record wasn't approved but is now
            if (origAffiliatedHospital.Contract_Country__c != updatedAffiliatedHospital.Contract_Country__c ||
                origAffiliatedHospital.Contract_Region__c != updatedAffiliatedHospital.Contract_Region__c ||
                origAffiliatedHospital.Contract_Zone__c != updatedAffiliatedHospital.Contract_Zone__c ||
                origAffiliatedHospital.Contract_Category__c != updatedAffiliatedHospital.Contract_Category__c 
               )
            {
                if( !LocationSet.contains(string.valueof(updatedAffiliatedHospital.Contract_Country__c) + string.valueof(updatedAffiliatedHospital.Contract_Region__c)
                                          + string.valueof(updatedAffiliatedHospital.Contract_Zone__c) + string.valueof(updatedAffiliatedHospital.Contract_Category__c)))
                {
                    LocationSet.add(string.valueof(updatedAffiliatedHospital.Contract_Country__c) + string.valueof(updatedAffiliatedHospital.Contract_Region__c)
                                    + string.valueof(updatedAffiliatedHospital.Contract_Zone__c) + string.valueof(updatedAffiliatedHospital.Contract_Category__c));
                }

            }
            
            count++;
        }
        
        AggregateResult[] LastOrder = [select Contract_Country__c Contract_Country, Contract_Region__c Contract_Region,
                                       Contract_Zone__c Contract_Zone, Contract_Category__c Contract_Category,
                                       Max(Hospital_Sort_Order__c) LastOrder
                                       from AffiliatedHospital__c
                                       where f_orderingcondition__c =:LocationSet
                                       group by Contract_Country__c, Contract_Region__c,
                                       Contract_Zone__c, Contract_Category__c
                                       order by Contract_Country__c, Contract_Region__c,
                                       Contract_Zone__c, Contract_Category__c ];
        
        List <Integer> LocationOrder = new List <Integer>();
        Map<String,Integer> LocationeMap = new Map<String,Integer>();
        for (integer i=0; i < LastOrder.size(); i ++ ){
            
            LocationeMap.put( string.valueof(LastOrder[i].get('Contract_Country')) + String.valueof(LastOrder[i].get('Contract_Region')) 
                             + String.valueof(LastOrder[i].get('Contract_Zone'))  + String.valueof(LastOrder[i].get('Contract_Category'))
                             ,i);
            LocationOrder.add(Integer.Valueof(LastOrder[i].get('LastOrder')));
        }
        
        count = 0;
        for(AffiliatedHospital__c updatedAffiliatedHospital : Trigger.new)
        {
            AffiliatedHospital__c origAffiliatedHospital = Trigger.Old[count]; // Get the original value
            
            // Only bother if the record wasn't approved but is now
            if (origAffiliatedHospital.Contract_Country__c != updatedAffiliatedHospital.Contract_Country__c ||
                origAffiliatedHospital.Contract_Region__c != updatedAffiliatedHospital.Contract_Region__c ||
                origAffiliatedHospital.Contract_Zone__c != updatedAffiliatedHospital.Contract_Zone__c ||
                origAffiliatedHospital.Contract_Category__c != updatedAffiliatedHospital.Contract_Category__c 
               )
            {
                 //get the index
                Integer index = LocationeMap.get(string.valueof(updatedAffiliatedHospital.Contract_Country__c) + string.valueof(updatedAffiliatedHospital.Contract_Region__c)
                                                 + string.valueof(updatedAffiliatedHospital.Contract_Zone__c) + string.valueof(updatedAffiliatedHospital.Contract_Category__c));
               // system.debug(index);
                //system.debug(LocationOrder[index]);
                updatedAffiliatedHospital.Hospital_Sort_Order__c = LocationOrder[index] + 10;
                LocationOrder[index] = LocationOrder[index] + 10;                           
                //do something if myaccount exists
                
            }
            count++;
        }
        
    }
    

    
    /*
    if (Trigger.isUpdate)
    {
        for(AffiliatedHospital__c updatedAffiliatedHospital : Trigger.new)
        {
            updatedAccount.CountryCode__c = updatedAccount.CountryCd__c;
        }
    }*/

}