public class wb_FamilyInfo_HealthCheck {
    private ApexPages.StandardController standardController;
    public FamilyInfo__c FamilyInfo {get;set;}
    public boolean 	Healthcheck_NOT_WB_Editable {get;set;}
    public boolean 	EditMode {get;set;}
    public wb_FamilyInfo_HealthCheck(ApexPages.StandardController stdController){
        this.standardController = stdController;
        FamilyInfo = (FamilyInfo__c) stdController.getRecord();
        FamilyInfo = [select Id, MemberShimei__r.KinmuCompany__r.PersonalInfoDisclosure__c, 
                      MemberShimei__r.CompanyKeiyakuNo__r.KeiyakuCompanyName__r.PersonalInfoDisclosure__c,
                      Healthcheck_NOT_WB__c
                      from FamilyInfo__c
                      where Id =: FamilyInfo.id];
        if (//FamilyInfo.MemberShimei__r.CompanyKeiyakuNo__r.KeiyakuCompanyName__r.PersonalInfoDisclosure__c == true ||
            FamilyInfo.MemberShimei__r.KinmuCompany__r.PersonalInfoDisclosure__c == true )
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
        UpdateFamilyInfo();
        EditMode = false;
    }
    
    public void UpdateFamilyInfo(){
        if (FamilyInfo != null)
            update FamilyInfo;
    }


}