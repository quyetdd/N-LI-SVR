public class wb_Account_MDContract {
    private ApexPages.StandardController standardController;
    public Account theAccount {get; set;}
    public List<wb_Membership__c> theMemberships {get; set;}   
    public List<wb_Membership__c> theDraftContracts {get; set;}
    
    public List<wb_Membership__c> theConfirmedContracts {get; set;}

    public wb_utility_datapaging ConfirmedContractsPage {get; set;}
    public List<wb_MembershipDetail__c> theConfirmedContractDetails {get; set;}
    public wb_utility_datapaging ConfirmedContractDetailsPage {get; set;}
    
    public List<wb_Membership__c> theCancelledContracts {get; set;}
    public List<wb_MembershipDetail__c> theMembershipDetails {get; set;}
    public List<wb_Member__c> theMember {get; set;}
    
    public wb_Account_MDContract(ApexPages.StandardController stdController){
        this.standardController = stdController;
        theAccount = (Account) stdController.getRecord();
        theMemberships =  [SELECT Id, Name, Status__c, Currency__c,ContractDate__c FROM wb_Membership__c
                           where ContractCompany__c =:theAccount.id 
                           order by name desc];
    
        theDraftContracts = new List<wb_Membership__c>();
        theConfirmedContracts = new List<wb_Membership__c>();
        theCancelledContracts = new List<wb_Membership__c>();
        
        for (wb_Membership__c c:theMemberships){
            if ( c.Status__c =='未確定')
                theDraftContracts.add(c);
            if ( c.Status__c =='確定')
                theConfirmedContracts.add(c);
            if ( c.Status__c =='キャンセル')
                theCancelledContracts.add(c);
        }
   //     List<Id> MDContractID = new List<Id>();
   //     for ( wb_Membership__c m:theConfirmedContracts){
  //          MDContractID.add(m.id);
   //     }
       // theMember = new List<wb_Member__c>();
   /*     theMember = [SELECT MembershipDetail__r.Membership__r.Id,
                     MembershipDetail__r.Membership__r.name, MembershipDetail__r.name,
                     Individual__r.name, MembershipDetail__c, 
                     WorkingCompany__c, Name , MembershipDetail__r.Type__c, 
                     MembershipDetail__r.MembershipEndDate__c,
                     MembershipDetail__r.MemberNo__c
                     FROM wb_Member__c
                     where  MembershipDetail__r.Membership__r.id =:MDContractID]; */
        
        ConfirmedContractsPage = new wb_utility_datapaging(theConfirmedContracts);
        
        theConfirmedContractDetails = [SELECT Membership__r.name, name, Type__c, Individual__c, Individual__r.name, WorkingCompany__c, MembershipEndDate__c, MembershipStopDate__c
                                       FROM wb_MembershipDetail__c
                                       where Membership__r.ContractCompany__c =:theAccount.id 
                                       //Membership__r.name =:theHighlightedConfirmed 
                                       and ParentDetail__c = null 
                                       order by Membership__r.name, f_NameforOrdering__c ];
    }
	public string theHighlightedConfirmed {get; set;}
    public void GetConfirmedDetails(){
        //  system.debug('GetConfirmedDetails:' + theHighlightedConfirmed);
        
        List<wb_MembershipDetail__c> theDetail = new List<wb_MembershipDetail__c>();
        
        if (theHighlightedConfirmed.length() > 0){
            
          //  theConfirmedContractDetails = [SELECT name, Type__c, Individual__c, Individual__r.name, WorkingCompany__c, MembershipEndDate__c, MembershipStopDate__c
          //                                 FROM wb_MembershipDetail__c
         //                                  where  Membership__r.name =:theHighlightedConfirmed 
          //                                 and ParentDetail__c = null order by id];
            for (wb_MembershipDetail__c d: theConfirmedContractDetails){
              if ( d.Membership__r.name == theHighlightedConfirmed )
                  theDetail.add(d);
            }
            
        } //else
           // theConfirmedContractDetails = new List<wb_MembershipDetail__c>();
        
        ConfirmedContractDetailsPage = new wb_utility_datapaging(theDetail);
    }

    
}