public class wb_MembershipClone {
    
    public id OrgMembershipId {get;set;}
    public id NextMembershipId {get;set;}
    
    public wb_Membership__c OrgMembership {get; set;}
    public wb_Membership__c NextMembership {get; set;}
    
    public List<wb_MembershipDetail__c> OrgMembershipDetails {get; set;}
    public List<wb_MembershipDetail__c> OrgMembershipDetailsParent {get; set;}
    public List<wb_MembershipDetail__c> OrgMembershipDetailsChild {get; set;}
    
    public  List<wb_Individual__c> thisIndividualMember {get; set;}
    public  List<wb_Individual__c> thisIndividualFamily {get; set;}
    public  List<wb_Member__c> ThisVisitor {get; set;}
    
    List<wb_utility_quicksort.IdIndex> OrgMembershipDetailsParentIdx;
    List<wb_utility_quicksort.IdIndex> OrgMembershipDetailsChildIdx;
    
    public List<wb_MembershipDetail__c> NextMembershipDetails {get; set;}
    
    public wb_Membership Helper {get; set;}
    
    public wb_MembershipClone( id OrgID ){
        OrgMembershipId = OrgID;
        Helper = new wb_Membership();       
        OrgMembership = Helper.getContractHeader(OrgMembershipId);
        OrgMembershipDetails = Helper.getContractDetail(OrgMembership);
        
    }
    
    
    public void start_continue(){
        //system.debug('start_clone');      
        
        OrgMembershipDetailsParent = new  List<wb_MembershipDetail__c>();
        OrgMembershipDetailsChild = new  List<wb_MembershipDetail__c>();
        
        system.debug(OrgMembershipDetails.size());
        for (wb_MembershipDetail__c d:OrgMembershipDetails){
            if (d.ParentDetail__c == null && d.CancellationDate__c == null)
                OrgMembershipDetailsParent.add(d);
            else if (d.ParentDetail__c != null && d.CancellationDate__c == null)
                OrgMembershipDetailsChild.add(d);
        }
        
        
        wb_utility_quicksort qshelper = new wb_utility_quicksort();
        
        OrgMembershipDetailsParentIdx = new List<wb_utility_quicksort.IdIndex>();
        
        OrgMembershipDetailsChildIdx = new List<wb_utility_quicksort.IdIndex>();
        system.debug(OrgMembershipDetailsParent.size());
        for (integer i=0; i < OrgMembershipDetailsParent.size();i++){
            OrgMembershipDetailsParentIdx.add( new wb_utility_quicksort.IdIndex(OrgMembershipDetailsParent[i].id,i));
        }
        system.debug(OrgMembershipDetailsParentIdx.size());
        
        for (integer i=0; i < OrgMembershipDetailsChild.size();i++){
            OrgMembershipDetailsChildIdx.add( new wb_utility_quicksort.IdIndex(OrgMembershipDetailsChild[i].ParentDetail__c,i));
        }
        

        qshelper.sortcustomObjList(OrgMembershipDetailsParentIdx);    
        qshelper.sortcustomObjList(OrgMembershipDetailsChildIdx);   
        
        Map<Id,Integer> OrgMembershipDetailsChildFirstParentIdxMap = new Map<Id,Integer>();
        
        for ( integer i=0; i < OrgMembershipDetailsChildIdx.size(); i++){
            if (i == 0){
                OrgMembershipDetailsChildFirstParentIdxMap.put(OrgMembershipDetailsChildIdx[i].Id,i);
            } else if ( OrgMembershipDetailsChildIdx[i-1].Id != OrgMembershipDetailsChildIdx[i].Id){
                OrgMembershipDetailsChildFirstParentIdxMap.put(OrgMembershipDetailsChildIdx[i].Id,i);
            }
            
        }
        
        Helper = new wb_Membership();    
        
        
        Helper = MembershipContractHeaderContinue( Helper, OrgMembership);
        
        
        system.debug(OrgMembershipDetailsParentIdx.size());
        
        List<Id> IndIDs = new List<Id>();
        List<Id> VisitorMemberIDs = new List<Id>();
        
        for ( integer p = 0; p<OrgMembershipDetailsParent.size();p++){
            if ( (OrgMembershipDetailsParent[p].Type__c == '家族' || OrgMembershipDetailsParent[p].Type__c == '単身') 
                && OrgMembershipDetailsParent[p].Individual__c != null) {
                    IndIDs.add(OrgMembershipDetailsParent[p].Individual__c);
                } else if (OrgMembershipDetailsParent[p].Type__c == '無記名'){
                    if(OrgMembershipDetailsChildFirstParentIdxMap.containsKey(OrgMembershipDetailsParent[p].Id))
                    {
                        
                        //get the index
                        Integer index = OrgMembershipDetailsChildFirstParentIdxMap.get(OrgMembershipDetailsParent[p].Id);
                        
                        system.debug(index);
                        for (integer i = index; i < OrgMembershipDetailsChildIdx.size() && 
                             OrgMembershipDetailsChildIdx[i].Id == OrgMembershipDetailsChildIdx[index].Id; i++){
                                 VisitorMemberIDs.add(OrgMembershipDetailsChild[OrgMembershipDetailsChildIdx[i].idx].Member__c);
                             }
                        
                    }
                }
            
        }
        
        
        thisIndividualMember =[select Id, name, WorkingCompany__c, Old_Id__c, Parent__c
                               from wb_Individual__c 
                               where id =:IndIDs // and id ='a0n5D000000eaemQAA'
                               order by Id];
        system.debug(thisIndividualMember);        
        
        Map<Id,Integer> MemberIdxMap = new Map<Id,Integer>();
        for ( integer i = 0; i<thisIndividualMember.size();i++){
            MemberIdxMap.put(thisIndividualMember[i].Id,i);
        }
        
        thisIndividualFamily = [select Id, name, Parent__c, Old_Id__c, Parent__r.Old_Id__c
                                from wb_Individual__c 
                                where Parent__c =:IndIDs  //and Parent__c ='a0n5D000000eaemQAA'
                                order by Parent__c desc ];
        system.debug(thisIndividualFamily);
        
        
        ThisVisitor = [select Id, Name, Old_Id__c, WorkingCompany__c, Old_MemberNo__c 
                       from wb_Member__c 
                       where Id =:VisitorMemberIDs 
                       order by WorkingCompany__c, f_MemberNo__c];
        system.debug(ThisVisitor);
        
        Map<Id,Integer> VisitorWorkingCompanyFirstIdxMap = new Map<Id,Integer>();
        
        for ( integer i=0; i < ThisVisitor.size(); i++){
            if (i == 0){
                VisitorWorkingCompanyFirstIdxMap.put(ThisVisitor[i].WorkingCompany__c,i);
            } else if ( ThisVisitor[i-1].WorkingCompany__c != ThisVisitor[i].WorkingCompany__c){
                VisitorWorkingCompanyFirstIdxMap.put(ThisVisitor[i].WorkingCompany__c,i);
            }
            
        }
        
        
        
        Map<Id,Integer> MemberFamilyFirstIdxMap = new Map<Id,Integer>();
        
        for ( integer i=0; i < thisIndividualFamily.size(); i++){
            if (i == 0){
                MemberFamilyFirstIdxMap.put(thisIndividualFamily[i].Parent__c,i);
            } else if ( thisIndividualFamily[i-1].Parent__c != thisIndividualFamily[i].Parent__c){
                MemberFamilyFirstIdxMap.put(thisIndividualFamily[i].Parent__c,i);
            }
            
        }
        system.debug(MemberFamilyFirstIdxMap);
        
        //   for ( integer p =0; p < OrgMembershipDetailsParentIdx.size() ; p ++){
        List<wb_Individual__c> Family = new List<wb_Individual__c>();
        List<wb_Member__c> Visitor;
        for ( integer p =0; p < OrgMembershipDetailsParentIdx.size() ; p ++){
            
            
            system.debug(OrgMembershipDetailsParent[p]);
            if (OrgMembershipDetailsParent[p].Type__c == '家族' || OrgMembershipDetailsParent[p].Type__c == '単身' ) {
                Integer midx = MemberIdxMap.get(OrgMembershipDetailsParent[p].Individual__c);
                
                Family = new List<wb_Individual__c>();
                if ( OrgMembershipDetailsParent[p].Type__c == '家族'){
                    system.debug(OrgMembershipDetailsParent[p]);
                    if(MemberFamilyFirstIdxMap.containsKey(OrgMembershipDetailsParent[p].Individual__c))
                    {
                        
                        //get the index
                        Integer index = MemberFamilyFirstIdxMap.get(OrgMembershipDetailsParent[p].Individual__c);
                        system.debug(index);
                        for (integer i = index; i < thisIndividualFamily.size() && 
                             thisIndividualFamily[i].Parent__c == thisIndividualFamily[index].Parent__c; i++){
                                 Family.add(thisIndividualFamily[i]);
                             }
                    }
                }
                
                Helper = MembershipContractAdd( Helper,  
                                               OrgMembershipDetailsParent[p].Type__c,
                                               Integer.Valueof(OrgMembershipDetailsParent[p].Quantity__c),
                                               OrgMembershipDetailsParent[p].Individual__c,
                                               OrgMembershipDetailsParent[p].Service__c,
                                               thisIndividualMember[midx],
                                               Family,
                                               null,
                                               null,
                                               null,
                                               null
                                              );
            }
            else if (OrgMembershipDetailsParent[p].Type__c == '無記名'){
                Visitor = new List<wb_Member__c>();
                if(VisitorWorkingCompanyFirstIdxMap.containsKey(OrgMembershipDetailsParent[p].WorkingCompany__c))
                {
                    //get the index
                    Integer index = VisitorWorkingCompanyFirstIdxMap.get(OrgMembershipDetailsParent[p].WorkingCompany__c);
                    
                    for (integer v = 0 ; v < Integer.Valueof(OrgMembershipDetailsParent[p].Quantity__c); v ++){
                        if (ThisVisitor[index + v].WorkingCompany__c == OrgMembershipDetailsParent[p].WorkingCompany__c)
                            Visitor.add(ThisVisitor[index + v]);
                    }
                    
                }
                
                Helper = MembershipContractAdd( Helper,  
                                               OrgMembershipDetailsParent[p].Type__c,
                                               Integer.Valueof(OrgMembershipDetailsParent[p].Quantity__c),
                                               null,
                                               OrgMembershipDetailsParent[p].Service__c,
                                               null,
                                               null,
                                               OrgMembershipDetailsParent[p].WorkingCompany__c,
                                               Integer.Valueof(OrgMembershipDetailsParent[p].Quantity__c),
                                               Visitor,
                                               OrgMembershipDetailsParent[p].WorkingCompany__r.CountryCd__c
                                              );
                
                
            }
            
            
        }
        
        system.debug(Helper.MembershipDetailsParent);
        
    }
    
