trigger wb_MemberHistoryEffectiveUntil on wb_MemberHistory__c (before insert, before update) {

    if (Trigger.isInsert)
    {
        for(wb_MemberHistory__c newMemberHistory : Trigger.new)
        { 
            if ( newMemberHistory.ReplacedWith__c == null ) {
                if (newMemberHistory.MembershipStopDate__c == null) {
                    newMemberHistory.EffectiveUntil__c = newMemberHistory.MembershipEndDate__c;  
                } else {
                    newMemberHistory.EffectiveUntil__c = newMemberHistory.MembershipStopDate__c;  
                }
            } else {
                newMemberHistory.EffectiveUntil__c = null;
            }
            //insert newMemberHistory;
        }
    }
    
    if (Trigger.isUpdate)
    {
        for(wb_MemberHistory__c updatedMemberHistory : Trigger.new)
        { 
            if ( updatedMemberHistory.ReplacedWith__c == null ) {
                if (updatedMemberHistory.MembershipStopDate__c == null) {
                    updatedMemberHistory.EffectiveUntil__c = updatedMemberHistory.MembershipEndDate__c;  
                } else {
                    updatedMemberHistory.EffectiveUntil__c = updatedMemberHistory.MembershipStopDate__c;  
                }
            } else {
                updatedMemberHistory.EffectiveUntil__c = null;
            }
            //update updatedMemberHistory;
        }
    }

}