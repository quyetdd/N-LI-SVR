public class wb_convert_ContractInfo_Batch {
    
    public Account theCompany  {get;set;}
    public List<ContractInfo__c> theContractInfo  {get;set;}
    public List<wb_Service__c> MDService  {get;set;}
    public List<AggregateResult> AgRCountryDistrict {get; set;}   
    public List<wb_CountryDistrict__c> District {get; set;} 
    
    public List<aContractRow> theContractRows {get;set;}
    
    public class MemberFamily {
        
        public MemberInfo__c theMemberInfo { get; set; }
        public List<FamilyInfo__c> theFamilyInfo { get; set; }
        
        public wb_Individual__c theMember { get; set; }
        public List<wb_Individual__c> theFamily { get; set; }
        
        public MemberFamily(wb_Individual__c m){
            theMember = m;
            theFamilyInfo = new List<FamilyInfo__c>();
            theFamily = new List<wb_Individual__c>();
        }
        
        public MemberFamily(wb_Individual__c m, List<wb_Individual__c> f){
            theMember = m;
            theFamilyInfo = new List<FamilyInfo__c>();
            theFamily = new List<wb_Individual__c>();
            theFamily = f;
        }
        
        public MemberFamily(MemberInfo__c m){
            theMemberInfo = m;
            theFamilyInfo = new List<FamilyInfo__c>();
            theFamily = new List<wb_Individual__c>();
        }
        
    } 
    
    public Class Visitor {
        public Id WorkingCompanyID {get;set;}
        public string Plan {get;set;}
        public string MemberNo {get;set;}
        public Visitor(Id WId, string P, string M){
            WorkingCompanyID =WId;
            Plan = P;
            MemberNo =M;
        }
    }
    
    public class aContractRow {
        public Boolean isSelected { get; set; }
        public ContractInfo__c thisContractInfo { get; set; }
        public List<MemberInfo__c> thisMemberInfo {get;set;}
        public List<FamilyInfo__c> thisFamilyInfo {get;set;}
        public List<MemberInfo__c> thisVisitorInfo {get;set;}
        
        public List<wb_Individual__c> thisIndividualMember {get;set;}
        public List<wb_Individual__c> thisIndividualFamily{get;set;}
        public List<MemberFamily> thisMemberFamilyList { get; set; }
        
        public List<wb_Member__c> thisCardHolder { get; set; }
        
        public wb_Membership Converted {get;set;}
        public List<wb_Service__c> MDService {get;set;}
        public List<AggregateResult> AgRCountryDistrict {get; set;}
        public List<wb_CountryDistrict__c> District {get; set;}
        
        public aContractRow(ContractInfo__c ContractInfo,List<MemberFamily> MemberFamilies ){
            thisContractInfo = ContractInfo;
            thisMemberFamilyList = MemberFamilies;
            //Converted = new wb_Membership(MDService);
        }
        
        public aContractRow(ContractInfo__c ContractInfo, List<wb_Service__c> MDS, List<AggregateResult> AgRC, List<wb_CountryDistrict__c> Dst ){
            thisContractInfo = ContractInfo;
            getMemberAndFamily(thisContractInfo.id);
            getVisitor(thisContractInfo.id);
            CreateNotExistVistor(thisVisitorInfo);            
            CreateNotExistIndividual(thisMemberInfo,thisFamilyInfo);
            
            getAllIndividuals(thisMemberInfo,thisFamilyInfo);
            system.debug(thisIndividualFamily);
            CreateMemberFamily(thisMemberInfo,thisFamilyInfo,thisIndividualMember,thisIndividualFamily);
            
            
            MDService = MDS;
            AgRCountryDistrict = AgRC;
            District =Dst;
            // system.debug(thisMemberFamilyList.size());
            
            // Converted = new wb_Membership();
            //  Converted.Membership.name = ContractInfo.name; 
        }
        
        public aContractRow(ContractInfo__c ContractInfo, List<MemberInfo__c> m, List<wb_Service__c> MDS, List<AggregateResult> AgRC, List<wb_CountryDistrict__c> Dst ){
            thisContractInfo = ContractInfo;
            getMemberAndFamily(thisContractInfo.id, m);
            getVisitor(thisContractInfo.id);
            CreateNotExistVistor(thisVisitorInfo);
            
            CreateNotExistIndividual(thisMemberInfo,thisFamilyInfo);
            
            getAllIndividuals(thisMemberInfo,thisFamilyInfo);
            system.debug(thisIndividualFamily);
            CreateMemberFamily(thisMemberInfo,thisFamilyInfo,thisIndividualMember,thisIndividualFamily);
            
            
            MDService = MDS;
            AgRCountryDistrict = AgRC;
            District =Dst;
            // system.debug(thisMemberFamilyList.size());
            
            // Converted = new wb_Membership();
            //  Converted.Membership.name = ContractInfo.name; 
        }
        
        public aContractRow(ContractInfo__c ContractInfo, string type, List<wb_Service__c> MDS, List<AggregateResult> AgRC, List<wb_CountryDistrict__c> Dst ){
            thisContractInfo = ContractInfo;
            getMemberAndFamily(thisContractInfo.id, type);
            getVisitor(thisContractInfo.id);
            
            CreateNotExistIndividual(thisMemberInfo,thisFamilyInfo);
            CreateNotExistVistor(thisVisitorInfo);
            
            getAllIndividuals(thisMemberInfo,thisFamilyInfo);
            system.debug(thisIndividualFamily);
            CreateMemberFamily(thisMemberInfo,thisFamilyInfo,thisIndividualMember,thisIndividualFamily);
            
            
            MDService = MDS;
            AgRCountryDistrict = AgRC;
            District =Dst;
            // system.debug(thisMemberFamilyList.size());
            
            // Converted = new wb_Membership();
            //  Converted.Membership.name = ContractInfo.name; 
        }
        
        void getMemberAndFamily( Id ContractID, string type){
            
            thisMemberInfo = [Select Id, Name,Sex__c,DateOfBirth__c,KinmuCompany__c,
                              Postcd__c,Email__c,MailHaishin__c,CountryCallingCodes__c,
                              Mobile__c,Tel__c,Address__c,SeiRoma__c,SeiKana__c,MeiRoma__c,MeiKana__c, Yakushoku__c, 
                              KeiyakuNo__c,
                              CompanyKeiyakuNo__c, KeiyakuKeitai__c,MankiDate__c,MemberNo__c, KinmuCompany__r.name
                              From MemberInfo__c 
                              where CompanyKeiyakuNo__c =:ContractID and MemberKubunB__c ='会員'
                              
                              and (not Name like '%Unnamed%') and (not Name like '%VISITOR%')
                              and KeiyakuKeitai__c like '%家族%'  and ( not KeiyakuKeitai__c like '%無記名%')
                              order by Id];            
            
            List<Id> MemberIds = new List<Id>();      
            for ( MemberInfo__c m:thisMemberInfo){
                MemberIds.add(m.id);
            }
            
            thisFamilyInfo = [Select id, Name,Sex__c,DateOfBirth__c,KinmuCompany__c,
                              Email__c,MailHaishin__c,
                              SeiRoma__c,SeiKana__c,MeiRoma__c,MeiKana__c,  
                              KeiyakuNo__c,
                              KeiyakuKeitai__c, MemberShimei__c, FamilyNo__c, Relationship__c,
                              MemberShimei__r.CompanyKeiyakuNo__c, Mobile__c
                              From FamilyInfo__c
                              where MemberShimei__r.CompanyKeiyakuNo__c =:ContractID 
                              and MemberShimei__c =:MemberIds
                              and MemberShimei__r.MemberKubunB__c ='会員'
                              order by  MemberShimei__c asc ];
            
            
        }
        
        
        void getMemberAndFamily( Id ContractID, List<MemberInfo__c> mbr){
            
            List<Id> MemberIds = new List<Id>();      
            for ( MemberInfo__c m:mbr){
                MemberIds.add(m.id);
            }
            
            thisMemberInfo = [Select Id, Name,Sex__c,DateOfBirth__c,KinmuCompany__c,
                              Postcd__c,Email__c,MailHaishin__c,CountryCallingCodes__c,
                              Mobile__c,Tel__c,Address__c,SeiRoma__c,SeiKana__c,MeiRoma__c,MeiKana__c, Yakushoku__c, 
                              KeiyakuNo__c,
                              CompanyKeiyakuNo__c, KeiyakuKeitai__c,MankiDate__c,MemberNo__c, KinmuCompany__r.name
                              From MemberInfo__c 
                              where CompanyKeiyakuNo__c =:ContractID and MemberKubunB__c ='会員'
                              and id =:MemberIds
                              and (not Name like '%Unnamed%') and (not Name like '%VISITOR%')
                              and ( not KeiyakuKeitai__c  like '%Biz Trip Pass%' )
                              and ( not KeiyakuKeitai__c like '%無記名%')
                              order by Id];            
            
            
            thisFamilyInfo = [Select id, Name,Sex__c,DateOfBirth__c,KinmuCompany__c,
                              Email__c,MailHaishin__c,
                              SeiRoma__c,SeiKana__c,MeiRoma__c,MeiKana__c,  
                              KeiyakuNo__c,
                              KeiyakuKeitai__c, MemberShimei__c, FamilyNo__c, Relationship__c,
                              MemberShimei__r.CompanyKeiyakuNo__c, Mobile__c
                              From FamilyInfo__c
                              where MemberShimei__r.CompanyKeiyakuNo__c =:ContractID 
                              and MemberShimei__c =:MemberIds
                              and MemberShimei__r.MemberKubunB__c ='会員'
                              order by  MemberShimei__c asc ];
            
            //system.debug(thisMemberInfo.size());
            //system.debug(thisFamilyInfo.size());
            //system.debug(thisFamilyInfo);
        }
        
        void getMemberAndFamily( Id ContractID){
            
            thisMemberInfo = [Select Id, Name,Sex__c,DateOfBirth__c,KinmuCompany__c,
                              Postcd__c,Email__c,MailHaishin__c,CountryCallingCodes__c,
                              Mobile__c,Tel__c,Address__c,SeiRoma__c,SeiKana__c,MeiRoma__c,MeiKana__c, Yakushoku__c, 
                              KeiyakuNo__c,
                              CompanyKeiyakuNo__c, KeiyakuKeitai__c,MankiDate__c,MemberNo__c, KinmuCompany__r.name
                              From MemberInfo__c 
                              where CompanyKeiyakuNo__c =:ContractID and MemberKubunB__c ='会員'
                              and (not Name like '%Unnamed%') and (not Name like '%VISITOR%')
                              and ( not KeiyakuKeitai__c like '%無記名%')
                              order by Id];            
            
            List<Id> MemberIds = new List<Id>();      
            for ( MemberInfo__c m:thisMemberInfo){
                MemberIds.add(m.id);
            }
            
            thisFamilyInfo = [Select id, Name,Sex__c,DateOfBirth__c,KinmuCompany__c,
                              Email__c,MailHaishin__c,
                              SeiRoma__c,SeiKana__c,MeiRoma__c,MeiKana__c,  
                              KeiyakuNo__c,
                              KeiyakuKeitai__c, MemberShimei__c, FamilyNo__c, Relationship__c,
                              MemberShimei__r.CompanyKeiyakuNo__c, Mobile__c
                              From FamilyInfo__c
                              where MemberShimei__r.CompanyKeiyakuNo__c =:ContractID and  
                              MemberShimei__r.MemberKubunB__c ='会員'
                              order by  MemberShimei__c asc ];
            
            //system.debug(thisMemberInfo.size());
            //system.debug(thisFamilyInfo.size());
            //system.debug(thisFamilyInfo);
        }
        
        void getVisitor( Id ContractID){
            
            thisVisitorInfo = [Select  CompanyKeiyakuNo__c, KeiyakuNo__c, KinmuCompany__c,
                               MankiDate__c,KeiyakuKeitai__c, MemberNo__c, KinmuCompany__r.name,
                               KinmuCompany__r.CountryCd__c
                               From MemberInfo__c 
                               where CompanyKeiyakuNo__c =:ContractID and MemberKubunB__c ='会員'
                               // and ( ( Name like '%Unnamed%') OR ( Name like '%VISITOR%'))
                               and KeiyakuKeitai__c like '%無記名%'
                               order by Id, MankiDate__c, MemberNo__c];            
            
        }
        
        void CreateNotExistVistor(List<MemberInfo__c> thisVisitors){
            
            List<Id> VisitorIDs = new List<Id>();
            for (MemberInfo__c m:thisVisitors) {
                VisitorIDs.add(m.Id);
            }
            
            List<wb_Member__c> ExistingVisitor = [select Id,  Old_Id__c, WorkingCompany__c, Old_MemberNo__c 
                                                  from wb_Member__c 
                                                  where Old_Id__c =:VisitorIDs 
                                                  order by Old_Id__c];
            
            system.debug( thisVisitors.size());
            system.debug( ExistingVisitor.size());
            List<MemberInfo__c> CloneVisitor = thisVisitors.clone();
            
            if ( ExistingVisitor.size()>0) {
                // sortListI = ExistingVisitor;
                //  sortcustomObjList(sortListI,'OLD'); // Sort the list in string order with ID
                system.debug( ExistingVisitor);
                wb_utility_quicksort qs = new wb_utility_quicksort();
                qs.sortList = new List<wb_utility_quicksort.IdIndex>();
                for (integer i = 0 ; i < ExistingVisitor.size(); i ++){
                    qs.sortList.add( new wb_utility_quicksort.IdIndex( Id.valueOf(ExistingVisitor[i].Old_Id__c), i) );
                }
                
                qs.sortcustomObjList();
                
                integer j = ExistingVisitor.size() -1 ;
                for ( integer i = CloneVisitor.size() - 1; i >= 0 ; i -- ){
                    
                    for ( ;j >=0 && i>=0 &&
                         string.valueof(CloneVisitor[i].Id ) <= string.valueof(ExistingVisitor[qs.sortList[j].Idx].Old_Id__c) 
                         ;){
                             
                             if ( string.valueof(CloneVisitor[i].Id ) == string.valueof(ExistingVisitor[qs.sortList[j].Idx].Old_Id__c )){
                                 CloneVisitor.remove(i);
                                 break;
                                 
                             } else if ( string.valueof(CloneVisitor[i].Id ) < string.valueof(ExistingVisitor[qs.sortList[j].Idx].Old_Id__c ))
                             { 
                                 j =  j - 1;
                             }
                         }
                }
            }
            
            system.debug( CloneVisitor.size());
            
            List<wb_Member__c> NewVisitorMem = new List<wb_Member__c>();            
            
            
            for (MemberInfo__c m:CloneVisitor){
                
                NewVisitorMem.add( 
                    new wb_Member__c(
                        Old_MemberNo__c = String.valueOf(m.MemberNo__c).mid(4,6),
                        WorkingCompany__c=m.KinmuCompany__c,
                        Old_Id__c=m.id
                    )
                );
            }
            
            system.debug(NewVisitorMem);
            
            if ( NewVisitorMem.size() > 0)
                insert NewVisitorMem;
            
            
            thisCardHolder = new  List<wb_Member__c>();
            
            for (wb_Member__c m:ExistingVisitor){
                thisCardHolder.add(m);
            }
            for (wb_Member__c m:NewVisitorMem){
                thisCardHolder.add(m);
            }
            
        }
        
        void CreateNotExistIndividual( List<MemberInfo__c> MemberInfo, List<FamilyInfo__c> FamilyInfo){
            
            sortListM = MemberInfo;
            sortcustomObjList(sortListM); // Sort the list in string order with ID
            
            sortListFInfo = FamilyInfo;
            sortcustomObjList(sortListFInfo,'ID'); // Sort the list in string order with ID
            
            List<MemberInfo__c> CloneMemberInfo = MemberInfo.clone();
            List<FamilyInfo__c> CloneFamilyInfo = FamilyInfo.clone();
            
            List<Id> MemInfoIDs = new List<Id>();
            List<Id> FamIDs = new List<Id>();
            
            for (MemberInfo__c m:CloneMemberInfo) {
                MemInfoIDs.add(m.Id);
            }
            
            for (FamilyInfo__c f:CloneFamilyInfo){
                FamIDs.add(f.Id);
            }
            
            
            List<wb_Individual__c> ExistingMember = [select Id,  Old_Id__c
                                                     from wb_Individual__c 
                                                     where Old_Id__c =:MemInfoIDs 
                                                     order by Old_Id__c];
            
            List<wb_Individual__c> ExistingFamily = [select Id, Parent__c, Old_Id__c, Parent__r.Old_Id__c
                                                     from wb_Individual__c 
                                                     where Old_Id__c =:FamIDs 
                                                     order by Old_Id__c];
            
            
            system.debug( thisMemberInfo.size());
            system.debug( ExistingMember.size());
            
            system.debug( thisFamilyInfo.size());
            system.debug( ExistingFamily.size());
            
            
            if ( ExistingMember.size()>0) {
                sortListI = ExistingMember;
                sortcustomObjList(sortListI,'OLD'); // Sort the list in string order with ID
                system.debug( ExistingMember);
                
                integer j = ExistingMember.size() -1 ;
                for ( integer i = CloneMemberInfo.size() - 1; i >= 0 ; i -- ){
                    
                    for ( ;j >=0 && i>=0 &&
                         string.valueof(CloneMemberInfo[i].Id ) <= string.valueof(ExistingMember[j].Old_Id__c) 
                         ;){
                             
                             
                             if ( string.valueof(CloneMemberInfo[i].Id ) == string.valueof(ExistingMember[j].Old_Id__c )){
                                 CloneMemberInfo.remove(i);
                                 break;
                                 
                             } else if ( string.valueof(CloneMemberInfo[i].Id ) < string.valueof(ExistingMember[j].Old_Id__c ))
                             { 
                                 j =  j - 1;
                             }
                         }
                }
            }
            
            
            system.debug( CloneMemberInfo.size());
            
            List<wb_Individual__c> NewInd = new List<wb_Individual__c>();            
            
            
            for (MemberInfo__c m:CloneMemberInfo){
                
                NewInd.add( 
                    new wb_Individual__c(
                        Name = m.Name,
                        Sex__c=m.Sex__c,
                        DateOfBirth__c=m.DateOfBirth__c,
                        WorkingCompany__c=m.KinmuCompany__c,
                        PostalCode__c=m.Postcd__c,
                        EmailAddress__c=m.Email__c,
                        MailDelivery__c=m.MailHaishin__c,
                        CountryCallingCodes__c=m.CountryCallingCodes__c,
                        Mobile__c=m.Mobile__c,
                        Tel__c=m.Tel__c,
                        Address__c=m.Address__c,
                        LastNameRoma__c=m.SeiRoma__c,
                        LastNameKana__c=m.SeiKana__c,
                        FirstNameRoma__c=m.MeiRoma__c,
                        FirstNameKana__c=m.MeiKana__c, 
                        Position__c=m.Yakushoku__c,
                        Old_Id__c=m.id
                    )
                );
            }
            
            
            system.debug( thisMemberInfo.size());
            system.debug( NewInd.size());
            
            system.debug( CloneFamilyInfo.size());
            
            if ( NewInd.size() > 0)
                insert NewInd;
            
            system.debug(CloneFamilyInfo);
            if ( ExistingFamily.size()>0) {
                sortListI = ExistingFamily;
                sortcustomObjList(sortListI,'OLD'); // Sort the list in string order with ID
                system.debug( ExistingFamily);
                
                integer j = ExistingFamily.size() -1 ;
                for ( integer i = CloneFamilyInfo.size() - 1; i >= 0 ; i -- ){
                    
                    for ( ;j >=0 && i>=0 &&
                         string.valueof(CloneFamilyInfo[i].Id ) <= string.valueof(ExistingFamily[j].Old_Id__c) 
                         ;){
                             // system.debug(i +','+ j +',' + CloneFamilyInfo[i].Id +',' + string.valueof(ExistingFamily[j].Old_Id__c) );
                             
                             if ( string.valueof(CloneFamilyInfo[i].Id ) == string.valueof(ExistingFamily[j].Old_Id__c) &&
                                 string.valueof(CloneFamilyInfo[i].MemberShimei__c ) == string.valueof(ExistingFamily[j].Parent__r.Old_Id__c)){
                                     CloneFamilyInfo.remove(i);
                                     break;
                                     // i = i - 1;
                                 } else if ( string.valueof(CloneFamilyInfo[i].Id ) < string.valueof(ExistingFamily[j].Old_Id__c ))
                                 { 
                                     j =  j - 1;
                                 }
                         }
                }
                
            }
            
            List<Id> FamParentIDs = new List<Id>();
            for (FamilyInfo__c f:CloneFamilyInfo){
                FamParentIDs.add(f.MemberShimei__c);
            }
            
            List<wb_Individual__c> theParents = [select Id,  Old_Id__c
                                                 from wb_Individual__c 
                                                 where Old_Id__c =:FamParentIDs 
                                                 order by Old_Id__c];
            
            sortListI = theParents;
            sortcustomObjList(theParents,'OLD');
            
            sortListFInfo = CloneFamilyInfo;
            sortcustomObjList(sortListFInfo,'PID');
            
            system.debug(theParents);
            system.debug(CloneFamilyInfo);
            
            
            List<wb_Individual__c> NewIndF = new List<wb_Individual__c>();     
            
            integer fi = 0;
            integer fj = 0;
            
            for (; fi < CloneFamilyInfo.size(); fi ++){
                
                for (;fj<theParents.size() &&
                     string.valueof(theParents[fj].Old_Id__c) <  string.valueof(CloneFamilyInfo[fi].MemberShimei__c)
                     ;fj++){
                         
                     }
                
                if ( string.valueof(theParents[fj].Old_Id__c) == string.valueof(CloneFamilyInfo[fi].MemberShimei__c))
                {
                    NewIndF.add( 
                        new wb_Individual__c(
                            Name = CloneFamilyInfo[fi].Name,
                            Sex__c=CloneFamilyInfo[fi].Sex__c,
                            DateOfBirth__c=CloneFamilyInfo[fi].DateOfBirth__c,
                            EmailAddress__c=CloneFamilyInfo[fi].Email__c,
                            MailDelivery__c=CloneFamilyInfo[fi].MailHaishin__c,
                            Mobile__c=CloneFamilyInfo[fi].Mobile__c,
                            FamilyNo__c=CloneFamilyInfo[fi].FamilyNo__c, 
                            FamilyRelationship__c=CloneFamilyInfo[fi].Relationship__c,
                            LastNameRoma__c=CloneFamilyInfo[fi].SeiRoma__c,
                            LastNameKana__c=CloneFamilyInfo[fi].SeiKana__c,
                            FirstNameRoma__c=CloneFamilyInfo[fi].MeiRoma__c,
                            FirstNameKana__c=CloneFamilyInfo[fi].MeiKana__c, 
                            Old_Id__c=CloneFamilyInfo[fi].id,
                            Parent__c=theParents[fj].id
                        )
                    );
                }
            }
            
            system.debug(NewIndF);
            
            if (NewIndF.size()>0)
                insert NewIndF;
            
        }
        
        void getAllIndividuals(List<MemberInfo__c> MemberInfo, List<FamilyInfo__c> FamilyInfo){
            List<Id> MemberIds = new List<Id>();      
            for ( MemberInfo__c m:MemberInfo){
                MemberIds.add(m.id);
            }
            
            thisIndividualMember =[select Id, name, WorkingCompany__c, Old_Id__c, Parent__c
                                   from wb_Individual__c 
                                   where Old_Id__c =:MemberIds 
                                   order by Id];
            
            List<Id> FamilyIds = new List<Id>();      
            for ( FamilyInfo__c m:FamilyInfo){
                FamilyIds.add(m.id);
            }
            
            thisIndividualFamily = null;
            thisIndividualFamily = [select Id, name, Parent__c, Old_Id__c, Parent__r.Old_Id__c
                                    from wb_Individual__c 
                                    where Old_Id__c =:FamilyIds or Parent__r.Old_Id__c =:MemberIds
                                    order by Parent__c desc ];
            
            system.debug(thisIndividualMember.size());
            system.debug(thisIndividualFamily.size());
            system.debug(thisIndividualFamily);
            
        }
        public void CreateMemberFamily(List<MemberInfo__c> MemberInfo, List<FamilyInfo__c> FamilyInfo,
                                       List<wb_Individual__c> IndividualMember, List<wb_Individual__c> IndividualFamily
                                      )
        {
            
            sortListM = MemberInfo;
            sortcustomObjList(MemberInfo);
            
            sortListI = IndividualMember;
            sortcustomObjList(IndividualMember,'OLD');
            
            system.debug(MemberInfo.size());
            system.debug(IndividualMember.size());
            system.debug(MemberInfo);
            system.debug(IndividualMember);
            system.debug(FamilyInfo.size());
            system.debug(IndividualFamily.size());
            system.debug(FamilyInfo);
            system.debug(IndividualFamily);
            List<MemberInfo__c> CloneMemberInfo = MemberInfo.clone();
            // List<MemberFamily> MemberFamilyList = new List<MemberFamily>();
            thisMemberFamilyList = new List<MemberFamily>();
            MemberFamily aMemberFamily;
            
            sortListI = IndividualFamily;
            sortcustomObjList(IndividualFamily,'POID');
            system.debug(IndividualFamily);
            
            integer k;
            integer ek = 0 ;
            integer l = IndividualMember.size() - 1 ;
            integer lf = IndividualFamily.size() - 1 ;
            
            for ( k = CloneMemberInfo.size() -1; K >= 0; k--){
                if (CloneMemberInfo[k].CompanyKeiyakuNo__c == thisContractInfo.Id ){
                    aMemberFamily = new MemberFamily(CloneMemberInfo[k]);
                    
                    List<FamilyInfo__c> theContractFamilyInfo = new List<FamilyInfo__c>();
                    
                    // Family Info
                    integer fk;
                    for ( fk = FamilyInfo.size() -1; fk >= 0; fk -- ){
                        if (FamilyInfo[fk].MemberShimei__r.CompanyKeiyakuNo__c == thisContractInfo.Id &&
                            FamilyInfo[fk].MemberShimei__c == CloneMemberInfo[k].Id
                           ){
                               theContractFamilyInfo.add(FamilyInfo[fk]);
                               FamilyInfo.remove(fk);
                           } else if (FamilyInfo[fk].MemberShimei__r.CompanyKeiyakuNo__c > thisContractInfo.Id ||
                                      FamilyInfo[fk].MemberShimei__c < CloneMemberInfo[k].Id
                                     ){
                                         fk = -2;
                                     }
                    }
                    
                    aMemberFamily.theFamilyInfo = theContractFamilyInfo;
                    
                    
                    // Individual
                    for (;l>=0 && 
                         string.valueOf(CloneMemberInfo[k].Id)<=string.valueof(IndividualMember[l].Old_Id__c);
                        ){
                            if ( string.valueOf(CloneMemberInfo[k].Id)==string.valueof(IndividualMember[l].Old_Id__c)) {
                                aMemberFamily.theMember = IndividualMember[l];
                                l--;
                            }
                            else if ( string.valueOf(CloneMemberInfo[k].Id)<string.valueof(IndividualMember[l].Old_Id__c))
                                l--;
                        }
                    
                    /* Individual Family */
                    aMemberFamily.theFamily = new List<wb_Individual__c>();
                    for (;lf>=0 && 
                         string.valueOf(CloneMemberInfo[k].Id)<=string.valueof(IndividualFamily[lf].Parent__r.Old_Id__c);
                        ){
                            if ( string.valueOf(CloneMemberInfo[k].Id)==string.valueof(IndividualFamily[lf].Parent__r.Old_Id__c)) {
                                aMemberFamily.theFamily.add(IndividualFamily[lf]);
                                lf--;
                            }
                            else if ( string.valueOf(CloneMemberInfo[k].Id)<string.valueof(IndividualFamily[lf].Parent__r.Old_Id__c))
                                lf--;
                        }
                    
                    
                    if ( aMemberFamily.theFamilyInfo.size() > 0)
                        system.debug(aMemberFamily);
                    thisMemberFamilyList.add(aMemberFamily);
                    
                    
                    CloneMemberInfo.remove(k);
                } else if (CloneMemberInfo[k].CompanyKeiyakuNo__c > thisContractInfo.Id  ){
                    k = -2;
                }
            }
            
            system.debug(thisMemberFamilyList.size());
            
            for ( MemberFamily m:thisMemberFamilyList){
                if ( m.theMemberInfo.Id != null && m.theMember == null ) {
                    system.debug('This Member Info is not converted:' + m.theMemberInfo);
                }
            }
            
            // sortListF = thisMemberFamilyList;
            // sortcustomObjList(sortListF); // Sort the list in string order with ID
            
        }
        
        public List<Date> GetMemberContractEndDate(){
            List <Date> EndDate = new List <Date>();
            Set<Date> EDS = new Set<Date>();
            system.debug(thisMemberInfo);
            for (MemberInfo__c m:thisMemberInfo){
                if ( m.MankiDate__c != null && EndDate.size() == 0){
                    EndDate.add(m.MankiDate__c);
                    EDS.add(m.MankiDate__c);
                } else if ( EDS.contains(m.MankiDate__c) == false){
                    EndDate.add(m.MankiDate__c);
                    EDS.add(m.MankiDate__c);
                }
            }
            
             for (MemberInfo__c m:thisVisitorInfo){
                if ( m.MankiDate__c != null && EndDate.size() == 0){
                    EndDate.add(m.MankiDate__c);
                    EDS.add(m.MankiDate__c);
                } else if ( EDS.contains(m.MankiDate__c) == false){
                    EndDate.add(m.MankiDate__c);
                    EDS.add(m.MankiDate__c);
                }
            }
            
            return EndDate;
        }
        
        public void ConvertHeader(date enddate){
            system.debug(District);
            Converted = new wb_Membership(MDService,AgRCountryDistrict,District);
            //   for (aSelectiveRow c:theContractInfoRows){
            if (thisContractInfo != null ){
                Converted.start_Edit();
             // Convert with the old number
                Converted.Membership.name = thisContractInfo.Name;
                Converted.Membership.Status__c = '未確定';
                Converted.Membership.ContractCompany__c = thisContractInfo.KeiyakuCompanyName__c;
                Converted.GetGroupDiscountPercentage();
                Converted.Membership.Classification__c ='会社';
                Converted.Membership.BillingCompany__c = thisContractInfo.SeikyuCompanyName__c;
                Converted.Membership.ContractCountry__c =thisContractInfo.CountryName__c;
                Converted.Membership.ContractDistrict__c = thisContractInfo.KeiyakuArea__c;
                Converted.Membership.BillingDistrict__c = thisContractInfo.SeikyuArea__c;
                Converted.Membership.Currency__c = thisContractInfo.Currency__c;
                Converted.Membership.ContractDate__c = system.today();
                Converted.Membership.ApplicationDate__c = system.today();
                Converted.Membership.ContractExpiryDate__c = enddate;
                Converted.RateAndRoundUp = Converted.getRateAndRoundUp();
                
                
                Converted.Membership.DiscountType__c = thisContractInfo.DiscountShubetsu__c;
                Converted.Membership.DiscountPercentage__c=thisContractInfo.GroupDiscountPer__c; 
                if (thisContractInfo.GroupTekiyouDiscountDate__c != null && thisContractInfo.GroupTekiyouDiscountDate__c !='-') {
                    try{
                        string d = thisContractInfo.GroupTekiyouDiscountDate__c;
                        d = d.replaceall('-','/');
                        Converted.Membership.DiscountApplicableDate__c= date.parse(thisContractInfo.GroupTekiyouDiscountDate__c);
                    } 	catch (Exception e) {
                    }

                    
                }
                        
                
                Converted.Membership.Sales__c = thisContractInfo.KeiyakuCompanyName__r.EigyoTanto__c;
                Converted.Membership.InternalAffairs__c = thisContractInfo.KeiyakuCompanyName__r.NaimuTanto__c;
                
                // Converted.getServiceMaster();
            }
            //  }
            system.debug(Converted.MDService);
        }
        
        public void ConvertDetail(date enddate){
            
            sortListF = thisMemberFamilyList;
            sortcustomObjList(thisMemberFamilyList,'KinmuCompany'); // Sort the list in string order with ID
            system.debug(thisMemberFamilyList.size());
            integer o_indx = 0, t_indx = 0;
            Converted.removeEmptyRow();
            for (MemberFamily m:thisMemberFamilyList){
                
                system.debug(m);
                if ( m.theMemberInfo.MankiDate__c == enddate ) {
                    
                    
                    string KeiyakuKeitai = m.theMemberInfo.KeiyakuKeitai__c;
                    // KeiyakuKeitai ='法人／家族Global Plus Member';
                    KeiyakuKeitai = KeiyakuKeitai.right(KeiyakuKeitai.length() - KeiyakuKeitai.indexOf('／') - 1);
                    Id ServiceId;
                    system.debug(KeiyakuKeitai);
                    wb_Service__c theService;
                    for ( wb_Service__c s:Converted.MDService){
                        if(s.DataType__c + s.Service__c == KeiyakuKeitai) {
                            ServiceId = s.Id;
                            theService = s;
                        }
                    }
                    system.debug(theService);
                    Converted = MembershipContractAdd(Converted,theService.DataType__c,1,m.theMember.Id, theService.Id,
                                                      m.theMember, m.theFamily,
                                                      null, null, null, null
                                                     );
                    
                }
            }
            
            for ( wb_MembershipDetail__c d:Converted.MembershipDetailsParent ){
                d.Classification__c ='移行';
            }
            
            for ( wb_MembershipDetail__c d:Converted.MembershipDetailsChild ){
                d.Classification__c ='移行';
            }
            
        }
        
        
        
        public void ConvertDetailVisitor(date enddate){
            
            List<string> VisitorMemberNo = new List<string>();
            List<Visitor> theVisitors = new List<Visitor>();
            Map<String,Integer> VisitorPlanMap = new Map<String,Integer>();
            List <Integer> VisitorPlanOrder = new List <Integer>();
            List <String> VisitorPlan = new List <String>();
            
            if ( thisVisitorInfo != null) {
                
                for ( integer i = 0; i < thisVisitorInfo.size(); i++ ){
                    if (thisVisitorInfo[i].MankiDate__c == enddate ) {
                        VisitorMemberNo.add( String.valueof(thisVisitorInfo[i].MemberNo__c).substring(4,10));
                        theVisitors.add( new Visitor(thisVisitorInfo[i].KinmuCompany__c,
                                                     thisVisitorInfo[i].KeiyakuKeitai__c,
                                                     String.valueof(thisVisitorInfo[i].MemberNo__c).substring(4,10)));
                        if(VisitorPlanMap.containsKey(string.valueof(thisVisitorInfo[i].KinmuCompany__c) + ',' + string.valueof(thisVisitorInfo[i].KeiyakuKeitai__c) ))
                        {
                            Integer index = VisitorPlanMap.get(string.valueof(string.valueof(thisVisitorInfo[i].KinmuCompany__c) + ',' +  thisVisitorInfo[i].KeiyakuKeitai__c));
                            VisitorPlanOrder[index]=VisitorPlanOrder[index]+1;
                        } else{
                            VisitorPlanMap.put(string.valueof(thisVisitorInfo[i].KinmuCompany__c) + ',' +  string.valueof(thisVisitorInfo[i].KeiyakuKeitai__c),VisitorPlanMap.size());
                            VisitorPlan.add(string.valueof(thisVisitorInfo[i].KinmuCompany__c) + ',' +  string.valueof(thisVisitorInfo[i].KeiyakuKeitai__c));
                            VisitorPlanOrder.add(1);
                        }
                    }
                }
                
                Converted.removeEmptyRow();
                
                List<Id> WorkingCompanyIds = new List<Id>();
                
                for (string plan:VisitorPlan){
                    WorkingCompanyIds.add(plan.substring(0,plan.indexOf(',')));
                }
                
                List<Account> WorkingCompnay = [select id, CountryCd__c from Account where Id =:WorkingCompanyIds]; 
                
                for (string plan:VisitorPlan){
                    
                    // system.debug(plan.substring(0,plan.indexOf(',')));
                    // system.debug(plan.substring(plan.indexOf(',') + 1,plan.Length()));
                    
                    string WorkingCompanyID = plan.substring(0,plan.indexOf(','));
                    string KeiyakuKeitai = plan.substring(plan.indexOf(',') + 1,plan.Length());
                    // KeiyakuKeitai ='法人／家族Global Plus Member';
                    KeiyakuKeitai = KeiyakuKeitai.right(KeiyakuKeitai.length() - KeiyakuKeitai.indexOf('／') - 1);
                    Id ServiceId;
                    system.debug(KeiyakuKeitai);
                    wb_Service__c theService;
                    
                    for ( wb_Service__c s:Converted.MDService){
                        if(s.DataType__c + s.Service__c == KeiyakuKeitai) {
                            ServiceId = s.Id;
                            theService = s;
                        }
                    }
                    system.debug(theService);
                    Integer index = VisitorPlanMap.get(plan);
                    
                    List<wb_Member__c> thisWorkingCompanyCardHolders= new List<wb_Member__c>();
                    
                    for (wb_Member__c ch:thisCardHolder){
                        if ( string.valueof(ch.WorkingCompany__c) == WorkingCompanyID) {
                            thisWorkingCompanyCardHolders.add(ch);
                        }
                    }
                    
                    string CountryCode;
                    
                    for (account w:WorkingCompnay){
                        if ( string.valueof(w.Id) == WorkingCompanyID) {
                            CountryCode = w.CountryCd__c;
                        }
                    }
                    
                    Converted = MembershipContractAdd(Converted,theService.DataType__c,1,null, theService.Id,
                                                      null, null,
                                                      WorkingCompanyID, VisitorPlanOrder[index],
                                                      thisWorkingCompanyCardHolders,
                                                      CountryCode
                                                     );
                    
                }
                
                
                for ( wb_MembershipDetail__c d:Converted.MembershipDetailsParent ){
                    d.Classification__c ='移行';
                }
                
                for ( wb_MembershipDetail__c d:Converted.MembershipDetailsChild ){
                    d.Classification__c ='移行';
                }
                
            }
        }
        
        public wb_Membership MembershipContractAdd( wb_Membership MS,string Type, integer Qty, Id IndID, Id ServiceID,
                                                   wb_Individual__c theIndividual, List<wb_Individual__c> theFamily,
                                                   Id VisitorWorkingCompId, Integer VisitorQty, 
                                                   List<wb_Member__c> CardHolders,
                                                   string CountryCode
                                                  ){
                                                      wb_Service__c theService;
                                                      system.debug(MS.MembershipDetailsParent);
                                                      if (Type == '入会金'){
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
                                                      else if (Type == '単身'){
                                                          integer ps = MS.MembershipDetailsParent.size();
                                                          //   system.debug(ps);
                                                          for (wb_Service__c s:MS.MDService) {
                                                              //if (s.SERVICE__C == 'Global Member' && s.DATATYPE__C=='単身' )
                                                              if (s.id == ServiceID )
                                                                  theService = s;
                                                          }
                                                          //system.debug(theService);
                                                          for (integer i = 1 ; i <= Qty; i ++ ) {
                                                              MS.add_empty_row();
                                                              if (MS.Membership.DiscountPercentage__c != null){
                                                                  MS.theMembershipDetail[MS.theMembershipDetail.size()-1].theDiscountPercentage = MS.Membership.DiscountPercentage__c ;
                                                              }
                                                                  
                                                              MS.theIndividualList =IndID;
                                                              MS.theServiceList=theService.Id;
                                                              MS.theStartRowIndex= ps + i - 1;
                                                              MS.theStartRowID='';
                                                              //MS.UpdateAndInsertRow_at();
                                                              MS.UpdateAndInsertRow_at(theIndividual,null);
                                                              
                                                          }
                                                          
                                                          
                                                          
                                                      } 
                                                      else if (Type == '家族'){
                                                          integer ps = MS.MembershipDetailsParent.size();
                                                          for (wb_Service__c s:MS.MDService) {
                                                              // if (s.SERVICE__C == 'Global Member' && s.DATATYPE__C=='家族' )
                                                              if (s.id == ServiceID )
                                                                  theService = s;
                                                          }
                                                          for (integer i = 1 ; i <= Qty; i ++ ) {
                                                              MS.add_empty_row();
                                                              if (MS.Membership.DiscountPercentage__c != null){
                                                                  MS.theMembershipDetail[MS.theMembershipDetail.size()-1].theDiscountPercentage = MS.Membership.DiscountPercentage__c ;
                                                              }
                                                                  

                                                              MS.theIndividualList =IndID;
                                                              MS.theServiceList=ServiceID;
                                                              MS.theStartRowIndex= ps + i - 1;
                                                              MS.theStartRowID='';
                                                              //  MS.UpdateAndInsertRow_at();
                                                              MS.UpdateAndInsertRow_at(theIndividual,theFamily);
                                                              
                                                          }
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
                                                          
                                                          if (MS.Membership.DiscountPercentage__c != null){
                                                              MS.theMembershipDetail[MS.theMembershipDetail.size()-1].theDiscountPercentage = MS.Membership.DiscountPercentage__c ;
                                                          }
                                                                  
                                                          MS.theMembershipDetail[ps].selectedValue = '3';
                                                          MS.theMembershipDetail[ps].fetchServiceOptions();
                                                          MS.theMembershipDetail[ps].theRow.Service__c = theService.id;
                                                          MS.theMembershipDetail[ps].theRow.Type__c = theService.DATATYPE__C;
                                                          MS.theMembershipDetail[ps].theRow.MembershipPlan__c = theService.Service__c;
                                                          MS.theMembershipDetail[ps].theRow.WorkingCompany__c = VisitorWorkingCompId;
                                                          MS.theMembershipDetail[ps].theRow.Quantity__c= VisitorQty;
                                                          MS.theMembershipDetail[ps].fetchServiceFee();
                                                          
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
                                                                                                                      MembershipEndDate__c = MS.theMembershipDetail[ps].theRow.MembershipEndDate__c
                                                                                                                      // ParentDetail__c = CardHolder[i].Parent.id
                                                                                                                     );
                                                              //  insert NCH;
                                                              MS.MembershipDetailsChild.add(NCH);
                                                              //nm.MembershipDetail__c = NCH.Id;
                                                              // NewMDCardHolders.add(  NCH );
                                                              //wb_MembershipDetail__c c = new wb_MembershipDetail__c();
                                                              //  c = NCH.clone(false);
                                                              //CardHolder[i].Child.add(c);
                                                              //  i = CardHolder.size();
                                                              //  }
                                                          }
                                                          }
                                                          //}
                                                          
                                                          
                                                          
                                                      }
                                                      MS.removeEmptyRow();
                                                      system.debug(MS.MembershipDetailsParent);
                                                      return MS;
                                                  }
        
        
        public void Confirm(){
            
            Converted.ValidateAndUpdate();
            //  Converted.Confirm();
        }
        public List<MemberInfo__c> sortListM  {get;set;}
        public List<FamilyInfo__c> sortListFInfo  {get;set;}
        
        public List<wb_Individual__c> sortListI  {get;set;}
        
        public List<MemberFamily> sortListF  {get;set;}
        
        public Integer sortNum  {get;set;}
        
        public void sortcustomObjList(List<MemberInfo__c> customObjList) {
            if(customObjList!=null && customObjList.size()>0) {
                this.sortListM = customObjList;
                this.sortNum = customObjList.size();
                quickSortM(0, sortNum-1);
                
                Integer sortedCount = 1;
                
            }
        }
        
        public void sortcustomObjList(List<FamilyInfo__c> customObjList, string sortby) {
            if(customObjList!=null && customObjList.size()>0) {
                this.sortListFInfo = customObjList;
                this.sortNum = customObjList.size();
                quickSortFInfo(0, sortNum-1, sortby);
                
                Integer sortedCount = 1;
                
            }
        }
        
        public void sortcustomObjList(List<wb_Individual__c> customObjList, string sortby) {
            if(customObjList!=null && customObjList.size()>0) {
                this.sortListI = customObjList;
                this.sortNum = customObjList.size();
                quickSortI(0, sortNum-1, sortby);
                
                Integer sortedCount = 1;
                
            }
        }
        
        public void sortcustomObjList(List<MemberFamily> customObjList, string sortby) {
            if(customObjList!=null && customObjList.size()>0) {
                this.sortListF = customObjList;
                this.sortNum = customObjList.size();
                quickSortF(0, sortNum-1, sortby);
                
                Integer sortedCount = 1;
                
            }
        }
        
        private void quickSortM(Integer low, Integer high ) {
            Integer i = low;
            Integer j = high;
            // Get the pivot element from the middle of the list
            MemberInfo__c pivot = sortListM[low + (high-low)/2];
            
            // Divide into two lists
            while (i <= j) {
                
                while (string.valueof(sortListM[i].id) < string.valueof(pivot.id)) {
                    i++;
                }
                
                while (string.valueof(sortListM[j].id) > string.valueof(pivot.id)) {
                    j--;
                }
                
                
                if (i <= j) {
                    exchangeM(i, j);
                    i++;
                    j--;
                }
            }
            // Recursion
            if (low < j)
                quickSortM(low, j);
            if (i < high)
                quickSortM(i, high);
        }
        
        private void quickSortFInfo(Integer low, Integer high, string sortby ) {
            Integer i = low;
            Integer j = high;
            // Get the pivot element from the middle of the list
            FamilyInfo__c pivot = sortListFInfo[low + (high-low)/2];
            
            // Divide into two lists
            while (i <= j) {
                
                if (sortby=='ID'){
                    while (string.valueof(sortListFInfo[i].id) < string.valueof(pivot.id)) {
                        i++;
                    }
                    
                    while (string.valueof(sortListFInfo[j].id) > string.valueof(pivot.id)) {
                        j--;
                    }
                } else if (sortby=='PID'){
                    
                    while (string.valueof(sortListFInfo[i].MemberShimei__c) < string.valueof(pivot.MemberShimei__c)) {
                        i++;
                    }
                    
                    while (string.valueof(sortListFInfo[j].MemberShimei__c) > string.valueof(pivot.MemberShimei__c)) {
                        j--;
                    }
                    
                }
                
                
                if (i <= j) {
                    exchangeFInfo(i, j);
                    i++;
                    j--;
                }
            }
            // Recursion
            if (low < j)
                quickSortFInfo(low, j, sortby);
            if (i < high)
                quickSortFInfo(i, high, sortby);
        }
        
        private void exchangeM(Integer i, Integer j) {
            MemberInfo__c temp = sortListM[i];
            sortListM[i] = sortListM[j];
            sortListM[j] = temp;
        }  
        
        private void exchangeFInfo(Integer i, Integer j) {
            FamilyInfo__c temp = sortListFInfo[i];
            sortListFInfo[i] = sortListFInfo[j];
            sortListFInfo[j] = temp;
        }  
        
        private void quickSortI(Integer low, Integer high, string sortby ) {
            Integer i = low;
            Integer j = high;
            // Get the pivot element from the middle of the list
            wb_Individual__c pivot = sortListI[low + (high-low)/2];
            
            // Divide into two lists
            while (i <= j) {
                
                if ( sortby == 'ID') {
                    while (string.valueof(sortListI[i].id) < string.valueof(pivot.id)) {
                        i++;
                    }
                    
                    while (string.valueof(sortListI[j].id) > string.valueof(pivot.id)) {
                        j--;
                    }
                } else if ( sortby == 'OLD') {
                    while (string.valueof(sortListI[i].Old_Id__c) < string.valueof(pivot.Old_Id__c)) {
                        i++;
                    }
                    
                    while (string.valueof(sortListI[j].Old_Id__c) > string.valueof(pivot.Old_Id__c)) {
                        j--;
                    }
                } else if (sortby=='POID'){
                    while (string.valueof(sortListI[i].Parent__r.Old_Id__c) < string.valueof(pivot.Parent__r.Old_Id__c)) {
                        i++;
                    }
                    
                    while (string.valueof(sortListI[j].Parent__r.Old_Id__c) > string.valueof(pivot.Parent__r.Old_Id__c)) {
                        j--;
                    }
                }
                
                
                if (i <= j) {
                    exchangeI(i, j);
                    i++;
                    j--;
                }
            }
            // Recursion
            if (low < j)
                quickSortI(low, j, sortby);
            if (i < high)
                quickSortI(i, high, sortby);
        }
        
        private void exchangeI(Integer i, Integer j) {
            wb_Individual__c temp = sortListI[i];
            sortListI[i] = sortListI[j];
            sortListI[j] = temp;
        }  
        
        private void quickSortF(Integer low, Integer high, string sortby ) {
            Integer i = low;
            Integer j = high;
            // Get the pivot element from the middle of the list
            MemberFamily pivot = sortListF[low + (high-low)/2];
            
            // Divide into two lists
            while (i <= j) {
                
                if ( sortby == 'oid') {
                    while (Id.valueof(sortListF[i].theMember.Old_Id__c) < Id.valueof(pivot.theMember.Old_Id__c)) {
                        i++;
                    }
                    
                    while (Id.valueof(sortListF[j].theMember.Old_Id__c) > Id.valueof(pivot.theMember.Old_Id__c)) {
                        j--;
                    }
                } else if (sortby == 'MemberNo') {
                    
                    while (string.valueof(sortListF[i].theMemberInfo.MemberNo__c) < string.valueof(pivot.theMemberInfo.MemberNo__c)) {
                        i++;
                    }
                    
                    while (string.valueof(sortListF[j].theMemberInfo.MemberNo__c) > string.valueof(pivot.theMemberInfo.MemberNo__c)) {
                        j--;
                    }
                    
                } else if ( sortby =='KinmuCompany') {
                    while (string.valueof(sortListF[i].theMemberInfo.KinmuCompany__r.name) < string.valueof(pivot.theMemberInfo.KinmuCompany__r.name)) {
                        i++;
                    }
                    
                    while (string.valueof(sortListF[j].theMemberInfo.KinmuCompany__r.name) > string.valueof(pivot.theMemberInfo.KinmuCompany__r.name)) {
                        j--;
                    }
                    
                }
                
                
                if (i <= j) {
                    exchangeF(i, j);
                    i++;
                    j--;
                }
            }
            // Recursion
            if (low < j)
                quicksortF(low, j, sortby);
            if (i < high)
                quicksortF(i, high, sortby);
        }
        
        private void exchangeF(Integer i, Integer j) {
            MemberFamily temp = sortListF[i];
            sortListF[i] = sortListF[j];
            sortListF[j] = temp;
        }          
        
    }
    
    public wb_convert_ContractInfo_Batch(Account Company){
        
        theCompany = [select Id, name, CountryName__c from Account where Id =: Company.Id ];
        getService();
        getCountryDistrict();
        getDistrict();
        
        if (theCompany != null) {
            
            getContractInfo();
            
            theContractRows = new List<aContractRow>();
            
            if (theContractInfo.size() > 0) {
                for ( ContractInfo__c c:theContractInfo)
                    theContractRows.add(new aContractRow(c,MDService,AgRCountryDistrict,District) );
            }
            
            
        }
        
        
        
    }
    
    public wb_convert_ContractInfo_Batch(ContractInfo__c Contract){
        
        theCompany = [select Id, name, CountryName__c from Account where Id =: Contract.KeiyakuCompanyName__c ];
        getService();
        getCountryDistrict();
        getDistrict();
        system.debug(MDService);
        
        if (theCompany != null) {
            
            getContractInfo(Contract);
            
            theContractRows = new List<aContractRow>();
            
            if (theContractInfo.size() > 0) {
                for ( ContractInfo__c c:theContractInfo)
                    theContractRows.add(new aContractRow(c,MDService,AgRCountryDistrict,District) );
            }
            
            
        }
        
        
    }
    
    public wb_convert_ContractInfo_Batch(ContractInfo__c Contract, List<MemberInfo__c> m){
        
        theCompany = [select Id, name, CountryName__c from Account where Id =: Contract.KeiyakuCompanyName__c ];
        getService();
        getCountryDistrict();
        getDistrict();
        system.debug(MDService);
        
        if (theCompany != null) {
            
            getContractInfo(Contract);
            
            theContractRows = new List<aContractRow>();
            
            if (theContractInfo.size() > 0) {
                for ( ContractInfo__c c:theContractInfo)
                    theContractRows.add(new aContractRow(c,m,MDService,AgRCountryDistrict,District) );
            }
            
            
        }
        
    }
    public wb_convert_ContractInfo_Batch(ContractInfo__c Contract, string type ){
        
        theCompany = [select Id, name, CountryName__c from Account where Id =: Contract.KeiyakuCompanyName__c ];
        getService();
        getCountryDistrict();
        getDistrict();
        system.debug(MDService);
        
        if (theCompany != null) {
            
            getContractInfo(Contract);
            
            theContractRows = new List<aContractRow>();
            
            if (theContractInfo.size() > 0) {
                for ( ContractInfo__c c:theContractInfo)
                    theContractRows.add(new aContractRow(c,type,MDService,AgRCountryDistrict,District) );
            }
            
            
        }
        
    }
    
    public void getService(){
        MDService = [SELECT id, Service__c, CardPrefix__c, Currency__c, ServiceFee__c, Discountable__c,
                     DataType__c
                     FROM wb_Service__c
                     where ServiceClassification__c = '会員' and Enable__c = true
                     order by DisplayOrder__C];
    }
    public void getCountryDistrict(){
        AgRCountryDistrict = [SELECT Region__c, Country__c, District__c, Jurisdiction__c, Affiliation__c, count(Id)
                              FROM wb_CountryDistrict__c
                              //  where service__c = 'MD会員'
                              where service__c = 'MD'
                              group by Region__c, Country__c, District__c, Jurisdiction__c, Affiliation__c
                              order by Region__c, Country__c, District__c, Jurisdiction__c, Affiliation__c ];
    }
    public void getDistrict(){
        District = [SELECT  Id, District__c
                    FROM wb_CountryDistrict__c
                    where service__c = 'MD契約' 
                    order by id ];
    }
    
    public void startConvert(){
        system.debug(MDService);
        for (aContractRow c:theContractRows){
            
            List<Date> ed = c.GetMemberContractEndDate();
            system.debug(ed);
            for ( Date d:ed){
                c.ConvertHeader(d);
                c.ConvertDetail(d);
                c.ConvertDetailVisitor(d);
                // c.Converted.Membership.ContractCountry__c='日本';
                c.Converted.ValidateAndUpdate();
                system.debug(c.Converted.Membership);
                system.debug(c.Converted.MembershipDetailsParent);
                //  c.Converted.ValidateAndUpdate();
                c.Confirm();
            }
            
        }
        
    }
    
    void getContractInfo(){
        
        theContractInfo = [ select Id, Name, KeiyakuArea__c, KeiyakuCompanyName__c, KeiyakuCompanyName__r.name,
                           SeikyuArea__c, SeikyuCompanyName__c, SeikyuCompanyName__r.name, Currency__c, CountryName__c,
                           KeiyakuCompanyName__r.EigyoTanto__c, KeiyakuCompanyName__r.NaimuTanto__c,
                           DiscountShubetsu__c, GroupDiscountPer__c, GroupTekiyouDiscountDate__c
                           from ContractInfo__c 
                           where KeiyakuCompanyName__c =:theCompany.Id
                           order by Id];
        
    }
    
    void getContractInfo(ContractInfo__c c){
        
        theContractInfo = [ select Id, Name, KeiyakuArea__c, KeiyakuCompanyName__c, KeiyakuCompanyName__r.name,
                           SeikyuArea__c, SeikyuCompanyName__c, SeikyuCompanyName__r.name, Currency__c, CountryName__c,
                           KeiyakuCompanyName__r.EigyoTanto__c, KeiyakuCompanyName__r.NaimuTanto__c,
                           DiscountShubetsu__c, GroupDiscountPer__c, GroupTekiyouDiscountDate__c
                           from ContractInfo__c 
                           where Id =:c.Id
                           order by Id];
        
    }
    
    
    
}