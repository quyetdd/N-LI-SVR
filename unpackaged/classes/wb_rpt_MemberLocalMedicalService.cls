public class wb_rpt_MemberLocalMedicalService {
    
    public wb_MedicalInsuranceDetail__c ReportingCondition{get;set;}
    
    public List<wb_MedicalInsuranceDetail__c> LocalMedicalInsuranceIndividual{get;set;}
    
    public wb_rpt_MemberLocalMedicalService(){
        
        ReportingCondition = new wb_MedicalInsuranceDetail__c();
    }
    
    public void execute(){
        
        List<Id> IndIDs = new List<Id>();
        LocalMedicalInsuranceIndividual=
            [select  Individual__r.Parent__c, Individual__c,
             ContractCompany__r.name, ContractCompany__r.CountryName__c,
             InsuranceEndDate__c, Insurance__c
             from wb_MedicalInsuranceDetail__c 
             where InsuranceEndDate__c > 2017-01-01
             and MedicalInsurance__r.MedicalDivision__c ='現地医療' and 
             ( Individual__r.f_Classification__c ='会員' or Individual__r.Parent__r.f_Classification__c ='会員' )];
        
        for ( wb_MedicalInsuranceDetail__c lmsi:LocalMedicalInsuranceIndividual) 
        {
            if ( lmsi.Individual__r.Parent__c != null )
                IndIDs.add(lmsi.Individual__r.Parent__c);
            else
                IndIDs.add(lmsi.Individual__c);
        }
       
        List<wb_Member__c> Members =
            [select Individual__c, MembershipDetail__r.Membership__r.ContractCompany__c, 
             MembershipDetail__r.Membership__r.ContractCountry__c
             from wb_Member__c
             where Individual__c =:IndIDs 
             order by Individual__c];
        
       // List<Contact> contacts = [SELECT Name, Id FROM Contact ORDER BY Id LIMIT 10]; // We'll reorder by Name later
        Map<String, wb_Member__c> MembersMap = new Map<String, wb_Member__c>(); // Reversed for sorting
        List<String> sortThis = new List<String>();
        
        for(wb_Member__c m : Members)
        {
            MembersMap.put(string.valueof(m.Individual__c), m); // For simplicity in this example, we assume the name is unique
            sortThis.add(string.valueof(m.Individual__c));
        }
        
        sortThis.sort(); // Sort by Name in this case    
        List<wb_Member__c> SortedMembers = new List<wb_Member__c>();
        
        for(String s : sortThis)
        {
            SortedMembers.add(MembersMap.get(s));
        }
        
        wb_Member__c theMember;
        for ( wb_MedicalInsuranceDetail__c lmsi:LocalMedicalInsuranceIndividual) {
            
            if ( lmsi.Individual__r.Parent__c != null ) {
               theMember = Search(String.Valueof(lmsi.Individual__r.Parent__c),SortedMembers);
                
            }
            else {
                theMember = Search(string.valueof(lmsi.Individual__c),SortedMembers);
            }
            system.debug(theMember);
            system.debug(lmsi);
            if (theMember != null){
                if (theMember.MembershipDetail__r.Membership__r.ContractCompany__c != null)
                	lmsi.ContractCompany__r.name = theMember.MembershipDetail__r.Membership__r.ContractCompany__c;
                if (theMember.MembershipDetail__r.Membership__r.ContractCountry__c != null)
                	lmsi.ContractCompany__r.CountryName__c = theMember.MembershipDetail__r.Membership__r.ContractCountry__c;
            }
            
        }
        

    }
    
        
    public wb_Member__c Search(string Pid, List<wb_Member__c> Index){
		system.debug(Pid);
        system.debug(Index);
        Integer low = 0;
        Integer high = Index.size();
        if (Index.size()>0 && Pid != null){
            boolean found = false;
            while (found == false && high != low ){
                string pivot = String.valueof(Index[low + (high-low)/2].Individual__c);
                system.debug(pivot);
                system.debug(Pid);
                if ( pivot == Pid){
                    found = true;
                    return Index[low + (high-low)/2];
                }
                else if (pivot > Pid){
                    high = low + (high-low)/2;
                } else {
                    if (low == low + (high-low)/2){
                        return null;
                    }
                    else{
                        high = high - (high-low)/2;
                    }
                }
            }
        } 
        
        return null;
    }
    

}