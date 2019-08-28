public class wb_Individual_Member {
    
    private ApexPages.StandardController standardController;
    public wb_Individual__c Individual {get;set;}
    
    public List<wb_member__c> Member {get;set;}
    public List<wb_MemberHistory__c> MemberHistory {get;set;}
    
    public class MemberNo{
        string MemberNo {get; set;}
        date EndDate {get; set;}
        public MemberNo(string mn, date ed){
            MemberNo =mn;
            EndDate = ed;
        }
    }
    
    public class aRow{
        public wb_member__c theRow {get; set;}
        public List<wb_MemberHistory__c> theChild {get; set;}
        public string CurrentMemberNo {get; set;}
        public List<MemberNo> MyMemberNo {get; set;}
        public aRow( wb_member__c m, List<wb_MemberHistory__c> c ){
            theRow = m;
            theChild = new List<wb_MemberHistory__c>();
            theChild = c;
            fetchMyMemberNo();
        }
        
        public void fetchMyMemberNo(){
            system.debug('fetchMyMemberNo');
            MyMemberNo = new List<MemberNo>();
            for (wb_MemberHistory__c c:theChild){
                if (MyMemberNo.size() == 0) {
                    MyMemberNo.add( new MemberNo(c.MemberNo__c, c.MembershipEndDate__c));
                }
                else {
                    boolean Add2List = false;
                    for (integer i = 0; i < MyMemberNo.size() && Add2List == false; i++ ){
                        if ( MyMemberNo[i].EndDate <  c.MembershipEndDate__c ){
                            MyMemberNo.add(i,new MemberNo(c.MemberNo__c, c.MembershipEndDate__c) );
                            Add2List = true;
                        } 
                    }
                    if (Add2List == false){
                         MyMemberNo.add(new MemberNo(c.MemberNo__c, c.MembershipEndDate__c) );
                    }
                }
            }
            if (MyMemberNo.size() > 0 ) {
                CurrentMemberNo = MyMemberNo[0].MemberNo;
            	system.debug(MyMemberNo.size() + ':' + MyMemberNo[0].MemberNo);
            }
        }
	
    }
    
    public List<aRow> theList {get;set;}
    
    public wb_Individual_Member(ApexPages.StandardController stdController){
        this.standardController = stdController;
        Individual = (wb_Individual__c) stdController.getRecord();
        Member = [select id, Name, WorkingCompany__c, MembershipDetail__c, EndDate__c 
                  from wb_member__c where Individual__c =:Individual.id];
        List<Id> MemId = new List<Id>();
        for (wb_member__c m:Member){
            MemId.add(m.id);
        }
        
        MemberHistory = [ SELECT member__c, MemberType__c, MemberNo__c, MembershipEndDate__c, MembershipStartDate__c 
                         FROM wb_MemberHistory__c 
                         where member__c =:MemId];
        
        theList = new List<aRow>();
        
        for (wb_member__c m:Member){
            List<wb_MemberHistory__c> ch = new  List<wb_MemberHistory__c>();
            for ( wb_MemberHistory__c mh:MemberHistory){
                if ( mh.member__c == m.id)
                    ch.add(mh);
            }
            theList.add(new aRow(m,ch));
           // theList[theList.size()-1].fetchMyMemberNo();
        }

    }

}