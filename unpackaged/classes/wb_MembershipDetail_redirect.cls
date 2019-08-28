public class wb_MembershipDetail_redirect {
    ApexPages.StandardController stdController;
    public wb_MembershipDetail__c wb_MembershipDetail {get;set;}
    public wb_MembershipDetail_redirect(ApexPages.StandardController stdController){
        this.stdController = stdController;
        wb_MembershipDetail = (wb_MembershipDetail__c) stdController.getRecord();
        wb_MembershipDetail = [select id, Membership__c from wb_MembershipDetail__c where id =: wb_MembershipDetail.id ];
    }
    
    public PageReference redirect() {
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        
        return new PageReference(sfdcBaseURL+'/apex/wb_Membership_View?Id=' + wb_MembershipDetail.Membership__c);
    }

}