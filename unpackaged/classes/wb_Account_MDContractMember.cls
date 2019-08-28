public class wb_Account_MDContractMember {
    private ApexPages.StandardController standardController;
    public Account theAccount {get; set;}
    
    public List<wb_Member__c> theContractedMembers {get; set;}
    public wb_utility_datapaging ContractedMembersPage {get; set;}
    
    public List<wb_MembershipDetail__c> theContractedMembersFamily {get; set;}
    
    public List<wb_MemberHistory__c> theContractedMemberHistories {get; set;}
    public wb_utility_datapaging ContractedMemberHistoryPage {get; set;}
    
    public wb_Account_MDContractMember(ApexPages.StandardController stdController){
        this.standardController = stdController;
        theAccount = (Account) stdController.getRecord();
        List<Id> MDContractID = new List<Id>();
        
        for ( wb_Membership__c m:[SELECT Id FROM wb_Membership__c
                                  where ContractCompany__c =:theAccount.id and Status__c ='確定']){
                                      MDContractID.add(m.id);
                                  }
        theContractedMembers = new List<wb_Member__c>();
        
        List<Id> effectiveMIds = new List<Id>();
        for (wb_MemberHistory__c em:[SELECT  member__c 
                                           FROM wb_MemberHistory__c 
                                           where  MembershipDetail__r.Membership__r.Status__c ='確定' and
                                           ( MembershipDetail__r.Membership__r.id =:MDContractID 
                                            or MembershipDetail__r.WorkingCompany__c =:theAccount.id)
                                           and f_effectiveness__c = true
                                          // and ReplacedWith__c = null
                                          ])
        {
            effectiveMIds.add(em.member__c);
        }
        
        theContractedMembers = [SELECT id, Name, EndDate__c,  WorkingCompany__c,WorkingCompany__r.name,Individual__c,
                                Individual__r.name, MembershipDetail__c, 
                                MembershipDetail__r.Type__c, 
                                MembershipDetail__r.Membership__r.Id, MembershipDetail__r.Membership__r.name,
                                MembershipDetail__r.MembershipEndDate__c,
                                MembershipDetail__r.MemberNo__c
                                FROM wb_Member__c
                                where Id =:effectiveMIds];
        //                        where MembershipDetail__r.Membership__r.Status__c ='確定' and
       //                         ( MembershipDetail__r.Membership__r.id =:MDContractID 
       //                         or WorkingCompany__c =:theAccount.id)];
    
        system.debug(MDContractID);
        List<Id> FamilyTypeID = new List<Id>(); 
        for (wb_Member__c m:theContractedMembers){
            if (m.MembershipDetail__r.Type__c =='家族'){
                FamilyTypeID.add(m.MembershipDetail__c);
            }
        }
        
        if (FamilyTypeID.size() > 0) {
            theContractedMembersFamily = [select Individual__c, Individual__r.name, MemberNo__c, ParentDetail__c
                                          from wb_MembershipDetail__c where ParentDetail__c =:FamilyTypeID];
        }
        
        List<Id> MemberID = new List<Id>();
        for ( wb_Member__c m:theContractedMembers){
            MemberID.add(m.id);
        }
        if (MemberID.size() > 0)
        /*    
        theContractedMemberHistories = [SELECT MemberNo__c, Name, MembershipDetail__c, MembershipDetail__r.name,
                                        MemberType__c, member__c, CancellationDate__c, MembershipEndDate__c, 
                                        MembershipStartDate__c, Classification__c 
                                        FROM wb_MemberHistory__c where member__c =:MemberID]; */
        theContractedMemberHistories = [SELECT MemberNo__c, Name, MembershipDetail__c, 
                                        MembershipDetail__r.MembershipPlan__c, MembershipDetail__r.Type__c,
                                        MemberType__c, member__c, CancellationDate__c, MembershipEndDate__c, 
                                        MembershipStartDate__c,MembershipStopDate__c, Classification__c 
                                        FROM wb_MemberHistory__c where member__c =:MemberID
                                        order by id desc ];

        if (theContractedMembersFamily != null) {
            system.debug(theContractedMembers.size() + ',' + theContractedMembersFamily.size());
            ContractedMembersPage = new wb_utility_datapaging(theContractedMembers, theContractedMembersFamily);
        } else {
            system.debug(theContractedMembers.size());
             ContractedMembersPage = new wb_utility_datapaging(theContractedMembers, null);
            //ContractedMembersPage = new wb_utility_datapaging(theContractedMembers);
        }
    }
    public string theHighlightedMember {get; set;}
    public void GetMemberHistory(){
        List<wb_MemberHistory__c> theHistory = new List<wb_MemberHistory__c>();
        if (theHighlightedMember.length() > 0){
            //boolean found = false;
            wb_Member__c theMember;
            for ( integer i = 0; i < theContractedMembers.size(); i++ ){
                if ( theContractedMembers[i].MembershipDetail__r.MemberNo__c == theHighlightedMember){
                    theMember =  theContractedMembers[i];
                    i = theContractedMembers.size();
                }
            }
            for (wb_MemberHistory__c h:theContractedMemberHistories){
                if(h.member__c == theMember.id)
                    theHistory.add(h);
            }
            
        }
        
         ContractedMemberHistoryPage = new wb_utility_datapaging(theHistory);
    }
    
}