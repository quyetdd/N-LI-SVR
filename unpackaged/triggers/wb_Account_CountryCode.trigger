trigger wb_Account_CountryCode on Account (before insert, before update) {
    
    if (Trigger.isInsert)
    {
        for(Account newAccount : Trigger.new)
        { 
          newAccount.CountryCode__c = newAccount.CountryCd__c;
        }
    }
    
     if (Trigger.isUpdate)
    {

        for(Account updatedAccount : Trigger.new)
        {
              updatedAccount.CountryCode__c = updatedAccount.CountryCd__c;
        }
    }

}