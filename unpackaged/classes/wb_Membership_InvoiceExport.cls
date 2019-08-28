public class wb_Membership_InvoiceExport {
    
    public H InvoiceHeader {get;set;} 
    
    public List<ContractMemberInsurance> InvoiceDetail {get;set;} 
        
    public class H{
        public wb_Membership__c theContract  {get;set;} 
        public decimal SubTotal1 {get;set;}
        public decimal SubTotal2 {get;set;}
        H( wb_Membership__c Contract,  decimal Sub1 ,  decimal Sub2 ){
            theContract = Contract;
            SubTotal1 = Sub1;
            SubTotal2 = Sub2;
        }
    }
    
    public class  ContractMemberInsurance {
        
        public wb_MembershipDetail__c ContractRow {get;set;}
        public List<wb_MedicalInsuranceDetail__c> MedicalInsuranceDetail {get;set;}
        public string HavingInsurance {get;set;}
        
        public ContractMemberInsurance( wb_MembershipDetail__c r, List<wb_MedicalInsuranceDetail__c> i){
            ContractRow = r;
            MedicalInsuranceDetail = i;
            if ( MedicalInsuranceDetail.size() > 0 )
                HavingInsurance = 'あり';
            else
                HavingInsurance = 'なし';
        }
    }
    

    
    public wb_Membership_InvoiceExport(wb_Membership__c Contract, decimal st1, decimal st2, 
                                       List<wb_MembershipDetail__c> ContractDetail,
                                       List<wb_MedicalInsuranceDetail__c> MedicalInsuranceDetail
                                      ){
        InvoiceHeader = new H(Contract, st1, st2);
       // InvoiceDeatil = CD;
       // 
        InvoiceDetail = new List<ContractMemberInsurance>();
        
        integer i = 0;
        integer j = 0;
        
        for ( ;i <ContractDetail.size(); i++){
            List<wb_MedicalInsuranceDetail__c> MI = new List<wb_MedicalInsuranceDetail__c>();
            for (;j<MedicalInsuranceDetail.size() && ContractDetail[i].Individual__c>=MedicalInsuranceDetail[j].Individual__c;){
                if ( ContractDetail[i].Individual__c == MedicalInsuranceDetail[j].Individual__c){
                    MI.add(MedicalInsuranceDetail[j]);
                    j++;
                } else
                    j++;
            }
            // theContractDetailInsurance.add( new ContractMemberInsurance(theContractDetail[i],MI));
            InvoiceDetail.add( new ContractMemberInsurance(ContractDetail[i],MI));
        }
    }

}