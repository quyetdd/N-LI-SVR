@RestResource(urlMapping='/MDContract/*')
global with sharing class wb_soap_MDContract {
    
    global class ContractMember{
        global string Id; 
        global string WorkingCompany;
        global string MemberNo;
        global string MemberName;
        global string Plan;
        ContractMember(wb_MembershipDetail__c d){
            Id = d.Id;
            WorkingCompany = d.WorkingCompany__r.name;
            MemberNo= d.MemberNo__c;
            if (d.MemberName__c != null)
                MemberName=d.MemberName__c;
            else 
                MemberName = d.Individual__r.name;
            Plan= d.MembershipPlan__c;
        }
    }
    
     global class Contract{
         global string Id; 
         global string ContractCompany;
         global string BillingCompany;
         global string PaymentCurrency;
         global string StartDate;
         global string EndDate;
         global List<ContractMember> Members;
         
         Contract(wb_Membership__c H, List<wb_MembershipDetail__c> D){
             Id = H.Id;
             ContractCompany = H.ContractCompany__r.name;
             BillingCompany = H.BillingCompany__r.name;
             PaymentCurrency = H.Currency__c;
             Members = new List<ContractMember>();
             for (wb_MembershipDetail__c dd:D){
                 Members.add( new ContractMember(dd));
             }
         }
     }
    
    @HttpGet
    global static List<Contract> getContract() {
        
        RestRequest request = RestContext.request;
        // grab the caseId from the end of the URL
        String req = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        system.debug('req:'+req);
        if ( req.indexOf('=') > 1){
            string reqType = req.left( req.indexOf('='));
            string reqInfo = req.right(req.length() - req.indexOf('=') - 1);
            if ( reqType=='CONTRACTCOMPANYID')
                return GetContracts(Id.valueOf(reqInfo));
            else 
                return null;
        } else
            return null;            
        
        
    }
    
    public static List<Contract> GetContracts(Id CompID){
        List<Contract> Contracts = new List<Contract>();
        List<wb_Membership__c> Membership =  [ SELECT  Id,
                                              ContractCompany__r.name,
                                              BillingCompany__r.name,
                                              Currency__c
                                              FROM wb_Membership__c
                                              where ContractCompany__c=:CompID and Status__c ='確定'
                                              order by Id];
        List<Id> MID = new List<Id>();
        for (wb_Membership__c m:Membership)
            MID.add(m.Id);
        
        List<wb_MembershipDetail__c> MembershipDetail =[SELECT Id, Membership__c, MemberName__c, Individual__r.name,
                                                        WorkingCompany__r.name, 
                                                        MembershipPlan__c, MemberNo__c, MembershipStartDate__c, MembershipEndDate__c
                                                        FROM wb_MembershipDetail__c where Membership__c =:MID and Type__c != '入会金'
                                                        order by Membership__c, Id];
        integer i ;
        integer j=0;
        
        for (i = 0 ; i < Membership.size(); i ++ ){
            List<wb_MembershipDetail__c> d = new List<wb_MembershipDetail__c>();
            for (;j < MembershipDetail.size() &&
                 ( Membership[i].Id == MembershipDetail[j].Membership__c || Membership[i].Id > MembershipDetail[j].Membership__c)
                 ; j ++){
                d.add(MembershipDetail[j]);
            }
            Contracts.add( new Contract(Membership[i], d));
        }
        
        return Contracts;
    }
    

}