global class OTAHistoryImportBatch implements Database.Batchable<sObject>, Database.Stateful
{
    global OTAHistoryImportBatch()
    {}
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
		return Database.getQueryLocator('select Id, Temp_MemberNo__c, Temp_FamilyNo__c ' +
			'from OTAHistory__c where MemberName__c=null and MemberFamilyName__c=null');
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
	    list<string> lm = new list<string>();
        list<string> lf = new list<string>();
        
        for(sobject s : scope)
        {
        	OTAHistory__c o = (OTAHistory__c)s;

			if(o.Temp_MemberNo__c!=null)
        		lm.add(o.Temp_MemberNo__c.substring(4,10));
       		else if(o.Temp_FamilyNo__c!=null)
       			lf.add(o.Temp_FamilyNo__c.substring(4,10));
        }
            
        map<string, string> mm = new map<string, string>();
        for(MemberInfo__c mi : [select Id, MemberNo__c from MemberInfo__c where KeiyakuNo__c in :lm])
       		mm.put(mi.MemberNo__c.substring(4,11), mi.Id);
               
        map<string, string> mf = new map<string, string>();
        for(FamilyInfo__c fi : [select Id, MemberNo__c from FamilyInfo__c where KeiyakuNo__c in :lf])
       		mf.put(fi.MemberNo__c.substring(4,11), fi.Id);
               		
        for(sobject s : scope)
        {
        	OTAHistory__c o = (OTAHistory__c)s;
        	
			string mkey;
			if(o.Temp_MemberNo__c!=null)
			{
        		mkey = o.Temp_MemberNo__c.substring(4,11);
        		o.MemberName__c = mm.containsKey(mkey) ? mm.get(mkey) : null;
			}
       		else if(o.Temp_FamilyNo__c!=null)
       		{
       			mkey = o.Temp_FamilyNo__c.substring(4,11);
       			o.MemberFamilyName__c = mf.containsKey(mkey) ? mf.get(mkey) : null;
       		}
        }
        
		update scope;
        
    }

    global void finish(Database.BatchableContext BC)
    {
    }
    
 
 
    static testMethod void OTAHistoryImportBatch_Test()
    {
        Test.startTest();
        test1();
        Test.stopTest();
    }
    
    static void Test1()
    {
        OTAHistoryImportBatch bat = new OTAHistoryImportBatch();
        Database.executeBatch(bat);
    }
    
}