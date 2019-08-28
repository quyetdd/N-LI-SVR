public class wb_MemberInfo_HealthCheck {
    private ApexPages.StandardController standardController;
    public MemberInfo__c MemberInfo {get;set;}
    public boolean 	Healthcheck_NOT_WB_Editable {get;set;}
    public boolean 	EditMode {get;set;}
    public wb_MemberInfo_HealthCheck(ApexPages.StandardController stdController){
        this.standardController = stdController;
        MemberInfo = (MemberInfo__c) stdController.getRecord();
        MemberInfo = [select Id, KinmuCompany__r.PersonalInfoDisclosure__c, 
                      CompanyKeiyakuNo__r.KeiyakuCompanyName__r.PersonalInfoDisclosure__c,
                      Healthcheck_NOT_WB__c
                      from MemberInfo__c
                      where Id =: MemberInfo.id];
        if (//MemberInfo.CompanyKeiyakuNo__r.KeiyakuCompanyName__r.PersonalInfoDisclosure__c == true ||
            MemberInfo.KinmuCompany__r.PersonalInfoDisclosure__c == true )
            {
                Healthcheck_NOT_WB_Editable = true;
            }
        else {
            Healthcheck_NOT_WB_Editable = false;
        }
        
          EditMode = false;
    }
    public void Edit(){
        EditMode = true;
    }
    public void View(){
        UpdateMemberInfo();
        EditMode = false;
    }
    
    public void UpdateMemberInfo(){
        if (MemberInfo != null)
            update MemberInfo;
    }

}