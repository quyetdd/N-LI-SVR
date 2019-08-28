public class wb_Individual_Membership {
    private ApexPages.StandardController standardController;
    public wb_Individual__c theIndividual {get;set;}
    
    public List<wb_Member__c> theMembers {get; set;}
    public wb_utility_datapaging MembersPage {get; set;}
    
    public List<wb_MemberHistory__c> theMemberHistories {get; set;}
    //public List<wb_MemberHistory__c> MemberHistories {get; set;}
    public wb_utility_datapaging MemberHistoryPage {get; set;}
    public boolean effective  {get; set;}     
    public wb_Individual_Membership(ApexPages.StandardController stdController){
        this.standardController = stdController;
        theIndividual = (wb_Individual__c) stdController.getRecord();
        system.debug('theIndividual:' + theIndividual.id);
        /*
        AggregateResult[] MemberEffectiveness = [SELECT  member__r.name memseq, MembershipDetail__r.name conseq, f_effectiveness__c, count(Id)
                                                 FROM wb_MemberHistory__c 
                                                 where  member__r.Individual__c =:theIndividual.Id and f_effectiveness__c = true
                                                 and ReplacedWith__c = null
                                                 group by member__r.name, MembershipDetail__r.name, f_effectiveness__c ];
   
      */
            
        theMembers = [SELECT id, Name,  WorkingCompany__c, WorkingCompany__r.name, f_ContractCompany__c, 
                      MembershipDetail__r.Membership__r.ContractCompany__c,
                      Individual__c, Old_MemberNo__c,
                      Individual__r.name, MembershipDetail__c, 
                      f_MemberNo__c, r_EffectiveUntil__c, f_Classification__c,
                      MembershipDetail__r.Type__c, 
                      MembershipDetail__r.Membership__r.Id, MembershipDetail__r.Membership__r.name,
                      MembershipDetail__r.MembershipEndDate__c,
                      MembershipDetail__r.MemberNo__c
                      FROM wb_Member__c
                      where MembershipDetail__r.Membership__r.Status__c ='確定' and
                      Individual__c =:theIndividual.Id];
        
        MembersPage = new wb_utility_datapaging(theMembers);
        
        List<Id> MemberID = new List<Id>();
        for ( wb_Member__c m:theMembers){
            MemberID.add(m.id);
        }
        if (MemberID.size() > 0)
            
            theMemberHistories = [SELECT MemberNo__c, Name, MembershipDetail__c, 
                                  MembershipDetail__r.MembershipPlan__c, MembershipDetail__r.Type__c,
                                  MemberType__c, member__c, CancellationDate__c, MembershipEndDate__c, 
                                  MembershipStartDate__c,MembershipStopDate__c, Classification__c 
                                  FROM wb_MemberHistory__c where member__c =:MemberID
                                  order by id desc ];
        
        List<wb_MemberHistory__c> theHistory = new List<wb_MemberHistory__c>();
        if (theMembers.size() > 0  ) {
            for (wb_MemberHistory__c h:theMemberHistories){
                if(h.member__c == theMembers[0].id)
                    theHistory.add(h);
            }
        }
         MemberHistoryPage = new wb_utility_datapaging(theHistory);
    }
    //theHighlightedMember
    public string theHighlightedMember {get; set;}
    public void GetMemberHistory(){
        system.debug(theHighlightedMember +',' + theMembers.size());
        List<wb_MemberHistory__c> theHistory = new List<wb_MemberHistory__c>();
        if (theHighlightedMember.length() > 0){
            //boolean found = false;
            wb_Member__c theMember;
            for ( integer i = 0; i < theMembers.size(); i++ ){
                if ( theMembers[i].name == theHighlightedMember){
                    theMember =  theMembers[i];
                    i = theMembers.size();
                }
            }
            
            if (theMember != null ) {
                system.debug(theMember);
                for (wb_MemberHistory__c h:theMemberHistories){
                    if(h.member__c == theMember.id)
                        theHistory.add(h);
                }
            }
        }
        
        MemberHistoryPage = new wb_utility_datapaging(theHistory);
    }
    
}