public class wb_AccountMembershipPanel {
    private ApexPages.StandardController standardController;
    public Account theAccount {get; set;}
    public wb_AccountMembershipPanel(ApexPages.StandardController stdController){
        this.standardController = stdController;
        theAccount = (Account) stdController.getRecord();
    }
    
}