    public wb_Membership MembershipContractHeaderContinue(wb_Membership NextMS, wb_Membership__c ThisMSH ){
        
        date s;
        s=ThisMSH.ContractExpiryDate__c;
        s=s.addYears(1);
        
        NextMS.Membership.Status__c = '未確定';
        NextMS.Membership.ContractCompany__c = ThisMSH.ContractCompany__c;
        NextMS.GetGroupDiscountPercentage();
        NextMS.Membership.Classification__c ='会社';
        NextMS.Membership.BillingCompany__c = ThisMSH.BillingCompany__c;
        NextMS.Membership.ContractCountry__c =ThisMSH.ContractCountry__c;
        NextMS.Membership.ContractDistrict__c = ThisMSH.ContractDistrict__c;
        NextMS.Membership.BillingDistrict__c = ThisMSH.BillingDistrict__c;
        NextMS.Membership.Currency__c = ThisMSH.Currency__c;
        NextMS.Membership.ContractDate__c = system.today();
        NextMS.Membership.ApplicationDate__c = system.today();
        NextMS.Membership.ContractExpiryDate__c = s;
        NextMS.Membership.BillingCompany__c = ThisMSH.BillingCompany__c;
        NextMS.Membership.BillingNote__c = ThisMSH.BillingNote__c;
        NextMS.Membership.BillingFax__c = ThisMSH.BillingFax__c;
        NextMS.Membership.BillingTel__c = ThisMSH.BillingTel__c; 
        NextMS.Membership.BillingExtNo__c = ThisMSH.BillingExtNo__c; 
        NextMS.Membership.BillingCountryNo__c = ThisMSH.BillingCountryNo__c; 
        NextMS.Membership.BillingTitle__c = ThisMSH.BillingTitle__c;
        NextMS.Membership.BillingName__c = ThisMSH.BillingName__c;
        NextMS.Membership.BillingDept__c = ThisMSH.BillingDept__c;
        NextMS.Membership.BillingDistrict__c = ThisMSH.BillingDistrict__c;  

        NextMS.Membership.ContractIndividual__c  = ThisMSH.ContractIndividual__c;
        NextMS.Membership.PreviousContract__c = ThisMSH.Id;

        NextMS.RateAndRoundUp = NextMS.getRateAndRoundUp();
        return NextMS;
    }
    
