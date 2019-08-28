public class wb_convert_ContractInfo {

   	private ApexPages.StandardController standardController;
    public Account theCompany  {get;set;}
    public List<ContractInfo__c> theContractInfo  {get;set;}
    
    public List<aSelectiveRow> theContractInfoRows { get; set; }
    public List<aSelectiveRow> theMemberAndFamilyInfoRows { get; set; }
    public List<aSelectiveRow> ConvertedMemberAndFamilyInfoRows { get; set; }
    
    public boolean MemberExist(Id theID){
        for ( aSelectiveRow m :theMemberAndFamilyInfoRows){
            if (m.theMemberInfo.Id == theID) {
                return true;
            }   
        }
        return false;
    }
 
    public class aSelectiveRow {
        public Boolean isSelected { get; set; }
        public string isDone { get; set; }
        public ContractInfo__c theContractInfo { get; set; }
        public MemberInfo__c theMemberInfo { get; set; }
        public List<FamilyInfo__c> theFamilyInfo { get; set; }
        
        public wb_Individual__c MappedParent { get; set; }
        public List<wb_Individual__c> MappedChild { get; set; }
        
        public string newid { get; set; }
        public string  WorkingCompany { get; set; }
        public boolean FamilyExist(Id theID){
            for ( FamilyInfo__c f :theFamilyInfo){
                if (f.Id == theID) {
                    return true;
                }   
            }
            return false;
        }
        
        public aSelectiveRow(Boolean b, ContractInfo__c theRow) {
            theContractInfo = theRow;
            isSelected = b;
        }
        public aSelectiveRow(Boolean b, MemberInfo__c theRow) {
            theMemberInfo = theRow;
            isSelected = b;
            
            theFamilyInfo = new List<FamilyInfo__c>();
        }
        
        public aSelectiveRow(Boolean b, MemberInfo__c theRow, List<FamilyInfo__c> theFamily ){
            theMemberInfo = theRow;
            isSelected = b;
            theFamilyInfo = new List<FamilyInfo__c>();
            theFamilyInfo = theFamily;
        }
    }
    
    public List<MemberInfo__c> theMemberInfo  {get;set;}
    public List<FamilyInfo__c> theFamilyInfo  {get;set;}
    
    public wb_Membership__c theMembership {get;set;}
    public List<wb_MembershipDetail__c> theMembershipDetail {get;set;}
    public List<wb_Individual__c> theIndividual {get;set;}
    public wb_Membership ConvertedResult {get;set;}
    
    public List<Family> theMappedFamilies {get;set;}
    
    public class Family {

        public wb_Individual__c theParent { get; set; }
        public List<wb_Individual__c> theChild { get; set; }

        
         public Family(wb_Individual__c p, List<wb_Individual__c> c){
             theParent = p;
             theChild = new List<wb_Individual__c>();
             theChild = c;
         }
    } 
    
    public wb_convert_ContractInfo(ApexPages.StandardController stdController){
        this.standardController = stdController;
        theCompany = (Account) stdController.getRecord();
        system.debug('ID:' + theCompany.id);
        if (theCompany.id != null) {
            getContractInfo();
          
        }
         ConvertedResult = new wb_Membership();
        IsSelectAll = false;
    }
    
    void getContractInfo(){
        
        theContractInfo = [ select id, KeiyakuArea__c, KeiyakuCompanyName__c, KeiyakuCompanyName__r.name,
                           SeikyuArea__c, SeikyuCompanyName__c, SeikyuCompanyName__r.name, Currency__c
                           from ContractInfo__c 
                           where KeiyakuCompanyName__c =:theCompany.id];
           theContractInfoRows = new List<aSelectiveRow>();
        if (theContractInfo.size() > 0){
            for (ContractInfo__c c:theContractInfo){
                theContractInfoRows.add( new aSelectiveRow( false, c));
            }
            getMemberAndFamily();
        }
    }
    
    void getMemberAndFamily(){
        List<Id> CId = new  List<Id>();

        for (ContractInfo__c c:theContractInfo){
     
                CId.add(c.id);
         
        }
        if(CId.size()>0){
            
            theFamilyInfo = [SELECT Id, MemberShimei__c
                             FROM FamilyInfo__c
                             where  MemberShimei__r.CompanyKeiyakuNo__c =:CId ];
            
            List<Id> MemberIds = new List<Id>();
            
            for ( FamilyInfo__c f:theFamilyInfo){
                MemberIds.add(f.MemberShimei__c);
            }
        
            
            sortList = [Select id, Name,Sex__c,DateOfBirth__c,KinmuCompany__c,
                             //Postcd__c,Email__c,MailHaishin__c,CountryCallingCodes__c,
                             //Mobile__c,Tel__c,Address__c,
                             SeiRoma__c, //SeiKana__c,
                             MeiRoma__c, //MeiKana__c, Yakushoku__c, 
                             KeiyakuNo__c,
                             CompanyKeiyakuNo__c, KeiyakuKeitai__c, o_id__c
                             From MemberInfo__c 
                             where CompanyKeiyakuNo__c =:CId
                        	and id=:MemberIds
                            order by id];
             sortcustomObjList(sortList); // Sort the list in string order with ID
            theMemberInfo = sortList;
            
           // List<Id> MemberIds = new List<Id>();
            
            for ( MemberInfo__c m:theMemberInfo){
                MemberIds.add(m.id);
            }
            
            theFamilyInfo = [Select id, Name,Sex__c,DateOfBirth__c,Email__c,MailHaishin__c,
                             Mobile__c,SeiRoma__c,SeiKana__c,MeiRoma__c,MeiKana__c, 
                             FamilyNo__c,Relationship__c,
                             MemberShimei__c, MemberShimei__r.CompanyKeiyakuNo__c
                             From FamilyInfo__c 
                             where MemberShimei__c=:MemberIds
                            // where MemberShimei__r.CompanyKeiyakuNo__c =:CId
                            order by id]; 
            
        }
    }
    
    public void RefreshMemberAndFamily(){
        if ( theMemberAndFamilyInfoRows == null )
            theMemberAndFamilyInfoRows = new List<aSelectiveRow>();
        
        for (aSelectiveRow c:theContractInfoRows){
            if (c.isSelected == true){
                for (MemberInfo__c m:theMemberInfo){
                    if (m.CompanyKeiyakuNo__c == c.theContractInfo.id){
                        if ( MemberExist(m.Id) == false) {
                            aSelectiveRow MemberAndFamilyInfoRow = new aSelectiveRow(true,m);
                            for ( FamilyInfo__c f:theFamilyInfo){
                                if ( f.MemberShimei__c == m.id ) //&& f.MemberShimei__r.CompanyKeiyakuNo__c == c.theContractInfo.id)
                                {
                                    if (MemberAndFamilyInfoRow.FamilyExist(f.id) == false)
                                        MemberAndFamilyInfoRow.theFamilyInfo.add(f);
                                }
                                
                            }
                            
                            theMemberAndFamilyInfoRows.add( MemberAndFamilyInfoRow);
                        }
                    }
                }
            }
            else {
                 for (MemberInfo__c m:theMemberInfo){
                    if (m.CompanyKeiyakuNo__c == c.theContractInfo.id){
                        for ( aSelectiveRow t :theMemberAndFamilyInfoRows){
                            if (t.theMemberInfo.Id == m.id) {
                                t.isSelected = false;
                            }   
                        }
                    }
                 }
                
            }
        }
    
    }
    
    public void MapMemberInfoWithIndividual(){
        
        List<Id> theSelectedMemInfoID = new List<Id>();
        List<Id> theSelectedFamID = new List<Id>();
        ConvertedMemberAndFamilyInfoRows = new List<aSelectiveRow>();
        for (aSelectiveRow m:theMemberAndFamilyInfoRows){
            if (m.isSelected == true){
                ConvertedMemberAndFamilyInfoRows.add(new aSelectiveRow(true,m.theMemberInfo, m.theFamilyInfo));
            }
        }
        
        system.debug(theMemberAndFamilyInfoRows.size() +',' + ConvertedMemberAndFamilyInfoRows.size());
        
        for (aSelectiveRow m:ConvertedMemberAndFamilyInfoRows) {
            if (m.isSelected == true){
                theSelectedMemInfoID.add(m.theMemberInfo.Id);
                if (m.theFamilyInfo.size()>0){
                    for (FamilyInfo__c f:m.theFamilyInfo){
                        //  Families.add( new Family(m.theMemberInfo.Id, f.Id));
                        theSelectedFamID.add(f.Id);
                    }
                }
            }
        }
        
        List<wb_Individual__c> ExistIndividual;
        List<wb_Individual__c> ExistFamily;
        system.debug( theSelectedMemInfoID );
        if (theSelectedMemInfoID.size() > 0 ){
            ExistIndividual = [select Id, name, WorkingCompany__c, Old_Id__c 
                               from wb_Individual__c 
                               where Old_Id__c =:theSelectedMemInfoID 
                               order by Old_Id__c ];
        }
        
  
        //system.debug(ExistIndividual);
        
        if (theSelectedFamID.size() > 0 ){
            ExistFamily = [select Id, name, Parent__c, Old_Id__c, Parent__r.Old_Id__c
                           from wb_Individual__c 
                           where Old_Id__c =:theSelectedFamID 
                           order by Parent__r.Old_Id__c desc ];
        }
        
        //system.debug('ExistIndividual:' + ExistIndividual.size() + ' ExistFamily:' + ExistFamily.size() );
        
        List<wb_Individual__c> NewIndividual = new  List<wb_Individual__c>();
        List<wb_Individual__c> NewFamily = new  List<wb_Individual__c>();
        
        integer l_i = 0;
        integer l_j = 0;
        
        List<Id> NewIndividual_OldMemberID = new List<Id>();
        List<string> NewIndividual_OldMember_oID = new List<string>();
        
        List<wb_Individual__c> FamilyInfo2IndividualChild;
        
        system.debug(l_i +',' + ConvertedMemberAndFamilyInfoRows.size() +',' + l_j +',' + ExistIndividual.size() );
        // Mapping the Existing Individual to the Selected Member and Family
        while ( l_i < ConvertedMemberAndFamilyInfoRows.size() && l_j < ExistIndividual.size()) { 
           // system.debug('l_i:' + l_i +',' + 'l_j:' + l_j);
            if (ConvertedMemberAndFamilyInfoRows[l_i].isSelected == true){
                //boolean exist = false;
                if (ExistIndividual[l_j].Old_Id__c == ConvertedMemberAndFamilyInfoRows[l_i].theMemberInfo.Id) {
                    ConvertedMemberAndFamilyInfoRows[l_i].newid = ExistIndividual[l_j].id;
                    ConvertedMemberAndFamilyInfoRows[l_i].WorkingCompany = ExistIndividual[l_j].WorkingCompany__c;
                    ConvertedMemberAndFamilyInfoRows[l_i].MappedParent = ExistIndividual[l_j];
                    //system.debug('found ' + l_i + ' at ' + l_j);
                    FamilyInfo2IndividualChild = new List<wb_Individual__c>();
                    if (ExistFamily != null){
                    if (ExistFamily.size()>0){
                        integer k;
                        for ( k = ExistFamily.size() -1; K >= 0; k -- ){
                            if (ExistFamily[k].Parent__r.Old_Id__c == ExistIndividual[l_j].Old_Id__c ){
     
                                FamilyInfo2IndividualChild.add(ExistFamily[k]);
                                
                                ExistFamily.remove(k);
                            } else if (ExistFamily[k].Parent__r.Old_Id__c > ExistIndividual[l_j].Old_Id__c){
                                
                                ConvertedMemberAndFamilyInfoRows[l_i].MappedChild = FamilyInfo2IndividualChild;
                                k = -2;
                            }
                        }
                        if (k == -1){
                            ConvertedMemberAndFamilyInfoRows[l_i].MappedChild = FamilyInfo2IndividualChild;
                        }
                    } 
                    }
                    l_i = l_i + 1;
                    l_j = l_j + 1;
                } else if (string.valueof(ExistIndividual[l_j].Old_Id__c) > string.valueof(ConvertedMemberAndFamilyInfoRows[l_i].theMemberInfo.Id)){
                    system.debug('not find:' + ConvertedMemberAndFamilyInfoRows[l_i].theMemberInfo.Id +',' + ExistIndividual[l_j].Old_Id__c + ',' + l_j );
                    NewIndividual_OldMemberID.add(ConvertedMemberAndFamilyInfoRows[l_i].theMemberInfo.Id);
                 // NewIndividual_OldMember_oID.add(theMemberAndFamilyInfoRows[l_i].theMemberInfo.o_id__c);
                    l_i = l_i + 1;
                }
                else 
                    l_j = l_j + 1; 
            } else {
                l_i = l_i + 1;
            }
        }
        
        system.debug(l_i +',' + ConvertedMemberAndFamilyInfoRows.size() + ',' + l_j + ',' + ExistIndividual.size() +',' + NewIndividual_OldMemberID.size());
        

        
        if(l_i < ConvertedMemberAndFamilyInfoRows.size()  ){
            for ( integer i = l_i; i <  ConvertedMemberAndFamilyInfoRows.size() ; i ++) {
                l_i = i;
                NewIndividual_OldMemberID.add(ConvertedMemberAndFamilyInfoRows[l_i].theMemberInfo.Id);

            }
        } 
        
          system.debug(l_i +',' + ConvertedMemberAndFamilyInfoRows.size() + ',' + l_j + ',' + ExistIndividual.size() +',' + NewIndividual_OldMemberID.size());
        
        if ( NewIndividual_OldMemberID != null) {
            system.debug(NewIndividual_OldMemberID.size());
            system.debug(NewIndividual_OldMemberID);
        }
         
        
        List<FamilyInfo__c> NewMemberFamily =[Select id, Name,Sex__c,DateOfBirth__c,KinmuCompany__c,
                                        Email__c,MailHaishin__c,
                                        SeiRoma__c,SeiKana__c,MeiRoma__c,MeiKana__c,  
                                        KeiyakuNo__c,
                                        KeiyakuKeitai__c, MemberShimei__c, FamilyNo__c, Relationship__c
                                        From FamilyInfo__c
                                        where MemberShimei__c=:NewIndividual_OldMemberID
                                        order by MemberShimei__c desc];
		List<Family> ConvertedFamily = new List<Family>();
        wb_Individual__c MemberInfo2Individual;
    
        if (NewIndividual_OldMemberID.size() > 0){
            for ( MemberInfo__c nm:[Select id, Name,Sex__c,DateOfBirth__c,KinmuCompany__c,
                                    Postcd__c,Email__c,MailHaishin__c,CountryCallingCodes__c,
                                    Mobile__c,Tel__c,Address__c,SeiRoma__c,SeiKana__c,MeiRoma__c,MeiKana__c, Yakushoku__c, 
                                    KeiyakuNo__c,
                                    CompanyKeiyakuNo__c, KeiyakuKeitai__c, o_id__c
                                    From MemberInfo__c 
                                    where id =:NewIndividual_OldMemberID
                                    order by id]) 
            {
                MemberInfo2Individual = new wb_Individual__c(Name = nm.Name, 
                                                             Sex__c = nm.Sex__c,
                                                             DateOfBirth__c=nm.DateOfBirth__c,
                                                             WorkingCompany__c = nm.KinmuCompany__c,
                                                             PostalCode__c=nm.Postcd__c,
                                                             EmailAddress__c=nm.Email__c,
                                                             MailDelivery__c=nm.MailHaishin__c,
                                                             CountryCallingCodes__c=nm.CountryCallingCodes__c,
                                                             Mobile__c=nm.Mobile__c,
                                                             Tel__c=nm.Tel__c,
                                                             Address__c=nm.Address__c,
                                                             LastNameRoma__c=nm.SeiRoma__c,
                                                             LastNameKana__c=nm.SeiKana__c,
                                                             FirstNameKana__c=nm.MeiRoma__c,
                                                             FirstNameRoma__c=nm.MeiKana__c,
                                                             Old_Id__c = nm.Id);
                
                FamilyInfo2IndividualChild = new List<wb_Individual__c>();
                
                if (NewMemberFamily.size()>0){
                    integer k;
                    for ( k = NewMemberFamily.size() -1; K >= 0; k -- ){
                        if (NewMemberFamily[k].MemberShimei__c == nm.id ){
                            wb_Individual__c FamilyInfo2Individual = new wb_Individual__c(Name = NewMemberFamily[k].Name, 
                                                                                          Sex__c = NewMemberFamily[k].Sex__c,
                                                                                          DateOfBirth__c=NewMemberFamily[k].DateOfBirth__c,
                                                                                          EmailAddress__c=NewMemberFamily[k].Email__c,
                                                                                          MailDelivery__c=NewMemberFamily[k].MailHaishin__c,
                                                                                          LastNameRoma__c=NewMemberFamily[k].SeiRoma__c,
                                                                                          LastNameKana__c=NewMemberFamily[k].SeiKana__c,
                                                                                          FirstNameKana__c=NewMemberFamily[k].MeiRoma__c,
                                                                                          FirstNameRoma__c=NewMemberFamily[k].MeiKana__c,
                                                                                          FamilyNo__c=NewMemberFamily[k].FamilyNo__c,
                                                                                          FamilyRelationship__c=NewMemberFamily[k].Relationship__c,
                                                                                          //Parent__c = MemberInfo2Individual.id,
                                                                                          Old_Id__c = NewMemberFamily[k].Id);
                            FamilyInfo2IndividualChild.add(FamilyInfo2Individual);
                            NewMemberFamily.remove(k);
                        } else if (NewMemberFamily[k].MemberShimei__c > nm.id ){
                            ConvertedFamily.add( new Family(MemberInfo2Individual,FamilyInfo2IndividualChild));
                            k = -2;
                        }
                    }
                    
                    if (k == -1){
                         ConvertedFamily.add( new Family(MemberInfo2Individual,FamilyInfo2IndividualChild));
                    }
                    
                } else {
                    ConvertedFamily.add( new Family(MemberInfo2Individual,FamilyInfo2IndividualChild));
                   // MemberInfo2Individual = null;
                }
                
            } 
        }
        
        system.debug( ConvertedFamily.size());
        
        NewIndividual = new List<wb_Individual__c>();
        NewFamily = new List<wb_Individual__c>();
        
        for (Family f:ConvertedFamily){
            if (f.theParent != null )
                NewIndividual.add(f.theParent);
            if (f.theChild != null) {
                if ( f.theChild.size() > 0){
                    for ( wb_Individual__c c:f.theChild){
                        NewFamily.add(c);
                    }
                }
            }
        }
        
        
        if ( NewIndividual.size() > 0 )
            insert NewIndividual;
        
        if ( NewFamily.size() > 0 )
            insert NewFamily;

        for (Family f:ConvertedFamily){
            if (f.theChild != null) {
                if ( f.theChild.size() > 0){
                    for ( wb_Individual__c c:f.theChild){
                        c.Parent__c = f.theParent.id;
                    }
                }
            }
        }
        if ( NewFamily.size() > 0 )
            update NewFamily;
       
        
        l_i = 0;
        l_j = 0;
        
       NewIndividual_OldMemberID = new List<Id>();
        
        // Mapping the Created Indivdual back to Member and Family
        while ( l_i < ConvertedMemberAndFamilyInfoRows.size() && l_j < ConvertedFamily.size()) { 
            if (ConvertedMemberAndFamilyInfoRows[l_i].isSelected == true){
                //boolean exist = false;
                if (ConvertedFamily[l_j].theParent.Old_Id__c == ConvertedMemberAndFamilyInfoRows[l_i].theMemberInfo.Id) {
                    ConvertedMemberAndFamilyInfoRows[l_i].newid = ConvertedFamily[l_j].theParent.id;
                    ConvertedMemberAndFamilyInfoRows[l_i].WorkingCompany = ConvertedFamily[l_j].theParent.WorkingCompany__c;
                    ConvertedMemberAndFamilyInfoRows[l_i].MappedParent = ConvertedFamily[l_j].theParent;
                    ConvertedMemberAndFamilyInfoRows[l_i].MappedChild = ConvertedFamily[l_j].theChild;
                   // system.debug('found ' + l_i + ' at ' + l_j);
                    l_i ++;
                    l_j ++;
                } else if (string.valueof(ConvertedFamily[l_j].theParent.Old_Id__c) > string.valueof(ConvertedMemberAndFamilyInfoRows[l_i].theMemberInfo.Id)) {
                    NewIndividual_OldMemberID.add(ConvertedMemberAndFamilyInfoRows[l_i].theMemberInfo.Id);
                    l_i ++;
                }
                else 
                    l_j ++; 
            } else {
                l_i = l_i + 1;
            }
        }
        
        system.debug(NewIndividual_OldMemberID.size());
	
    }
    
    public boolean IsSelectAll {get;set;}
    public void UnSelectAll(){
        system.debug('UnSelectAll');
       for (aSelectiveRow c:theMemberAndFamilyInfoRows){
            //if (c.isSelected == true){
                c.isSelected = false;
           // }
       }
       IsSelectAll = true; 
    }
    
    public void SelectAll(){
        //system.debug('UnSelectAll');
        for (aSelectiveRow c:theMemberAndFamilyInfoRows){
            //if (c.isSelected == true){
            c.isSelected = true;
            // }
        }
        IsSelectAll = false; 
    }
    
    public void Convert2New(){
        ConvertedResult.start_Edit();
        
        for (aSelectiveRow c:theContractInfoRows){
            if (c.isSelected == true){
                ConvertedResult.Membership.Status__c = '未確定';
                ConvertedResult.Membership.ContractCompany__c = theCompany.Id;
                ConvertedResult.GetGroupDiscountPercentage();
                ConvertedResult.Membership.Classification__c ='会社';
                ConvertedResult.Membership.BillingCompany__c = theCompany.Id;
                ConvertedResult.Membership.ContractDistrict__c = c.theContractInfo.KeiyakuArea__c;
                ConvertedResult.Membership.BillingDistrict__c = c.theContractInfo.SeikyuArea__c;
                ConvertedResult.Membership.Currency__c = c.theContractInfo.Currency__c;
                ConvertedResult.Membership.ContractDate__c = system.today();
                ConvertedResult.RateAndRoundUp = ConvertedResult.getRateAndRoundUp();
                ConvertedResult.getServiceMaster();
            }
        }
        
       
        MapMemberInfoWithIndividual();
        
        integer o_indx = 0, t_indx = 0;
        ConvertedResult.removeEmptyRow();
        for (aSelectiveRow m:ConvertedMemberAndFamilyInfoRows){
    
            if (m.isSelected == true // && ( // m.theMemberInfo.KeiyakuKeitai__c=='法人／単身Global Plus Member' ||
               // m.theMemberInfo.KeiyakuKeitai__c=='法人／家族Global Plus Member')
               )
            {
                system.debug(o_indx + ',' + ConvertedResult.theMembershipDetail.size());
           
        
                wb_MembershipDetail__c d = new wb_MembershipDetail__c(Classification__c='継続');
              //  d.Membership__c = Membership.id;
                ConvertedResult.MembershipDetailsParent.add(d);
                ConvertedResult.theMembershipDetail.add( new wb_MembershipDetailRow(ConvertedResult.theMembershipDetail.size(),
                                                                                    d, null, ConvertedResult.MDService,
                                                                                    ConvertedResult.RateAndRoundUp,
                                                                                    ConvertedResult.Membership.Currency__c, 
                                                                                    null, null
                                                                                   // ConvertedResult.Membership.DiscountPercentage__c
                                                                                   ));
                ConvertedResult.theMembershipDetail[ConvertedResult.theMembershipDetail.size()-1 ].selectedValue ='2';
             
                ConvertedResult.theMembershipDetail[ConvertedResult.theMembershipDetail.size()-1].theRow.Individual__c = m.newid;
                ConvertedResult.theMembershipDetail[ConvertedResult.theMembershipDetail.size()-1].theRow.WorkingCompany__c = m.WorkingCompany;
          
              
                string KeiyakuKeitai = m.theMemberInfo.KeiyakuKeitai__c;
                KeiyakuKeitai ='法人／家族Global Plus Member';
                KeiyakuKeitai = KeiyakuKeitai.right(KeiyakuKeitai.length() - KeiyakuKeitai.indexOf('／') - 1);
                Id ServiceId;
                system.debug(KeiyakuKeitai);
                wb_Service__c theService;
                for ( wb_Service__c s:ConvertedResult.MDService){
                    if(s.DataType__c + s.Service__c == KeiyakuKeitai) {
                        ServiceId = s.Id;
                        theService = s;
                    }
                }
                system.debug(ServiceId);
                ConvertedResult.theServiceList =ServiceId;
                ConvertedResult.theStartDate = system.today();
            
               
                if ( ConvertedResult.theMembershipDetail[ConvertedResult.theMembershipDetail.size()-1].selectedValue == null)
                    ConvertedResult.theMembershipDetail[ConvertedResult.theMembershipDetail.size()-1].selectedValue ='2';
                if (ServiceId != null) {
                    ConvertedResult.theMembershipDetail[ConvertedResult.theMembershipDetail.size()-1].fetchServiceOptions();
                    ConvertedResult.theMembershipDetail[ConvertedResult.theMembershipDetail.size()-1].theRow.Service__c = ServiceId;
                    ConvertedResult.theMembershipDetail[ConvertedResult.theMembershipDetail.size()-1].theRow.Type__c = theService.DataType__c;
                    ConvertedResult.theMembershipDetail[ConvertedResult.theMembershipDetail.size()-1].theRow.MembershipPlan__c = theService.Service__c;
                    ConvertedResult.theMembershipDetail[ConvertedResult.theMembershipDetail.size()-1].theRow.Quantity__c =1;
                }
                
                if (ConvertedResult.theMembershipDetail[ConvertedResult.theMembershipDetail.size()-1].theRow.Type__c =='家族')
                {
                    ConvertedResult.theMembershipDetail[ConvertedResult.theMembershipDetail.size()-1].fetchFamily(m.MappedParent,m.MappedChild);
                    ConvertedResult.theMembershipDetail[ConvertedResult.theMembershipDetail.size()-1].fetchtheFamilies();
                }                       
                 ConvertedResult.theMembershipDetail[ConvertedResult.theMembershipDetail.size()-1].theRow.MembershipStartDate__c = system.today();
                 ConvertedResult.theMembershipDetail[ConvertedResult.theMembershipDetail.size()-1].fetchEndDateOnly();
                 ConvertedResult.theMembershipDetail[ConvertedResult.theMembershipDetail.size()-1].fetchServiceFeeOnly();
               
                o_indx = o_indx + 1;
            }
            
            
        }
		
        
    }
    

    public List<MemberInfo__c> sortList  {get;set;}
    
    public Integer sortNum  {get;set;}
    
    public void sortcustomObjList(List<MemberInfo__c> customObjList) {
        if(customObjList!=null && customObjList.size()>0) {
            this.sortList = customObjList;
            this.sortNum = customObjList.size();
            quickSort(0, sortNum-1);
            
            Integer sortedCount = 1;
          /*  for(wb_Individual__c customObj : customObjList) {
                customObj.qCount = sortedCount;
                sortedCount += 1;
            }*/
        }
    }
    private void quickSort(Integer low, Integer high) {
        Integer i = low;
        Integer j = high;
        // Get the pivot element from the middle of the list
        MemberInfo__c pivot = sortList[low + (high-low)/2];
        
        // Divide into two lists
        while (i <= j) {
            // If the current value from the left list is smaller then the pivot
            // element then get the next element from the left list
            while (string.valueof(sortList[i].Id) < string.valueof(pivot.Id)) {
                i++;
            }
            // If the current value from the right list is larger then the pivot
            // element then get the next element from the right list
            while (string.valueof(sortList[j].Id) > string.valueof(pivot.Id)) {
                j--;
            }
            
            // If we have found a values in the left list which is larger then
            // the pivot element and if we have found a value in the right list
            // which is smaller then the pivot element then we exchange the
            // values.
            // As we are done we can increase i and j
            if (i <= j) {
                exchange(i, j);
                i++;
                j--;
            }
        }
        // Recursion
        if (low < j)
            quicksort(low, j);
        if (i < high)
            quicksort(i, high);
    }
    private void exchange(Integer i, Integer j) {
        MemberInfo__c temp = sortList[i];
        sortList[i] = sortList[j];
        sortList[j] = temp;
    }    

}