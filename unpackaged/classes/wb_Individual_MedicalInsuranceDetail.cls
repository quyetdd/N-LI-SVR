public class wb_Individual_MedicalInsuranceDetail {
    private ApexPages.StandardController standardController;
    public wb_Individual__c Individual {get;set;}
    
    public List<wb_MedicalInsuranceDetail__c> MedicalInsuranceDetail {get;set;}
    
    public List<Attachment> AllAttachments {get;set;}
    
    public List<aRow> TblMedicalInsuranceDetail { get; set; }
    public class aRow {
        public wb_MedicalInsuranceDetail__c theMedicalInsuranceDetail { get; set; }
        public List<Attachment> Attachments {get;set;}
        public aRow(wb_MedicalInsuranceDetail__c d) {
            theMedicalInsuranceDetail = d;
            Attachments = new List<Attachment>();
        }
    }
    
    public wb_Individual_MedicalInsuranceDetail(ApexPages.StandardController stdController){
        this.standardController = stdController;
        Individual = (wb_Individual__c) stdController.getRecord();
        MedicalInsuranceDetail = [select id, Name, InsurancePlan__c, StorageLocation__c, MedicalInsurance__c,Priority__c,
                                  InsuranceStartDate__c,InsuranceEndDate__c,MedicalSettlement__c,InsuranceCurrency__c,
                                  InsuranceCompany__c,HandlingBy__c,PolicyNumber__c, Remark__c
                                  from wb_MedicalInsuranceDetail__c where Individual__c =:Individual.id];
        
        List<Id> MI_Id = new  List<Id>();
        TblMedicalInsuranceDetail = new List<aRow>();
        for( wb_MedicalInsuranceDetail__c d:MedicalInsuranceDetail){
            MI_Id.add(d.MedicalInsurance__c);
            TblMedicalInsuranceDetail.add( new aRow(d));
        }
        
        AllAttachments = [SELECT id, ParentId ,name
                       FROM Attachment where ParentId =:MI_Id];
        
        
       for( aRow r:TblMedicalInsuranceDetail){
           for ( Attachment a:AllAttachments){
               if (r.theMedicalInsuranceDetail.MedicalInsurance__c ==  a.ParentId )
                   r.Attachments.add(a);
           }
       }
    }

}