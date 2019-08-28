public class  wb_ContractMemberInsurance {
    
    public wb_MembershipDetail__c ContractRow {get;set;}
    public List<wb_MedicalInsuranceDetail__c> MedicalInsuranceDetail {get;set;}
    public string HavingInsurance {get;set;}
    
    public wb_ContractMemberInsurance( wb_MembershipDetail__c r, List<wb_MedicalInsuranceDetail__c> i){
        ContractRow = r;
        MedicalInsuranceDetail = i;
        if ( MedicalInsuranceDetail.size() > 0 )
            HavingInsurance = 'あり';
        else
            HavingInsurance = 'なし';
    }
    
}