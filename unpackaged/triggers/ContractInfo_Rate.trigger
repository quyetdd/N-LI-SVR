trigger ContractInfo_Rate on ContractInfo__c (after insert, after update) {
    
    
    // List of accounts to update or insert (Bulk)
    //list<Account> accountsToUpdate = new list<Account>();
    
    // Handle insert
    if (Trigger.isInsert)
    {
        for(ContractInfo__c newContractInfo : Trigger.new)
        { 
            if (( newContractInfo.KeiyakuDate__c <> null) && (newContractInfo.Currency__c <> null)){
                if ([select Rate__c from wb_BudgetRate__c where ToCurrency__c =:newContractInfo.Currency__c 
                     and FromDate__c <=:newContractInfo.KeiyakuDate__c and ToDate__c >=:newContractInfo.KeiyakuDate__c].size() > 0 )
                {
                    wb_BudgetRate__c r = [ select Rate__c from wb_BudgetRate__c 
                                          where  ToCurrency__c =:newContractInfo.Currency__c  
                                          and FromDate__c <=:newContractInfo.KeiyakuDate__c and ToDate__c >=:newContractInfo.KeiyakuDate__c limit 1];
                    ContractInfo__c c =  [select id, BudgetRate__c from ContractInfo__c where id =: newContractInfo.id];
                    c.BudgetRate__c = r.Rate__c;
                    //newContractInfo.BudgetRate__c = r.Rate__c;
                    update c;
                } 
            }
        }
    }
    
    // Handle Update
    if (Trigger.isUpdate)
    {
        integer count = 0;
        for(ContractInfo__c updatedContractInfo : Trigger.new)
        {
            ContractInfo__c origContractInfo = Trigger.Old[count]; // Get the original value
            
            // Only bother if the record wasn't approved but is now
            if (origContractInfo.KeiyakuDate__c != updatedContractInfo.KeiyakuDate__c ||
                origContractInfo.Currency__c != updatedContractInfo.Currency__c )
            {
                   if (( updatedContractInfo.KeiyakuDate__c <> null) && (updatedContractInfo.Currency__c <> null)){
                       if ([select Rate__c from wb_BudgetRate__c where ToCurrency__c =:updatedContractInfo.Currency__c 
                            and FromDate__c <=:updatedContractInfo.KeiyakuDate__c and ToDate__c >=:updatedContractInfo.KeiyakuDate__c].size() > 0 )
                       {
                           wb_BudgetRate__c r = [ select Rate__c from wb_BudgetRate__c 
                                                 where  ToCurrency__c =:updatedContractInfo.Currency__c  
                                                 and FromDate__c <=:updatedContractInfo.KeiyakuDate__c and ToDate__c >=:updatedContractInfo.KeiyakuDate__c limit 1];
                          // updatedContractInfo.BudgetRate__c = r.Rate__c;
                           ContractInfo__c c =  [select id, BudgetRate__c from ContractInfo__c where id =: updatedContractInfo.id];
                           c.BudgetRate__c = r.Rate__c;
                           update c;
                       } else {
                           // updatedContractInfo.BudgetRate__c = null;
                           ContractInfo__c c =  [select id, BudgetRate__c from ContractInfo__c where id =: updatedContractInfo.id];
                           c.BudgetRate__c = null;
                           update c;    
                       }
                          
                }
            }
            
            count++;
        }
    }
    

    
        /*
 for(ContractInfo__c record : Trigger.new) {
      if (( record.KeiyakuDate__c <> null) && (record.Currency__c <> null)){
         if ([select Rate__c from wb_BudgetRate__c where ToCurrency__c =:record.Currency__c 
             and FromDate__c <=:record.KeiyakuDate__c and ToDate__c >=:record.KeiyakuDate__c].size() > 0 )
         {
             wb_BudgetRate__c r = [ select Rate__c from wb_BudgetRate__c 
                                     where  ToCurrency__c =:record.Currency__c  
                                     and FromDate__c <=:record.KeiyakuDate__c and ToDate__c >=:record.KeiyakuDate__c limit 1];
             record.BudgetRate__c = r.Rate__c;
         } else
             record.BudgetRate__c = null;
      }
  } 
 
*/
}