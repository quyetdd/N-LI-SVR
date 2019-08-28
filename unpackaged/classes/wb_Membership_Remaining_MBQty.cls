public class wb_Membership_Remaining_MBQty {
    public id ContractCompanyId {get; set;}
    public Account ContractCompany {get; set;}
    public Id CallerRowID {get; set;}
    public integer CallerRowIndex {get; set;}
    public List<wb_MembershipDetail__c> theMDs {get; set;}
    
    public wb_Membership_Remaining_MBQty(){
      
    }
    
    public void getURLparameters(){
        
        if (apexpages.currentpage() != null ) {
            if (apexpages.currentpage().getparameters().get('pv0') !='')
                CallerRowID = apexpages.currentpage().getparameters().get('pv0');
            if (apexpages.currentpage().getparameters().get('pv1') !='')
                CallerRowIndex = integer.valueof(apexpages.currentpage().getparameters().get('pv1'));
            if (apexpages.currentpage().getparameters().get('pv2') != '') {
                ContractCompanyId = apexpages.currentpage().getparameters().get('pv2');
                ContractCompany = [select id, name, ParentId from Account where id=:ContractCompanyId];
            }
        }
        
        GetRemainingMBQty();
    }
    
    public wb_Membership_Remaining_MBQty(List<string> theMembershipID){
        List<Id> MSId = new  List<Id>();
        for (string s:theMembershipID){
            MSId.add(s);
        }
        theMDs = new list<wb_MembershipDetail__c>();            
        theMDs = [SELECT Quantity__c, MembershipStartDate__c, MembershipEndDate__c, 
                  Service__c, Membership__c, Membership__r.name, Type__c, SecondType__c, ParentDetail__c,
                  Membership__r.ContractCompany__r.name,name
                  FROM wb_MembershipDetail__c
                  where Membership__c=:MSId
                  and  Membership__r.Status__c ='確定' and Type__c = '入会金'
                  order by Membership__r.name, Type__c ];
        
        CalculateMBQty();
    }
    
    public List<RemainingMBQty> theRemainingMBQty {get; set;}
    
    public class  RemainingMBQty {
        public boolean IsSelected {get; set;}
        public Id ID {get; set;}
        public string Name {get; set;}
        public string Type {get; set;}
        public string StartDate {get; set;}
        public string EndDate {get; set;}
        public integer Qty {get; set;}
        public string ContractCompName {get; set;}
       /* public integer SingleQty {get; set;}
        public integer FamilyQty {get; set;}
        public integer CardHolderQty {get; set;} */
        public integer UsedQty {get; set;}
        public integer TransInQty {get; set;}
        public integer TransOutQty {get; set;}
        public integer RemainQty {get; set;}
        public integer TransferQty {get; set;}
       
        
        public RemainingMBQty( Id theId, string theName, string theType, date theStartDate, date theEndDate, integer theQty, string theContractCompName){
            ID = theId;
            Name = theName;
            Type = theType;
            if ( theStartDate != null)
                StartDate = theStartDate.format();
            if ( theEndDate != null )
                EndDate = theEndDate.format();
            Qty = theQty;
            IsSelected = false;
            ContractCompName = theContractCompName;
           /* SingleQty = 0;
            FamilyQty=0;
            CardHolderQty=0; */
            UsedQty=0;
            TransInQty = 0;
            TransOutQty = 0;
            //RemainQty = 0;
        }
        
        public void fetchTransferQty(){
            if ( TransferQty == null )
                TransferQty = RemainQty;
        }
        
        public void fetchRemainQty(){
             integer q = 0;
            if ( Qty != null ) q = Qty ;
            
             RemainQty = q +  TransInQty +
                //SingleQty + FamilyQty +  CardHolderQty +
                 UsedQty +
                 TransOutQty;
        }
    }
    

    public void GetRemainingMBQty(){
        
        List<Id> Ids = new List<Id>();
        Ids.add(ContractCompany.Id);
        if (ContractCompany.ParentId != null)
            Ids.add(ContractCompany.ParentId);
        
        for( Account c:[Select Id, Name From Account where ParentId=:ContractCompany.Id])
        {
            Ids.add(c.Id);
        }
        theMDs = new list<wb_MembershipDetail__c>();            
        theMDs = [SELECT Quantity__c, MembershipStartDate__c, MembershipEndDate__c, 
                                           Service__c, Membership__c, Membership__r.name, Type__c, SecondType__c, ParentDetail__c,
                                            Membership__r.ContractCompany__r.name, name
                                           FROM wb_MembershipDetail__c
                                           where Membership__r.ContractCompany__c=:Ids
                                           and  Membership__r.Status__c ='確定' and Type__c = '入会金'
                                           order by Membership__r.name, Type__c ];
        
       CalculateMBQty();
    }
    
    public void CalculateMBQty(){
        theRemainingMBQty = new List<RemainingMBQty>();
        integer i;
        
        List<wb_MembershipDetail__c> MsP = new List<wb_MembershipDetail__c>();
        List<wb_MembershipDetail__c> MsC = new List<wb_MembershipDetail__c>();
        for ( wb_MembershipDetail__c d:theMDs){
            if (d.ParentDetail__c == null )
                MsP.add(d);
            else
                MsC.add(d);
        }
        
        for ( wb_MembershipDetail__c p:MsP){
            theRemainingMBQty.add( new RemainingMBQty(p.ID,
                                                      p.Name,
                                                      p.Type__c,
                                                      p.MembershipStartDate__c,
                                                      p.MembershipEndDate__c,
                                                      integer.valueof(p.Quantity__c),
                                                      p.Membership__r.ContractCompany__r.name)
                                                     );
            integer Idx = theRemainingMBQty.size() -1;
            for (wb_MembershipDetail__c c:MsC){
                if ( c.ParentDetail__c == p.id){
                /*    if ( c.SecondType__c=='単身')
                        theRemainingMBQty[idx].SingleQty += integer.valueof(c.Quantity__c);
                    if ( c.SecondType__c=='家族')
                        theRemainingMBQty[idx].FamilyQty += integer.valueof(c.Quantity__c);
                    if ( c.SecondType__c=='無記名')
                        theRemainingMBQty[idx].CardHolderQty += integer.valueof(c.Quantity__c); */
                    if ( c.SecondType__c=='IN')
                        theRemainingMBQty[idx].TransInQty += integer.valueof(c.Quantity__c);
                    else if ( c.SecondType__c=='OUT')
                        theRemainingMBQty[idx].TransOutQty += integer.valueof(c.Quantity__c);
                    else 
                         theRemainingMBQty[idx].UsedQty += integer.valueof(c.Quantity__c);
                }
            }
            
           // integer q = 0;
           // if ( theRemainingMBQty[idx].Qty != null ) q = theRemainingMBQty[idx].Qty ;
            
             theRemainingMBQty[idx].fetchRemainQty();
        }
            
    
    }
 
}