    public wb_Membership MembershipContractAdd( wb_Membership MS,
                                               string Type, 
                                               integer Qty, 
                                               Id IndID, 
                                               Id ServiceID,
                                               wb_Individual__c theIndividual, 
                                               List<wb_Individual__c> theFamily,
                                               Id VisitorWorkingCompId, 
                                               Integer VisitorQty, 
                                               List<wb_Member__c> CardHolders,
                                               string CountryCode
                                              ){
                                                  wb_Service__c theService;
                                                  system.debug(MS.MembershipDetailsParent);
                                                  /*if (Type == '入会金'){
MS.theMembershipDetail[0].theRow.Membership__c = MS.Membership.id;
MS.theMembershipDetail[0].selectedValue = '1';
MS.theMembershipDetail[0].fetchServiceOptions();

for (wb_Service__c s:MS.MDService) {
if (s.DATATYPE__C =='入会金')
theService = s;
}
MS.theMembershipDetail[0].theRow.Service__c = theService.id;
MS.theMembershipDetail[0].theRow.Quantity__c= Qty;
MS.theMembershipDetail[0].fetchServiceFee();

}
else */
                                                  if (Type == '単身'){
                                                      integer ps = MS.MembershipDetailsParent.size();
                                                      //   system.debug(ps);
                                                      for (wb_Service__c s:MS.MDService) {
                                                          //if (s.SERVICE__C == 'Global Member' && s.DATATYPE__C=='単身' )
                                                          if (s.id == ServiceID )
                                                              theService = s;
                                                      }
                                                      
                                                      
                                                      MS.add_empty_row();
                                                      
                                                      MS.theIndividualList =IndID;
                                                      MS.theServiceList=theService.Id;
                                                      MS.theStartRowIndex= ps ;
                                                      MS.theStartRowID='';
                                                      //MS.UpdateAndInsertRow_at();
                                                      MS.UpdateAndInsertRow_at(theIndividual,null);
                                                      MS.theMembershipDetail[ps].theRow.Classification__c ='継続';
                                                      
                                                      
                                                  } 
                                                  else if (Type == '家族'){
                                                      integer ps = MS.MembershipDetailsParent.size();
                                                      for (wb_Service__c s:MS.MDService) {
                                                          // if (s.SERVICE__C == 'Global Member' && s.DATATYPE__C=='家族' )
                                                          if (s.id == ServiceID )
                                                              theService = s;
                                                      }
                                                      
                                                      
                                                      MS.add_empty_row();
                                                      MS.theIndividualList =IndID;
                                                      MS.theServiceList=ServiceID;
                                                      MS.theStartRowIndex= ps ;
                                                      MS.theStartRowID='';
                                                      //  MS.UpdateAndInsertRow_at();
                                                      MS.UpdateAndInsertRow_at(theIndividual,theFamily);
                                                      MS.theMembershipDetail[ps].theRow.Classification__c ='継続';
                                                  }
                                                  else if (Type == '無記名'){
                                                      integer ps = MS.MembershipDetailsParent.size();
                                                      for (wb_Service__c s:MS.MDService) {
                                                          // if (s.SERVICE__C == 'Biz Trip Pass' && s.DATATYPE__C=='無記名' )
                                                          //     theService = s;
                                                          if (s.id == ServiceID )
                                                              theService = s;
                                                      }
                                                      
                                                      MS.add_empty_row();
                                                      MS.theMembershipDetail[ps].selectedValue = '3';
                                                      MS.theMembershipDetail[ps].fetchServiceOptions();
                                                      MS.theMembershipDetail[ps].theRow.Service__c = theService.id;
                                                      MS.theMembershipDetail[ps].theRow.Type__c = theService.DATATYPE__C;
                                                      MS.theMembershipDetail[ps].theRow.MembershipPlan__c = theService.Service__c;
                                                      MS.theMembershipDetail[ps].theRow.WorkingCompany__c = VisitorWorkingCompId;
                                                      MS.theMembershipDetail[ps].theRow.Quantity__c= VisitorQty;
                                                      MS.theMembershipDetail[ps].fetchServiceFee();
                                                      MS.theMembershipDetail[ps].theRow.Classification__c ='継続';
                                                      //   for (wb_member__c nm : CardHolders) {
                                                      if (CardHolders != null ) {
                                                          for ( integer i = 0; i < CardHolders.size(); i++ ){
                                                              
                                                              //     if (CardHolders[i].Parent.Id == nm.MembershipDetail__c  ){
                                                              string MemberNo;
                                                              if ( CardHolders[i].Old_MemberNo__c != null )
                                                                  MemberNo = theService.CardPrefix__c + 
                                                                  CountryCode +  CardHolders[i].Old_MemberNo__c + '0';
                                                              else
                                                                  MemberNo = theService.CardPrefix__c + 
                                                                  CountryCode +  CardHolders[i].name + '0';
                                                              
                                                              //    integer subno =  CardHolder[i].GetNoofChild() + 1;
                                                              wb_MembershipDetail__c NCH = new wb_MembershipDetail__c(Name=  MS.theMembershipDetail[ps].theRow.name , 
                                                                                                                      WorkingCompany__c = VisitorWorkingCompId,
                                                                                                                      Type__c = MS.theMembershipDetail[ps].theRow.Type__c,
                                                                                                                      Member__c = CardHolders[i].Id,
                                                                                                                      MemberNo__c = MemberNo,
                                                                                                                      Membership__c =  MS.theMembershipDetail[ps].theRow.Membership__c,
                                                                                                                      Service__c = MS.theMembershipDetail[ps].theRow.Service__c,
                                                                                                                      MembershipPlan__c = MS.theMembershipDetail[ps].theRow.MembershipPlan__c,
                                                                                                                      Quantity__c = 1,
                                                                                                                      MembershipStartDate__c = MS.theMembershipDetail[ps].theRow.MembershipStartDate__c,
                                                                                                                      MembershipEndDate__c = MS.theMembershipDetail[ps].theRow.MembershipEndDate__c,
                                                                                                                      // ParentDetail__c = CardHolder[i].Parent.id
                                                                                                                      Classification__c ='継続'
                                                                                                                     );
                                                              //  insert NCH;
                                                              MS.MembershipDetailsChild.add(NCH);
                                                              
                                                          }
                                                      }
                                                      
                                                  }
                                                  MS.removeEmptyRow();
                                                  system.debug(MS.MembershipDetailsParent);
                                                  return MS;
                                              }
    
}