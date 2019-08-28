global with SHARING class MDMemberReportSchedular implements Schedulable {
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new MDMemberReportBatch());
    } 
        //run every hour
        Public static void SchedulerMethod(){
        System.schedule('RunBatchApexTest', '0 0 * * * ?', new MDMemberReportSchedular());
    }    
}