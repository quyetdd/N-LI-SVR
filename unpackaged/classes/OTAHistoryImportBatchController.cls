public with sharing class OTAHistoryImportBatchController {
	
	public void Run()
	{
		OTAHistoryImportBatch bat = new OTAHistoryImportBatch();
        Database.executeBatch(bat);	
	}
	
	static testMethod void Test_OTAHistoryImportBatchController()
	{
		OTAHistoryImportBatchController con = new OTAHistoryImportBatchController();
		con.run();	
	}

}