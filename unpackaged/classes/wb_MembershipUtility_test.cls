@isTest
public class wb_MembershipUtility_test {
    
    @isTest static void test1(){
        List<wb_MembershipDetail__c> MembershipDetailsParent = new List<wb_MembershipDetail__c>();
        List<wb_MembershipDetail__c> MembershipDetailsChild  = new List<wb_MembershipDetail__c>();
        
        MembershipDetailsParent.add( 
            new wb_MembershipDetail__c(Classification__c='移行', Name='1', Quantity__c=1, Service__c='a0L5D0000000LYjUAM', Type__c='家族', MembershipPlan__c='Global Plus Member', MemberName__c='八木　浩道'));
        
        MembershipDetailsParent.add( 
            new wb_MembershipDetail__c(Classification__c='移行', Name='3', Quantity__c=1, Service__c='a0L5D0000000LYjUAM', Type__c='家族', MembershipPlan__c='Global Plus Member', MemberName__c='松村　浩夫'));
        
        
        MembershipDetailsChild.add(
            new wb_MembershipDetail__c(Name='1', ParentDetail__c=null,  MemberName__c='八木　美佐代', Type__c='家族', Classification__c='移行')
        );
        
        MembershipDetailsChild.add(
            new wb_MembershipDetail__c(Name='3', ParentDetail__c=null,  MemberName__c='松村　実憂', Type__c='家族', Classification__c='移行')
        );
        
        MembershipDetailsChild.add(
            new wb_MembershipDetail__c(Name='3', ParentDetail__c=null,  MemberName__c='松村　杷奈', Type__c='家族', Classification__c='移行')
        );
        
        MembershipDetailsChild.add(
            new wb_MembershipDetail__c(Name='3', ParentDetail__c=null,  MemberName__c='松村　玲子', Type__c='家族', Classification__c='移行')
        );

            
        List<wb_MembershipUtility.ChildIndex> Parent_CIndx = new List<wb_MembershipUtility.ChildIndex>();
        
        wb_MembershipUtility Helper = new wb_MembershipUtility();
        
        Parent_CIndx = Helper.bulidChildIndex(MembershipDetailsParent,MembershipDetailsChild);
        
        system.debug(MembershipDetailsParent);
        system.debug(MembershipDetailsChild);
        system.debug(Parent_CIndx);
        
        
    }

}