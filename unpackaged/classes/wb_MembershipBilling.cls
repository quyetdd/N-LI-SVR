global with sharing class wb_MembershipBilling {
   
    private Id MyID;
    
    public List<MDContractBilling> MDContractBillingList;
    
    public class MDContractBilling{
        String MembershipContractID {get; set;}
        Id ServiceID {get; set;}
        String MDPlan {get; set;}
        Decimal Amount {get; set;}
        public MDContractBilling(string c, Id e, string b, decimal p){
            this.MembershipContractID =c;
            this.ServiceID = e;
            this.MDPlan =b;
            this.Amount =p;
        }
    }
    
    public boolean CheckReadiness(ID md_id){
          if(  [SELECT id
              FROM wb_MembershipDetail__c
              where Membership__c=:md_id
              and ParentDetail__c = null 
              and Type__c = '仮名'].size() == 0 )
            return true;
        else
            return false;
    }
    /*
    public boolean ConfirmAndBilling(ID md_id){
        
        if (md_id != null) {
            SavePoint sp = Database.setSavepoint();
            try {
                wb_Membership__c Membership = [select id, Status__c, Name, ContractCountry__c, ContractCompany__c, ContractDistrict__c, 
                                               ContractDate__c, Currency__c, BillingCompany__c
                                               from wb_Membership__c where id =:md_id];
                List<wb_MembershipDetail__c> MembershipDetail = [SELECT Id, Name, MembershipEndDate__c, MembershipStartDate__c,
                                                                 individual__c, MemberNo__c, WorkingCompany__c, Membership__c,Type__c, MembershipPlan__c,
                                                                 Service__r.CardPrefix__c, Service__r.DataType__c, 
                                                                 WorkingCompany__r.CountryCd__c, 
                                                                 Individual__r.FamilyNo__c,
                                                                 Quantity__c,ParentDetail__c,PreviousRecord__c,PendingAction__c,Classification__c
                                                                 FROM wb_MembershipDetail__c
                                                                 where Membership__c =:Membership.id
                                                                 order by id
                                                                ];
                boolean status = Billing(Membership, MembershipDetail,null);
                if (status == false) {
                    Database.rollBack(sp);
                    return false;
                } else
                    return true;
                
            } catch(Exception e) {
                Database.rollBack(sp);
                return false;
            }
            
        } else {
            return false;
        }
           
    }
   */
    public boolean CheckAdmissionBalance(List<wb_MembershipDetail__c> MD_All){
        
        List<wb_MembershipDetail__c> MDAdmissionfeePrnt = new List<wb_MembershipDetail__c>();
        List<wb_MembershipDetail__c> MDAdmissionfeeChd = new List<wb_MembershipDetail__c>();
        
        for ( wb_MembershipDetail__c  a:MD_All ){
            if ( a.Type__c == '入会金') {
                if ( a.ParentDetail__c == null)
                    MDAdmissionfeePrnt.add(a);
                else
                    MDAdmissionfeeChd.add(a);  
            }
        }
        

        for (wb_MembershipDetail__c p:MDAdmissionfeePrnt ){
            if (p.Quantity__c == null)  p.Quantity__c= 0;
            for (wb_MembershipDetail__c c:MDAdmissionfeeChd ){
                if ( c.ParentDetail__c == p.id)
                    p.Quantity__c = p.Quantity__c + c.Quantity__c;
            }
        }
        
        for (integer i = MDAdmissionfeePrnt.size() - 1; i >= 0; i -- ){
            if ( MDAdmissionfeePrnt[i].Quantity__c <=0)
                MDAdmissionfeePrnt.remove(i);
            
        }
        
        integer AvailbleAdmissionQty = 0;
        for ( wb_MembershipDetail__c a:MDAdmissionfeePrnt)
            AvailbleAdmissionQty = AvailbleAdmissionQty + Integer.valueOf(a.Quantity__c);
        integer AdditionalMemberQty = 0;
        
        for (  wb_MembershipDetail__c d:MD_All) {
            
            system.debug(d);
            
            if ( d.PreviousRecord__c == null &&
                d.ParentDetail__c == null && d.PendingAction__c !='解約' && d.Classification__c !='継続' && d.Classification__c !='移行'
                && ( d.Type__c == '単身' ||  d.Type__c == '家族' ||  d.Type__c == '無記名') )
                AdditionalMemberQty = AdditionalMemberQty + Integer.valueOf(d.Quantity__c);
        }
        
        system.debug(AvailbleAdmissionQty +','+ AdditionalMemberQty);
        
        if ( AvailbleAdmissionQty  < AdditionalMemberQty){
            system.debug('Membership Fee not enough:'+ AvailbleAdmissionQty + '<' + AdditionalMemberQty );
            return false;  
        } else
            return true;
        
    }

    public List<wb_MembershipDetail__c> MDAdmissionfeeParent {get; set;}
    public List<wb_MembershipDetail__c> MDAdmissionfeeChild {get; set;}
    
    // For Normal Contracts
    public boolean ConfirmAndBillingRow(ID md_id){
        
         if (md_id != null) {
             
            SavePoint sp = Database.setSavepoint();
             
            try {
                
                wb_Membership__c Membership = [select id, Status__c, Name, ContractCountry__c, ContractCompany__c, ContractDistrict__c, 
                                               ContractDate__c, Currency__c, BillingCompany__c
                                               from wb_Membership__c where id =:md_id];
               // system.Debug(Membership);
                
                List<wb_MembershipDetail__c> MembershipDetail = [SELECT Id, Name, MembershipEndDate__c, MembershipStartDate__c,
                                                                 individual__c, MemberNo__c, WorkingCompany__c, Membership__c,Type__c, MembershipPlan__c,
                                                                 Service__r.CardPrefix__c, Service__r.DataType__c, 
                                                                 WorkingCompany__r.CountryCd__c, 
                                                                 Individual__r.FamilyNo__c,
                                                                 Quantity__c,ParentDetail__c,PreviousRecord__c,PendingAction__c,Classification__c,
                                                                 BillingAmount__c, Member__c
                                                                 FROM wb_MembershipDetail__c
                                                                 where Membership__c =:Membership.id 
                                                                 order by id
                                                                ];
                
                
                List<wb_MembershipDetail__c> MembershipDetailNew = new  List<wb_MembershipDetail__c>();
                
                for ( wb_MembershipDetail__c d:MembershipDetail ){
                    if (d.Classification__c == '新規')
                        MembershipDetailNew.add(d);
                }
                
                boolean Admissionbalance = CheckAdmissionBalance(MembershipDetailNew);     
                system.debug('Admissionbalance:' + Admissionbalance);
                if (Admissionbalance == false) { 
                    Database.rollBack(sp);
                    return false;
                }
                
                MDAdmissionfeeParent = new List<wb_MembershipDetail__c>();
                MDAdmissionfeeChild = new List<wb_MembershipDetail__c>();
                
                // Separate and group Records 
                for ( wb_MembershipDetail__c  a:MembershipDetail ){
                    if ( a.Type__c == '入会金') {
                        
                        wb_MembershipDetail__c ca = new wb_MembershipDetail__c();
                        ca = a.clone(true);
                        
                        if ( a.ParentDetail__c == null) {
                            MDAdmissionfeeParent.add(ca);
                        }
                        else{
                            MDAdmissionfeeChild.add(ca);  
                        }
                    }
                    
                }
                
                for (wb_MembershipDetail__c p:MDAdmissionfeeParent ){
                    //if ( a.Quantity__c != null) MembershipFeeQty += integer.valueof(a.Quantity__c);
                    for (wb_MembershipDetail__c c:MDAdmissionfeeChild ){
                        if ( c.ParentDetail__c == p.id)
                            p.Quantity__c = p.Quantity__c + c.Quantity__c;
                    }
                }
                
                for (integer i = MDAdmissionfeeParent.size() - 1; i >= 0; i -- ){
                    if ( MDAdmissionfeeParent[i].Quantity__c <=0)
                        MDAdmissionfeeParent.remove(i);
                }
                
                
                if (MembershipDetail.size() > 0) {
                   // system.debug('Call BillingAdmissionAndMemberPlan');
                    boolean status = BillingAdmissionAndMemberPlan(Membership, MembershipDetail);
                    if ( status == true) {
                        
                        Membership.Status__c = '確定';
                        update Membership;
                      //  system.debug(Membership);
                        return true;
                        
                    }
                    else {
                        Database.rollBack(sp);
                        return false;  
                    }
               } 
                else
                    return false;
                

                
            } catch(Exception e) {
                Database.rollBack(sp);
                return false;
            }
            
        } else {
            return false;
        }
    }
    // For Amendmenet
    // 
    public boolean ConfirmAndBillingPendingRow(ID md_id, wb_MembershipDetail__c PerviousRow, wb_MembershipDetail__c PendingRow, set<string> CompanySet ){
        theCompanySet = CompanySet;
        return ConfirmAndBillingPendingRow( md_id,PerviousRow, PendingRow);
    }
    
    public set<string> theCompanySet {get;set;}
    public boolean ConfirmAndBillingPendingRow(ID md_id, wb_MembershipDetail__c PerviousRow, wb_MembershipDetail__c PendingRow){
      
        wb_Membership__c Membership = [select id, Status__c, Name, ContractCountry__c, ContractCompany__c, ContractDistrict__c, 
                                       ContractDate__c, Currency__c, BillingCompany__c
                                       from wb_Membership__c where id =:md_id];
        
        List<wb_MembershipDetail__c> MembershipAdmissionfeeP = new List<wb_MembershipDetail__c>();
        List<wb_MembershipDetail__c> MembershipAdmissionfeeC = new List<wb_MembershipDetail__c>();
        if (PerviousRow != null) system.debug(PerviousRow);
        if (PendingRow != null) system.debug(PendingRow);
        if (PendingRow.Classification__c =='追加' && (PendingRow.Type__c == '家族' || PendingRow.Type__c == '単身')) {
            
            List<wb_MembershipDetail__c> MDMembershipAdmissionfeeALL = [SELECT Id, Name, MembershipEndDate__c, MembershipStartDate__c,
                                                                        individual__c, MemberNo__c, WorkingCompany__c, Membership__c,Type__c, MembershipPlan__c,
                                                                        Service__r.CardPrefix__c, Service__r.DataType__c, 
                                                                        WorkingCompany__r.CountryCd__c, 
                                                                        Individual__r.FamilyNo__c,
                                                                        Quantity__c,ParentDetail__c,PreviousRecord__c, MembershipStopDate__c
                                                                        FROM wb_MembershipDetail__c
                                                                        where Membership__c =:Membership.id 
                                                                        and PendingAction__c = null and Type__c = '入会金'
                                                                        order by id
                                                                       ];
            
            
            for ( wb_MembershipDetail__c  a:MDMembershipAdmissionfeeALL ){
                
                if ( a.ParentDetail__c == null)
                    MembershipAdmissionfeeP.add(a);
                else
                    MembershipAdmissionfeeC.add(a);  
                
                
            }
            
            for (wb_MembershipDetail__c p:MembershipAdmissionfeeP ){
                //if ( a.Quantity__c != null) MembershipFeeQty += integer.valueof(a.Quantity__c);
                for (wb_MembershipDetail__c c:MembershipAdmissionfeeC ){
                    if ( c.ParentDetail__c == p.id)
                        p.Quantity__c = p.Quantity__c + c.Quantity__c;
                }
            }
            
            for (integer i = MembershipAdmissionfeeP.size() - 1; i >= 0; i -- ){
                if ( MembershipAdmissionfeeP[i].Quantity__c <=0)
                    MembershipAdmissionfeeP.remove(i);
                
            }
            
            //system.debug( MembershipAdmissionfeeP );
        }
        
        
		List<wb_MembershipDetail__c> PendingMembershipDetail;
        if (PerviousRow != null && PendingRow !=null ) 
        {
            if (PendingRow.Id != null) {
                PendingMembershipDetail = [SELECT Id, Name, MembershipEndDate__c, MembershipStartDate__c,
                                           individual__c, MemberNo__c, WorkingCompany__c, Membership__c,Type__c, MembershipPlan__c,
                                           Service__r.CardPrefix__c, Service__r.DataType__c, 
                                           WorkingCompany__r.CountryCd__c, 
                                           Individual__r.FamilyNo__c,
                                           Quantity__c, ParentDetail__c,PreviousRecord__c, PendingAction__c, MembershipStopDate__c,
                                           Classification__c,BillingAmount__c, BalanceAmount__c, Member__c, Amount__c
                                           FROM wb_MembershipDetail__c
                                           where ( Id =:PerviousRow.id or ParentDetail__c=:PerviousRow.id ) or
                                           ( Id =:PendingRow.id or ParentDetail__c=:PendingRow.id )
                                           order by id];
            } else {
                PendingMembershipDetail = [SELECT Id, Name, MembershipEndDate__c, MembershipStartDate__c,
                                           individual__c, MemberNo__c, WorkingCompany__c, Membership__c,Type__c, MembershipPlan__c,
                                           Service__r.CardPrefix__c, Service__r.DataType__c, 
                                           WorkingCompany__r.CountryCd__c, 
                                           Individual__r.FamilyNo__c,
                                           Quantity__c, ParentDetail__c,PreviousRecord__c, PendingAction__c, MembershipStopDate__c,
                                           Classification__c,BillingAmount__c, BalanceAmount__c, Member__c, Amount__c
                                           FROM wb_MembershipDetail__c
                                           where ( Id =:PerviousRow.id or ParentDetail__c=:PerviousRow.id ) 
                                           order by id];
                
                PendingMembershipDetail.add(PendingRow);
            }
        }
        else if ( PendingRow !=null )
            if (PendingRow.id != null) {
                PendingMembershipDetail = [SELECT Id, Name, MembershipEndDate__c, MembershipStartDate__c,
                                           individual__c, MemberNo__c, WorkingCompany__c, Membership__c,Type__c, MembershipPlan__c,
                                           Service__r.CardPrefix__c, Service__r.DataType__c, 
                                           WorkingCompany__r.CountryCd__c, 
                                           Individual__r.FamilyNo__c,
                                           Quantity__c, ParentDetail__c,PreviousRecord__c, PendingAction__c, MembershipStopDate__c,
                                           Classification__c,BillingAmount__c, BalanceAmount__c, Member__c, Amount__c
                                           FROM wb_MembershipDetail__c
                                           where 
                                           ( Id =:PendingRow.id or ParentDetail__c=:PendingRow.id )
                                           order by id];
            } else {
                insert PendingRow;
                PendingMembershipDetail = [SELECT Id, Name, MembershipEndDate__c, MembershipStartDate__c,
                                           individual__c, MemberNo__c, WorkingCompany__c, Membership__c,Type__c, MembershipPlan__c,
                                           Service__r.CardPrefix__c, Service__r.DataType__c, 
                                           WorkingCompany__r.CountryCd__c, 
                                           Individual__r.FamilyNo__c,
                                           Quantity__c, ParentDetail__c,PreviousRecord__c, PendingAction__c, MembershipStopDate__c,
                                           Classification__c,BillingAmount__c, BalanceAmount__c, Member__c, Amount__c
                                           FROM wb_MembershipDetail__c
                                           where 
                                           ( Id =:PendingRow.id or ParentDetail__c=:PendingRow.id )
                                           order by id];
                
            }

        
        boolean status;
  
        SavePoint sp = Database.setSavepoint();
        
        
        if ( PendingRow.PendingAction__c =='解約'){
           // system.debug(PendingMembershipDetail);
            status = BillingCancellation(Membership,PendingMembershipDetail);
           // system.debug(status);
        } else if (PendingRow.Classification__c =='交替'){
           // system.debug(PendingMembershipDetail);
            status = BillingReplacement(Membership,PendingMembershipDetail);
           // system.debug(status);
        } else if (PendingRow.Classification__c =='変更'){
           // system.debug(PendingMembershipDetail);
         /*   List<wb_MembershipDetail__c> BillingRows = new List<wb_MembershipDetail__c>();
            for (wb_MembershipDetail__c p:PendingMembershipDetail){
                if ( p.PendingAction__c =='確認'){
                    BillingRows.add(p);
                }
            }*/
            status = BillingChanges(Membership,PendingMembershipDetail,theCompanySet);
           // system.debug(status);
        } else if (PendingRow.Classification__c =='追加' && PendingRow.Type__c=='入会金'){
           // system.debug(PendingMembershipDetail);
            status = BillingAdmissionFee(Membership,PendingMembershipDetail);
           // system.debug(status);
        } else if (PendingRow.Classification__c =='追加' && ( PendingRow.Type__c =='単身' || PendingRow.Type__c =='家族' ) ){
         //   system.debug(PendingMembershipDetail);
            List<wb_MembershipDetail__c> AdmissionfeeC = new List<wb_MembershipDetail__c>();
            for (wb_MembershipDetail__c p:MembershipAdmissionfeeP ){
                for (wb_MembershipDetail__c c:MembershipAdmissionfeeC ){
                    if ( c.ParentDetail__c == p.id)
                        AdmissionfeeC.add(c);
                }
            }
          //  system.debug(AdmissionfeeC);
            status = BillingAdditionalMember(Membership, MembershipAdmissionfeeP, AdmissionfeeC ,PendingMembershipDetail);
           // system.debug(status);
        } else if (PendingRow.Classification__c =='解約変更' ){
            List<wb_MembershipDetail__c> BillingRows = new List<wb_MembershipDetail__c>();
            for (wb_MembershipDetail__c p:PendingMembershipDetail){
                if (p.Classification__c =='解約変更' && p.PendingAction__c =='確認'){
                    BillingRows.add(p);
                }
            }
            status = BillingCancellationChange(Membership,BillingRows);
        }
        
        if (status == true){
            try
            { 
                if(PerviousRow != null) {
                    PerviousRow.PendingAction__c = null;
                    //system.debug(PerviousRow);
                    update PerviousRow;
                }
                if(PendingRow != null) {  
                    PendingRow.PendingAction__c = null;
                    //system.debug(PendingRow);
                    update PendingRow; 
                }
            }
            catch(Exception e)
            {
                Database.rollBack(sp);
                // PopupMessage = e.getMessage();
                return false;
            }
            return true;
            
        } else {
            Database.rollBack(sp);
            return status;
        }
        

        
    }
    

    public boolean BillingAdmissionAndMemberPlan(wb_Membership__c MH,  List<wb_MembershipDetail__c> MD_ALL){
        SavePoint sp = Database.setSavepoint();
        try
        {
            //  Admission Fee Billing
            List<MDContractBilling>  BillingList = new List<MDContractBilling>();
           
            
            List<wb_MembershipDetail__c> AdmissionfeeCNew = new  List<wb_MembershipDetail__c>();
            List<wb_MembershipDetail__c> AdmissionMembers = new List<wb_MembershipDetail__c>();
            
            for (wb_MembershipDetail__c m:MD_ALL) {
                if (m.ParentDetail__c == null  && ( m.Type__c == '単身' ||  m.Type__c == '家族' ||  m.Type__c == '無記名')) 
                    AdmissionMembers.add(m);
            }
            
           // system.debug(AdmissionMembers);
            
          //  system.debug('MembershipAdmissionfeeParent:' + MDAdmissionfeeParent.size());
            
            for (wb_MembershipDetail__c AdmP:MDAdmissionfeeParent ){
                integer thisBal = 0;
                integer subnumber = 1;
                if ( AdmP.Quantity__c != null) thisBal = integer.valueof(AdmP.Quantity__c);
                
                for (wb_MembershipDetail__c c:MDAdmissionfeeChild){
                    if ( c.ParentDetail__c == AdmP.id)  {
                        //thisBal += integer.valueof(c.Quantity__c);
                        subnumber ++;
                    }
                }
                // To register the Addmission Fee for Each Member
                for (integer i = AdmissionMembers.size() - 1; i >= 0 && thisBal > 0 ; i -- ){
                    //     if (AdmissionMembers[i].PendingAction__c != '解約') {
                    if ( AdmissionMembers[i].PreviousRecord__c == null) 
                    { 
                        
                        wb_MembershipDetail__c nd = new wb_MembershipDetail__c(name = AdmP.name + '-' + subnumber,
                                                                               Membership__c= AdmP.Membership__c, ParentDetail__c=AdmP.id,
                                                                               Individual__c= AdmissionMembers[i].Individual__c,
                                                                               WorkingCompany__c = AdmissionMembers[i].WorkingCompany__c,
                                                                               Quantity__c= - AdmissionMembers[i].Quantity__c,
                                                                               Type__c = '入会金', 
                                                                               SecondType__c= AdmissionMembers[i].Name
                                                                              );
                        AdmissionfeeCNew.add(nd);
                        
                        wb_MembershipDetail__c ca = new wb_MembershipDetail__c();
                        ca = nd.clone(false);
                        MDAdmissionfeeChild.add(ca);
                        
                        thisBal = thisBal - integer.valueOf( AdmissionMembers[i].Quantity__c);
                        AdmP.Quantity__c = decimal.valueof( integer.valueof(AdmP.Quantity__c) 
                                                           - integer.valueOf(AdmissionMembers[i].Quantity__c));
                        // AdditionalMemberQty = AdditionalMemberQty - integer.valueOf(AdmissionMembers[i].Quantity__c);
                        
                        AdmissionMembers.remove(i);
                        subnumber ++;
                    }
                    // }
                }
            } 
            
            
            
            List<Id> IndID = new List<ID>();
           // List<Id> MDIDs = new List<ID>();
            
            for ( wb_MembershipDetail__c md:MD_ALL){
                if (md.individual__c != null)
                    IndID.add(md.individual__c);
              //  MDIDs.add(md.Id);
            }
            
            // All Individuals involved
            List<wb_Individual__c> IndListALL = [SELECT Id,// CurrentMemberNo__c, 
                                               //  MembershipEndDate__c, MembershipStartDate__c , //Classification__c,
                                                 FamilyNo__c,
                                                 Member__c,
                                                 Old_Id__c
                                                 FROM wb_Individual__c where Id  =:IndID ];
            // Membership of Individuals
            List<wb_member__c> MemberList = [select id, Name, Individual__c, WorkingCompany__c, EndDate__c, MembershipDetail__c,
                                             AdmissionFee__c, Old_MemberNo__c
                                             from wb_member__c where Individual__c =:IndID ];
            

            List<wb_MembershipDetail__c> FamilyMDList = new List<wb_MembershipDetail__c>();
            List<wb_MembershipDetail__c> MemberMDList = new List<wb_MembershipDetail__c>();
            List<wb_MembershipDetail__c> CardHolderList = new List<wb_MembershipDetail__c>();
 			List<wb_MembershipDetail__c> CardHolderDetail = new List<wb_MembershipDetail__c>();
            
            // Separate the Members, Families and Card Holder
            for ( wb_MembershipDetail__c  a:MD_ALL ){
                if ( a.Service__r.DataType__c =='単身' || a.Service__r.DataType__c =='家族') {
                    if ( a.ParentDetail__c == null)
                        MemberMDList.add(a);
                    else
                        FamilyMDList.add(a);   
                } else if (a.Service__r.DataType__c =='無記名' ) {
                    if ( a.ParentDetail__c == null)
                    	CardHolderList.add(a);
                    else 
                        CardHolderDetail.add(a);
                }
            }
            
            List<wb_MemberHistory__c> MemberHistory = new List<wb_MemberHistory__c>();
            
            for ( wb_MembershipDetail__c mb:MemberMDList) {
                boolean found = false;
                wb_member__c theMember;
                
                
                for (integer i=0; i<MemberList.size() && found == false ; i++){
                    if ( MemberList[i].Individual__c == mb.individual__c && 
                        MemberList[i].WorkingCompany__c == mb.WorkingCompany__c ){
                            found = true;
                            theMember = MemberList[i];
                        }
                }
                
                if ( found == true){
                    
                    string MemberNo; // = m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCd__c + theMember.name + '0';
                    if ( theMember.Old_MemberNo__c == null)
                        MemberNo = mb.Service__r.CardPrefix__c + mb.WorkingCompany__r.CountryCd__c + theMember.name + '0';
                    else
                        MemberNo = mb.Service__r.CardPrefix__c + mb.WorkingCompany__r.CountryCd__c + theMember.Old_MemberNo__c + '0';
                    
                    MemberHistory.add( new wb_MemberHistory__c(
                        member__c   = theMember.id,
                        MemberNo__c = MemberNo,
                        MembershipDetail__c = mb.id,
                        MembershipEndDate__c = mb.MembershipEndDate__c,
                        MembershipStartDate__c = mb.MembershipStartDate__c,
                        Classification__c = mb.Classification__c
                    ));
                    
                    theMember.MembershipDetail__c=mb.id;
                    mb.MemberNo__c = MemberNo; 
                    
                }
                
            }
            
            // CardHolder History
          
            for ( wb_MembershipDetail__c c:CardHolderDetail)
            
             MemberHistory.add(new wb_MemberHistory__c(
                            member__c   = c.member__c,
                            MemberNo__c =  c.MemberNo__c,
                            MembershipDetail__c = c.id,
                            MembershipEndDate__c = c.MembershipEndDate__c,
                            MembershipStartDate__c = c.MembershipStartDate__c,
                            Classification__c = c.Classification__c
                        ));
            
            //  Billing the Member Plan
      
            List<wb_ReceivableServiceFee__c> Billing = new List<wb_ReceivableServiceFee__c>();
            
            List<Id> MD_All_Id = new List<Id>();
            for (wb_MembershipDetail__c md:MD_ALL ) { MD_All_Id.add(md.id);}
            AggregateResult[] AgR = [SELECT Membership__c,  Service__c, MembershipPlan__c, sum(BillingAmount__c)
                                     FROM wb_MembershipDetail__c
                                     where Id=:MD_All_Id and ParentDetail__c = null
                                     group by Membership__c, Service__c, MembershipPlan__c]; 
           // system.debug('AgR:' + AgR.size());
            for (AggregateResult SalesList : AgR) { 
                BillingList.add(new MDContractBilling(String.valueOf(SalesList.get('Membership__c')),
                                                                (Id) (SalesList.get('Service__c')),  
                                                                String.valueOf(SalesList.get('MembershipPlan__c')),  
                                                                (Decimal) SalesList.get('expr0')));
            }
           // system.debug('MDContractBillingList:' + BillingList.size());
            for (MDContractBilling BList : BillingList) { 
                wb_ReceivableServiceFee__c NewBilling = new wb_ReceivableServiceFee__c( Classification__c= '会員',
                                                                                       Date__c=date.today(), Membership__c=MH.id, 
                                                                                       Country__c = MH.ContractCountry__c, District__c = MH.ContractDistrict__c,
                                                                                       Service__c = BList.ServiceID,
                                                                                       ServiceName__c = BList.MDPlan, Currency__c = MH.Currency__c,
                                                                                       ServiceAmount__c = BList.Amount,
                                                                                       InvoicingCompany__c = MH.BillingCompany__c ); 
                Billing.add(NewBilling);
            }
            
            
            insert AdmissionfeeCNew;
            //system.debug(AdmissionfeeCNew);
            
            List<wb_Member__c> MembersUpd = new List<wb_Member__c>();
            for ( wb_MembershipDetail__c na:AdmissionfeeCNew){
                for (integer i = 0; i < MemberList.size(); i ++){
                    if (MemberList[i].Individual__c == na.Individual__c &&
                        MemberList[i].WorkingCompany__c == na.WorkingCompany__c ) {
                            MemberList[i].AdmissionFee__c = na.id;
                            MembersUpd.add(MemberList[i]);
                            i = MemberList.size();
                        }
                }
            }
          //  system.debug(MembersUpd);
            if (MembersUpd.size() > 0)
                update MembersUpd;
            
            update MD_ALL;
            insert MemberHistory;
           // system.debug(Billing);
            insert Billing;
            return true;
            
        }
        catch(Exception e)
        {
            Database.rollBack(sp);
            // PopupMessage = e.getMessage();
            return false;
        }
        
    }
    

    
    /*
    public boolean Billing(wb_Membership__c MH, List<wb_MembershipDetail__c> MD_ALL, List<wb_MembershipDetail__c> MD_AdmissionFeeBalance){
		
        
        //system.debug('Billing:' + MH.id + ',' + MD_ALL.size());
        
        Date d;
        // Today as billing date
        d = date.today();
        List<MDContractBilling> MDContractBillingList;
        
        
        List<wb_MembershipDetail__c> MembershipAdmissionfeeP = new List<wb_MembershipDetail__c>();
        List<wb_MembershipDetail__c> MembershipAdmissionfeeC = new List<wb_MembershipDetail__c>();
        List<wb_MembershipDetail__c> MembershipAdmissionfeeCNew = new List<wb_MembershipDetail__c>();
        List<wb_MembershipDetail__c> MembershipDetailList_Member = new List<wb_MembershipDetail__c>();
        List<wb_MembershipDetail__c> MembershipDetailList_MemberAdmission = new List<wb_MembershipDetail__c>();
        List<wb_MembershipDetail__c> FamilyMembershipDetailList = new List<wb_MembershipDetail__c>();
        List<wb_MembershipDetail__c> MembershipDetailList_Holder = new List<wb_MembershipDetail__c>();
        // Separate and group Records 
        for ( wb_MembershipDetail__c  a:MD_ALL ){
            if ( a.Type__c == '入会金') {
                if ( a.ParentDetail__c == null)
                    MembershipAdmissionfeeP.add(a);
                else
                    MembershipAdmissionfeeC.add(a);  
            }
            else if ( a.Service__r.DataType__c =='単身' || a.Service__r.DataType__c =='家族') {
                if ( a.ParentDetail__c == null) {
                    MembershipDetailList_Member.add(a);
                    MembershipDetailList_MemberAdmission.add(a);
                }
                else
                    FamilyMembershipDetailList.add(a);   
            }
            else if ( a.Service__r.DataType__c =='無記名' )
                MembershipDetailList_Holder.add(a);
        }
        
        integer MembershipFeeQty = 0;
        integer SingleMemberQty = 0;
        integer FamilyMemberQty = 0;
        integer CardHolderQty = 0;
        if (MembershipAdmissionfeeP.size() == 0)
            MembershipAdmissionfeeP = MD_AdmissionFeeBalance;
       // system.debug('MembershipAdmissionfeeP' + MembershipAdmissionfeeP);
        for (wb_MembershipDetail__c a:MembershipAdmissionfeeP ){
            if ( a.Quantity__c != null) MembershipFeeQty += integer.valueof(a.Quantity__c);
        }
        for (wb_MembershipDetail__c a:MembershipAdmissionfeeC ){
            MembershipFeeQty += integer.valueof(a.Quantity__c);
        }
        for (wb_MembershipDetail__c m:MembershipDetailList_MemberAdmission ){
            if (m.PendingAction__c != '解約') {
                if (m.Type__c == '単身' && m.PreviousRecord__c == null) { SingleMemberQty += integer.valueof(m.Quantity__c);}
                else if (m.Type__c == '家族' && m.PreviousRecord__c == null) { FamilyMemberQty += integer.valueof(m.Quantity__c);}
            }
        }
        for (wb_MembershipDetail__c a:MembershipDetailList_Holder ){
            if (a.PendingAction__c != '解約') 
            CardHolderQty += integer.valueof(a.Quantity__c);
        }
        // To deduce the Membership Fee 
        if ( MembershipFeeQty  < SingleMemberQty + FamilyMemberQty + CardHolderQty){
           // system.debug('Membership Fee not enough:'+ MembershipFeeQty + '<' + SingleMemberQty + '+' + FamilyMemberQty + '+' + CardHolderQty  );
            return false;  
        } 
        else {
            
            for (wb_MembershipDetail__c p:MembershipAdmissionfeeP ){
                integer thisBal = 0;
                integer subnumber = 1;
                if ( p.Quantity__c != null) thisBal = integer.valueof(p.Quantity__c);
                for (wb_MembershipDetail__c c:MembershipAdmissionfeeC){
                    if ( c.ParentDetail__c == p.id)  thisBal += integer.valueof(c.Quantity__c);
                    subnumber ++;
                }
                
                if ( thisBal > 0 && SingleMemberQty > 0) {
                    if (thisBal >= SingleMemberQty){
                    
                        for (integer i = MembershipDetailList_MemberAdmission.size() - 1; i >= 0; i -- ){
                            if (MembershipDetailList_MemberAdmission[i].PendingAction__c != '解約') {
                                if (MembershipDetailList_MemberAdmission[i].Type__c == '単身' && MembershipDetailList_MemberAdmission[i].PreviousRecord__c == null) 
                                { 
                                    //SingleMemberQty += integer.valueof(m.Quantity__c);
                                     wb_MembershipDetail__c nd = new wb_MembershipDetail__c(name = p.name + '-' + subnumber,
                                                                               Membership__c= p.Membership__c, ParentDetail__c=p.id,
                                                                               Individual__c= MembershipDetailList_MemberAdmission[i].Individual__c,
                                                                               Quantity__c= - MembershipDetailList_MemberAdmission[i].Quantity__c,
                                                                               Type__c = '入会金', SecondType__c= MembershipDetailList_MemberAdmission[i].Name);
                                    MembershipAdmissionfeeCNew.add(nd);
                                    subnumber ++;
                                    MembershipDetailList_MemberAdmission.remove(i);
                                }
                            }
                        }
                        
                       // MembershipAdmissionfeeCNew.add(nd);
                        thisBal = thisBal - SingleMemberQty;
                       // subnumber ++;
                    } else
                    {
                  
                        
                        for (integer i = MembershipDetailList_MemberAdmission.size() - 1; i >= 0 && thisBal > 0 ; i -- ){
                            if (MembershipDetailList_MemberAdmission[i].PendingAction__c != '解約') {
                                if (MembershipDetailList_MemberAdmission[i].Type__c == '単身' && MembershipDetailList_MemberAdmission[i].PreviousRecord__c == null) 
                                { 
                                    //SingleMemberQty += integer.valueof(m.Quantity__c);
                                    wb_MembershipDetail__c nd = new wb_MembershipDetail__c(name = p.name + '-' + subnumber,
                                                                                           Membership__c= p.Membership__c, ParentDetail__c=p.id,
                                                                                           Individual__c= MembershipDetailList_MemberAdmission[i].Individual__c,
                                                                                           Quantity__c= - MembershipDetailList_MemberAdmission[i].Quantity__c,
                                                                                           Type__c = '入会金', SecondType__c= MembershipDetailList_MemberAdmission[i].Name);
                                    MembershipAdmissionfeeCNew.add(nd);
                                    
                                    thisBal = thisBal - integer.valueOf( MembershipDetailList_MemberAdmission[i].Quantity__c);
                                    SingleMemberQty = SingleMemberQty - integer.valueOf(MembershipDetailList_MemberAdmission[i].Quantity__c);
                                    
                                    MembershipDetailList_MemberAdmission.remove(i);
                                    subnumber ++;
                                }
                            }
                        }
                        
                        
                       // MembershipAdmissionfeeCNew.add(nd);
                      //  SingleMemberQty = SingleMemberQty - thisBal;
                      //  thisBal = 0;
                    //    subnumber ++;
                    }
                }
                
                if ( thisBal > 0 && FamilyMemberQty > 0 ) {
                    if (thisBal >= FamilyMemberQty){
                 
                        for (integer i = MembershipDetailList_MemberAdmission.size() - 1; i >= 0; i -- ){
                            if (MembershipDetailList_MemberAdmission[i].PendingAction__c != '解約') {
                                if (MembershipDetailList_MemberAdmission[i].Type__c == '家族' && MembershipDetailList_MemberAdmission[i].PreviousRecord__c == null) 
                                { 
                                    //SingleMemberQty += integer.valueof(m.Quantity__c);
                                    wb_MembershipDetail__c nd = new wb_MembershipDetail__c(name = p.name + '-' + subnumber,
                                                                                           Membership__c= p.Membership__c, ParentDetail__c=p.id,
                                                                                           Individual__c= MembershipDetailList_MemberAdmission[i].Individual__c,
                                                                                           Quantity__c= - MembershipDetailList_MemberAdmission[i].Quantity__c,
                                                                                           Type__c = '入会金', SecondType__c= MembershipDetailList_MemberAdmission[i].Name);
                                    MembershipAdmissionfeeCNew.add(nd);     
                                    MembershipDetailList_MemberAdmission.remove(i);
                                    subnumber ++;
                                }
                            }
                        }
                        
                      //  MembershipAdmissionfeeCNew.add(nd);
                        thisBal = thisBal - FamilyMemberQty;
                    //    subnumber ++;
                    } else
                    {
                 
                        for (integer i = MembershipDetailList_MemberAdmission.size() - 1; i >= 0 && thisBal > 0 ; i -- ){
                            if (MembershipDetailList_MemberAdmission[i].PendingAction__c != '解約') {
                                if (MembershipDetailList_MemberAdmission[i].Type__c == '家族' && MembershipDetailList_MemberAdmission[i].PreviousRecord__c == null) 
                                { 
                                    //SingleMemberQty += integer.valueof(m.Quantity__c);
                                    wb_MembershipDetail__c nd = new wb_MembershipDetail__c(name = p.name + '-' + subnumber,
                                                                                           Membership__c= p.Membership__c, ParentDetail__c=p.id,
                                                                                           Individual__c= MembershipDetailList_MemberAdmission[i].Individual__c,
                                                                                           Quantity__c= - MembershipDetailList_MemberAdmission[i].Quantity__c,
                                                                                           Type__c = '入会金', SecondType__c= MembershipDetailList_MemberAdmission[i].Name);
                                    MembershipAdmissionfeeCNew.add(nd);
                                    
                                    thisBal = thisBal - integer.valueOf( MembershipDetailList_MemberAdmission[i].Quantity__c);
                                    FamilyMemberQty = FamilyMemberQty - integer.valueOf(MembershipDetailList_MemberAdmission[i].Quantity__c);
                                    
                                    MembershipDetailList_MemberAdmission.remove(i);
                                    subnumber ++;
                                }
                            }
                        }
                      //  MembershipAdmissionfeeCNew.add(nd);
                     //   FamilyMemberQty = FamilyMemberQty - thisBal;
                      //  thisBal = 0;
                     //   subnumber ++;
                    }
                }
                
                if ( thisBal > 0 && CardHolderQty > 0 ) {
                    if (thisBal >= CardHolderQty){
                        wb_MembershipDetail__c nd = new wb_MembershipDetail__c(name =p.name + '-' + subnumber,
                                                                               Membership__c= p.Membership__c, ParentDetail__c=p.id,
                                                                               Quantity__c=-CardHolderQty,
                                                                               Type__c = '入会金', SecondType__c='無記名');
                        MembershipAdmissionfeeCNew.add(nd);
                        thisBal = thisBal - CardHolderQty;
                          subnumber ++;
                    } else
                    {
                        wb_MembershipDetail__c nd = new wb_MembershipDetail__c(name =p.name + '-' + subnumber, Membership__c= p.Membership__c, ParentDetail__c=p.id,
                                                                               Quantity__c=-thisBal,
                                                                               Type__c = '入会金', SecondType__c='無記名');
                        MembershipAdmissionfeeCNew.add(nd);
                        CardHolderQty = CardHolderQty - thisBal;
                        thisBal = 0;
                         subnumber ++;
                    }
                }
            }
            
        }
        
        List<Id> IndID = new List<ID>();
        
        for ( wb_MembershipDetail__c md:MD_ALL){
            if (md.individual__c != null)
                IndID.add(md.individual__c);
        }
        
        List<wb_Individual__c> IndListALL = [SELECT Id, CurrentMemberNo__c, MembershipEndDate__c, MembershipStartDate__c , //Classification__c, 
                                             FamilyNo__c,
                                             Old_Id__c
                                             FROM wb_Individual__c where Id  =:IndID ];
        
        List<wb_member__c> MemberList = [select id, Name, Individual__c, WorkingCompany__c, EndDate__c, MembershipDetail__c,
                                         Old_MemberNo__c
                                         from wb_member__c where Individual__c =:IndID ];
        List<wb_member__c> NewMemberList = new List<wb_member__c>(); 
        
        for (wb_MembershipDetail__c m : MembershipDetailList_Member) { 
            
            wb_Individual__c theInd;
            for (integer i=0; i <IndListALL.size(); i++ ){
                if (IndListALL[i].id == m.Individual__c )
                    theInd = IndListALL[i];
            }
            

            boolean found = false;
            wb_member__c theMember;
            
            
            for (integer i=0; i<MemberList.size() && found == false ; i++){
                if ( MemberList[i].Individual__c == m.individual__c && MemberList[i].WorkingCompany__c == m.WorkingCompany__c ){
                    found = true;
                    theMember = MemberList[i];
                }
            }
            
            if ( found == true){
                
                string MemberNo; // = m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCd__c + theMember.name + '0';
                if ( theMember.Old_MemberNo__c == null)
                    MemberNo = m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCd__c + theMember.name + '0';
                else
                    MemberNo = m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCd__c + theMember.Old_MemberNo__c + '0';
                
                insert new wb_MemberHistory__c(
                    member__c   = theMember.id,
                    MemberNo__c = MemberNo,
                    MembershipDetail__c = m.id,
                    MembershipEndDate__c = m.MembershipEndDate__c,
                    MembershipStartDate__c = m.MembershipStartDate__c,
                    Classification__c = m.Classification__c
                );
                
                theMember.MembershipDetail__c=m.id;
               // theMember.EndDate__c = m.MembershipEndDate__c;
               // theInd.CurrentMemberNo__c = MemberNo; 
                m.MemberNo__c = MemberNo; 
                
            }
            
            // For Family Plan, generate the Member Number for the family members
            if  (  m.Service__r.DataType__c =='家族' && found == true ) {
                
                string FamilyMemberNo; // =  m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCd__c +  theMember.name ;
                if ( theMember.Old_MemberNo__c == null)
                    FamilyMemberNo =  m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCd__c +  theMember.name ;
                else
                    FamilyMemberNo =  m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCd__c +  theMember.Old_MemberNo__c ;
                
                for ( wb_MembershipDetail__c f:FamilyMembershipDetailList){
                    if ( f.ParentDetail__c ==m.id ){
                        f.MemberNo__c = FamilyMemberNo + f.Individual__r.FamilyNo__c;
                        
                        for (wb_Individual__c fi:IndListALL){
                            if ( fi.id == f.Individual__c ) {
                                fi.CurrentMemberNo__c = FamilyMemberNo + fi.FamilyNo__c;
                                fi.MembershipStartDate__c = m.MembershipStartDate__c;
                                fi.MembershipEndDate__c = m.MembershipEndDate__c;
                              //  fi.Classification__c = '会員家族';
                            }
                        }
                    }                
                }
                
            } 
            
        }
        
        for (wb_MembershipDetail__c m:MembershipDetailList_Holder)
        { 
            for ( integer i=0; i < m.Quantity__c; i++ ){

                NewMemberList.add(new wb_member__c(
                    Individual__c   =  null,
                    WorkingCompany__c = m.WorkingCompany__c,
                    MembershipDetail__c=m.id 
                    // EndDate__c = m.MembershipEndDate__c
                ));
            }
            
 
        }
       
        if ( NewMemberList.size() > 0) {
            insert NewMemberList;
        
        List<Id> NMID = new List<ID>();
        for ( wb_member__c m:NewMemberList){
            NMID.add(m.id);
        }
        
            NewMemberList = [select id, Name, Individual__c, WorkingCompany__c, MembershipDetail__c
                             from wb_member__c where id=:NMID ];
        }
        
        List<wb_MemberHistory__c> NewMemberHis = new List<wb_MemberHistory__c>();
        List<wb_MembershipDetail__c> CardHolders = new List<wb_MembershipDetail__c>();
        
        for ( wb_member__c nm:NewMemberList){
            if ( nm.Individual__c != null){  // for Real Name Memebrs
                   for (wb_MembershipDetail__c m : MembershipDetailList_Member) { 
                       if ( nm.MembershipDetail__c == m.id){
                           string fno;
                           if ( m.ParentDetail__c == null)
                               fno = '0';
                           else
                               fno = m.Individual__r.FamilyNo__c;
                           m.MemberNo__c = m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCd__c + nm.name + fno;
                      
                           NewMemberHis.add( new wb_MemberHistory__c(
                               member__c   = nm.id,
                               MemberNo__c =  m.MemberNo__c,
                               MembershipDetail__c = m.id,
                               MembershipEndDate__c = m.MembershipEndDate__c,
                               MembershipStartDate__c = m.MembershipStartDate__c,
                               Classification__c = m.Classification__c
                           ));
                            // Update CurrentMemberNo__c
                           for ( integer i=0 ; i < IndListALL.size(); i++){
                               if ( IndListALL[i].id == nm.Individual__c ){
                                   IndListALL[i].CurrentMemberNo__c =  m.MemberNo__c;
                                   IndListALL[i].MembershipStartDate__c = m.MembershipStartDate__c;
                                   IndListALL[i].MembershipEndDate__c = m.MembershipEndDate__c;
                                  // IndListALL[i].Classification__c = '会員';
                                   i = IndListALL.size();
                               }
                           }
                           // For Family Plan, generate the Member Number for the family members
                           if  (  m.Service__r.DataType__c =='家族'  ) {
                               
                               string FamilyMemberNo =  m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCd__c +  nm.name ;
                               
                               for ( wb_MembershipDetail__c f:FamilyMembershipDetailList){
                                   if ( f.ParentDetail__c ==m.id ){
                                       f.MemberNo__c = FamilyMemberNo + f.Individual__r.FamilyNo__c;
                                       
                                       for (wb_Individual__c fi:IndListALL){
                                           if ( fi.id == f.Individual__c ) {
                                               fi.CurrentMemberNo__c = f.MemberNo__c;
                                               fi.MembershipStartDate__c = m.MembershipStartDate__c;
                                               fi.MembershipEndDate__c = m.MembershipEndDate__c;
                                               //fi.Classification__c = '会員家族';
                                           }
                                       }
                                   }                
                               }
                               
                           } 
                           
                       }
                   }
                
            } else
            {
                for ( wb_MembershipDetail__c m:MembershipDetailList_Holder){
                    if ( nm.MembershipDetail__c == m.id) {
                        
                        string MemberNo = m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCd__c + nm.name + '0';
                     
                        CardHolders.add(  new wb_MembershipDetail__c(Name= m.Name, 
                                                                     WorkingCompany__c = m.WorkingCompany__c,
                                                                     Type__c = m.Type__c,
                                                                     MemberNo__c = MemberNo,
                                                                     Membership__c = m.Membership__c,
                                                                     Service__c = m.Service__c,
                                                                     MembershipPlan__c = m.MembershipPlan__c,
                                                                     MembershipStartDate__c = m.MembershipStartDate__c,
                                                                     MembershipEndDate__c = m.MembershipEndDate__c,
                                                                     ParentDetail__c = m.id
                                                                    )
                                       );
                        //m.MemberNo__c =m.Service__r.CardPrefex__c + m.WorkingCompany__r.CountryCd__c + nm.name + '0';
                        NewMemberHis.add(new wb_MemberHistory__c(
                            member__c   = nm.id,
                            MemberNo__c =  MemberNo,
                            MembershipDetail__c = m.id,
                            MembershipEndDate__c = m.MembershipEndDate__c,
                            MembershipStartDate__c = m.MembershipStartDate__c,
                            Classification__c = m.Classification__c
                        ));
                    }
                }
            }
        }
        
        if ( CardHolders.size() > 0){
            for ( wb_MembershipDetail__c m:MembershipDetailList_Holder ){
                integer i = 0;
                for (wb_MembershipDetail__c c:CardHolders ){
                    if ( c.ParentDetail__c == m.id){
                        i++;
                        c.Name = c.Name + '-' + i;
                    }
                }
            }
            insert CardHolders;
        }

        
        
        // Get and Insert the Billing according to the Contract Detail
        MDContractBillingList = new List<MDContractBilling>();
        List<Id> MD_All_Id = new List<Id>();
        for (wb_MembershipDetail__c md:MD_ALL ) { MD_All_Id.add(md.id);}
        AggregateResult[] AgR = [SELECT Membership__c,  Service__c, MembershipPlan__c, sum(f_BillingAmount__c)
                                 FROM wb_MembershipDetail__c
                                 where Id=:MD_All_Id and ParentDetail__c = null
                                 group by Membership__c, Service__c, MembershipPlan__c]; 
       // system.debug('AgR:' + AgR.size());
        for (AggregateResult SalesList : AgR) { 
            MDContractBillingList.add(new MDContractBilling(String.valueOf(SalesList.get('Membership__c')),
                                                            (Id) (SalesList.get('Service__c')),  
                                                            String.valueOf(SalesList.get('MembershipPlan__c')),  
                                                            (Decimal) SalesList.get('expr0')));
        }
       // system.debug('MDContractBillingList:' + MDContractBillingList.size());
        for (MDContractBilling BList : MDContractBillingList) { 
            wb_ReceivableServiceFee__c NewBilling = new wb_ReceivableServiceFee__c( Classification__c= '会員',
                                                                                   Date__c=d, Membership__c=MH.id, 
                                                                                   Country__c = MH.ContractCountry__c, District__c = MH.ContractDistrict__c,
                                                                                   Service__c = BList.ServiceID,
                                                                                   ServiceName__c = BList.MDPlan, Currency__c = MH.Currency__c,
                                                                                   ServiceAmount__c = BList.Amount,
                                                                                   InvoicingCompany__c = MH.BillingCompany__c );                                                                                
            
            try{
                insert NewBilling;
            } catch (System.QueryException e){
                
             //   System.debug(e);
                return false;
            }
        }
        
        MH.Status__c = '確定';
        
        try{
            update MH;
            if ( MembershipAdmissionfeeCNew.size() > 0)
                insert MembershipAdmissionfeeCNew;
            if ( NewMemberHis.size() > 0 )
                insert NewMemberHis;
            update MemberList;
            update MembershipDetailList_Holder;
            update MembershipDetailList_Member;
            update FamilyMembershipDetailList;
            update IndListALL;
            
        } catch (System.QueryException e){
            //System.debug(e);
            return false;
        }
        
        return true;
    } 
  */
    
    public List<wb_Membership.PrevirousPendingRowPair> BillingPendingRowPair {get; set;}
    List<wb_MembershipDetail__c> MembershipAdmissionfeeParent {get; set;}
    List<wb_MembershipDetail__c> MembershipAdmissionfeeChild {get; set;}
    /*
    public boolean BillingPendingRowPairs(wb_Membership__c MH, List<wb_Membership.PrevirousPendingRowPair> PendingRowPair){
       // system.debug('BillingPendingRowPairs:');
        if (PendingRowPair.size() > 0 && MH != null) {
            
            wb_Membership__c Membership = [select id, Status__c, Name, ContractCountry__c, ContractCompany__c, ContractDistrict__c, 
                                           ContractDate__c, Currency__c, BillingCompany__c
                                           from wb_Membership__c where id =:MH.id];            
            
            SavePoint sp = Database.setSavepoint();
            try
            {
             	// Process Admission Fee              
                for ( wb_Membership.PrevirousPendingRowPair rp:PendingRowPair){
                    if ((rp.thePendingRow.Classification__c=='追加' && rp.thePendingRow.Type__c=='入会金' && rp.thePendingRow.PendingAction__c =='確認') && 
                        rp.thePreviousRow == null){
                            if (rp.thePendingRow.Classification__c =='追加' && rp.thePendingRow.Type__c=='入会金'){
                                //system.debug(PendingMembershipDetail);
                                List<wb_MembershipDetail__c> PendRow = new List<wb_MembershipDetail__c>();
                                PendRow.add(rp.thePendingRow);
                                boolean status = BillingAdmissionFee(Membership, PendRow);
                                if (status == true){
                                    rp.thePendingRow.PendingAction__c = null;
                                    update rp.thePendingRow;
                                } else {
                                    Database.rollBack(sp);
                                    return false;
                                }
                                    
                            }
                        }
                    
                }
             
                
                List<wb_MembershipDetail__c> MembershipDetail = [SELECT Id, Name, MembershipEndDate__c, MembershipStartDate__c,
                                                                 individual__c, MemberNo__c, WorkingCompany__c, Membership__c,Type__c, MembershipPlan__c,
                                                                 Service__r.CardPrefix__c, Service__r.DataType__c, 
                                                                 WorkingCompany__r.CountryCd__c, 
                                                                 Individual__r.FamilyNo__c,
                                                                 Quantity__c,ParentDetail__c,PreviousRecord__c,PendingAction__c,Classification__c,
                                                                 BillingAmount__c, Member__c
                                                                 FROM wb_MembershipDetail__c
                                                                 where Membership__c =:Membership.id
                                                                 and (((Type__c = '単身' or Type__c = '家族' or Type__c = '無記名')  and
                                                                     ((MembershipEndDate__c != null and PendingAction__c != null ) or
                                                                      MembershipEndDate__c = null )) 
                                                                      OR Type__c = '入会金')
                                                                 order by id
                                                                ];
               // system.debug(MembershipDetail);
                boolean Admissionbalance = CheckAdmissionBalance(MembershipDetail);     
               // system.debug('Admissionbalance:' + Admissionbalance);
                if (Admissionbalance == false) { 
                    Database.rollBack(sp);
                    return false;
                }
                
                 
                MembershipAdmissionfeeParent = new List<wb_MembershipDetail__c>();
                MembershipAdmissionfeeChild = new List<wb_MembershipDetail__c>();
                
                // Separate and group Admission Fee  
                for ( wb_MembershipDetail__c  a:MembershipDetail ){
                    if ( a.Type__c == '入会金') {
                        
                        wb_MembershipDetail__c ca = new wb_MembershipDetail__c();
                        ca = a.clone(true);
                        
                        if ( a.ParentDetail__c == null) {
                            MembershipAdmissionfeeParent.add(ca);
                        }
                        else{
                            MembershipAdmissionfeeChild.add(ca);  
                        }
                    }
                    
                }
                
                for (wb_MembershipDetail__c p:MembershipAdmissionfeeParent ){
                    //if ( a.Quantity__c != null) MembershipFeeQty += integer.valueof(a.Quantity__c);
                    for (wb_MembershipDetail__c c:MembershipAdmissionfeeChild ){
                        if ( c.ParentDetail__c == p.id)
                            p.Quantity__c = p.Quantity__c + c.Quantity__c;
                    }
                }
                
                for (integer i = MembershipAdmissionfeeParent.size() - 1; i >= 0; i -- ){
                    if ( MembershipAdmissionfeeParent[i].Quantity__c <=0)
                        MembershipAdmissionfeeParent.remove(i);
                }
                
               // system.debug(MembershipAdmissionfeeParent);
              //  system.debug(MembershipAdmissionfeeChild);
                
                List<wb_MembershipDetail__c> BillingPendingRow = new List<wb_MembershipDetail__c>();
                for ( wb_Membership.PrevirousPendingRowPair rp:PendingRowPair){
                    if (rp.thePendingRow.Classification__c =='追加' && ( rp.thePendingRow.Type__c =='単身' || rp.thePendingRow.Type__c =='家族' ) ){
                       // system.debug(PendingMembershipDetail);
        
                      //  system.debug(AdmissionfeeC);
                      
                        BillingPendingRow.add(rp.thePendingRow);
         
                    }
                }
                
                if (BillingPendingRow.size() > 0) {
               // system.debug('Call BillingAdditionalMember');
                boolean status = BillingAdditionalMember(Membership, BillingPendingRow);
               // boolean status = BillingAdditionalMember(Membership, 
               //                                          MembershipAdmissionfeeParent,
               //                                          MembershipAdmissionfeeChild,
               //                                          BillingPendingRow);
                    if ( status == true) {
                        for (wb_MembershipDetail__c nm:BillingPendingRow ) {
                            nm.PendingAction__c = null;}
                        update BillingPendingRow;
                    }
                    else {
                        Database.rollBack(sp);
                        return false;  
                    }
                }
                
                BillingPendingRow = new List<wb_MembershipDetail__c>();
                for ( wb_Membership.PrevirousPendingRowPair rp:PendingRowPair){
                    if (rp.thePendingRow.PendingAction__c =='解約'  ){
                        BillingPendingRow.add(rp.thePendingRow);
                    }
                }
                
                if (BillingPendingRow.size() > 0) {
                   // system.debug('Call BillingCancellation');
                    boolean status = BillingCancellation(Membership, 
                                                             BillingPendingRow);
                    if ( status == true) {
                        for (wb_MembershipDetail__c nm:BillingPendingRow ) {
                            nm.PendingAction__c = null;}
                        update BillingPendingRow;
                    }
                    else {
                        Database.rollBack(sp);
                        return false;  
                    }
                }
                
                BillingPendingRow = new List<wb_MembershipDetail__c>();
                for ( wb_Membership.PrevirousPendingRowPair rp:PendingRowPair){
                    if (rp.thePendingRow.Classification__c =='交替'  ){
                        BillingPendingRow.add(rp.thePreviousRow);
                        BillingPendingRow.add(rp.thePendingRow);
                    }
                }
                
                if (BillingPendingRow.size() > 0) {
                   // system.debug('Call BillingReplacement');
                    boolean status = BillingReplacement(Membership, 
                                                        BillingPendingRow);
                    if ( status == true) {
                        for (wb_MembershipDetail__c nm:BillingPendingRow ) {
                            nm.PendingAction__c = null;}
                        update BillingPendingRow;
                    }
                    else {
                        Database.rollBack(sp);
                        return false;  
                    }
                }
                    
                BillingPendingRow = new List<wb_MembershipDetail__c>();
                for ( wb_Membership.PrevirousPendingRowPair rp:PendingRowPair){
                    if (rp.thePendingRow.Classification__c =='変更'  ){
                        BillingPendingRow.add(rp.thePreviousRow);
                        BillingPendingRow.add(rp.thePendingRow);
                    }
                }
                
                if (BillingPendingRow.size() > 0) {
                  //  system.debug('Call BillingChanges');
                    boolean status = BillingChanges(Membership, 
                                                        BillingPendingRow, null);
                    if ( status == true) {
                        for (wb_MembershipDetail__c nm:BillingPendingRow ) {
                            nm.PendingAction__c = null;}
                        update BillingPendingRow;
                    }
                    else {
                        Database.rollBack(sp);
                        return false;  
                    }
                }
                    
                //update MD_ALL;
                //insert RefundAndBilling;
            }
            catch(Exception e)
            {
                Database.rollBack(sp);
                // PopupMessage = e.getMessage();
                return false;
            }
            
        }
        return true;
    }
    */
    public boolean BillingAdmissionFee(wb_Membership__c MH,  List<wb_MembershipDetail__c> MD_ALL){
        
  
      //  List<Id> MDIDs = new List<ID>();
        
        
        List<MDContractBilling>  MDContractRefundAndBillingList = new List<MDContractBilling>();
        // Perpare the Refund for Replacee & Billing for Replacer 
        for (wb_MembershipDetail__c m : MD_ALL){
            if ( m.Classification__c=='追加' && m.Type__c=='入会金' && m.PendingAction__c =='確認' ){
                MDContractRefundAndBillingList.add(new MDContractBilling(String.valueOf(m.Membership__c),
                                                                         (Id) (m.Service__c),  
                                                                          m.name + ':' + m.MembershipPlan__c +' ' + m.Type__c ,  
                                                                         (Decimal) m.BillingAmount__c));
            }
        }
        
        
        //  system.debug(MDContractRefundList);
        List<wb_ReceivableServiceFee__c> RefundAndBilling = new  List<wb_ReceivableServiceFee__c>();
        for (MDContractBilling RList : MDContractRefundAndBillingList) { 
            RefundAndBilling.add( new wb_ReceivableServiceFee__c( Classification__c= '会員',
                                                                 Date__c=system.today(), Membership__c=MH.id, 
                                                                 Country__c = MH.ContractCountry__c, District__c = MH.ContractDistrict__c,
                                                                 Service__c = RList.ServiceID,
                                                                 ServiceName__c = RList.MDPlan, Currency__c = MH.Currency__c,
                                                                 ServiceAmount__c =  RList.Amount,
                                                                 InvoicingCompany__c = MH.BillingCompany__c ));   
        }
        
        
        SavePoint sp = Database.setSavepoint();
        try
        {
            //update MD_ALL;
            insert RefundAndBilling;
        }
        catch(Exception e)
        {
            Database.rollBack(sp);
            // PopupMessage = e.getMessage();
            return false;
        }
        
        return true;
    }
    /*
    public boolean BillingAdditionalMember(wb_Membership__c MH,  List<wb_MembershipDetail__c> MD_ALL){
       // system.debug('BillingAdditionalMember:' + MembershipAdmissionfeeParent.size());
        List<wb_MembershipDetail__c> AdmissionfeeCNew = new  List<wb_MembershipDetail__c>();
        List<wb_MembershipDetail__c> AdmissionMembers = new List<wb_MembershipDetail__c>();
        
        for (wb_MembershipDetail__c m:MD_ALL) {
            if (m.ParentDetail__c == null && ( m.Type__c == '単身' ||  m.Type__c == '家族' ||  m.Type__c == '無記名')) 
                AdmissionMembers.add(m);
        }
            
       // system.debug('MembershipAdmissionfeeParent:' + MembershipAdmissionfeeParent.size());
        for (wb_MembershipDetail__c p:MembershipAdmissionfeeParent ){
            integer thisBal = 0;
            integer subnumber = 1;
            if ( p.Quantity__c != null) thisBal = integer.valueof(p.Quantity__c);
            for (wb_MembershipDetail__c c:MembershipAdmissionfeeChild){
                if ( c.ParentDetail__c == p.id)  {
                    //thisBal += integer.valueof(c.Quantity__c);
                    subnumber ++;
                }
            }
            
            for (integer i = AdmissionMembers.size() - 1; i >= 0 && thisBal > 0 ; i -- ){
                if (AdmissionMembers[i].PendingAction__c != '解約') {
                    if ( AdmissionMembers[i].PreviousRecord__c == null) 
                    { 
                        //SingleMemberQty += integer.valueof(m.Quantity__c);
                        wb_MembershipDetail__c nd = new wb_MembershipDetail__c(name = p.name + '-' + subnumber,
                                                                               Membership__c= p.Membership__c, ParentDetail__c=p.id,
                                                                               Individual__c= AdmissionMembers[i].Individual__c,
                                                                               Quantity__c= - AdmissionMembers[i].Quantity__c,
                                                                               Type__c = '入会金', SecondType__c= AdmissionMembers[i].Name);
                        AdmissionfeeCNew.add(nd);
                        
                        thisBal = thisBal - integer.valueOf( AdmissionMembers[i].Quantity__c);
                        p.Quantity__c = decimal.valueof( integer.valueof(p.Quantity__c) 
                                                        - integer.valueOf(AdmissionMembers[i].Quantity__c));
                       
                        
                        AdmissionMembers.remove(i);
                        subnumber ++;
                    }
                }
            }
        } 
                                               

        
        List<Id> IndID = new List<ID>();
        List<Id> MDIDs = new List<ID>();
        
        for ( wb_MembershipDetail__c md:MD_ALL){
            if (md.individual__c != null)
                IndID.add(md.individual__c);
            MDIDs.add(md.Id);
        }
        
        // All Individuals involved
        List<wb_Individual__c> IndListALL = [SELECT Id,// CurrentMemberNo__c, 
                                             MembershipEndDate__c, MembershipStartDate__c ,// Classification__c, 
                                             FamilyNo__c,
                                             Old_Id__c
                                             FROM wb_Individual__c where Id  =:IndID ];
        // Membership of Individuals
        List<wb_member__c> MemberList = [select id, Name, Individual__c, WorkingCompany__c, EndDate__c, MembershipDetail__c,
                                         Old_MemberNo__c
                                         from wb_member__c where Individual__c =:IndID ];
        
        List<wb_MembershipDetail__c> FamilyMDList = new List<wb_MembershipDetail__c>();
        List<wb_MembershipDetail__c> MemberMDList = new List<wb_MembershipDetail__c>();
        // Separate the Members and Families 
        for ( wb_MembershipDetail__c  a:MD_ALL ){
            if ( a.Service__r.DataType__c =='単身' || a.Service__r.DataType__c =='家族') {
                if ( a.ParentDetail__c == null)
                    MemberMDList.add(a);
                else
                    FamilyMDList.add(a);   
            }
        }
        
        List<Id> MBIDs = new List<Id>();
        for (wb_member__c m:MemberList)
            MBIDs.add(m.Id);

        
        List<wb_MemberHistory__c> MemberHistory;
        MemberHistory = new List<wb_MemberHistory__c>();
         
        
        // Create the Membership History and generate Member No for the Replacer
        for (wb_MembershipDetail__c m : MemberMDList) { 
            
            wb_Individual__c theInd;
            for (integer i=0; i <IndListALL.size(); i++ ){
                if (IndListALL[i].id == m.Individual__c )
                    theInd = IndListALL[i];
            }
            
            if ( m.Classification__c =='追加' && ( m.Type__c =='単身' || m.Type__c =='家族' ) && m.PendingAction__c =='確認' ){ 

                
                // Update the information of the indiviual
                if ( theInd.MembershipStartDate__c == null )
                {
                    theInd.MembershipStartDate__c = m.MembershipStartDate__c;
                }
                
                theInd.MembershipEndDate__c = m.MembershipEndDate__c;
               // theInd.Classification__c = '会員';
                
                boolean found = false;
                wb_member__c theMember;
                
                
                for (integer i=0; i<MemberList.size() && found == false ; i++){
                    if ( MemberList[i].Individual__c == m.individual__c 
                        && MemberList[i].WorkingCompany__c == m.WorkingCompany__c ){
                        found = true;
                        theMember = MemberList[i];
                    }
                }
                
                if ( found == true){
                    
                    string MemberNo; // = m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCd__c + theMember.name + '0';
                    if ( theMember.Old_MemberNo__c == null)
                        MemberNo = m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCd__c + theMember.name + '0';
                    else
                        MemberNo = m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCd__c + theMember.Old_MemberNo__c + '0';
                    
                    MemberHistory.add( new wb_MemberHistory__c(
                        member__c   = theMember.id,
                        MemberNo__c = MemberNo,
                        MembershipDetail__c = m.id,
                        MembershipEndDate__c = m.MembershipEndDate__c,
                        MembershipStartDate__c = m.MembershipStartDate__c,
                        Classification__c = '新規'
                    ));
                    
                    theMember.MembershipDetail__c=m.id;
                    theMember.EndDate__c = m.MembershipEndDate__c;
                   // theInd.CurrentMemberNo__c = MemberNo; 
                    m.MemberNo__c = MemberNo; 
                    
                }
                
                // For Family Plan, generate the Member Number for the family members
                if  (  m.Service__r.DataType__c =='家族' && found == true ) {
                    
                    string FamilyMemberNo; // =  m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCd__c +  theMember.name ;
                    if ( theMember.Old_MemberNo__c == null)
                        FamilyMemberNo =  m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCd__c +  theMember.name ;
                    else
                        FamilyMemberNo =  m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCd__c +  theMember.Old_MemberNo__c ;
                    
                    for ( wb_MembershipDetail__c f:FamilyMDList){
                        if ( f.ParentDetail__c ==m.id ){
                            f.MemberNo__c = FamilyMemberNo + f.Individual__r.FamilyNo__c;
                            
                            for (wb_Individual__c fi:IndListALL){
                                if ( fi.id == f.Individual__c ) {
                                    fi.CurrentMemberNo__c = FamilyMemberNo + fi.FamilyNo__c;
                                    fi.MembershipStartDate__c = m.MembershipStartDate__c;
                                    fi.MembershipEndDate__c = m.MembershipEndDate__c;
                                   // fi.Classification__c = '会員家族';
                                }
                            }
                        }                
                    }
                    
                } 
                
            }
        }
         
        
        List<MDContractBilling>  MDContractRefundAndBillingList = new List<MDContractBilling>();
		// Perpare the Refund for Replacee & Billing for Replacer 
        for (wb_MembershipDetail__c m : MemberMDList){
            if ( m.Classification__c =='追加' && ( m.Type__c =='単身' || m.Type__c =='家族' ) && m.PendingAction__c =='確認'){
                MDContractRefundAndBillingList.add(new MDContractBilling(String.valueOf(m.Membership__c),
                                                                         (Id) (m.Service__c),  
                                                                         m.name + ':' + m.MembershipPlan__c,  
                                                                         (Decimal) m.BillingAmount__c));
            }
        }


      //  system.debug(MDContractRefundList);
        List<wb_ReceivableServiceFee__c> RefundAndBilling = new  List<wb_ReceivableServiceFee__c>();
        for (MDContractBilling RList : MDContractRefundAndBillingList) { 
            RefundAndBilling.add( new wb_ReceivableServiceFee__c( Classification__c= '会員',
                                                       Date__c=system.today(), Membership__c=MH.id, 
                                                       Country__c = MH.ContractCountry__c, District__c = MH.ContractDistrict__c,
                                                       Service__c = RList.ServiceID,
                                                       ServiceName__c = RList.MDPlan, Currency__c = MH.Currency__c,
                                                       ServiceAmount__c =  RList.Amount,
                                                       InvoicingCompany__c = MH.BillingCompany__c ));   
        }
        
        SavePoint sp = Database.setSavepoint();
        try
        {
            insert AdmissionfeeCNew;
            update MD_ALL;
            insert MemberHistory;
            insert RefundAndBilling;
            
        }
        catch(Exception e)
        {
            Database.rollBack(sp);
            // PopupMessage = e.getMessage();
            return false;
        }
        
        return true;
    }
*/
    
    public boolean BillingAdditionalMember(wb_Membership__c MH,  List<wb_MembershipDetail__c> AdmissionfeeP, 
                                           List<wb_MembershipDetail__c> AdmissionfeeC, 
                                           List<wb_MembershipDetail__c> MD_ALL){
        
        integer AvailbleAdmissionQty = 0;
        for ( wb_MembershipDetail__c a:AdmissionfeeP)
            AvailbleAdmissionQty = AvailbleAdmissionQty + Integer.valueOf(a.Quantity__c);
        integer AdditionalMemberQty = 0;
        for ( wb_MembershipDetail__c m:MD_ALL) {
            if (m.ParentDetail__c == null && ( m.Type__c == '単身' ||  m.Type__c == '家族' ||  m.Type__c == '無記名') ){
                system.debug(m.Quantity__c);
                AdditionalMemberQty = AdditionalMemberQty + Integer.valueOf(m.Quantity__c);
            }
        }
       // system.debug(AvailbleAdmissionQty +','+ AdditionalMemberQty);
        List<wb_MembershipDetail__c> AdmissionfeeCNew = new  List<wb_MembershipDetail__c>();
        if ( AvailbleAdmissionQty  < AdditionalMemberQty){
         //   system.debug('Membership Fee not enough:'+ AvailbleAdmissionQty + '<' + AdditionalMemberQty );
            return false;  
        } 
        else {
          
			List<wb_MembershipDetail__c> AdmissionMembers = new List<wb_MembershipDetail__c>();
            for (wb_MembershipDetail__c m:MD_ALL) {
                if (m.ParentDetail__c == null && ( m.Type__c == '単身' ||  m.Type__c == '家族' ||  m.Type__c == '無記名')) 
                	AdmissionMembers.add(m);
            }
            
            for (wb_MembershipDetail__c p:AdmissionfeeP ){
                integer thisBal = 0;
                integer subnumber = 1;
                if ( p.Quantity__c != null) thisBal = integer.valueof(p.Quantity__c);
                for (wb_MembershipDetail__c c:AdmissionfeeC){
                    if ( c.ParentDetail__c == p.id)  {
                        //thisBal += integer.valueof(c.Quantity__c);
                        subnumber ++;
                    }
                }
                
                for (integer i = AdmissionMembers.size() - 1; i >= 0 && thisBal > 0 ; i -- ){
                    if (AdmissionMembers[i].PendingAction__c != '解約') {
                        if ( AdmissionMembers[i].PreviousRecord__c == null) 
                        { 
                            //SingleMemberQty += integer.valueof(m.Quantity__c);
                            wb_MembershipDetail__c nd = new wb_MembershipDetail__c(name = p.name + '-' + subnumber,
                                                                                   Membership__c= p.Membership__c, ParentDetail__c=p.id,
                                                                                   Individual__c= AdmissionMembers[i].Individual__c,
                                                                                   Quantity__c= - AdmissionMembers[i].Quantity__c,
                                                                                   Type__c = '入会金', SecondType__c= AdmissionMembers[i].Name);
                            AdmissionfeeCNew.add(nd);
                            
                            thisBal = thisBal - integer.valueOf( AdmissionMembers[i].Quantity__c);
                           // AdditionalMemberQty = AdditionalMemberQty - integer.valueOf(AdmissionMembers[i].Quantity__c);
                            
                            AdmissionMembers.remove(i);
                            subnumber ++;
                        }
                    }
                }
            }             
        }
         
        List<Id> IndID = new List<ID>();
        List<Id> MDIDs = new List<ID>();
        
        for ( wb_MembershipDetail__c md:MD_ALL){
            if (md.individual__c != null)
                IndID.add(md.individual__c);
            MDIDs.add(md.Id);
        }
        
        // All Individuals involved
        List<wb_Individual__c> IndListALL = [SELECT Id, // CurrentMemberNo__c, MembershipEndDate__c, MembershipStartDate__c ,// Classification__c, 
                                             FamilyNo__c,
                                             Old_Id__c
                                             FROM wb_Individual__c where Id  =:IndID ];
        // Membership of Individuals
        List<wb_member__c> MemberList = [select id, Name, Individual__c, WorkingCompany__c, EndDate__c, MembershipDetail__c,
                                         Old_MemberNo__c
                                         from wb_member__c where Individual__c =:IndID ];
        
        List<wb_MembershipDetail__c> FamilyMDList = new List<wb_MembershipDetail__c>();
        List<wb_MembershipDetail__c> MemberMDList = new List<wb_MembershipDetail__c>();
        // Separate the Members and Families 
        for ( wb_MembershipDetail__c  a:MD_ALL ){
            if ( a.Service__r.DataType__c =='単身' || a.Service__r.DataType__c =='家族') {
                if ( a.ParentDetail__c == null)
                    MemberMDList.add(a);
                else
                    FamilyMDList.add(a);   
            }
        }
        
        List<Id> MBIDs = new List<Id>();
        for (wb_member__c m:MemberList)
            MBIDs.add(m.Id);
        /*
        List<wb_MemberHistory__c> MemberHistoryList =[SELECT member__r.Individual__c, member__r.MembershipDetail__c,
                                                      member__c, MemberType__c, MemberNo__c, MembershipStartDate__c, MembershipEndDate__c, Classification__c, CancellationDate__c 
                                                      FROM wb_MemberHistory__c 
                                                      where member__c =:MBIDs and member__r.MembershipDetail__c !=:MDIDs and MembershipEndDate__c >= today];
        List<Id> CancelledMemberHistoryMDIds = new List<Id>();      
        */
        
        List<wb_MemberHistory__c> MemberHistory;
        MemberHistory = new List<wb_MemberHistory__c>();
        
        
        // Create the Membership History and generate Member No for the Replacer
        for (wb_MembershipDetail__c m : MemberMDList) { 
            
            wb_Individual__c theInd;
            for (integer i=0; i <IndListALL.size(); i++ ){
                if (IndListALL[i].id == m.Individual__c )
                    theInd = IndListALL[i];
            }
            
            if ( m.Classification__c =='追加' && ( m.Type__c =='単身' || m.Type__c =='家族' ) && m.PendingAction__c =='確認' ){ 

                
                // Update the information of the indiviual
          /*      if ( theInd.MembershipStartDate__c == null )
                {
                    theInd.MembershipStartDate__c = m.MembershipStartDate__c;
                }
                
                theInd.MembershipEndDate__c = m.MembershipEndDate__c; */
                //theInd.Classification__c = '会員';
                
                boolean found = false;
                wb_member__c theMember;
                
                
                for (integer i=0; i<MemberList.size() && found == false ; i++){
                    if ( MemberList[i].Individual__c == m.individual__c && MemberList[i].WorkingCompany__c == m.WorkingCompany__c ){
                        found = true;
                        theMember = MemberList[i];
                    }
                }
                
                if ( found == true){
                    
                    string MemberNo; // = m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCd__c + theMember.name + '0';
                    if ( theMember.Old_MemberNo__c == null)
                        MemberNo = m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCd__c + theMember.name + '0';
                    else
                        MemberNo = m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCd__c + theMember.Old_MemberNo__c + '0';
                    
                    MemberHistory.add( new wb_MemberHistory__c(
                        member__c   = theMember.id,
                        MemberNo__c = MemberNo,
                        MembershipDetail__c = m.id,
                        MembershipEndDate__c = m.MembershipEndDate__c,
                        MembershipStartDate__c = m.MembershipStartDate__c,
                        Classification__c = '新規'
                    ));
                    
                    theMember.MembershipDetail__c=m.id;
                    theMember.EndDate__c = m.MembershipEndDate__c;
                 //   theInd.CurrentMemberNo__c = MemberNo; 
                    m.MemberNo__c = MemberNo; 
                    
                }
                
                // For Family Plan, generate the Member Number for the family members
                if  (  m.Service__r.DataType__c =='家族' && found == true ) {
                    
                    string FamilyMemberNo; // =  m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCd__c +  theMember.name ;
                    if ( theMember.Old_MemberNo__c == null)
                        FamilyMemberNo =  m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCd__c +  theMember.name ;
                    else
                        FamilyMemberNo =  m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCd__c +  theMember.Old_MemberNo__c ;
                    
                    for ( wb_MembershipDetail__c f:FamilyMDList){
                        if ( f.ParentDetail__c ==m.id ){
                            f.MemberNo__c = FamilyMemberNo + f.Individual__r.FamilyNo__c;
                           /* 
                            for (wb_Individual__c fi:IndListALL){
                                if ( fi.id == f.Individual__c ) {
                                    fi.CurrentMemberNo__c = FamilyMemberNo + fi.FamilyNo__c;
                                    fi.MembershipStartDate__c = m.MembershipStartDate__c;
                                    fi.MembershipEndDate__c = m.MembershipEndDate__c;
                                   // fi.Classification__c = '会員家族';
                                }
                            } */
                        }                
                    }
                    
                } 
                
            }
        }
        
        
        List<MDContractBilling>  MDContractRefundAndBillingList = new List<MDContractBilling>();
		// Perpare the Refund for Replacee & Billing for Replacer 
        for (wb_MembershipDetail__c m : MemberMDList){
            if ( m.Classification__c =='追加' && ( m.Type__c =='単身' || m.Type__c =='家族' ) && m.PendingAction__c =='確認'){
                MDContractRefundAndBillingList.add(new MDContractBilling(String.valueOf(m.Membership__c),
                                                                         (Id) (m.Service__c),  
                                                                         m.name + ':' + m.MembershipPlan__c,  
                                                                         (Decimal) m.BillingAmount__c));
            }
        }


      //  system.debug(MDContractRefundList);
        List<wb_ReceivableServiceFee__c> RefundAndBilling = new  List<wb_ReceivableServiceFee__c>();
        for (MDContractBilling RList : MDContractRefundAndBillingList) { 
            RefundAndBilling.add( new wb_ReceivableServiceFee__c( Classification__c= '会員',
                                                       Date__c=system.today(), Membership__c=MH.id, 
                                                       Country__c = MH.ContractCountry__c, District__c = MH.ContractDistrict__c,
                                                       Service__c = RList.ServiceID,
                                                       ServiceName__c = RList.MDPlan, Currency__c = MH.Currency__c,
                                                       ServiceAmount__c =  RList.Amount,
                                                       InvoicingCompany__c = MH.BillingCompany__c ));   
        }
        
        SavePoint sp = Database.setSavepoint();
        try
        {
            insert AdmissionfeeCNew;
            update MD_ALL;
            insert MemberHistory;
            insert RefundAndBilling;
            
        }
        catch(Exception e)
        {
            Database.rollBack(sp);
            // PopupMessage = e.getMessage();
            return false;
        }
        
        return true;
    }

    
    public boolean BillingReplacement(wb_Membership__c MH,  List<wb_MembershipDetail__c> MD_ALL){
        
        List<Id> IndID = new List<ID>();
        List<Id> MDIDs = new List<ID>();
        
        for ( wb_MembershipDetail__c md:MD_ALL){
            if (md.individual__c != null)
                IndID.add(md.individual__c);
            MDIDs.add(md.Id);
        }
        
        // All Individuals involved
        List<wb_Individual__c> IndListALL = [SELECT Id, // CurrentMemberNo__c, MembershipEndDate__c, MembershipStartDate__c ,// Classification__c, 
                                             FamilyNo__c,
                                             Old_Id__c
                                             FROM wb_Individual__c where Id  =:IndID ];
        // Members of Individuals
        List<wb_member__c> MemberList = [select id, Name, Individual__c, WorkingCompany__c, EndDate__c, MembershipDetail__c,
                                         Old_MemberNo__c
                                         from wb_member__c where Individual__c =:IndID ];
        
        List<wb_MembershipDetail__c> FamilyMDList = new List<wb_MembershipDetail__c>();
        List<wb_MembershipDetail__c> MemberMDList = new List<wb_MembershipDetail__c>();
        // Separate the Members and Families 
        for ( wb_MembershipDetail__c  a:MD_ALL ){
            if ( a.Service__r.DataType__c =='単身' || a.Service__r.DataType__c =='家族') {
                if ( a.ParentDetail__c == null)
                    MemberMDList.add(a);
                else
                    FamilyMDList.add(a);   
            }
        }
        
        List<Id> MBIDs = new List<Id>();
        for (wb_member__c m:MemberList)
            MBIDs.add(m.Id);

        
        List<wb_MemberHistory__c> MemberHistory_Replacement;
        MemberHistory_Replacement = new List<wb_MemberHistory__c>();
        
      //  List<wb_MemberHistory__c> MemberHistory_Replacer;
      //  MemberHistory_Replacer = new List<wb_MemberHistory__c>();
        
        // Create the Membership History and generate Member No for the Replacer
        for (wb_MembershipDetail__c m : MemberMDList) { 
            
            wb_Individual__c theInd;
            for (integer i=0; i <IndListALL.size(); i++ ){
                if (IndListALL[i].id == m.Individual__c )
                    theInd = IndListALL[i];
            }
            
            if ( m.PendingAction__c =='交替' /* Replacee */ ){ // Replacee

                boolean found = false;
                wb_member__c theMember;
                
                // To get the Membership of the working company
                for (integer i=0; i<MemberList.size() && found == false ; i++){
                    if ( MemberList[i].Individual__c == m.individual__c 
                        && MemberList[i].WorkingCompany__c == m.WorkingCompany__c ){
                        found = true;
                        theMember = MemberList[i];
                    }
                }
                
                if ( found == true && m.ParentDetail__c == null ){
                    MemberHistory_Replacement.add( new wb_MemberHistory__c(
                        member__c   = theMember.id,
                        MemberNo__c = m.MemberNo__c,
                        MembershipDetail__c = m.id,
                        MembershipStopDate__c = m.MembershipStopDate__c,
                        MembershipStartDate__c = m.MembershipStartDate__c,
                        Classification__c = '交替退会'
                    ));
                }
                
                m.CancellationDate__c=system.today();
    
                // Process the Termination of Family
                for (wb_MembershipDetail__c fm:FamilyMDList){
                    if (fm.ParentDetail__c == m.id)
                        fm.CancellationDate__c=system.today();
                }  
            }          
            else if ( m.Classification__c =='交替' && m.PendingAction__c =='確認' /* Replacer */){ 
                
                // Update the information of the indiviual
              /*  if ( theInd.MembershipStartDate__c == null )
                {
                    theInd.MembershipStartDate__c = m.MembershipStartDate__c;
                }
                
                theInd.MembershipEndDate__c = m.MembershipEndDate__c;*/
                //theInd.Classification__c = '会員';
                
                boolean found = false;
                wb_member__c theMember;
                
                
                for (integer i=0; i<MemberList.size() && found == false ; i++){
                    if ( MemberList[i].Individual__c == m.individual__c && MemberList[i].WorkingCompany__c == m.WorkingCompany__c ){
                        found = true;
                        theMember = MemberList[i];
                    }
                }
                
                if ( found == true){
                    
                    string MemberNo; // = m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCd__c + theMember.name + '0';
                    if ( theMember.Old_MemberNo__c == null)
                        MemberNo = m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCd__c + theMember.name + '0';
                    else
                        MemberNo = m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCd__c + theMember.Old_MemberNo__c + '0';
                    
                    MemberHistory_Replacement.add( new wb_MemberHistory__c(
                        member__c   = theMember.id,
                        MemberNo__c = MemberNo,
                        MembershipDetail__c = m.id,
                        MembershipEndDate__c = m.MembershipEndDate__c,
                        MembershipStartDate__c = m.MembershipStartDate__c,
                        Classification__c = '交替増員'
                    ));
                    
                    theMember.MembershipDetail__c=m.id;
                    theMember.EndDate__c = m.MembershipEndDate__c;
                //    theInd.CurrentMemberNo__c = MemberNo; 
                    m.MemberNo__c = MemberNo; 
                    
                }
                
                // For Family Plan, generate the Member Number for the family members
                if  (  m.Service__r.DataType__c =='家族' && found == true ) {
                    
                    string FamilyMemberNo; // =  m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCd__c +  theMember.name ;
                    if ( theMember.Old_MemberNo__c == null)
                        FamilyMemberNo =  m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCd__c +  theMember.name ;
                    else
                        FamilyMemberNo =  m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCd__c +  theMember.Old_MemberNo__c ;
                    
                    for ( wb_MembershipDetail__c f:FamilyMDList){
                        if ( f.ParentDetail__c ==m.id ){
                            f.MemberNo__c = FamilyMemberNo + f.Individual__r.FamilyNo__c;
                            
                         /*   for (wb_Individual__c fi:IndListALL){
                                if ( fi.id == f.Individual__c ) {
                                    fi.CurrentMemberNo__c = FamilyMemberNo + fi.FamilyNo__c;
                                    fi.MembershipStartDate__c = m.MembershipStartDate__c;
                                    fi.MembershipEndDate__c = m.MembershipEndDate__c;
                                  //  fi.Classification__c = '会員家族';
                                }
                            } */
                        }                
                    }
                    
                } 
                
            }
        }
        
        
        List<MDContractBilling>  MDContractRefundAndBillingList = new List<MDContractBilling>();
		// Perpare the Refund for Replacee & Billing for Replacer 
        for (wb_MembershipDetail__c m : MemberMDList){
           /* if ( m.PendingAction__c =='交替') {
                MDContractRefundAndBillingList.add(new MDContractBilling(String.valueOf(m.Membership__c),
                                                               (Id) (m.Service__c),  
                                                               String.valueOf(m.MembershipPlan__c),  
                                                               (Decimal) m.BalanceAmount__c));
                
            } else */
            if ( m.Classification__c =='交替' && m.PendingAction__c =='確認'){
                MDContractRefundAndBillingList.add(new MDContractBilling(String.valueOf(m.Membership__c),
                                                                         (Id) (m.Service__c),  
                                                                         m.name + ':' + m.MembershipPlan__c,  
                                                                         (Decimal) m.BillingAmount__c));
            }
        }


      //  system.debug(MDContractRefundList);
        List<wb_ReceivableServiceFee__c> RefundAndBilling = new  List<wb_ReceivableServiceFee__c>();
        for (MDContractBilling RList : MDContractRefundAndBillingList) { 
            RefundAndBilling.add( new wb_ReceivableServiceFee__c( Classification__c= '会員',
                                                       Date__c=system.today(), Membership__c=MH.id, 
                                                       Country__c = MH.ContractCountry__c, District__c = MH.ContractDistrict__c,
                                                       Service__c = RList.ServiceID,
                                                       ServiceName__c = RList.MDPlan, Currency__c = MH.Currency__c,
                                                       ServiceAmount__c =  RList.Amount,
                                                       InvoicingCompany__c = MH.BillingCompany__c ));   
        }
        
        SavePoint sp = Database.setSavepoint();
        try
        {
            //system.debug(MD_ALL);
            upsert MD_ALL;
            insert MemberHistory_Replacement;
            insert RefundAndBilling;
        }
        catch(Exception e)
        {
            Database.rollBack(sp);
            // PopupMessage = e.getMessage();
            return false;
        }
        
        return true;
    }
    
    public boolean BillingChanges(wb_Membership__c MH,  List<wb_MembershipDetail__c> MD_ALL, set<string> CompanySet){
        system.debug(MD_ALL);
        List<Id> IndID = new List<ID>();
        List<Id> MDIDs = new List<ID>();
        
        for ( wb_MembershipDetail__c md:MD_ALL){
            if (md.individual__c != null)
                IndID.add(md.individual__c);
            MDIDs.add(md.Id);
        }
        
        // All Individuals involved
        List<wb_Individual__c> IndListALL = [SELECT Id,// CurrentMemberNo__c, MembershipEndDate__c, MembershipStartDate__c , //Classification__c, 
                                             FamilyNo__c,
                                             Old_Id__c
                                             FROM wb_Individual__c where Id  =:IndID ];
        // Membership of Individuals
        List<wb_member__c> MemberList = [select id, Name, Individual__c, WorkingCompany__c, EndDate__c, MembershipDetail__c,
                                         Old_MemberNo__c
                                         from wb_member__c where Individual__c =:IndID ];
        
        List<wb_MembershipDetail__c> FamilyMDList = new List<wb_MembershipDetail__c>();
        List<wb_MembershipDetail__c> MemberMDList = new List<wb_MembershipDetail__c>();
        // Separate the Members and Families 
        for ( wb_MembershipDetail__c  a:MD_ALL ){
            if ( a.Service__r.DataType__c =='単身' || a.Service__r.DataType__c =='家族') {
                if ( a.ParentDetail__c == null)
                    MemberMDList.add(a);
                else
                    FamilyMDList.add(a);   
            }
        }
        
        List<Id> MBIDs = new List<Id>();
        for (wb_member__c m:MemberList)
            MBIDs.add(m.Id);
        
        
        List<wb_MemberHistory__c> MemberHistory_ChangeReplacee;
        MemberHistory_ChangeReplacee = new List<wb_MemberHistory__c>();
        List<wb_MemberHistory__c> MemberHistory_ChangeReplacer;
        MemberHistory_ChangeReplacer = new List<wb_MemberHistory__c>();
        
        
        // Create the Membership History of Changes
        system.debug(MemberMDList);
        for (wb_MembershipDetail__c m : MemberMDList) { 
            
            wb_Individual__c theInd;
            for (integer i=0; i <IndListALL.size(); i++ ){
                if (IndListALL[i].id == m.Individual__c )
                    theInd = IndListALL[i];
            }
            
            if ( m.PendingAction__c =='変更' /* Now */ ){ 
                
                boolean found = false;
               // boolean changeworkingcompany = false;
                wb_member__c theMember;
                //system.debug(MemberList);
                //system.debug(CompanySet);
                system.debug(m);
                // To get the Membership of the working company
                for (integer i=0; i<MemberList.size() && found == false ; i++){
                    if ( MemberList[i].Individual__c == m.individual__c) {
                        if( MemberList[i].WorkingCompany__c == m.WorkingCompany__c ) {
                            found = true;
                    
                            theMember = MemberList[i];
                        } 
                    }
                }
                
                if ( found == true && m.ParentDetail__c == null ){
                //    theMember.MembershipDetail__c = m.Id;
                    MemberHistory_ChangeReplacee.add( new wb_MemberHistory__c(
                        member__c   = theMember.id,
                        MemberNo__c = m.MemberNo__c,
                        MembershipDetail__c = m.id,
                        MembershipStopDate__c = m.MembershipStopDate__c,
                        MembershipStartDate__c = m.MembershipStartDate__c,
                        Classification__c = '変更'
                    ));
                  //  update theMember;
                }
                
                m.CancellationDate__c=system.today();
                
                // Process the Termination of Family
                for (wb_MembershipDetail__c fm:FamilyMDList){
                    if (fm.ParentDetail__c == m.id)
                        fm.CancellationDate__c=system.today();
                }  
            }          
            else if ( m.Classification__c =='変更' && m.PendingAction__c =='確認' /* Replacer */){ 
                
                // Update the information of the indiviual
           /*     if ( theInd.MembershipStartDate__c == null )
                {
                    theInd.MembershipStartDate__c = m.MembershipStartDate__c;
                }
                
                theInd.MembershipEndDate__c = m.MembershipEndDate__c;*/
                //theInd.Classification__c = '会員';
                
                boolean found = false;
                boolean changeworkingcompany = false;
                wb_member__c theMember;
                
                system.debug(MemberList);
                system.debug(CompanySet);
                system.debug(m);
                for (integer i=0; i<MemberList.size() && found == false ; i++){
                    if ( MemberList[i].Individual__c == m.individual__c) {// && MemberList[i].WorkingCompany__c == m.WorkingCompany__c ){
                       // found = true;
                       // theMember = MemberList[i];
                        if( MemberList[i].WorkingCompany__c == m.WorkingCompany__c ) {
                            found = true;
                            changeworkingcompany = false;
                            theMember = MemberList[i];
                        } else if (CompanySet.contains( string.valueof(m.WorkingCompany__c))){
                            found = true;
                            changeworkingcompany = true;
                            theMember = MemberList[i];
                            theMember.WorkingCompany__c = m.WorkingCompany__c;
                            
                        }
                    }
                }
                
                if ( found == true){
                    
                    string MemberNo; // = m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCd__c + theMember.name + '0';
                    if ( theMember.Old_MemberNo__c == null)
                        MemberNo = m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCd__c + theMember.name + '0';
                    else
                        MemberNo = m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCd__c + theMember.Old_MemberNo__c + '0';
                    
                    MemberHistory_ChangeReplacer.add( new wb_MemberHistory__c(
                        member__c   = theMember.id,
                        MemberNo__c = MemberNo,
                        MembershipDetail__c = m.id,
                        MembershipEndDate__c = m.MembershipEndDate__c,
                        MembershipStartDate__c = m.MembershipStartDate__c,
                        Classification__c = '変更'
                    ));
                    
                    theMember.MembershipDetail__c=m.id;
                    theMember.EndDate__c = m.MembershipEndDate__c;
                    if (changeworkingcompany == true ){
                        theMember.WorkingCompany__c = m.WorkingCompany__c;
                    }
                 //   theInd.CurrentMemberNo__c = MemberNo; 
                    m.MemberNo__c = MemberNo; 
                    update  theMember;
                }
                
                // For Family Plan, generate the Member Number for the family members
                if  (  m.Service__r.DataType__c =='家族' && found == true ) {
                    
                    string FamilyMemberNo; // =  m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCd__c +  theMember.name ;
                    if ( theMember.Old_MemberNo__c == null)
                        FamilyMemberNo =  m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCd__c +  theMember.name ;
                    else
                        FamilyMemberNo =  m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCd__c +  theMember.Old_MemberNo__c ;
                    
                    for ( wb_MembershipDetail__c f:FamilyMDList){
                        if ( f.ParentDetail__c ==m.id ){
                            f.MemberNo__c = FamilyMemberNo + f.Individual__r.FamilyNo__c;
                            
                           /* for (wb_Individual__c fi:IndListALL){
                                if ( fi.id == f.Individual__c ) {
                                    fi.CurrentMemberNo__c = FamilyMemberNo + fi.FamilyNo__c;
                                    fi.MembershipStartDate__c = m.MembershipStartDate__c;
                                    fi.MembershipEndDate__c = m.MembershipEndDate__c;
                                    //fi.Classification__c = '会員家族';
                                }
                            } */
                        }                
                    }
                    
                } 
                
            }
        }
        
        
        List<MDContractBilling>  MDContractRefundAndBillingList = new List<MDContractBilling>();
        // Perpare the Refund for Replacee & Billing for Replacer 
        for (wb_MembershipDetail__c m : MemberMDList){
            if ( m.Classification__c =='変更' && m.PendingAction__c =='確認'){
                MDContractRefundAndBillingList.add(new MDContractBilling(String.valueOf(m.Membership__c),
                                                                         (Id) (m.Service__c),  
                                                                         '(' + m.name + ') ' + m.MembershipPlan__c,  
                                                                         (Decimal) m.BillingAmount__c));
            }
        }
        
        
        system.debug(MDContractRefundAndBillingList);
        List<wb_ReceivableServiceFee__c> RefundAndBilling = new  List<wb_ReceivableServiceFee__c>();
        for (MDContractBilling RList : MDContractRefundAndBillingList) { 
            RefundAndBilling.add( new wb_ReceivableServiceFee__c( Classification__c= '会員',
                                                                 Date__c=system.today(), Membership__c=MH.id, 
                                                                 Country__c = MH.ContractCountry__c, District__c = MH.ContractDistrict__c,
                                                                 Service__c = RList.ServiceID,
                                                                 ServiceName__c = RList.MDPlan, Currency__c = MH.Currency__c,
                                                                 ServiceAmount__c =  RList.Amount,
                                                                 InvoicingCompany__c = MH.BillingCompany__c ));   
        }
        
        system.debug(RefundAndBilling);
        SavePoint sp = Database.setSavepoint();
        try
        {
            update MD_ALL;
            insert MemberHistory_ChangeReplacee;
            List<Id> MHReplaceeIDs = new List<Id>();
            for (wb_MemberHistory__c h:MemberHistory_ChangeReplacee){
                MHReplaceeIDs.add(h.Id);
            }
            List<Id> MHReplaceeMDIDs = new List<Id>();
            for (wb_MemberHistory__c h:MemberHistory_ChangeReplacee){
                MHReplaceeMDIDs.add(h.MembershipDetail__c);
            }
            MemberHistory_ChangeReplacee = [select id, MembershipDetail__c, ReplacedWith__c 
                                            from wb_MemberHistory__c 
                                            where id =:MHReplaceeIDs
                                            order by MembershipDetail__c];
            
            List<wb_MemberHistory__c> Replaced = [select id, MembershipDetail__c, ReplacedWith__c 
                                            from wb_MemberHistory__c 
                                            where MembershipDetail__c=:MHReplaceeMDIDs and id !=:MHReplaceeIDs
                                            order by MembershipDetail__c];
            
            integer i = 0;
            integer j = 0;
            for (; i < MemberHistory_ChangeReplacee.size();i++){
                for (; j < Replaced.size() && 
                     MemberHistory_ChangeReplacee[i].MembershipDetail__c == Replaced[j].MembershipDetail__c; j ++ )
                {
                    Replaced[j].ReplacedWith__c = MemberHistory_ChangeReplacee[i].id;
                    Replaced[j].EffectiveUntil__c = null;
                }
            }
            update Replaced;
            
            insert MemberHistory_ChangeReplacer;
            List<Id> MHReplacerIDs = new List<Id>();
            for (wb_MemberHistory__c h:MemberHistory_ChangeReplacer){
                MHReplacerIDs.add(h.Id);
            }
            
            MemberHistory_ChangeReplacer = [select id, MembershipDetail__r.PreviousRecord__c, ReplacedWith__c 
                                            from wb_MemberHistory__c 
                                            where id =:MHReplacerIDs
                                            order by MembershipDetail__r.PreviousRecord__c];
            i = 0;
            j = 0;
            for (; i < MemberHistory_ChangeReplacer.size();i++){
                for (; j < MemberHistory_ChangeReplacee.size() && 
                     MemberHistory_ChangeReplacer[i].MembershipDetail__r.PreviousRecord__c 
                     == MemberHistory_ChangeReplacee[j].MembershipDetail__c; j ++ )
                {
                    MemberHistory_ChangeReplacee[j].ReplacedWith__c = MemberHistory_ChangeReplacer[i].id;
                    MemberHistory_ChangeReplacee[j].EffectiveUntil__c = null;
                }
            }
            update MemberHistory_ChangeReplacee;
            insert RefundAndBilling;
            system.debug(RefundAndBilling);
        }
        catch(Exception e)
        {
            Database.rollBack(sp);
            // PopupMessage = e.getMessage();
            return false;
        }
        
        return true;
    }
    
    public boolean BillingCancellation(wb_Membership__c MH,  List<wb_MembershipDetail__c> MD_ALL){
          
        Date td;
        // Today as billing date
        td = date.today();
        List<MDContractBilling> MDContractRefundList;
        
        List<wb_MembershipDetail__c> MembershipDetailList_Member = new List<wb_MembershipDetail__c>();
        List<wb_MembershipDetail__c> MembershipDetailList_Family = new List<wb_MembershipDetail__c>();
        
        for ( wb_MembershipDetail__c  a:MD_ALL ){
            if ( a.Service__r.DataType__c =='単身' || a.Service__r.DataType__c =='家族') {
                if ( a.ParentDetail__c == null)
                    MembershipDetailList_Member.add(a);
                else
                    MembershipDetailList_Family.add(a);   
            }
            
        }
        
        List<Id> IndID = new List<ID>();
        List<Id> MDIDs = new List<ID>();
        List<Id> MbrIDs = new List<ID>();
        
        for ( wb_MembershipDetail__c md:MD_ALL){
            if (md.individual__c != null )
                IndID.add(md.individual__c);
            if (md.Member__c != null )
                MbrIDs.add(md.Member__c);
            MDIDs.add(md.Id);
        }
        
        List<wb_Individual__c> IndList = [SELECT Id, // CurrentMemberNo__c, MembershipEndDate__c, MembershipStartDate__c ,// Classification__c, 
                                          FamilyNo__c,
                                          Old_Id__c
                                          FROM wb_Individual__c where Id  =:IndID ];
        
        List<wb_member__c> MemberList = [select id, Name, Individual__c, WorkingCompany__c, EndDate__c, MembershipDetail__c,
                                         Old_MemberNo__c, 
                                         AdmissionFee__c, 
                                         AdmissionFee__r.Membership__c, AdmissionFee__r.ParentDetail__c, AdmissionFee__r.SecondType__c,
                                         AdmissionFee__r.WorkingCompany__c, AdmissionFee__r.Individual__c, AdmissionFee__r.MemberNo__c,
                                         AdmissionFee__r.Type__c, AdmissionFee__r.name
                                         from wb_member__c 
                                         where Id =:MbrIDs ];
        
        List<Id> MBIDs = new List<Id>();
        for (wb_member__c m:MemberList)
            MBIDs.add(m.Id);
        
        List<wb_MemberHistory__c> MemberHistory_Old = [select id, MembershipDetail__c, member__c, ReplacedWith__c, EffectiveUntil__c
                                                       from wb_MemberHistory__c 
                                                       where MembershipDetail__c=:MDIDs
                                                       order by MembershipDetail__c];

        List<wb_MemberHistory__c> MemberHistory_Cancel;
        MemberHistory_Cancel = new List<wb_MemberHistory__c>();
        
        List<wb_MembershipDetail__c> AdmissionfeeCancel = new  List<wb_MembershipDetail__c>();
        
        // Deduce the Admission Fee
        /*
            wb_MembershipDetail__c nd = new wb_MembershipDetail__c(name = p.name + '-' + subnumber,
                                                                                   Membership__c= p.Membership__c, ParentDetail__c=p.id,
                                                                                   Individual__c= AdmissionMembers[i].Individual__c,
                                                                                   Quantity__c= - AdmissionMembers[i].Quantity__c,
                                                                                   Type__c = '入会金', SecondType__c= AdmissionMembers[i].Name);
                            AdmissionfeeCNew.add(nd);
        */
        
        // Process the Cancallation of Member
        for (wb_MembershipDetail__c m : MembershipDetailList_Member) { 
             
            
            wb_Individual__c theInd;
            for (integer i=0; i <IndList.size(); i++ ){
                if (IndList[i].id == m.Individual__c )
                    theInd = IndList[i];
            }
            
            
            //theInd.MembershipEndDate__c=td;
           // theInd.Classification__c = '非会員';
            
            boolean found = false;
            wb_member__c theMember;
            
            // To check if the Indiviual is an existing member under the same working company
            for (integer i=0; i<MemberList.size() && found == false ; i++){
                if ( MemberList[i].Individual__c == m.individual__c 
                   // && MemberList[i].WorkingCompany__c == m.WorkingCompany__c 
                      && MemberList[i].Id == m.Member__c 
                   ){
                    found = true;
                    theMember = MemberList[i];
                }
            }
            
 
            // Cancellation of Admission
           if ( found == true && m.ParentDetail__c == null && theMember.AdmissionFee__c != null ) {
               wb_MembershipDetail__c nd = new wb_MembershipDetail__c(name = theMember.AdmissionFee__r.name + 'D',
                                                                      Membership__c= theMember.AdmissionFee__r.Membership__c, 
                                                                      ParentDetail__c=theMember.AdmissionFee__r.ParentDetail__c,
                                                                      SecondType__c=  theMember.AdmissionFee__r.SecondType__c,
                                                                      Individual__c= theMember.AdmissionFee__r.Individual__c,
                                                                      WorkingCompany__c= theMember.AdmissionFee__r.WorkingCompany__c,
                                                                      MemberNo__c= theMember.AdmissionFee__r.MemberNo__c,
                                                                      Member__c=theMember.id,
                                                                      MembershipEndDate__c = m.MembershipEndDate__c,
                                                                      Quantity__c= 1,
                                                                      Type__c = '入会金');
               AdmissionfeeCancel.add(nd);
                
           }
            
            if ( found == true && m.ParentDetail__c == null ){
                            
                MemberHistory_Cancel.add( new wb_MemberHistory__c(
                    member__c   = theMember.id,
                    MemberNo__c = m.MemberNo__c,
                    MembershipDetail__c = m.id,
                    MembershipStopDate__c = m.MembershipStopDate__c,
                    MembershipStartDate__c = m.MembershipStartDate__c,
                    CancellationDate__c=td,
                    Classification__c = '解約退会'
                ));
                
                
            }
            
     
              m.CancellationDate__c=td;
        }
        

		// Process the Cancallation of Family
        for (wb_MembershipDetail__c m:MembershipDetailList_Family){
            
            wb_Individual__c theInd;
            for (integer i=0; i <IndList.size(); i++ ){
                if (IndList[i].id == m.Individual__c )
                    theInd = IndList[i];
            }
            
            
           // theInd.MembershipEndDate__c = td;
           // theInd.Classification__c = '非会員';
            
            m.CancellationDate__c=td;
            
        }
        
         MDContractRefundList = new List<MDContractBilling>();


        
        for (wb_MembershipDetail__c m : MembershipDetailList_Member){
             MDContractRefundList.add(new MDContractBilling(String.valueOf(m.Membership__c),
                                                                         (Id) (m.Service__c),  
                                                                        '(' + m.name + ') ' + m.MembershipPlan__c,  
                                                                         (Decimal) m.BalanceAmount__c));
        }
        
        //system.debug(MDContractRefundList);
        List<wb_ReceivableServiceFee__c> Refund = new  List<wb_ReceivableServiceFee__c>();
        for (MDContractBilling RList : MDContractRefundList) { 
            Refund.add( new wb_ReceivableServiceFee__c( Classification__c= '会員',
                                                       Date__c=td, Membership__c=MH.id, 
                                                       Country__c = MH.ContractCountry__c, District__c = MH.ContractDistrict__c,
                                                       Service__c = RList.ServiceID,
                                                       ServiceName__c = RList.MDPlan, Currency__c = MH.Currency__c,
                                                       ServiceAmount__c =  RList.Amount,
                                                       InvoicingCompany__c = MH.BillingCompany__c ));   
        }
        
         try{
            //update n;
            update MemberList;
            update MembershipDetailList_Member;
            update MembershipDetailList_Family;
            insert AdmissionfeeCancel;
            insert MemberHistory_Cancel;
             
             integer i = 0;
             integer j = 0;
             for (; i < MemberHistory_Cancel.size();i++){
                 for (; j < MemberHistory_Old.size() && 
                      MemberHistory_Cancel[i].MembershipDetail__c == MemberHistory_Old[j].MembershipDetail__c; j ++ )
                 {
                     MemberHistory_Old[j].ReplacedWith__c = MemberHistory_Cancel[i].id;
                     MemberHistory_Old[j].EffectiveUntil__c = null;
                 }
             }
             update MemberHistory_Old;   
             
        //    update MembershipDetailList_Holder;
        //    update MembershipDetailList_Admissionfee;
           // if (CroRef.size() > 0)
          //      update CroRef;
          //  update IndListALL;
            insert Refund;
            
        } catch (System.QueryException e){
           // System.debug(e);
            return false;
        }
        
        
        return true;
    }
    
     public boolean BillingCancellationChange(wb_Membership__c MH,  List<wb_MembershipDetail__c> MD_ALL){
       
        system.debug(MD_ALL);
        Date td;
        // Today as billing date
        td = date.today();
        List<MDContractBilling> MDContractRefundList;
        
        List<wb_MembershipDetail__c> MembershipDetailList_Member = new List<wb_MembershipDetail__c>();
        List<wb_MembershipDetail__c> MembershipDetailList_Family = new List<wb_MembershipDetail__c>();
        
        for ( wb_MembershipDetail__c  a:MD_ALL ){
            if ( a.Service__r.DataType__c =='単身' || a.Service__r.DataType__c =='家族') {
                if ( a.ParentDetail__c == null)
                    MembershipDetailList_Member.add(a);
                else
                    MembershipDetailList_Family.add(a);   
            }
            
        }
        
        List<Id> IndID = new List<ID>();
        List<Id> MDIDs = new List<ID>();
        List<Id> PMDIDs = new List<ID>();
        List<Id> MbrIDs = new List<ID>();
        
        for ( wb_MembershipDetail__c md:MD_ALL){
            if (md.individual__c != null )
                IndID.add(md.individual__c);
            if (md.Member__c != null )
                MbrIDs.add(md.Member__c);
            MDIDs.add(md.Id);
            PMDIDs.add(md.PreviousRecord__c);
        }
        
        List<wb_Individual__c> IndList = [SELECT Id,// CurrentMemberNo__c, MembershipEndDate__c, MembershipStartDate__c ,// Classification__c, 
                                          FamilyNo__c,
                                          Old_Id__c
                                          FROM wb_Individual__c where Id  =:IndID ];
        
        List<wb_member__c> MemberList = [select id, Name, Individual__c, WorkingCompany__c, EndDate__c, MembershipDetail__c,
                                         Old_MemberNo__c, 
                                         AdmissionFee__c, 
                                         AdmissionFee__r.Membership__c, AdmissionFee__r.ParentDetail__c, AdmissionFee__r.SecondType__c,
                                         AdmissionFee__r.WorkingCompany__c, AdmissionFee__r.Individual__c, AdmissionFee__r.MemberNo__c,
                                         AdmissionFee__r.Type__c, AdmissionFee__r.name
                                         from wb_member__c 
                                         where Id =:MbrIDs ];
        
        List<Id> MBIDs = new List<Id>();
        for (wb_member__c m:MemberList)
            MBIDs.add(m.Id);
        
        List<wb_MemberHistory__c> MemberHistory_Old = [select id, MembershipDetail__c, member__c, ReplacedWith__c, EffectiveUntil__c
                                                       from wb_MemberHistory__c 
                                                       where MembershipDetail__c=:PMDIDs
                                                       order by MembershipDetail__c];

        List<wb_MemberHistory__c> MemberHistory_CancelChange;
        MemberHistory_CancelChange = new List<wb_MemberHistory__c>();
        
       // List<wb_MembershipDetail__c> AdmissionfeeCancel = new  List<wb_MembershipDetail__c>();
        

        
        // Process the Cancallation Changes of Members
        system.debug(MembershipDetailList_Member);
        for (wb_MembershipDetail__c m : MembershipDetailList_Member) { 
             
            
            wb_Individual__c theInd;
            for (integer i=0; i <IndList.size(); i++ ){
                if (IndList[i].id == m.Individual__c )
                    theInd = IndList[i];
            }
            
            
            //theInd.MembershipEndDate__c=td;
           // theInd.Classification__c = '非会員';
            
            boolean found = false;
            wb_member__c theMember;
            
            system.debug(MemberList);
            // To check if the Indiviual is an existing member under the same working company
            for (integer i=0; i<MemberList.size() && found == false ; i++){
                if ( MemberList[i].Individual__c == m.individual__c 
                   // && MemberList[i].WorkingCompany__c == m.WorkingCompany__c 
                      && MemberList[i].Id == m.Member__c 
                   ){
                    found = true;
                    theMember = MemberList[i];
                }
            }
            
 

            
            if ( found == true && m.ParentDetail__c == null ){
                            
                MemberHistory_CancelChange.add( new wb_MemberHistory__c(
                    member__c   = theMember.id,
                    MemberNo__c = m.MemberNo__c,
                    MembershipDetail__c = m.id,
                    MembershipStopDate__c = m.MembershipStopDate__c,
                    MembershipStartDate__c = m.MembershipStartDate__c,
                    EffectiveUntil__c = m.MembershipStopDate__c,
                    CancellationDate__c=td,
                    Classification__c = '解約変更'
                ));
                
                
            }
            
     
              m.CancellationDate__c=td;
        }
        

		// Process the Cancallation of Family
        for (wb_MembershipDetail__c m:MembershipDetailList_Family){
            
            wb_Individual__c theInd;
            for (integer i=0; i <IndList.size(); i++ ){
                if (IndList[i].id == m.Individual__c )
                    theInd = IndList[i];
            }
            
            
           // theInd.MembershipEndDate__c = td;
           // theInd.Classification__c = '非会員';
            
            m.CancellationDate__c=td;
            
        }
        
         MDContractRefundList = new List<MDContractBilling>();


        
        for (wb_MembershipDetail__c m : MembershipDetailList_Member){
             MDContractRefundList.add(new MDContractBilling(String.valueOf(m.Membership__c),
                                                                         (Id) (m.Service__c),  
                                                                        '(' + m.name + ') ' + m.MembershipPlan__c,  
                                                                         (Decimal) m.Amount__c));
        }
        
        system.debug(MDContractRefundList);
        List<wb_ReceivableServiceFee__c> Refund = new  List<wb_ReceivableServiceFee__c>();
        for (MDContractBilling RList : MDContractRefundList) { 
            Refund.add( new wb_ReceivableServiceFee__c( Classification__c= '会員',
                                                       Date__c=td, Membership__c=MH.id, 
                                                       Country__c = MH.ContractCountry__c, District__c = MH.ContractDistrict__c,
                                                       Service__c = RList.ServiceID,
                                                       ServiceName__c = RList.MDPlan, Currency__c = MH.Currency__c,
                                                       ServiceAmount__c =  RList.Amount,
                                                       InvoicingCompany__c = MH.BillingCompany__c ));   
        }
        
         try{
            //update n;
            update MemberList;
            update MembershipDetailList_Member;
            update MembershipDetailList_Family;
          //  insert AdmissionfeeCancel;
            insert MemberHistory_CancelChange;
            system.debug(MemberHistory_CancelChange);
             
             List<Id> MHC = new List<Id>();
             for ( wb_MemberHistory__c h:MemberHistory_CancelChange){
                 MHC.add(h.id);
             }
             
             MemberHistory_CancelChange = [select Id, MembershipDetail__r.PreviousRecord__c 
                                           from wb_MemberHistory__c where Id =:MHC 
                                           order by MembershipDetail__r.PreviousRecord__c ];
             integer i = 0;
             integer j = 0;
             for (; i < MemberHistory_CancelChange.size();i++){
                 for (; j < MemberHistory_Old.size() && 
                      MemberHistory_CancelChange[i].MembershipDetail__r.PreviousRecord__c  == MemberHistory_Old[j].MembershipDetail__c; j ++ )
                 { 
                     if (MemberHistory_Old[j].ReplacedWith__c == null ) {
                         MemberHistory_Old[j].ReplacedWith__c = MemberHistory_CancelChange[i].id;
                         MemberHistory_Old[j].EffectiveUntil__c = null;
                     }
                 }
             }
             update MemberHistory_Old;   
             

            insert Refund;
             system.debug(Refund);
            
        } catch (System.QueryException e){
           // System.debug(e);
            return false;
        }
        
        
        return true;
    }
    
 
    public boolean CheckCancelReadiness(ID mh_id){
        wb_Membership__c status = [select Status__c from wb_Membership__c where id =:mh_id];
        
        //system.debug('status:' + status + ' ' +mh_id );
        if ( status.Status__c =='確定')
            return true;
        else
            return false;
        
    }
    
    public boolean CancelAndRefund(ID mh_id){
        
        wb_Membership__c n = [select id, Status__c, Name, ContractCountry__c, ContractCompany__c, ContractDistrict__c, 
                              ContractDate__c, Currency__c, BillingCompany__c
                              from wb_Membership__c where id =:mh_id];
        
        Date td;
        // Today as refund date
        td = date.today();
        List<MDContractBilling> MDContractRefundList;
        
        List<wb_MembershipDetail__c> MembershipDetailList_All = [SELECT Id, Name, MembershipEndDate__c, MembershipStartDate__c,
                                                                 individual__c, MemberNo__c, WorkingCompany__c, Membership__c,Type__c, MembershipPlan__c,
                                                                 Service__r.CardPrefix__c, Service__r.DataType__c, WorkingCompany__r.CountryCd__c, 
                                                                 Individual__r.FamilyNo__c,
                                                                 Quantity__c,ParentDetail__c,SecondType__c,CrossReference__c
                                                                 FROM wb_MembershipDetail__c
                                                                 where Membership__c =:mh_id //and ParentDetail__c = null
                                                                 order by id
                                                                ];
        
        List<wb_MembershipDetail__c> MembershipDetailList_Admissionfee = new List<wb_MembershipDetail__c>();
        List<wb_MembershipDetail__c> MembershipDetailList_Member = new List<wb_MembershipDetail__c>();
        List<wb_MembershipDetail__c> MembershipDetailList_Family = new List<wb_MembershipDetail__c>();
        List<wb_MembershipDetail__c> MembershipDetailList_Holder = new List<wb_MembershipDetail__c>();
        List<wb_MembershipDetail__c> MembershipDetailList_HolderList = new List<wb_MembershipDetail__c>();
        
        List<wb_MemberHistory__c> MemberHistory_Cancel =  new List<wb_MemberHistory__c>();
            
        for ( wb_MembershipDetail__c  a:MembershipDetailList_All ){
            if ( a.Type__c == '入会金')
                MembershipDetailList_Admissionfee.add(a);
            else if ( a.Type__c =='単身' || a.Type__c =='家族') {
                if ( a.ParentDetail__c == null)
                    MembershipDetailList_Member.add(a);
                else
                    MembershipDetailList_Family.add(a);   
            }
            else if ( a.Type__c =='無記名' ) {
                if (a.ParentDetail__c==null)
                    MembershipDetailList_Holder.add(a);
                else
                    MembershipDetailList_HolderList.add(a);
                    }
        }
        
         
        List<Id> IndID = new List<ID>();
        List<Id> MDID = new List<ID>();
        
        for ( wb_MembershipDetail__c md:MembershipDetailList_All){
            if (md.individual__c != null)
                IndID.add(md.individual__c);
            MDID.add(md.id);
        }
        
        List<wb_Individual__c> IndListALL = [SELECT Id, // CurrentMemberNo__c, MembershipEndDate__c, MembershipStartDate__c ,// Classification__c,
                                             FamilyNo__c
                                             FROM wb_Individual__c where Id  =:IndID ];
        
        List<wb_member__c> MemberList = [select id, Name, Individual__c, WorkingCompany__c, EndDate__c, MembershipDetail__c
                                         from wb_member__c 
                                         where Individual__c =:IndID and MembershipDetail__c=:MDID ];
        

        for (wb_MembershipDetail__c m : MembershipDetailList_Member) { 
            
            wb_Individual__c theInd;
            for (integer i=0; i <IndListALL.size(); i++ ){
                if (IndListALL[i].id == m.Individual__c )
                    theInd = IndListALL[i];
            }
            
            
        //    theInd.MembershipEndDate__c=td;
            //theInd.Classification__c = '非会員';
            
            boolean found = false;
            wb_member__c theMember;
            
            // To check if the Indiviual is an existing member under the same working company
            for (integer i=0; i<MemberList.size() && found == false ; i++){
                if ( MemberList[i].Individual__c == m.individual__c && MemberList[i].WorkingCompany__c == m.WorkingCompany__c ){
                    found = true;
                    theMember = MemberList[i];
                }
            }
            
            if ( found == true && m.ParentDetail__c == null ){
                            
                MemberHistory_Cancel.add( new wb_MemberHistory__c(
                    member__c   = theMember.id,
                    MemberNo__c = m.MemberNo__c,
                    MembershipDetail__c = m.id,
                    MembershipEndDate__c = m.MembershipEndDate__c,
                    MembershipStartDate__c = m.MembershipStartDate__c,
                    CancellationDate__c=td,
                    Classification__c = 'キャンセル'
                ));
                
                //theMember.MembershipDetail__c=m.id;
                theMember.EndDate__c = td;
              //  theInd.CurrentMemberNo__c = null; 
                
            }
            
     
              m.CancellationDate__c=td;
        }
        

		// Process the Cancallation of Family
        for (wb_MembershipDetail__c m:MembershipDetailList_Family){
            
            wb_Individual__c theInd;
            for (integer i=0; i <IndListALL.size(); i++ ){
                if (IndListALL[i].id == m.Individual__c )
                    theInd = IndListALL[i];
            }
            
            
           // theInd.MembershipEndDate__c = td;
            //theInd.Classification__c = '非会員';
            
            m.CancellationDate__c=td;
            
        }
        
        
        // Process the Cancallation of Card Holder 
        for (wb_MembershipDetail__c m:MembershipDetailList_Holder)
        {             
            // To check if the Indiviual is an existing member under the same working company
            for (integer i=0; i<MemberList.size() ; i++){
                if ( MemberList[i].MembershipDetail__c == m.id && MemberList[i].WorkingCompany__c == m.WorkingCompany__c ){
                    MemberList[i].EndDate__c = td;
                    //   theMember = MemberList[i];
                    
                    for (wb_MembershipDetail__c hl:MembershipDetailList_HolderList)
                    { 
                        if (hl.ParentDetail__c == m.id) {
                            MemberHistory_Cancel.add( new wb_MemberHistory__c(
                                member__c   =  MemberList[i].id,
                                MemberNo__c = hl.MemberNo__c,
                                MembershipDetail__c = m.id,
                                MembershipEndDate__c = hl.MembershipEndDate__c,
                                MembershipStartDate__c = hl.MembershipStartDate__c,
                                CancellationDate__c=td,
                                Classification__c = 'キャンセル'
                            ));
                        }
                    }
                    
                }
            }
            
              m.CancellationDate__c=td;

        }
        
		// Process the Cancallation of Admission Fee
		List<Id> CroRefId = new List<Id>();
        List <wb_MembershipDetail__c> CroRef = new List <wb_MembershipDetail__c>();
        for (wb_MembershipDetail__c m: MembershipDetailList_Admissionfee){
            m.CancellationDate__c=td;
            //(m.id + ':' + m.SecondType__c);
            if ( m.SecondType__c =='IN')
                CroRefId.add(m.CrossReference__c);
        }
        //system.debug('CroRefId:' + CroRefId.size());
        if (CroRefId.size() > 0){
            CroRef = [select id, CancellationDate__c from wb_MembershipDetail__c 
                where id =:CroRefId];
            //system.debug('CroRef:' + CroRef.size());
            if (CroRefId.size() == CroRef.size() ) {
                for ( wb_MembershipDetail__c cr:CroRef)
                    cr.CancellationDate__c = td;
            } else
                return false;
        }
        
        MDContractRefundList = new List<MDContractBilling>();
        AggregateResult[] AgR = [SELECT Membership__c,  Service__c, MembershipPlan__c, sum( BillingAmount__c)
                                 FROM wb_MembershipDetail__c
                                 where Membership__c =:n.id and ParentDetail__c = null 
                                 group by Membership__c, Service__c, MembershipPlan__c
                                 having  sum( BillingAmount__c) != null]; 
        for (AggregateResult SalesList : AgR) { 
            MDContractRefundList.add(new MDContractBilling(String.valueOf(SalesList.get('Membership__c')),
                                                            (Id) (SalesList.get('Service__c')),  
                                                            String.valueOf(SalesList.get('MembershipPlan__c')),  
                                                            (Decimal) SalesList.get('expr0')));
        }
        
        List<wb_ReceivableServiceFee__c> Refund = new  List<wb_ReceivableServiceFee__c>();
        for (MDContractBilling RList : MDContractRefundList) { 
            Refund.add( new wb_ReceivableServiceFee__c( Classification__c= '会員',
                                                       Date__c=td, Membership__c=n.id, 
                                                       Country__c = n.ContractCountry__c, District__c = n.ContractDistrict__c,
                                                       Service__c = RList.ServiceID,
                                                       ServiceName__c = RList.MDPlan, Currency__c = n.Currency__c,
                                                       ServiceAmount__c = - RList.Amount,
                                                       InvoicingCompany__c = n.BillingCompany__c ));                                                                                

        }
        
        n.Status__c = 'キャンセル';
        
            
        try{
            update n;
            update MemberList;
            update MembershipDetailList_Member;
            update MembershipDetailList_Family;
            update MembershipDetailList_Holder;
            update MembershipDetailList_Admissionfee;
            if (CroRef.size() > 0)
                update CroRef;
            update IndListALL;
            insert Refund;
            
        } catch (System.QueryException e){
           // System.debug(e);
            return false;
        }
        
        return true;
    }

    
    public static void CancelBilling( wb_Membership__c n) {
       
        Date d;
        // Use the system date as billing date
        d = date.today();
        List<MDContractBilling> MDContractBillingList;
        // MyID = n.ID;
        
        // Update the Individual Membership initial date and end date with the Contract Detail
        // 
        List<wb_MembershipDetail__c> MemberList = [SELECT MembershipEndDate__c, MembershipStartDate__c, Individual__c, 
                                                   WorkingCompany__c, Membership__c,
                                                   Service__r.CardPrefix__c, WorkingCompany__r.CountryCd__c, 
                                                   Individual__r.FamilyNo__c,
                                                   Quantity__c
                                                   FROM wb_MembershipDetail__c
                                                   where Membership__c =:n.ID
                                                   order by Name
                                                  ];
        
        for (wb_MembershipDetail__c m : MemberList) { 
            if ( m.Service__r.CardPrefix__c =='1' ||  m.Service__r.CardPrefix__c =='2' ) {  // Individual or Family Membership
                if( [select id from wb_Individual__c where  Id =:m.Individual__c
                    ].size() > 0 ) {
                        /*
                        wb_Individual__c i = [SELECT MembershipEndDate__c, MembershipStartDate__c,// Classification__c, 
                                              Id 
                                              FROM wb_Individual__c where Id  =:m.Individual__c 
                                             ];
                        
                        i.MembershipEndDate__c = d; */
                       // i.Classification__c = '退会会員';
                        
                        
                        
                        wb_member__c member = [select id, Name from wb_member__c where //Individualn__c =:i.id and 
                                               WorkingCompany__c =:m.WorkingCompany__c ];  
                        
                        string MemberNo = m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCd__c + member.name + m.Individual__r.FamilyNo__c;
                        
                        insert new wb_MemberHistory__c(
                            member__c   = member.id,
                            MemberNo__c = MemberNo,
                            MembershipDetail__c = m.id,
                            MembershipEndDate__c = m.MembershipEndDate__c,
                            MembershipStartDate__c = m.MembershipStartDate__c,
                            Classification__c = 'キャンセル'
                        );
                        
                        
                        //string MemberNo = m.Service__r.CardPrefex__c + m.WorkingCompany__r.CountryCd__c + member.name + m.Individual__r.FamilyNo__c;
                     //   i.CurrentMemberNo__c = '';  
                        // string FamilyMemberNo =  m.Service__r.CardPrefex__c + m.WorkingCompany__r.CountryCd__c +  member.name ;
                        
                        // Update the Start and End Date of the Family Member
                        /*
                        LIST<wb_Individual__c> FamilyMember = [SELECT // MembershipEndDate__c, MembershipStartDate__c,
                                                               FamilyNo__c, Id 
                                                               FROM wb_Individual__c where Parent__c  =:m.Individual__c 
                                                              ];
                        
                       
                        for (wb_Individual__c f : FamilyMember){
                            
                            
                          //  f.CurrentMemberNo__c = '';
                            // f.MembershipStartDate__c = m.MembershipStartDate__c;
                            f.MembershipEndDate__c = d;
                          //  f.Classification__c = '退会会員';
                            
                            update f;
                        } */
                        
                     //   update i;          
                    }
            } else if  ( m.Service__r.CardPrefix__c =='3' ) // Anonymous Membership
            {
                Integer ExistingQty =  [select id from wb_member__c where  Individual__c = null and WorkingCompany__c =:m.WorkingCompany__c ].size();
                
                
                /*    List<wb_MemberHistory__c> AMs =	[ select wb_member__c
from wb_MemberHistory__c
where  wb_MembershipDetail__c =: m.id ]; */
                
                List<wb_MemberHistory__c> CancelMembers = [SELECT  member__c, MemberNo__c 
                                                           FROM wb_MemberHistory__c where  MembershipDetail__c =: m.id ];
                /*      String SOQL_IDs = '';
for (wb_MemberHistory__c am : AMs) {
String id_in_quotes = '\''+am.wb_member__c+'\'';
if (SOQL_IDs!='') { SOQL_IDs+=','; }  //  add a comma if this isn't the first one
SOQL_IDs += id_in_quotes;
}

insert new Apex_Debug_Log__c(
Class__c    = 'Class: wb_v2_MembershipBilling',
Method__c   = 'SObject: Cancal',
Message__c  = 'Cancal for ' + SOQL_IDs
); 

List<wb_member__c> AnonymousMembers = [ select id, Name 
from wb_member__c 
where  Individual__c = null 
and WorkingCompany__c =:m.WorkingCompany__c 
and id in (:SOQL_IDs)
order by Name ];
*/
                Integer CancelQty = 0;
                for (wb_MemberHistory__c a : CancelMembers) {
                    
                    /*        insert new Apex_Debug_Log__c(
Class__c    = 'Class: wb_v2_MembershipBilling',
Method__c   = 'SObject: Cancal',
Message__c  = 'Cancal for ' + a.MemberNo__c
);
*/                           
                    // string MemberNo = m.Service__r.CardPrefex__c + m.WorkingCompany__r.CountryCd__c + a.name + '0';
                    if ( CancelQty < m.Quantity__c ) {
                        insert new wb_MemberHistory__c(
                            member__c   = a.member__c,
                            MemberNo__c = a.MemberNo__c,
                            MembershipDetail__c = m.id,
                            MembershipEndDate__c = m.MembershipEndDate__c,
                            MembershipStartDate__c = m.MembershipStartDate__c,
                            Classification__c = 'キャンセル'
                        );
                        CancelQty = CancelQty + 1;
                    }
                }                
            }
            
        }
        
        // Get and Insert the Billing according to the Contract Detail
        MDContractBillingList = new List<MDContractBilling>();
        AggregateResult[] AgR = [SELECT Membership__c,  Service__c, MembershipPlan__c, sum(BillingAmount__c)
                                 FROM wb_MembershipDetail__c
                                 where Membership__c =:n.ID
                                 group by Membership__c, Service__c, MembershipPlan__c]; 
        for (AggregateResult SalesList : AgR) { 
            MDContractBillingList.add(new MDContractBilling(String.valueOf(SalesList.get('WBMembership__c')),
                                                            (Id) (SalesList.get('Service__c')),  
                                                            String.valueOf(SalesList.get('MembershipPlan__c')),  
                                                            (Decimal) SalesList.get('expr0')));
        }
        
        for (MDContractBilling BList : MDContractBillingList) { 
            wb_ReceivableServiceFee__c NewBilling = new wb_ReceivableServiceFee__c( Classification__c= '会員' , 
                                                                                   Date__c=d, Membership__c=n.ID, 
                                                                                   Country__c = n.ContractCountry__c, District__c = n.ContractDistrict__c,
                                                                                   Service__c = BList.ServiceID,
                                                                                   ServiceName__c = BList.MDPlan, Currency__c = n.Currency__c,
                                                                                   ServiceAmount__c= - BList.Amount,
                                                                                   InvoicingCompany__c = n.BillingCompany__c );   
            // InvoicingCompany__c = n.ContractCompany__c);
            try{
                insert NewBilling;
            } catch (System.QueryException e){
                
                System.debug(e);
            }
        }
        
    }

}