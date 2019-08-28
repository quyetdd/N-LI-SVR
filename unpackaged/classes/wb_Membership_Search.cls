public class wb_Membership_Search {
    string theID { get; set; }
    public string theReplaceeID { get; set; }
    public string theReplaceeIdx { get; set; }
    public string theOption { get; set; }
    public class aSelectableRow {
        public Boolean IsSelected { get; set; }
        public integer Index { get; set; }
        public wb_MembershipDetail__c theRow  { get; set; }
        
        public aSelectableRow(wb_MembershipDetail__c row, integer i){
            theRow = row;
            Index = i;
        }
    }
    
    public List<aSelectableRow> ReplacementList  { get; set; }
    
    public  wb_Membership_Search(){
        theID = ApexPages.currentPage().getParameters().get('Id');
        theReplaceeID = ApexPages.currentPage().getParameters().get('pv0');
        theReplaceeIdx = ApexPages.currentPage().getParameters().get('pv1');
        theOption = ApexPages.currentPage().getParameters().get('pv2');
    }
    
    public void getReplacementList(){
        List<wb_MembershipDetail__c> theList;
        if (theOption =='Cancellation') {
            List<wb_MembershipDetail__c> UsedList = [select PreviousRecord__c                                                   
                                                     from wb_MembershipDetail__c 
                                                     where Membership__c =:theID
                                                     and PreviousRecord__c != null];
            List<Id> UsedID = new List<Id>();
			for (wb_MembershipDetail__c l:UsedList)
                UsedID.add(l.PreviousRecord__c);
            
             theList = [select id, name, Individual__c, Individual__r.name, MembershipStopDate__c
                                                    from wb_MembershipDetail__c 
                                                    where Membership__c =:theID
                                                    and PreviousRecord__c = null and MembershipStopDate__c != null
                                                    and Individual__c != null and ParentDetail__c = null
                                                    and PendingAction__c = null and Id !=:UsedID ];
            
        } else {
            theList = [select id, name, Individual__c, Individual__r.name, MembershipStopDate__c 
                                                    from wb_MembershipDetail__c 
                                                    where Membership__c =:theID
                                                    and PreviousRecord__c = null and MembershipStopDate__c = null
                                                    and Individual__c != null and ParentDetail__c = null
                                                    and PendingAction__c = null];
        }
        ReplacementList = new List<aSelectableRow>();
        for (wb_MembershipDetail__c l:theList){
            ReplacementList.add( new aSelectableRow(l,ReplacementList.size()) );
        }
    }

}