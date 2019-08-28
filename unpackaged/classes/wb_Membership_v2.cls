public class wb_Membership_v2 {
    
    private ApexPages.StandardController standardController;
    public string MyHome='/a0o/o'; 
    
    public wb_Membership__c Membership {get; set;}
    
    public class ChildIndex{
        public Id ParentID {get;set;}
        public string ParentName {get;set;}
        public integer Idx {get;set;}
        public integer firstChildIndx {get;set;}
        public integer lastChildIndx {get;set;}
        public ChildIndex(Id p, integer ix){
            ParentID = p;
            Idx = ix;
        }
        public ChildIndex(String pn, integer ix){
            ParentName = pn;
            Idx = ix;
        }
        public ChildIndex(Id p, String pn, integer ix){
            ParentID = p;
            ParentName = pn;
            Idx = ix;
        }
    }
    
    public List<ChildIndex> bulidChildIndex(wb_MembershipDetail__c Parent, 
                                            List<wb_MembershipDetail__c> Child
                                           )
    {
        List<wb_MembershipDetail__c> P = new List<wb_MembershipDetail__c>();
        P.add(Parent);
        return bulidChildIndex(P,Child);
    }
    public List<ChildIndex> bulidChildIndex(List<wb_MembershipDetail__c> Parent, 
                                            List<wb_MembershipDetail__c> Child
                                           )
    {
        List<ChildIndex> idx = new  List<ChildIndex>();
        integer fchild;
        integer lchild;
        boolean breakloop;
        integer i = 0;
        set<string> myset = new set<string>(); 
        myset.add('単身');
        myset.add('家族');
        myset.add('無記名');
        
        List<ChildIndex> Childidx = bulidChildIndex(Child);
        system.debug(Childidx);
        for (integer h = 0; h < Parent.size(); h ++){
            if ( myset.contains(Parent[h].Type__c)){
                ChildIndex ix = new ChildIndex(Parent[h].Id,Parent[h].Name,h);
                fchild = null;
                lchild = null;
                
                integer[] cidx;
                
                if (Parent[h].Id == null){
                    
                    cidx = SearchIndex( Parent[h].Name,Childidx); 
                }
                else{
                    // system.debug(Parent[h].Id);
                    // system.debug( Childidx);
                    cidx = SearchIndex( Parent[h].Id,Childidx);    
                    if (cidx[0] == null && cidx[1] == null){
                        cidx = SearchIndex( Parent[h].Name,Childidx); 
                    }
                    // system.debug(cidx);
                }
                
                if (cidx != null){
                    ix.firstChildIndx = cidx[0];
                    ix.lastChildIndx = cidx[1];
                }
                
                idx.add(ix);
            }
        }
        
        return idx;
    }
    
    
    
    public List<ChildIndex> bulidChildIndex( List<wb_MembershipDetail__c> Child )
    {
        List<ChildIndex> idx = new  List<ChildIndex>();
        integer fchild;
        integer lchild;
        boolean breakloop;
        integer i = 0;
        set<string> myset = new set<string>(); 
        myset.add('単身');
        myset.add('家族');
        myset.add('無記名');
        
        Id PId;
        String PName;
        integer c;
        ChildIndex ix;
        for ( c = 0; c < Child.size(); c ++){
            if ( Child[c].ParentDetail__c != null){
                PId = Child[c].ParentDetail__c;
                ix = new ChildIndex(PId,null);
                fchild = c;
            } else if (Child[c].Name != null){
                PName = Child[c].Name;
                ix = new ChildIndex(PName,null);
                fchild = c;
            }
            
        }
        
        if (c == Child.size() && fchild != null && ix != null){
            lchild = Child.size() -1 ;
            ix.firstChildIndx = fchild;
            ix.lastChildIndx = lchild;
            idx.add(ix);
        }
        
        
        return idx;
    }
    
    
    
    public integer[] GetChildIndex(Id Pid, List<ChildIndex> Index, List<wb_MembershipDetail__c> Child){
        
        Integer [] a;
        if ( (Index == null) || (Child == null))
            return new Integer[]{null,null,0};
                
                Integer low = 0;
        Integer high = Index.size();
        // Get the pivot element from the middle of the list
        if (Index.size()>0 && Child.size() > 0){
            boolean found = false;
            
            while (found == false){
                Id pivot = Index[low + (high-low)/2].ParentID;
                if ( pivot == Pid){
                    found = true;
                    string lastName = Child[low + (high-low)/2].name;
                    a=new Integer[]{Index[low + (high-low)/2].firstChildIndx, 
                        Index[low + (high-low)/2].lastChildIndx,
                        GetSeqfromName(Child[low + (high-low)/2].name)};
                            } 
                else if (pivot > Pid){
                    high = low + (high-low)/2;
                } else {
                    low = low + (high-low)/2;
                }
            }
        } else
            a=new Integer[]{null,null,0};
                return a;
    }
    
    
    public integer[] SearchIndex(Id Pid, List<ChildIndex> Index){
        
        Integer [] a = new Integer[]{null,null};
            if  (Index == null) 
            return new Integer[]{null,null};
                
                Integer low = 0;
        Integer high = Index.size();
        // Get the pivot element from the middle of the list
        if (Index.size()>0 && Pid != null){
            boolean found = false;
            
            while (found == false && high != low ){
                Id pivot = Index[low + (high-low)/2].ParentID;
                system.debug(low + ',' + high + ',' + pivot +',' + Pid);
                if (pivot > Pid)
                    system.debug('pivot > Pid');
                else
                    system.debug('pivot < Pid');
                
                
                if ( pivot == Pid){
                    found = true;
                    a=new Integer[]{Index[low + (high-low)/2].firstChildIndx, 
                        Index[low + (high-low)/2].lastChildIndx };
                            }
                else if (pivot > Pid){
                    high = low + (high-low)/2;
                    system.debug(high);
                } else {
                    if (low == low + (high-low)/2){
                        return new Integer[]{null,null};
                            }
                    else
                        low = low + (high-low)/2;
                }
            }
            
        } else {
            a=new Integer[]{null,null};
                }
        return a;
    }
    
    public integer[] SearchIndex(String PName, List<ChildIndex> Index){
        
        Integer [] a; 
        if  (Index == null) 
            return new Integer[]{null,null};
                
                Integer low = 0;
        Integer high = Index.size();
        // Get the pivot element from the middle of the list
        if (Index.size()>0 ){
            boolean found = false;
            
            while (found == false && high != low ){
                
                string pivotName = Index[low + (high-low)/2].ParentName;
                //  system.debug(low + ',' + high + ',' + pivotName +',' + PName);
                if ( PName == pivotName){
                    found = true;
                    a=new Integer[]{Index[low + (high-low)/2].firstChildIndx, 
                        Index[low + (high-low)/2].lastChildIndx };
                            }
                else if (PName > pivotName){
                    high = low + (high-low)/2;
                } else {
                    if (low == low + (high-low)/2){
                        return new Integer[]{null,null};
                            }
                    else
                        low = low + (high-low)/2;
                }
            }
        } else
            a=new Integer[]{null,null};
                return a;
    }
    
    public integer GetSeqfromName(string n){
        // string Seq = n.right(n.length() - n.indexOf('-') - 1);
        string Seq = n;
        if (Seq!=null){
            while (Seq.indexOf('-') > 0 ){
                Seq = n.right(n.length() - n.indexOf('-') - 1);
            }
            return integer.valueof(Seq);
        } else
            return 0;
    }
    
    private Integer pageNumber;
    private Integer pageSize;
    private Integer totalPageNumber;
    public Integer getPageNumber()
    {
        return pageNumber;
    }

    public Integer getPageSize()
    {
        return pageSize;
    }
    public Boolean getPreviousButtonEnabled()
    {
        return !(pageNumber > 1);
    }
    public Boolean getNextButtonDisabled()
    {
        if (MembershipDetailsParent == null) return true;
        else
            return ((pageNumber * pageSize) >= MembershipDetailsParent.size());
    }
    public Integer getTotalPageNumber()
    {
        if (totalPageNumber == 0 && MembershipDetailsParent !=null)
        {
            totalPageNumber = MembershipDetailsParent.size() / pageSize;
            Integer mod = MembershipDetailsParent.size() - (totalPageNumber * pageSize);
            if (mod > 0)
                totalPageNumber++;
        }
        return totalPageNumber;
    }
    public void datapaging()
    {
        pageNumber = 0;
        totalPageNumber = 0;
        pageSize = 50;
        ViewPageData();
    }
    public void ViewPageData()
    {
     
        theMembershipDetail = null;
        totalPageNumber = 0;
        BindPageData(1);
        return;
    }
    private void BindPageData(Integer newPageIndex)
    {
        try
        {

            theMembershipDetail = new List<wb_MembershipDetailRow>();
            
            Transient Integer counter = 0;
            Transient Integer min = 0;
            Transient Integer max = 0;
            
            if (newPageIndex > pageNumber)
            {
                min = pageNumber * pageSize;
                max = newPageIndex * pageSize;
            }
            else
            {
                max = newPageIndex * pageSize;
                min = max - pageSize;
                if ( 0 > min ) min = 0;
            }
            
            MembershipDetailsParent_CIndx = bulidChildIndex(MembershipDetailsParent,MembershipDetailsChild);
            
            for(integer i = min; (i <  max) && ( i < MembershipDetailsParent.size()) ; i ++)
            {
               
                wb_MembershipDetail__c d = MembershipDetailsParent[i];
                wb_MembershipDetailRow NR = new wb_MembershipDetailRow(MembershipDetailsParent.size() - 1,
                                                                    d, null, 
                                                                    MDService, RateAndRoundUp, Membership.Currency__c, null, null // Membership.DiscountPercentage__c 
                                                                      );

                
                if (d.Id != null ){
                    integer[] cidx = SearchIndex( d.Id,MembershipDetailsParent_CIndx);
                    if (cidx[0]!=null && cidx[1]!=null){
                        NR.theChildRow = new List<wb_MembershipDetail__c>();
                        for (integer ci = cidx[0] ; ci <= cidx[1]; ci ++){
                            NR.theChildRow.add(MembershipDetailsChild[ci]);
                        }
                        NR.fetchFamily(NR.theChildRow);
                    }
                   
                } 
                
                theMembershipDetail.add(NR);
            }
            
            
            pageNumber = newPageIndex;
            if (theMembershipDetail == null || theMembershipDetail.size() <= 0)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Data not available for this view.'));
        }
        catch(Exception ex)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,ex.getMessage()));
        }
    }
    
    public PageReference nextBtnClick() {
        system.debug('nextBtnClick:' + pageNumber );
        BindPageData(pageNumber + 1);
        return null;
    }
    public PageReference previousBtnClick() {
        system.debug('previousBtnClick:' + pageNumber  );
        BindPageData(pageNumber - 1);
        return null;
    }
    
    public List<wb_MembershipDetail__c> MembershipDetailsParent {get; set;}
    public List<ChildIndex> MembershipDetailsParent_CIndx {get; set;}
    public List<wb_MembershipDetail__c> MembershipDetailsChild {get; set;}
    
    
    public List<wb_MembershipDetailRow> theMembershipDetail {get; set;}
    
    public List<wb_MembershipDetail__c> BeingAmendedMembershipDetailsParent {get; set;}
    public List<ChildIndex> BeingAmendedMembershipDetailsParent_CIndx {get; set;}
    public List<wb_MembershipDetail__c> BeingAmendedMembershipDetailsChild {get; set;}
    public List<ChildIndex> BeingAmendedMembershipDetailsChild2ParentIndx {get; set;}
    
    
    
    public List<wb_MembershipDetailRow> theBeingAmendedMembershipDetail {get; set;}
    
    // public List<wb_MembershipDetail__c> MembershipDetails {get; set;}
    public List<wb_MembershipDetail__c> BeingAmendMembershipDetails {get; set;}
    
    public List<ChildIndex> MemberFee_CIndx {get; set;}
    public List<wb_MembershipDetail__c> MemberFeeChild {get; set;}
    public List<wb_MembershipDetail__c> MemberFeeChildIn {get; set;}
    public List<wb_MembershipDetail__c> MemberFeeChildOut {get; set;}
    
    
    public integer NoofMembershipDetails {get; set;}
    public integer NoofReceivable {get; set;}
    
    public List<wb_Service__c> MDService {get;set;}
    
    public List<AggregateResult> AgRCountryDistrict {get; set;}    
    public List<wb_Currency__c>  CurrencySymbol {get; set;}
    
    public List<wb_BudgetRate__c> RateAndRoundUp {get; set;}
    public string theMode {get; set;}   
    public string reportTimeValue {get; set;}
    
    // Option
    public SelectOption[] CountryOptions {get; set;}
    public SelectOption[] DistrictOptions {get; set;}
    public SelectOption[] BillingDistrictOptions {get; set;}
    public SelectOption[] AffiliationOptions {get; set;}
    public SelectOption[] CurrencySymbolOptions {get; set;}
    
    // public List<wb_Individual__c> Individuals {get;set;}
    
    public  Map<String, List<wb_Individual__c>> mapFamilies{get;set;}
    
    
    
    
    public Boolean AmendmentAdditionItemMode {get; set;}   
    
    public Boolean ErrAlert {get; set;}    
    public boolean HavingError {get; set;} 
    public string AlertMessage {get; set;}  
    
    //public Id ContractCompID {get; set;}
    public wb_Membership_v2(ApexPages.StandardController stdController){
        this.standardController = stdController;
        
        Membership = (wb_Membership__c) stdController.getRecord();
        
        if (Membership.id != null) 
            getContractHeader(Membership.id);
        getServiceMaster();
        
    }
    
    public wb_Membership_v2(){
        Membership = new wb_Membership__c();
        getServiceMaster();
        // MyUtility = new wb_MembershipUtility();
    }
    
    public PageReference redirect() {
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        if (Membership.Status__c=='未確定')
            return new PageReference(sfdcBaseURL+'/apex/wb_Membership_Edit?Id=' + Membership.Id);
        else if  (Membership.Status__c=='確定')
            return new PageReference(sfdcBaseURL+'/apex/wb_Membership_Amend?Id=' + Membership.Id);
        else return new PageReference(sfdcBaseURL+'/apex/wb_Membership_View?Id=' + Membership.Id);
    }
    
    public PageReference redirect_to_edit(){
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        if (Membership.Status__c=='未確定')
            return new PageReference(sfdcBaseURL+'/apex/wb_Membership_Edit?Id=' + Membership.Id);
        else if  (Membership.Status__c=='確定')
            return new PageReference(sfdcBaseURL+'/apex/wb_Membership_Amend?Id=' + Membership.Id);
        else
            return new PageReference(sfdcBaseURL+'/apex/wb_Membership_View?Id=' + Membership.Id);
    }
    
    public void start_View(){
        
        if (Membership.id != null) {
            Membership = getContractHeader(Membership.id);
            
            RateAndRoundUp=getRateAndRoundUp();
            getContractDetail_paging();
            datapaging();
            
        }
        // NoofReceivable = [select id  FROM wb_ReceivableServiceFee__c where Membership__c =:Membership.id].size();
        NoofReceivable= GetNoofReceivable(Membership.id);
    }
    
    public void start_Amend(){
        
        if (Membership.id != null) {
            Membership=getContractHeader(Membership.id);
            
            RateAndRoundUp=getRateAndRoundUp();
            getContractDetail();
        }
        // NoofReceivable = [select id  FROM wb_ReceivableServiceFee__c where Membership__c =:Membership.id].size();
        NoofReceivable= GetNoofReceivable(Membership.id);
    }
    
    public void start_Edit(){
        
        if (Membership.id != null) {
            Membership = getContractHeader(Membership.id);
            RateAndRoundUp=getRateAndRoundUp();
           // getContractDetail();
            getContractDetail_paging();
            datapaging();
            
        }
        else {
            Membership = new wb_Membership__c(Status__c='未確定');
            if (apexpages.currentpage() != null ) {
                if (apexpages.currentpage().getparameters().get('pv0') != null ){
                    Membership.Classification__c = '会社';
                    Membership.ContractCompany__c = apexpages.currentpage().getparameters().get('pv0');
                    GetGroupDiscountPercentage();
                }
            }
            MembershipDetailsParent =  new List<wb_MembershipDetail__c>(); 
            MembershipDetailsParent_CIndx =  new List<ChildIndex>(); 
            MembershipDetailsChild =  new List<wb_MembershipDetail__c>(); 
            theMembershipDetail = new List<wb_MembershipDetailRow>();
        }
        
        getCountryDistrict();
        getCurrencySymbol();
        RateAndRoundUp=getRateAndRoundUp();
        
        CountryOptions= getCountryOptions();
        DistrictOptions= getDistrictOptions();
        AffiliationOptions = getAffiliationOptions();
        
        BillingDistrictOptions = getDistrictOptions();
        CurrencySymbolOptions=getCurrencySymbolOptions();
        
        //NoofReceivable = [select id  FROM wb_ReceivableServiceFee__c where Membership__c =:Membership.id].size();
        NoofReceivable= GetNoofReceivable(Membership.id);
        add_empty_row();
    }
    
    public integer GetNoofReceivable(Id MSId){
        return [select id  FROM wb_ReceivableServiceFee__c where Membership__c =:MSId].size();
    }
    public void GenerateMemeberNo(){
        
        getContractHeader(Membership.id);
        
        if ( Membership.Status__c=='未確定') { 
            getContractDetail();
            GenerateMemeberNo_Start(theMembershipDetail);
        }
        
    }
    
    public class MDParentChild{
        public wb_MembershipDetail__c Parent{get;set;}
        public list<wb_MembershipDetail__c> Child{get;set;}
        public MDParentChild(wb_MembershipDetail__c p){
            Parent = p;
            Child = new list<wb_MembershipDetail__c>();
        }
        public integer GetNoofChild(){
            return Child.size();
        }    
        public integer GetCardHolderNoMemberNoQaulity(){
            integer i=0;
            for (wb_MembershipDetail__c c:Child){
                if (c.MemberNo__c!=null)
                    i++;
            }
            return integer.valueof(Parent.Quantity__c) - i;
        }    
    }
    
    public class Family{
        public wb_Individual__c theMember {get;set;}
        public List<wb_Individual__c> FamilyMembers {get;set;}
        public Family(Id ParentID){
            List<wb_Individual__c> theFamily = [SELECT FamilyNo__c, Id, Sex__c, Parent__c, Name, WorkingCompany__c
                                                FROM wb_Individual__c 
                                                where Parent__c =:ParentID
                                                or Id =:ParentID
                                                order by Id];
            //theMember;
            FamilyMembers = new List<wb_Individual__c>();
            for (wb_Individual__c i:theFamily){
                if (i.Id ==ParentID)
                    theMember = i;
                else
                    FamilyMembers.add(i);
            }
            
          //  system.debug(theMember);
        }
    }
    
    public boolean GenerateMemeberNo_Start(wb_MembershipDetailRow MDRow ){
        List<wb_MembershipDetailRow> theMDRow = new  List<wb_MembershipDetailRow>();
        theMDRow.add(MDRow);
        return GenerateMemeberNo_Start(theMDRow);
    }
    public boolean GenerateMemeberNo_Start(List<wb_MembershipDetailRow> MDRows ){
        
        List<wb_MembershipDetail__c> IndNoMbrno = new List<wb_MembershipDetail__c>();
        List<wb_MembershipDetail__c> IndNoMbrnoFml = new List<wb_MembershipDetail__c>();
        
        List<MDParentChild> CardHolder = new List<MDParentChild>();
        
        
        for ( wb_MembershipDetailRow r:MDRows ){
            if ((r.theRow.Type__c =='家族' || r.theRow.Type__c =='単身') 
                && r.theRow.Individual__c != null && r.theRow.Service__c != null ) 
            {
                IndNoMbrno.add(r.theRow);
                if (r.theRow.Type__c =='家族'){
                    if (r.theChildRow != null) {
                        for ( wb_MembershipDetail__c f:r.theChildRow){
                            IndNoMbrnoFml.add(f);
                        }
                    }
                }
            } else if (r.theRow.Type__c =='無記名' && r.theRow.Service__c != null)
            {
                wb_MembershipDetail__c c = new wb_MembershipDetail__c();
                c = r.theRow.clone(true);
                MDParentChild CHldr = new MDParentChild(c);
                if (r.theChildRow != null ) {  
                    for ( wb_MembershipDetail__c f:r.theChildRow){
                        CHldr.Child.add(f);
                    }
                }
                CardHolder.add( CHldr);
                
            }
        }
        
        
        
        List<Id> IndID = new List<ID>();
        
        for ( wb_MembershipDetail__c md:IndNoMbrno){
            if (md.individual__c != null)
                IndID.add(md.individual__c);
        }
        
        List<wb_Individual__c> OldIndiviualList = [select id, Old_Id__c from wb_Individual__c 
                                                   where Id=:IndID and Old_Id__c != null ];
        List<Id> OldMemID = new List<ID>();
        for (wb_Individual__c o:OldIndiviualList)
            OldMemID.add(o.Old_Id__c);
        List<MemberInfo__c> OldMembers = [select Id, KinmuCompany__c, KeiyakuNo__c 
                                          from MemberInfo__c where Id=:OldMemID];
        
        
        List<wb_member__c> MemberList = [select id, Name, Individual__c, WorkingCompany__c, EndDate__c, MembershipDetail__c,
                                         Old_MemberNo__c
                                         from wb_member__c where Individual__c =:IndID ];
        List<wb_member__c> NewMemberList = new List<wb_member__c>();
        
        for (wb_MembershipDetail__c m : IndNoMbrno) { 
            
            boolean NewMember = true;
            wb_member__c theMember;
            
            // To check if the Indiviual is an existing member under the same working company
            for (integer i=0; i<MemberList.size() && NewMember == true ; i++){
                if ( MemberList[i].Individual__c == m.individual__c 
                    && MemberList[i].WorkingCompany__c == m.WorkingCompany__c ){
                        NewMember = false;
                        theMember = MemberList[i];
                    }
            }
            
            if ( NewMember == true){
                boolean IsOldMember = false;
                string oldMemNo;
                for (integer i = 0; (i < OldIndiviualList.size() && IsOldMember == false); i++){
                    if (m.individual__c == OldIndiviualList[i].Id){
                        for ( integer j = 0; (j < OldMembers.size() && IsOldMember == false); j ++ ){
                            if (OldMembers[j].id == OldIndiviualList[i].Old_Id__c 
                                && OldMembers[j].KinmuCompany__c == m.WorkingCompany__c){
                                    IsOldMember = true;
                                    oldMemNo = OldMembers[j].KeiyakuNo__c;
                                }
                        }
                    }
                }               
                
                if (IsOldMember==false)
                    NewMemberList.add(new wb_member__c(
                        Individual__c   =  m.individual__c,
                        WorkingCompany__c = m.WorkingCompany__c,
                        MembershipDetail__c=m.id
                    ));
                else
                    NewMemberList.add(new wb_member__c(
                        Individual__c   =  m.individual__c,
                        WorkingCompany__c = m.WorkingCompany__c,
                        MembershipDetail__c=m.id,
                        Old_MemberNo__c=oldMemNo
                    ));   
                
            } else {
                
                string MemberNo; // = m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCode__c + theMember.name + '0';
                
                if ( theMember.Old_MemberNo__c == null)
                    MemberNo = m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCode__c + theMember.name + '0';
                else
                    MemberNo = m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCode__c + theMember.Old_MemberNo__c + '0';
                
                m.MemberNo__c = MemberNo; 
                m.Member__c = theMember.Id;
                
                string FamilyMemberNo; // =  m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCode__c +  theMember.name ;
                if ( theMember.Old_MemberNo__c == null)
                    FamilyMemberNo =  m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCode__c +  theMember.name ;
                else
                    FamilyMemberNo =  m.Service__r.CardPrefix__c + m.WorkingCompany__r.CountryCode__c +  theMember.Old_MemberNo__c ;
                
                for ( wb_MembershipDetail__c f:IndNoMbrnoFml){
                    if ( f.ParentDetail__c ==m.id ){
                        f.MemberNo__c = FamilyMemberNo + f.Individual__r.FamilyNo__c;
                    }                
                }
            }
        }
        
        List<wb_member__c> NewCardHolderMemberList = new List<wb_member__c>();
        
        for (MDParentChild cdhdr:CardHolder) {
            integer CardHolderQty = cdhdr.GetCardHolderNoMemberNoQaulity();
            for ( integer i=0; i < CardHolderQty; i++ ){
                
                NewCardHolderMemberList.add(new wb_member__c(
                    Individual__c   =  null,
                    WorkingCompany__c = cdhdr.Parent.WorkingCompany__c,
                    MembershipDetail__c=cdhdr.Parent.id 
                    // EndDate__c = m.MembershipEndDate__c
                ));
            }
        }
        
        
        if ( ( NewMemberList.size()>0) || NewCardHolderMemberList.size()>0) {
            
            SavePoint sp = Database.setSavepoint();
            try
            {
                if ( NewMemberList.size()>0) {
                    insert NewMemberList;
                    List<Id> NMID = new List<ID>();
                    for ( wb_member__c m:NewMemberList){
                        NMID.add(m.id);
                    }
                    
                    NewMemberList = [select id, Name, Individual__c, WorkingCompany__c, EndDate__c, MembershipDetail__c, Old_MemberNo__c
                                     from wb_member__c where id=:NMID ];
                    
                    for (wb_member__c nm : NewMemberList) {
                        for ( integer i = 0; i < IndNoMbrno.size(); i++ ){
                            if (IndNoMbrno[i].Individual__c == nm.Individual__c  ){
                                string MemberNo; // = IndNoMbrno[i].Service__r.CardPrefix__c + IndNoMbrno[i].WorkingCompany__r.CountryCode__c + nm.name + '0';
                                if (nm.Old_MemberNo__c == null)
                                    MemberNo = IndNoMbrno[i].Service__r.CardPrefix__c + IndNoMbrno[i].WorkingCompany__r.CountryCode__c + nm.name + '0';
                                else
                                    MemberNo = IndNoMbrno[i].Service__r.CardPrefix__c + IndNoMbrno[i].WorkingCompany__r.CountryCode__c + nm.Old_MemberNo__c + '0';
                                IndNoMbrno[i].MemberNo__c = MemberNo; 
                                IndNoMbrno[i].Member__c = nm.Id;
                                
                                string FamilyMemberNo;// =  IndNoMbrno[i].Service__r.CardPrefix__c + IndNoMbrno[i].WorkingCompany__r.CountryCode__c +  nm.name ;
                                if (nm.Old_MemberNo__c == null)
                                    FamilyMemberNo =  IndNoMbrno[i].Service__r.CardPrefix__c + IndNoMbrno[i].WorkingCompany__r.CountryCode__c +  nm.name ;
                                else
                                    FamilyMemberNo =  IndNoMbrno[i].Service__r.CardPrefix__c + IndNoMbrno[i].WorkingCompany__r.CountryCode__c +  nm.Old_MemberNo__c ;
                                
                                for ( wb_MembershipDetail__c f:IndNoMbrnoFml){
                                    if ( f.ParentDetail__c ==IndNoMbrno[i].id ){
                                        f.MemberNo__c = FamilyMemberNo + f.Individual__r.FamilyNo__c;
                                    }                
                                }
                                i = IndNoMbrno.size();
                            }
                        }
                    }
                    
                    if (IndNoMbrno.size()> 0)  
                        update IndNoMbrno;
                    if (IndNoMbrnoFml.size()> 0) {
                        system.debug(IndNoMbrnoFml);
                        update IndNoMbrnoFml;
                    }
                }
                
                if (NewCardHolderMemberList.size()>0){
                    insert NewCardHolderMemberList;
                    
                    List<Id> NMID = new List<ID>();
                    for ( wb_member__c m:NewCardHolderMemberList){
                        NMID.add(m.id);
                    }
                    
                    NewCardHolderMemberList = [select id, Name, Individual__c, WorkingCompany__c, EndDate__c, MembershipDetail__c, Old_MemberNo__c
                                               from wb_member__c where id=:NMID ];
                    // List<wb_MembershipDetail__c> NewMDCardHolders = new List<wb_MembershipDetail__c>();
                    
                    for (wb_member__c nm : NewCardHolderMemberList) {
                        for ( integer i = 0; i < CardHolder.size(); i++ ){
                            
                            if (CardHolder[i].Parent.Id == nm.MembershipDetail__c  ){
                                
                                string MemberNo = CardHolder[i].Parent.Service__r.CardPrefix__c + 
                                    CardHolder[i].Parent.WorkingCompany__r.CountryCode__c + nm.name + '0';
                                integer subno =  CardHolder[i].GetNoofChild() + 1;
                                wb_MembershipDetail__c NCH = new wb_MembershipDetail__c(Name= CardHolder[i].Parent.Name +'-' + subno , 
                                                                                        WorkingCompany__c = CardHolder[i].Parent.WorkingCompany__c,
                                                                                        Type__c = CardHolder[i].Parent.Type__c,
                                                                                        Member__c = nm.Id,
                                                                                        MemberNo__c = MemberNo,
                                                                                        Membership__c = CardHolder[i].Parent.Membership__c,
                                                                                        Service__c = CardHolder[i].Parent.Service__c,
                                                                                        MembershipPlan__c = CardHolder[i].Parent.MembershipPlan__c,
                                                                                        Quantity__c = 1,
                                                                                        MembershipStartDate__c = CardHolder[i].Parent.MembershipStartDate__c,
                                                                                        MembershipEndDate__c = CardHolder[i].Parent.MembershipEndDate__c,
                                                                                        ParentDetail__c = CardHolder[i].Parent.id
                                                                                       );
                                insert NCH;
                                nm.MembershipDetail__c = NCH.Id;
                                // NewMDCardHolders.add(  NCH );
                                wb_MembershipDetail__c c = new wb_MembershipDetail__c();
                                c = NCH.clone(false);
                                CardHolder[i].Child.add(c);
                                i = CardHolder.size();
                            }
                        }
                    }
                    
                    update NewCardHolderMemberList;
                    
                }
                return true;
            }
            catch(Exception e)
            {
                Database.rollBack(sp);
                //PopupMessage = e.getMessage();
                return false;
            }
        } 
        else 
            return true;
    }
    public void GenerateMemeberNoforBeingAmendingRow(){
        SaveBeingAmendingRow();
        GenerateMemeberNo_Start(theBeingAmendedMembershipDetail);
    }
    
    public PageReference Confirm(){
        
        HavingError = null;
        AlertMessage = null;
        getContractHeader(Membership.id);
        //   system.debug(Membership.Status__c +':' + HavingError);
        
        if ( Membership.Status__c=='未確定') { 
            getContractDetail();
            // boolean GenerateMemeberNoStatus = GenerateMemeberNo_Start();
            boolean GenerateMemeberNoStatus =  GenerateMemeberNo_Start(theMembershipDetail);
            system.debug('GenerateMemeberNoStatus:' + GenerateMemeberNoStatus);
            if ( GenerateMemeberNoStatus == false){
                HavingError = true;
                AlertMessage='確定が失敗しました。';
                return null;
            }
            wb_MembershipBilling BillingMgr = new wb_MembershipBilling();
            if ( BillingMgr.CheckReadiness(Membership.id) == true ){
                
                // if ( BillingMgr.ConfirmAndBilling(Membership.id) == true){
                if ( BillingMgr.ConfirmAndBillingRow(Membership.id) == true){ 
                    
                    HavingError = false;
                    // getContractHeader(Membership.id);
                    system.debug(Membership);
                    String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
                    return new PageReference(sfdcBaseURL+'/apex/wb_Membership_View?Id=' + Membership.Id);
                }
                else{
                    HavingError = true;
                    AlertMessage='確定が失敗しました。';
                    return null;
                }
                
            }
            else {
                HavingError = true;
                AlertMessage='無効です。確認対象は仮名データがあります。';
                return null;
            }
            
            
        } else
        {
            HavingError = true;
            AlertMessage='無効です。確認対象は未確定のみです。';
            return null;
            
        }
        
    }    
    
    
    public void CancelRefund(){
        HavingError = true;
        getContractHeader(Membership.id);
        system.debug('status:' + Membership.Status__c);
        if ( Membership.Status__c=='確定') { 
            wb_MembershipBilling BillingMgr = new wb_MembershipBilling();
            
            if ( BillingMgr.CheckCancelReadiness(Membership.id) == true ){
                
                if ( BillingMgr.CancelAndRefund(Membership.id) == true){
                    getContractHeader(Membership.id);
                    getContractDetail();
                    HavingError = false;
                    //  system.debug(Membership.Status__c +':' + HavingError);
                    return;
                }
                else{
                    HavingError = true;
                    AlertMessage='確定が失敗しました。';
                    return;
                }
                
            } else {
                system.debug('e2');
                HavingError = true;
                AlertMessage='無効です。キャンセル対象は確定のみです。';
                return;
            }
            
        } else {
            system.debug('e1');
            HavingError = true;
            AlertMessage='無効です。キャンセル対象は確定のみです。';
            return;
        }
        
    }
    
    public PageReference MedicalInsurance(){
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        return new PageReference(sfdcBaseURL +'/apex/wb_MemberContract2MedicalInsurance?ContractID='+ Membership.id );
    }
    
    public PageReference Cancel(){
        
        if (Membership.id != null) {
            
            String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
            return new PageReference(sfdcBaseURL+'/' +  Membership.id);
        }
        else {
            String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
            return new PageReference(sfdcBaseURL+MyHome);
            // return new PageReference(sfdcBaseURL+'/a0f/o');
            
        }
        
    }
    
    public PageReference Home(){
        
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        return new PageReference(sfdcBaseURL+MyHome);
        
    }
    
    public void ValidateHeader()
    {
        
        system.debug(Membership.ContractCountry__c );
        
        if ( Membership.ContractCountry__c ==null ) 
            Membership.ContractCountry__c.addError('必須な項目'); 
        if ( Membership.ContractDistrict__c == null ) 
            Membership.ContractDistrict__c.addError('必須な項目'); 
        
        if ( Membership.BillingDistrict__c == null ) 
            Membership.BillingDistrict__c.addError('必須な項目');  
        if ( Membership.ApplicationDate__c == null ) 
            Membership.ApplicationDate__c.addError('必須な項目');  
        if ( Membership.Currency__c == null ) 
            Membership.Currency__c.addError('必須な項目');  
        
   //     if ( Membership.DiscountPercentage__c == null ) 
   //         Membership.DiscountPercentage__c.addError('必須な項目');  
        if ( Membership.BillingCompany__c == null ) 
            Membership.BillingCompany__c.addError('必須な項目');  
        
    }
    
    
    public boolean IsMembershipfeeEnough {get;set;}
    public string MembershipfeeMessage {get;set;}
    
    public void ValidateMembershipFee(){
        
        integer   MembershipQty = 0;
        integer   MemberQty = 0;
        
        
        for ( wb_MembershipDetailRow r:theMembershipDetail){
            if  (r.theRow.Type__c=='入会金'){
                if(r.theRow.Quantity__c!=null) MembershipQty += integer.valueof(r.theRow.Quantity__c);
                if (r.theChildRow != null){
                    for ( wb_MembershipDetail__c c:r.theChildRow){
                        if(c.Quantity__c!=null && c.SecondType__c == 'IN') MembershipQty += integer.valueof(c.Quantity__c);
                    }
                }
                if (r.theInChildRow != null){
                    for ( wb_MembershipDetail__c c:r.theInChildRow){
                        if(c.Quantity__c!=null) MembershipQty += integer.valueof(c.Quantity__c);
                    }
                }
            } else if ( r.theRow.Type__c != null && r.theRow.ParentDetail__c ==null 
                       && ( r.theRow.Classification__c == '新規' || r.theRow.Classification__c == '追加'))
                MemberQty += integer.valueof(r.theRow.Quantity__c);
        } 
        
        system.debug( MemberQty + ',' + MembershipQty);
        if (MemberQty > MembershipQty) {
            IsMembershipfeeEnough = false;
            MembershipfeeMessage = '入会金不足';
        }
        else {
            IsMembershipfeeEnough = true;
            MembershipfeeMessage = null;
        }
        
        return; 
    }
    
    public PageReference ValidateSaveAndClose(){
        ValidateAndUpdate();
        if ( ErrAlert == false)
            return Cancel();
        else
            return null;
    }
    
    
    public PageReference ValidateAndUpdate(){
        system.debug(ApexPages.hasMessages(ApexPages.Severity.Error));
        ValidateHeader();
        system.debug(ApexPages.hasMessages(ApexPages.Severity.Error));
        integer   MemberFeeQty = 0;
        integer   MemberQty = 0;
        integer LastSeq = 0;
        
        
        for ( wb_MembershipDetail__c d:MembershipDetailsParent){   
            // Error Checking     
            if ( d.id != null && d.ParentDetail__c ==null && d.Type__c !='入会金') {
                if ( d.MembershipStartDate__c ==null ) 
                    d.MembershipStartDate__c.addError('必須な項目' + d.name); 
                if ( d.MembershipEndDate__c ==null  ) 
                    d.MembershipEndDate__c.addError('必須な項目' + d.name); 
            }
            
            if  (d.Type__c=='入会金' && d.Quantity__c!=null ){
                if ( d.SecondType__c == null   ){
                    
                    if ( d.Quantity__c!=null )
                        MemberFeeQty = MemberFeeQty + integer.valueof(d.Quantity__c);
                }
                if (d.SecondType__c == 'IN' && d.Quantity__c!=null  )
                    MemberFeeQty = MemberFeeQty + integer.valueof(d.Quantity__c); 
                
                
            } else if ( d.Type__c != null && d.ParentDetail__c ==null && d.Quantity__c != null
                       && ( d.Classification__c == '新規' || d.Classification__c == '追加'))
                MemberQty += integer.valueof(d.Quantity__c);
            
            
            // Get the final Numbers
            
            if ( d.ParentDetail__c == null && d.id != null){
                string name = d.Name;
                string Seq = name.right(name.length() - name.indexOf('-') - 1);
                if ( integer.valueOf(Seq) > LastSeq)
                    LastSeq = integer.valueOf(Seq);
            } 
        } 
        
        if (MemberFeeChild != null){
            for ( wb_MembershipDetail__c d:MemberFeeChild){
                if  (d.Type__c=='入会金' && d.Quantity__c!=null ){
                    if ( d.SecondType__c == null   ){
                        
                        if ( d.Quantity__c!=null )
                            MemberFeeQty = MemberFeeQty + integer.valueof(d.Quantity__c);
                    }
                    if (d.SecondType__c == 'IN' && d.Quantity__c!=null  )
                        MemberFeeQty = MemberFeeQty + integer.valueof(d.Quantity__c); 
                    
                }
            }
        }
        
        if (MemberFeeChildIn != null){
            for ( wb_MembershipDetail__c d:MemberFeeChildIn){
                if  (d.Type__c=='入会金' && d.Quantity__c!=null ){
                    if ( d.SecondType__c == null   ){
                        
                        if ( d.Quantity__c!=null )
                            MemberFeeQty = MemberFeeQty + integer.valueof(d.Quantity__c);
                    }
                    if (d.SecondType__c == 'IN' && d.Quantity__c!=null  )
                        MemberFeeQty = MemberFeeQty + integer.valueof(d.Quantity__c); 
                    
                }
            }
        }
        
        system.debug( MemberQty + ',' + MemberFeeQty);
        if (MemberQty > MemberFeeQty) {
            IsMembershipfeeEnough = false;
            MembershipfeeMessage = '入会金不足';
        }
        else {
            IsMembershipfeeEnough = true;
            MembershipfeeMessage = null;
        }
        
        system.debug(LastSeq +',' + ApexPages.hasMessages(ApexPages.Severity.Error) +',' + MembershipfeeMessage);
        
        
        if(ApexPages.hasMessages(ApexPages.Severity.Error) || MembershipfeeMessage != null){
            ErrAlert = true;
            return null;
        } else ErrAlert = false;
        
        try {
            if ( Membership.id == null){
                insert Membership;
                Membership = getContractHeader(Membership.id);
                for ( wb_MembershipDetail__c d:MembershipDetailsParent)
                    d.Membership__c = Membership.id;
                for ( wb_MembershipDetail__c c:MembershipDetailsChild)
                    c.Membership__c = Membership.id;
            } else
                update Membership;
            
            // To Update the IN and OUT for 入会金
            if (MemberFeeChildIn != null){           
                insert MemberFeeChildIn;
                for ( integer i = 0; i < MemberFeeChildIn.size(); i ++){
                    MemberFeeChildOut[i].CrossReference__c = MemberFeeChildIn[i].id;
                }
                if (MemberFeeChildOut != null) 
                    insert MemberFeeChildOut;
                for ( integer i = 0; i < MemberFeeChildIn.size(); i ++){
                    MemberFeeChildIn[i].CrossReference__c = MemberFeeChildOut[i].id;
                }
                update MemberFeeChildIn;
            }
            
            system.debug(MembershipDetailsParent);
            
            if (MembershipDetailsParent != null) {
                
                List<ChildIndex> Parent_CIndx = new List<ChildIndex>();
                Parent_CIndx = bulidChildIndex(MembershipDetailsParent,MembershipDetailsChild);
                // system.debug(MembershipDetailsParent);
                // system.debug(MembershipDetailsChild);
                // system.debug(Parent_CIndx);
                
                List<wb_MembershipDetail__c>  MembershipDetailsNoEmpty =  new List<wb_MembershipDetail__c>();
                List<wb_MembershipDetail__c>  MembershipDetailsChildNoEmpty =  new List<wb_MembershipDetail__c>();
                
                for ( integer i = 0; i < MembershipDetailsParent.size(); i ++){
                    if ( MembershipDetailsParent[i].Service__c != null) {  
                        if (MembershipDetailsParent[i].id  == null && MembershipDetailsParent[i].ParentDetail__c == null)
                        {
                            integer[] cidx;
                            cidx = SearchIndex( MembershipDetailsParent[i].Name,Parent_CIndx); 
                            // Assign the Number for Having Information
                            LastSeq ++;
                            MembershipDetailsParent[i].Name = Membership.name + '-' + LastSeq;
                            if (cidx != null){
                                if (cidx[0] != null && cidx[1] != null ){
                                    for ( integer ci = cidx[0]; ci <= cidx[1]; ci ++){
                                        //integer cseq = ci - cidx[0] + 1;
                                        MembershipDetailsChild[ci].name = MembershipDetailsParent[i].Name; // + '-' + cseq;
                                        MembershipDetailsChildNoEmpty.add(MembershipDetailsChild[ci]);
                                    }
                                }
                            }
                        }
                        MembershipDetailsNoEmpty.add(MembershipDetailsParent[i]); 
                    } 
                }
                
                
                upsert MembershipDetailsNoEmpty;
                upsert MembershipDetailsChildNoEmpty;
                // system.debug(MembershipDetailsNoEmpty);
                //system.debug(MembershipDetailsChildNoEmpty);
                
                List<ChildIndex> NoEmptyParent_CIndx = new List<ChildIndex>();
                NoEmptyParent_CIndx = bulidChildIndex(MembershipDetailsNoEmpty,MembershipDetailsChildNoEmpty);
                system.debug(NoEmptyParent_CIndx);
                for ( integer i = 0; i < NoEmptyParent_CIndx.size(); i ++){
                    if (NoEmptyParent_CIndx[i].firstChildIndx != null && NoEmptyParent_CIndx[i].lastChildIndx != null){
                        for( integer j = NoEmptyParent_CIndx[i].firstChildIndx; j <= NoEmptyParent_CIndx[i].lastChildIndx; j++){
                            integer cseq = j - NoEmptyParent_CIndx[i].firstChildIndx + 1;
                            MembershipDetailsChildNoEmpty[j].name = MembershipDetailsNoEmpty[NoEmptyParent_CIndx[i].Idx].name + '-' + cseq;
                            MembershipDetailsChildNoEmpty[j].ParentDetail__c=MembershipDetailsNoEmpty[NoEmptyParent_CIndx[i].Idx].Id;
                        }
                    }
                }
                upsert MembershipDetailsChildNoEmpty;
                
                //system.debug(Membership);
                system.debug(MembershipDetailsNoEmpty);
                system.debug(MembershipDetailsChildNoEmpty);
                
                
            }
            
            
            // upsert MembershipDetailsChild;
            
        } catch(exception e) {
            ErrAlert = true;
            return null;
        }
        
        
        return null;
    } 
    
    public void BatchSave(){
        
        try {
            
            if ( Membership.id == null){
                insert Membership;
                Membership = [select id, Name from wb_Membership__c where Id =:Membership.id];
                for ( wb_MembershipDetail__c d:MembershipDetailsParent)
                    d.Membership__c = Membership.id;
            } else
                update Membership;
            
            
            if (MembershipDetailsParent != null) {
                // Get the final Numbers
                integer LastSeq = 0;
                
                
                for ( integer i = MembershipDetailsParent.size() - 1 ; i >= 0 ; i--){
                    if ( theMembershipDetail[i].theRow.id  == null && theMembershipDetail[i].theRow.Service__c == null) {  
                        theMembershipDetail.remove(i); 
                    } 
                }
                for ( integer i = MembershipDetailsParent.size() - 1 ; i >= 0 ; i--){
                    if ( MembershipDetailsParent[i].id  == null && MembershipDetailsParent[i].Service__c == null) {  
                        MembershipDetailsParent.remove(i); 
                    } 
                }
                
                system.debug( MembershipDetailsParent.size() + ':' + theMembershipDetail.size());
                // Assign the Number for Having Information
                for (wb_MembershipDetailRow r:theMembershipDetail){
                    if (r.theRow.id  == null && r.theRow.ParentDetail__c == null)
                    {
                        LastSeq ++;
                        r.theRow.Name = Membership.name + '-' + LastSeq;
                        // system.debug('Name:' + r.theRow.Name);
                    }
                }
                
                upsert MembershipDetailsParent;
                // To Update the IN and OUT for 入会金
                for ( wb_MembershipDetailRow r:theMembershipDetail){
                    if ( r.theRow.Type__c =='入会金'){
                        
                        if (r.theInChildRow != null){
                            system.debug( r.theRow.name + ':' + r.theInChildRow.size() + ':' + r.theOutChildRow.size() );
                            integer cnt = 1;
                            if ( r.theChildRow != null)
                                cnt= r.theChildRow.size() + 1;
                            
                            for ( wb_MembershipDetail__c i:r.theInChildRow){
                                i.name =  r.theRow.Name + '-' + cnt;
                                i.Membership__c = Membership.id;
                                i.ParentDetail__c = r.theRow.id;
                                cnt++;
                            }
                            insert r.theInChildRow;
                            for ( integer i = 0; i < r.theInChildRow.size(); i ++){
                                r.theOutChildRow[i].CrossReference__c = r.theInChildRow[i].id;
                            }
                            insert  r.theOutChildRow;
                            for ( integer i = 0; i < r.theInChildRow.size(); i ++){
                                r.theInChildRow[i].CrossReference__c = r.theOutChildRow[i].id;
                            }
                            update r.theInChildRow;
                            
                        } 
                    }
                }
                
                
                
                system.debug( MembershipDetailsParent.size());
                // Update the Child Records from the Parent
                for ( wb_MembershipDetail__c d:MembershipDetailsParent){    
                    if (d.ParentDetail__c != null){
                        for ( wb_MembershipDetail__c p:MembershipDetailsParent) {
                            if ( d.ParentDetail__c == p.id) { // Update the Family Members 
                                d.MembershipStartDate__c = p.MembershipStartDate__c;
                                d.MembershipEndDate__c = p.MembershipEndDate__c;
                                d.Service__c = p.Service__c;
                                d.MembershipPlan__c = p.MembershipPlan__c;
                            }
                        }
                    }
                }
                
                system.debug( MembershipDetailsParent.size());
                
                upsert MembershipDetailsParent;
                
            }  
            
        } catch(exception e) {
            return;
        }
        
        
    } 
    
    public void AmendRowNumbering(){
        
        wb_MembershipDetail__c LastNo = [select f_NameforOrdering__c 
                                         FROM wb_MembershipDetail__c where Membership__c =:Membership.id 
                                         and f_NameforOrdering__c != null
                                         order by f_NameforOrdering__c desc limit 1];
        integer theLastNo = integer.valueof(LastNo.f_NameforOrdering__c);
        
        for ( wb_MembershipDetailRow r:theBeingAmendedMembershipDetail){
            system.debug( r.theRow.id +':' + r.theRow.Membership__c +':' + r.theRow.MemberName__c
                         +':' + r.theRow.MembershipPlan__c +':' +  r.theRow.Type__c + ':' + r.theRow.MemberNo__c + ':' + r.theRow.WorkingCompany__r.CountryCode__c);
            if (r.theRowAttribute == 'A' && r.theRow.name == 'A') {
                theLastNo ++;
                r.theRow.name = Membership.name + '-' + 'A' + theLastNo;
                upsert r.theRow;
                system.debug( r.theRow.id);
            }
            
            
        }
        
    }
    public void SaveBeingAmendingRow(){
        // Add Child Records for Family Members
        
        BeingAmendedMembershipDetailsParent_CIndx = bulidChildIndex(BeingAmendedMembershipDetailsParent,BeingAmendedMembershipDetailsChild);
        
        upsert BeingAmendedMembershipDetailsParent;
        for ( integer p = 0; p < BeingAmendedMembershipDetailsParent.size(); p++){
            
            if ( BeingAmendedMembershipDetailsParent_CIndx[p].firstChildIndx != null && 
                BeingAmendedMembershipDetailsParent[p].PendingAction__c =='確認' && BeingAmendedMembershipDetailsParent[p].type__c == '家族' ){
                    integer seq = 0;
                    for ( integer c = BeingAmendedMembershipDetailsParent_CIndx[p].firstChildIndx; 
                         c <= BeingAmendedMembershipDetailsParent_CIndx[p].lastChildIndx; c++){
                             seq = seq + 1;
                             BeingAmendedMembershipDetailsChild[c].name = BeingAmendedMembershipDetailsChild[c].name + '-' + seq;
                             BeingAmendedMembershipDetailsChild[c].ParentDetail__c = BeingAmendedMembershipDetailsParent[p].id;
                         }
                    
                }
            
        }
        
        upsert BeingAmendedMembershipDetailsChild;
        
        
    }
    
    public PageReference SaveAmendasDraft(){
        
        AmendRowNumbering();
        SaveBeingAmendingRow();
        
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        return new PageReference(sfdcBaseURL +'/apex/wb_Membership_Amend?Id='+ Membership.id );
    }
    
    public string PendingAmendRowId{get;set;}
    public string PendingAmendRowIdx{get;set;}
    public wb_MembershipDetailRow PreviousRow{get;set;}
    public wb_MembershipDetailRow PendingRow{get;set;}
    
    public void locatethePendingRowPair(){
        // system.debug('locatethePendingRowPair:' + PendingAmendRowId + ',' + PendingAmendRowIdx );
        PreviousRow = null;
        PendingRow = null;
        
        if ( PendingAmendRowId != null ) {
            if (PendingAmendRowId.length()==0)
                PendingAmendRowId = null;
        }
        
        if ( PendingAmendRowId != null ){
            
            for ( integer i = 0; i < theBeingAmendedMembershipDetail.size() ; i ++){
                if (theBeingAmendedMembershipDetail[i].theRow.id == PendingAmendRowId) {
                    system.debug(theBeingAmendedMembershipDetail[i].theRow.Classification__c + ',' + theBeingAmendedMembershipDetail[i].theRow.PendingAction__c);
                    if (theBeingAmendedMembershipDetail[i].theRow.Classification__c =='交替' 
                        && theBeingAmendedMembershipDetail[i].theRow.PendingAction__c =='確認') 
                    {
                        // 入替
                        PendingRow = theBeingAmendedMembershipDetail[i];
                        for ( integer j = 0; j < theBeingAmendedMembershipDetail.size() ; j ++){
                            if (theBeingAmendedMembershipDetail[j].theRow.id == PendingRow.theRow.PreviousRecord__c) {
                                PreviousRow = theBeingAmendedMembershipDetail[j];
                                j = theBeingAmendedMembershipDetail.size();
                            }
                        }
                    }  else if ( theBeingAmendedMembershipDetail[i].theRow.PendingAction__c =='交替' || 
                                theBeingAmendedMembershipDetail[i].theRow.PendingAction__c =='変更' )
                    {
                        // 交替
                        PreviousRow = theBeingAmendedMembershipDetail[i];
                        for ( integer j = 0; j < theBeingAmendedMembershipDetail.size() ; j ++){
                            if (theBeingAmendedMembershipDetail[j].theRow.PreviousRecord__c == PreviousRow.theRow.id) {
                                PendingRow = theBeingAmendedMembershipDetail[j];
                                j = theBeingAmendedMembershipDetail.size();
                            }
                        }
                        
                    }  else if (theBeingAmendedMembershipDetail[i].theRow.Classification__c =='追加' &&
                                theBeingAmendedMembershipDetail[i].theRow.PendingAction__c =='確認')
                    {
                        // 追加
                        PendingRow = theBeingAmendedMembershipDetail[i];
                    } else if (theBeingAmendedMembershipDetail[i].theRow.PendingAction__c =='解約') {
                        PendingRow = theBeingAmendedMembershipDetail[i];
                    } else if (theBeingAmendedMembershipDetail[i].theRow.Classification__c =='変更' 
                               && theBeingAmendedMembershipDetail[i].theRow.PendingAction__c =='確認')
                    { //変更
                        PendingRow = theBeingAmendedMembershipDetail[i];
                        for ( integer j = 0; j < theBeingAmendedMembershipDetail.size() ; j ++){
                            if (theBeingAmendedMembershipDetail[j].theRow.id == PendingRow.theRow.PreviousRecord__c) {
                                PreviousRow = theBeingAmendedMembershipDetail[j];
                                j = theBeingAmendedMembershipDetail.size();
                            }
                        }
                    }
                    
                    i = theBeingAmendedMembershipDetail.size();
                } 
            }
            
            
        }
        else if (theBeingAmendedMembershipDetail[integer.valueof(PendingAmendRowIdx)].theRow.id == null 
                 && (  theBeingAmendedMembershipDetail[integer.valueof(PendingAmendRowIdx)].theRow.Classification__c =='交替'  ||
                     ( theBeingAmendedMembershipDetail[integer.valueof(PendingAmendRowIdx)].theRow.Classification__c =='変更' &&
                      theBeingAmendedMembershipDetail[integer.valueof(PendingAmendRowIdx)].theRow.PreviousRecord__c != null ) )
                 && theBeingAmendedMembershipDetail[integer.valueof(PendingAmendRowIdx)].theRow.PendingAction__c =='確認'
                ) 
        { // 入替 (look up by index )
            PendingRow = theBeingAmendedMembershipDetail[integer.valueof(PendingAmendRowIdx)];
            if (PendingRow.theRow.PreviousRecord__c != null ) {
                for ( integer j = 0; j < theBeingAmendedMembershipDetail.size() ; j ++){
                    if (theBeingAmendedMembershipDetail[j].theRow.id == PendingRow.theRow.PreviousRecord__c) {
                        PreviousRow = theBeingAmendedMembershipDetail[j];
                        j = theBeingAmendedMembershipDetail.size();
                    }
                }
            }
        } 
        else if (theBeingAmendedMembershipDetail[integer.valueof(PendingAmendRowIdx)].theRow.Classification__c =='追加' &&
                 theBeingAmendedMembershipDetail[integer.valueof(PendingAmendRowIdx)].theRow.PendingAction__c =='確認') {
                     // '追加'
                     PendingRow = theBeingAmendedMembershipDetail[integer.valueof(PendingAmendRowIdx)];
                 }
        //  system.debug('thePreviousRow:' + PreviousRow);
        //  system.debug('thePendingRow:' + PendingRow);
        
    }
    public void DeletePendingAmendRow_deleteRowAndChild(Id theRowID){
        wb_MembershipDetail__c thePendingRow = [select id, PendingAction__c, PreviousRecord__c 
                                                from wb_MembershipDetail__c
                                                where id =:theRowID and PendingAction__c != null];
        List <wb_MembershipDetail__c> thePendingChildRows = [ select id from wb_MembershipDetail__c
                                                             where ParentDetail__c =:theRowID];
        
        if (thePendingChildRows != null )
            delete thePendingChildRows;
        if (thePendingRow != null)
            delete thePendingRow;
    }
    public void DeletePendingAmendRow(){
        
        DeletePendingAmendRow_a();
        getContractDetail(); 
    }
    
    public void DeletePendingAmendRow_a(){
        system.debug('DeletePendingAmendRow:' + PendingAmendRowId + ',' + PendingAmendRowIdx );
        locatethePendingRowPair();
        if (PendingRow != null && PreviousRow != null ){
            if (PendingRow.theRow.Classification__c =='交替'||PendingRow.theRow.Classification__c =='変更'){
                if (PendingRow.theRow.Id != null){
                    
                    DeletePendingAmendRow_deleteRowAndChild(PendingRow.theRow.Id);
                    
                } 
                
                PreviousRow.theRow.MembershipStopDate__c = null;
                PreviousRow.theRow.BalanceAmount__c  = null;
                PreviousRow.theRow.PendingAction__c = null;
                update PreviousRow.theRow;
                // getContractDetail();
            }
        } if (PendingRow != null && PreviousRow == null){
            if (PendingRow.theRow.PendingAction__c == '解約') {
                PendingRow.theRow.MembershipStopDate__c = null;
                PendingRow.theRow.BalanceAmount__c = null;
                PendingRow.theRow.PendingAction__c = null;
                update PendingRow.theRow;
                // getContractDetail();
            } else if (PendingRow.theRow.Classification__c =='追加') {
                if (PendingRow.theRow.Id != null){
                    
                    DeletePendingAmendRow_deleteRowAndChild(PendingRow.theRow.Id);
                    //   getContractDetail();
                } else {
                    system.debug(PendingAmendRowIdx + ',' + BeingAmendMembershipDetails.size());
                    BeingAmendMembershipDetails.remove(theBeingAmendedMembershipDetail[integer.valueof(PendingAmendRowIdx)].theRowIndex);
                    theBeingAmendedMembershipDetail.remove(integer.valueof(PendingAmendRowIdx));
                }
            }
        }
        
    }
    
    public void DeleteSelectedPendingAmendRow(){
        for (integer i = theBeingAmendedMembershipDetail.size() - 1 ; i >= 0; i --){
            //  if ((r.theRow.PendingAction__c=='確認' ||r.theRow.PendingAction__c=='解約') && r.IsSelected == true ){
            if ((theBeingAmendedMembershipDetail[i].theRow.PendingAction__c=='確認'||
                 theBeingAmendedMembershipDetail[i].theRow.PendingAction__c=='解約') && 
                theBeingAmendedMembershipDetail[i].IsSelected == true) {
                    PendingAmendRowId = theBeingAmendedMembershipDetail[i].theRow.Id;
                    PendingAmendRowIdx = string.valueof(i) ;
                    DeletePendingAmendRow_a();
                }     
            
        }
        
        getContractDetail();
    }
    public string PendingReplaceeStopDate {get;set;}
    public void RefreshPendingReplacerStartDate(){
        system.debug('RefreshReplacerStartDate:' + PendingAmendRowId + ',' + PendingAmendRowIdx +',' + PendingReplaceeStopDate);
        locatethePendingRowPair();
        if (PreviousRow !=null && PendingRow != null){
            system.debug('PendingAction__c:' + PreviousRow.theRow.PendingAction__c +':' +  PreviousRow.theRow.MembershipStopDate__c );
            if ((PreviousRow.theRow.PendingAction__c =='交替'||
                 PreviousRow.theRow.PendingAction__c =='変更') && PreviousRow.theRow.MembershipStopDate__c != null)
            {
                if (PreviousRow.theRow.MembershipStopDate__c < PreviousRow.theRow.MembershipStartDate__c)  PreviousRow.theRow.MembershipStopDate__c = PreviousRow.theRow.MembershipStartDate__c;
                if (PreviousRow.theRow.MembershipStopDate__c > PreviousRow.theRow.MembershipEndDate__c)  PreviousRow.theRow.MembershipStopDate__c = PreviousRow.theRow.MembershipEndDate__c;
                
                PreviousRow.Calculatenoofmonth(PreviousRow.theRow.MembershipStartDate__c,PreviousRow.theRow.MembershipStopDate__c,null,PreviousRow.theRow.MembershipEndDate__c );
                PreviousRow.fetchMonthlyfee();
                PreviousRow.CalculateRemainingFee();
                
                date sd = PreviousRow.theRow.MembershipStopDate__c;
                if ( PendingRow.theRow.MembershipStartDate__c == null)
                    PendingRow.theRow.MembershipStartDate__c = sd.addDays(1);
                else {
                    if (PreviousRow.theRow.BalanceAmount__c!= null && PendingRow.theRow.Amount__c != null)
                        PendingRow.theRow.BillingAmount__c = PreviousRow.theRow.BalanceAmount__c + PendingRow.theRow.Amount__c;
                    else
                        PendingRow.theRow.BillingAmount__c = null;
                }
                
                
                if (PendingRow.theRow.Classification__c =='交替') {
                    system.debug(PreviousRow.theRow.MembershipStartDate__c + ';' + PreviousRow.theRow.MembershipStopDate__c +';'+ PendingRow.theRow.MembershipStartDate__c + ';'+  PreviousRow.theRow.MembershipEndDate__c);
                    PendingRow.Calculatenoofmonth(PreviousRow.theRow.MembershipStartDate__c,PreviousRow.theRow.MembershipStopDate__c,PendingRow.theRow.MembershipStartDate__c,PreviousRow.theRow.MembershipEndDate__c );
                    PendingRow.fetchServiceFee();
                    CalculatePendingAmendRowBalanceAmount(PreviousRow,PendingRow);
                    system.debug(PendingRow.noofmonth);
                }
                
                if (PreviousRow.theRow.PendingAction__c =='変更' ){
                    
                    PendingRow.Calculatenoofmonth(PreviousRow.theRow.MembershipStartDate__c,PreviousRow.theRow.MembershipStopDate__c,PendingRow.theRow.MembershipStartDate__c,PreviousRow.theRow.MembershipEndDate__c ); 
                }
                
                PendingRow.fetchServiceFee();
                if (PreviousRow.theRow.PendingAction__c =='変更' ) {
                    PendingRow.theRow.BillingAmount__c = PreviousRow.theRow.BalanceAmount__c + PendingRow.theRow.Amount__c;
                }
                //  }
            }
            
        } else if (PendingRow != null && PreviousRow == null) {
            if (PendingRow.theRow.PendingAction__c =='解約'){
                PendingRow.Calculatenoofmonth(PendingRow.theRow.MembershipStartDate__c,
                                              PendingRow.theRow.MembershipStopDate__c,
                                              null,
                                              PendingRow.theRow.MembershipEndDate__c
                                             );
                PendingRow.CalculateRemainingFee();
            }
        }
       // system.debug(PendingRow);
        if (PendingRow.theRow.Classification__c =='変更')
            CalculatePendingAmendRowBalanceAmount();
        
    }
    
    
    public void CalculatePendingAmendRowBalanceAmount( wb_MembershipDetailRow PreviousR, wb_MembershipDetailRow PendingR){
        if ( PreviousR != null && PendingR != null ) {
            Date startD = PreviousR.theRow.MembershipStartDate__c;
            Date stopD = PreviousR.theRow.MembershipStopDate__c;
            
            Decimal PreviousAnnualAmount = PreviousR.theRow.UnitAmount__c;
            Date ContinueD = PendingR.theRow.MembershipStartDate__c;
            Date endD = PendingR.theRow.MembershipEndDate__c;
            
            Decimal ThisAnnualAmount = PendingR.theRow.UnitAmount__c;
            Decimal ThisMonthlyAmount = PendingR.theRow.MonthlyUnitAmount__c;
            
            system.debug( startD +',' + stopD +',' + ContinueD +',' + endD +',' + ThisMonthlyAmount);
            if (  PendingR.theRow.Classification__c == '交替') {
                if ( stopD != null &&  startD !=null && ContinueD != null && ThisMonthlyAmount != null ) {
                    
                    system.debug('PendingR.Calculatenoofmonth:' + startD + ',' + stopD +  ',' + ContinueD +  ',' + endD);
                    PendingR.Calculatenoofmonth(startD,stopD,ContinueD,endD);
                    system.debug(PendingR.noofmonth);                 
                    
                    decimal Replacermonth;
                    Replacermonth = PendingR.PeriodReplacerBillingmonth;
                    
                    wb_Service__c Service;
                    
                    if (PendingR.theRow.Service__c != null ) {
                        for ( wb_Service__c s:MDService){
                            if ( s.id == PendingR.theRow.Service__c)
                                Service = s;
                        }
                    }
                    
                    // system.debug('ThisAmount: ' + ThisAnnualAmount + ' * (' + monthDiff +'-' + monthConsumed + ') / ' + monthDiff + '+' + ThisAnnualAmount + '* (' + duplicatedmonth +'/' + monthDiff +')');
                    system.debug(Service);

                    
                    PendingR.theRow.Amount__c = ThisMonthlyAmount * Replacermonth;
                    
                    // PendingR.theRow.Amount__c = ThisMonthlyAmount * (monthDiff - monthConsumed)  + ThisMonthlyAmount * ( duplicatedmonth ) ;
                    
                    PendingR.theRow.BillingAmount__c = PreviousR.theRow.BalanceAmount__c + PendingR.theRow.Amount__c;
                    system.debug('BillingAmount__c:' + PendingR.theRow.BillingAmount__c);
                    if ( PendingR.theRow.BillingAmount__c < 0.0000001 &&  PendingR.theRow.BillingAmount__c > -0.0000001 )
                        PendingR.theRow.BillingAmount__c =0;
                    
                    PendingR.BillingAmountRoundUp();
                } else {
                    // PendingR.theRow.BalanceAmount__c = null;
                }
            } 
            else if ( PendingR.theRow.Classification__c == '変更'){
                if (PreviousR.theRow.BalanceAmount__c != null && PendingR.theRow.Amount__c != null  ) {
                    PendingR.theRow.BillingAmount__c = PreviousR.theRow.BalanceAmount__c + PendingR.theRow.Amount__c;
                    system.debug('PendingR.theRow.BillingAmount__c:' + PendingR.theRow.BillingAmount__c 
                                 +':' + PendingR.theRow.BalanceAmount__c + ' + ' + PendingR.theRow.Amount__c);
                }
            }
        } 
        else if (PreviousR == null && PendingR != null) {
            if (  PendingR.theRow.Classification__c == '交替') {
                PendingR.Calculatenoofmonth(PendingR.theRow.MembershipStartDate__c,null,null,PendingR.theRow.MembershipEndDate__c);
                PendingR.fetchServiceFee();
                PendingR.theRow.BillingAmount__c = PendingR.theRow.Amount__c;
            }
            
        }
    }
    
    public void CalculatePendingAmendRowBalanceAmount(){
        
        locatethePendingRowPair();
        system.debug('CalculatePendingAmendRowBalanceAmount PreviousRow:'+ PreviousRow);
        system.debug('CalculatePendingAmendRowBalanceAmount PendingRow:'+ PendingRow);
        if (PendingRow != null){
            
            if (PendingRow.theRow.Service__c != null && PendingRow.theRow.Individual__c != null){
                
                wb_Service__c Service;
                for ( wb_Service__c s:PendingRow.theService){
                    if ( s.id == PendingRow.theRow.Service__c)
                        Service = s;
                }
                
                if (Service != null){
                    PendingRow.theRow.Type__c = Service.DataType__c;
                    PendingRow.theRow.MembershipPlan__c = Service.Service__c;
                } else
                {
                    PendingRow.theRow.Type__c = null;
                    PendingRow.theRow.MembershipPlan__c = null;
                }
                List<wb_Individual__c> FamilyMembers = new  List<wb_Individual__c>();
                
                If (Service.DataType__c =='家族'){

                    integer seq = 0;
                    FamilyMembers =[SELECT FamilyNo__c, Id, Sex__c, Parent__c, Name FROM wb_Individual__c where Parent__c=: PendingRow.theRow.Individual__c];  
                    
                    if ( FamilyMembers.size() > 0) {
                        for (wb_Individual__c f: FamilyMembers) {
                            seq = seq + 1;
                            wb_MembershipDetail__c child = new wb_MembershipDetail__c( Membership__c= Membership.Id, 
                                                                                      name = PendingRow.theRow.name,
                                                                                      //  name = string.valueof(PendingRow.theRowIndex),
                                                                                      // ParentDetail__c = PendingRow.theRow.id, 
                                                                                      Individual__c = f.id , MemberName__c = f.name, Type__c ='家族');
                            BeingAmendedMembershipDetailsChild.add(child);
                        }
                        //theChildRow.add( new wb_MembershipDetail__c(Individual__c = f.id , MemberName__c = f.name, Type__c ='家族'));
                    }
                }
                
                PendingRow.fetchServiceFee(FamilyMembers);
            } 
            
        }
        
        CalculatePendingAmendRowBalanceAmount(PreviousRow,PendingRow);
        
        BeingAmendedMembershipDetailsParent_CIndx = bulidChildIndex(BeingAmendedMembershipDetailsParent,BeingAmendedMembershipDetailsChild);
        
        
    }
    
    public string PendingAmendRowChangeType {get;set;}
    public void updatePendingAmendRowChangeType() {
        locatethePendingRowPair();
        if ( PendingRow != null && PendingAmendRowChangeType.length() > 0 ) {
            for ( wb_MembershipDetail__c d: MembershipDetailsParent){
                if (d.name == PendingAmendRowChangeType) {
                    PendingRow.theRow.Classification__c ='交替';
                    PendingRow.theRow.PreviousRecord__c = d.id;
                    PendingRow.theRow.name = d.name + 'C';
                    PendingRow.ChangeSelectionPeriousStartDate = d.MembershipStartDate__c;
                }
            }
        } else if ( PendingRow != null && PendingAmendRowChangeType.length() == 0) {
            PendingRow.theRow.Classification__c ='追加';
            PendingRow.theRow.PreviousRecord__c = null;
            PendingRow.ChangeSelectionPeriousStartDate = null;
            PendingRow.theRow.name = 'A';
        }
    }
    
    public void updatePendingAmendRowReplacement() {
        locatethePendingRowPair();
        system.debug(PreviousRow);
        system.debug(PendingRow);
        if ( PendingRow != null && PendingAmendRowChangeType.length() > 0 ) {
            for (integer i = 0 ; i < theMembershipDetail.size(); i ++){
                if (theMembershipDetail[i].theRow.Name == PendingAmendRowChangeType ) {
                    //PendingRow.theRow.Classification__c ='交替';
                    if (PendingRow.theRow.Classification__c =='追加' && PendingRow.theRow.PendingAction__c =='確認' )
                        PendingRow.theRow.Classification__c ='交替';
                    PendingRow.theRow.PreviousRecord__c = theMembershipDetail[i].theRow.id;
                    PendingRow.theRow.name = theMembershipDetail[i].theRow.name + 'C';
                    for ( integer ci = 0 ; ci < PendingRow.theChildRow.size() ; ci ++){
                        system.debug(PendingRow.theChildRow[ci].name);
                        PendingRow.theChildRow[ci].name = PendingRow.theRow.name + '-' + (ci + 1);
                        system.debug(PendingRow.theChildRow[ci].name);
                    }
                    PendingRow.fetchtheFamilies();
                    PendingRow.ChangeSelectionPeriousStartDate = theMembershipDetail[i].theRow.MembershipStartDate__c;
                    PendingRow.MemberReplacement = false;
                    theMembershipDetail[i].theRowChangeType ='交替退会';
                    theMembershipDetail[i].theRow.PendingAction__c ='交替';
                    theMembershipDetail[i].fetchMonthlyfee();
                    Move2BeingAmended(theMembershipDetail[i]);
                    theMembershipDetail.remove(i);
                }
            }
        } else if ( PendingRow != null && PendingAmendRowChangeType.length() == 0) {
            // PendingRow.theRow.Classification__c ='交替';
            PendingRow.theRow.PreviousRecord__c = null;
            PendingRow.ChangeSelectionPeriousStartDate = null;
            PendingRow.theRow.name = 'C';
        }
    }
    
    public void updatePendingRow(){
        insert PendingRow.theRow;
        PendingRow.theRow = getContractDetail(PendingRow.theRow.Id);
        BeingAmendedMembershipDetailsParent_CIndx = bulidChildIndex(PendingRow.theRow,BeingAmendedMembershipDetailsChild);
        
        system.debug(BeingAmendedMembershipDetailsParent_CIndx);
        List<wb_MembershipDetail__c> PendingRowUpdate = new List<wb_MembershipDetail__c>();
        
        if( BeingAmendedMembershipDetailsParent_CIndx[0].firstChildIndx != null && BeingAmendedMembershipDetailsParent_CIndx[0].lastChildIndx != null) {
            for (integer i = BeingAmendedMembershipDetailsParent_CIndx[0].firstChildIndx ; i <= BeingAmendedMembershipDetailsParent_CIndx[0].lastChildIndx; i++)
            {
                BeingAmendedMembershipDetailsChild[i].name = BeingAmendedMembershipDetailsChild[i].name + '-' + string.valueOf(i - BeingAmendedMembershipDetailsParent_CIndx[0].firstChildIndx + 1);
                BeingAmendedMembershipDetailsChild[i].ParentDetail__c =  PendingRow.theRow.id;
                PendingRowUpdate.add(BeingAmendedMembershipDetailsChild[i]);
            }
            insert PendingRowUpdate;
            List<Id> CId = new List<Id>();
            for ( wb_MembershipDetail__c c:PendingRowUpdate){
                CId.add(c.Id);
            }
            PendingRow.fetchChildRow(getContractDetail(CId));
        }
        system.debug(PendingRowUpdate);
    }
    public PageReference ConfirmPendingRow(){
        
        locatethePendingRowPair();
        if (PreviousRow != null) system.debug(PreviousRow.theRow);
        if (PendingRow != null) system.debug(PendingRow.theRow);
        if ( PreviousRow != null && PendingRow != null ) {
            boolean status;
            
            if (PendingRow.theRow.Classification__c =='交替'){
                wb_MembershipBilling BillingMgr = new wb_MembershipBilling();
                if (PendingRow.theRow.Id == null){
                    updatePendingRow();
           
                }
                
                system.debug(PendingRow.theRow);
                system.debug(PendingRow.theChildRow);
                GenerateMemeberNo_Start(PendingRow);  
               // ConfirmAndBillingPendingRow
                system.debug(BeingAmendedMembershipDetailsParent);
                system.debug(BeingAmendedMembershipDetailsChild);
                system.debug(PreviousRow.theRow);
                system.debug(PendingRow.theRow);
                status = BillingMgr.ConfirmAndBillingPendingRow(Membership.id,PreviousRow.theRow,PendingRow.theRow);
                
                
            }
            else if (PendingRow.theRow.Classification__c =='変更'){      
                if (PendingRow.theRow.Id == null){
                    updatePendingRow();
                }
                wb_MembershipBilling BillingMgr = new wb_MembershipBilling();
                status = BillingMgr.ConfirmAndBillingPendingRow(Membership.id,PreviousRow.theRow,PendingRow.theRow);
            }
            
            if (status == true){
                HavingError = false;
                String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
                return new PageReference(sfdcBaseURL+'/apex/wb_Membership_View?Id=' + Membership.Id);
            }
            else{
                HavingError = true;
                AlertMessage='確定が失敗しました。';
                return null;
            }
            
        } 
        else if (PreviousRow == null && PendingRow != null && PendingRow.theRow.Classification__c =='追加'){
            wb_MembershipBilling BillingMgr = new wb_MembershipBilling();
            
            if ( PendingRow.theRow.Type__c =='単身' || PendingRow.theRow.Type__c =='家族' ) {
                GenerateMemeberNo_Start(PendingRow); 
            }
            
            if ( BillingMgr.ConfirmAndBillingPendingRow(Membership.id,null,PendingRow.theRow) == true){
                
                HavingError = false;
                
                String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
                return new PageReference(sfdcBaseURL+'/apex/wb_Membership_View?Id=' + Membership.Id);
            } 
            else{
                HavingError = true;
                AlertMessage='確定が失敗しました。';
                return null;
            }
            
        } 
        else if (PreviousRow == null && PendingRow != null && PendingRow.theRow.PendingAction__c =='解約' ) {
            
            SavePoint sp0 = Database.setSavepoint();
            try
            { 
                
                if ( PendingRow != null ) {
                    upsert PendingRow.theRow;
                    if (PendingRow.theChildRow != null )
                        for ( wb_MembershipDetail__c c:PendingRow.theChildRow)
                        upsert c;
                }
                
                
                wb_MembershipBilling BillingMgr = new wb_MembershipBilling();
                if ( BillingMgr.ConfirmAndBillingPendingRow(Membership.id,null,PendingRow.theRow) == true){
                    
                    HavingError = false;
                    
                    String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
                    return new PageReference(sfdcBaseURL+'/apex/wb_Membership_View?Id=' + Membership.Id);
                } 
                else{
                    HavingError = true;
                    AlertMessage='確定が失敗しました。';
                    return null;
                }
            }
            catch(Exception e)
            {
                Database.rollBack(sp0);
                HavingError = true;
                AlertMessage='確定が失敗しました。';
                return null;
            }
            
            
        }
        else if (PreviousRow == null && PendingRow != null && PendingRow.theRow.Classification__c =='交替' ) 
        {
            boolean status;
            wb_MembershipBilling BillingMgr = new wb_MembershipBilling();
            GenerateMemeberNo_Start(PendingRow); 
            status = BillingMgr.ConfirmAndBillingPendingRow(Membership.id,null,PendingRow.theRow);
            
            if ( status == true){
                
                HavingError = false;
                
                String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
                return new PageReference(sfdcBaseURL+'/apex/wb_Membership_View?Id=' + Membership.Id);
            } 
            else{
                HavingError = true;
                AlertMessage='確定が失敗しました。';
                return null;
            }
            
        }
        return null;
    }
    
    public class PrevirousPendingRowPair{
        public wb_MembershipDetail__c thePreviousRow {get;set;}
        public wb_MembershipDetail__c thePendingRow {get;set;}
        public PrevirousPendingRowPair(wb_MembershipDetail__c Prev, wb_MembershipDetail__c Pend){
            thePreviousRow = Prev;
            thePendingRow = Pend;
        }
    }
    
    public PageReference ConfirmSelectedPendingRow(){
        remove_empty_amend_row();
        SavePoint sp0 = Database.setSavepoint();
        try
        { 
            AmendRowNumbering();
            List<PrevirousPendingRowPair> ConfirmRowPair = new List<PrevirousPendingRowPair>();
            system.debug('theBeingAmendedMembershipDetail size:' + theBeingAmendedMembershipDetail.size());
            for (integer i = 0; i < theBeingAmendedMembershipDetail.size()  ; i ++ ){
                if ((theBeingAmendedMembershipDetail[i].theRow.PendingAction__c=='確認'||
                     theBeingAmendedMembershipDetail[i].theRow.PendingAction__c=='解約') && 
                    theBeingAmendedMembershipDetail[i].IsSelected == true) {
                        PendingAmendRowId = theBeingAmendedMembershipDetail[i].theRow.Id;
                        PendingAmendRowIdx = string.valueof(i) ;
                        system.debug('PendingAmendRowIdx:' + string.valueof(i));
                        locatethePendingRowPair();
                        if (PreviousRow != null)
                            ConfirmRowPair.add(new PrevirousPendingRowPair(PreviousRow.theRow,PendingRow.theRow));
                        else
                            ConfirmRowPair.add(new PrevirousPendingRowPair(null,PendingRow.theRow));
                        
                    }
            }
            system.debug('ConfirmRowPair size:' + ConfirmRowPair.size());
            List<Id> PrevIDs = new List<Id>();
            List<wb_MembershipDetail__c> PendingRows = new List<wb_MembershipDetail__c>();
            
            for ( PrevirousPendingRowPair p:ConfirmRowPair) {
                if ( p.thePreviousRow != null)
                    system.debug(p.thePreviousRow.name +':'+ p.thePendingRow.name);
                else 
                    system.debug('  :'+ p.thePendingRow.name);
                if (p.thePreviousRow != null){
                    PrevIDs.add(p.thePreviousRow.Id);
                }
                
                PendingRows.add(p.thePendingRow);
            }
            
            if (PrevIDs.size()>0){
                // List<wb_MembershipDetail__c> PrevRowStatusChanges = [select Id from wb_MembershipDetail__c where Id =:PrevIDs and PendingAction__c = null ];
                List<wb_MembershipDetail__c> PrevRowStatusChanges = [ SELECT Id, PreviousRecord__c 
                                                                     FROM wb_MembershipDetail__c 
                                                                     where PreviousRecord__c =:PrevIDs and PreviousRecord__r.PendingAction__c = null];
                system.debug(PrevRowStatusChanges);
                if (PrevRowStatusChanges.size() > 0 ) {
                    Database.rollBack(sp0);
                    getContractDetail();
                    HavingError = true;
                    AlertMessage='確定が失敗しました。';
                    return null;
                }
            }
            system.debug('PendingRows size:' + PendingRows.size());
            if (ConfirmRowPair.size()>0){
                // for ( PrevirousPendingRowPair p:ConfirmRowPair)
                upsert PendingRows;
            }
            List <Id> PendingIDs = new List<Id>();
            for (wb_MembershipDetail__c p:PendingRows) { PendingIDs.add(p.id);}
            
            PendingRows = [ SELECT Id, Name, MembershipEndDate__c, MembershipStartDate__c,
                           individual__c, MemberNo__c, WorkingCompany__c, Membership__c,Type__c, MembershipPlan__c,
                           Service__r.CardPrefix__c, Service__r.DataType__c, 
                           WorkingCompany__r.CountryCode__c, 
                           Individual__r.FamilyNo__c,
                           Quantity__c, ParentDetail__c,PreviousRecord__c, PendingAction__c, MembershipStopDate__c,
                           Classification__c,BillingAmount__c, BalanceAmount__c,Member__c
                           FROM wb_MembershipDetail__c
                           where Id=:PendingIDs
                          ];
            
            List<PrevirousPendingRowPair> ConfirmRowPairAfterUpSert = new List<PrevirousPendingRowPair>();
            
            for(wb_MembershipDetail__c pu: PendingRows){
                boolean prev = false;
                wb_MembershipDetail__c prev_r;
                
                for (integer i = 0 ; i < ConfirmRowPair.size(); i ++){
                    if (ConfirmRowPair[i].thePreviousRow != null) {
                        if (ConfirmRowPair[i].thePreviousRow.id == pu.PreviousRecord__c ){
                            prev = true;
                            prev_r = ConfirmRowPair[i].thePreviousRow;
                            i = ConfirmRowPair.size();
                        }
                    }
                }
                if (prev)
                    ConfirmRowPairAfterUpSert.add(new PrevirousPendingRowPair(prev_r,pu));
                else
                    ConfirmRowPairAfterUpSert.add(new PrevirousPendingRowPair(null,pu));
            }
            
            wb_MembershipBilling BillingMgr = new wb_MembershipBilling();
            system.debug(ConfirmRowPairAfterUpSert.size());
            system.debug(ConfirmRowPairAfterUpSert);
            
            
        }
        catch(Exception e)
        {
            Database.rollBack(sp0);
            HavingError = true;
            AlertMessage='確定が失敗しました。';
            return null;
        }
        
        HavingError = false;
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        return new PageReference(sfdcBaseURL+'/apex/wb_Membership_View?Id=' + Membership.Id);
    }
    
    public void DeleteSelectedRows(){
        List<wb_MembershipDetail__c> ParentRows = new List<wb_MembershipDetail__c>();
        List<wb_MembershipDetail__c> ChildRows = new List<wb_MembershipDetail__c>();
        
        
        for ( integer i = theMembershipDetail.size() - 1 ; i >= 0 ; i--){
            if ( theMembershipDetail[i].IsSelected == true){
                ParentRows.add(theMembershipDetail[i].theRow);
                theMembershipDetail.remove(i);
            }
        }
        
        for ( wb_MembershipDetail__c p:ParentRows){
            for (integer i = MembershipDetailsChild.size() - 1 ; i >= 0 ; i--){
                if ( MembershipDetailsChild[i].ParentDetail__c == p.id ){
                    ChildRows.add(MembershipDetailsChild[i]);
                    MembershipDetailsChild.remove(i);
                }
                
            }
            
            for (integer i = MembershipDetailsParent.size() - 1 ; i >= 0 ; i--){
                if ( MembershipDetailsParent[i].id == p.id ){
                    MembershipDetailsParent.remove(i);
                }
            }
        }
        delete ChildRows;
        delete ParentRows;
        
    }
    public integer ParentRowIndex {get;set;}
    public Id ChildRowId {get;set;}
    public void DeleteChildRow(){
        
        if (theMembershipDetail[ParentRowIndex-1].theChildRow != null){
            for(integer i = 0; i < theMembershipDetail[ParentRowIndex-1].theChildRow.size(); i++ ){
                if ( theMembershipDetail[ParentRowIndex-1].theChildRow[i].id ==ChildRowId ){
                    wb_MembershipDetail__c myRef =[select id from wb_MembershipDetail__c where id =:theMembershipDetail[ParentRowIndex-1].theChildRow[i].CrossReference__c];
                    if ( myRef != null){
                        delete myRef;
                        delete theMembershipDetail[ParentRowIndex-1].theChildRow[i];
                        theMembershipDetail[ParentRowIndex-1].theChildRow.remove(i);
                        theMembershipDetail[ParentRowIndex-1].fetchInQty();
                    }
                }
            }
        }
    }
     
    public wb_Membership__c getContractHeader(id theID){
        
        return [ SELECT Id, Name, //DiscountPercentage__c,
                InternalAffairs__c, InternalAffairs__r.name,
                Classification__c, Sales__c, Sales__r.name,
                ContractCompany__c, ContractCompany__r.name, ContractCountry__c, 
                ContractDistrict__c,
                ContractDate__c, 
                Status__c, ApplicationDate__c, BillingCompany__c, BillingCompany__r.name, BillingNote__c, BillingFax__c, BillingTel__c, BillingExtNo__c, 
                BillingCountryNo__c, BillingTitle__c, BillingName__c, BillingDept__c, 
                BillingDistrict__c, 
                BillingDate__c, Currency__c,
                ContractIndividual__c, LastModifiedDate
                FROM wb_Membership__c where ID =:theID
               ];
        
    }
    
    public void getContractDetail_paging(){
        
        MembershipDetailsParent = new List<wb_MembershipDetail__c>();
        MembershipDetailsChild = new List<wb_MembershipDetail__c>();
        List<wb_MembershipDetail__c> MyChild = new List<wb_MembershipDetail__c>();
        theMembershipDetail = new List<wb_MembershipDetailRow>();
        
        BeingAmendedMembershipDetailsParent = new List<wb_MembershipDetail__c>();
        BeingAmendedMembershipDetailsChild = new List<wb_MembershipDetail__c>();
        List<wb_MembershipDetail__c> MyBeingAmendedChild = new List<wb_MembershipDetail__c>();
        theBeingAmendedMembershipDetail = new List<wb_MembershipDetailRow>();
        List<wb_MembershipDetailRow> theBeingAmendedMembershipDetail_Org =  new List<wb_MembershipDetailRow>();
        
        MemberFeeChild = new List<wb_MembershipDetail__c>();
        
        List<wb_MembershipDetail__c> ReplacedRows = [select PreviousRecord__c 
                                                     FROM wb_MembershipDetail__c 
                                                     where Membership__c =:Membership.id 
                                                     and PreviousRecord__c != null
                                                     order by PreviousRecord__r.f_NameforOrdering__c ];
        
        List<wb_MembershipDetail__c> MembershipDetailAll = [SELECT  MembershipPlan__c, Quantity__c,
                                                            Name, Id,  Service__c, Service__r.CardPrefix__c, Service__r.DataType__c,
                                                            Membership__c, MembershipEndDate__c, MembershipStartDate__c,
                                                            Individual__c,  Individual__r.name, Individual__r.FamilyNo__c,
                                                            WorkingCompany__c, WorkingCompany__r.CountryCode__c, 
                                                            ParentDetail__c, ParentDetail__r.PendingAction__c,
                                                            MemberName__c, Type__c, MemberNo__c, CancellationDate__c, Classification__c,
                                                            CrossReference__c, CrossReference__r.name,  CrossReference__r.Membership__r.ContractCompany__c,
                                                            CrossReference__r.ParentDetail__r.name, 
                                                            SecondType__c, CrossReference__r.ParentDetail__r.CancellationDate__c,
                                                            PreviousRecord__c, PendingAction__c, MembershipStopDate__c,  Amount__c,
                                                            UnitAmount__c, BalanceAmount__c, BillingAmount__c,
                                                            f_BillingAmount__c, f_NameforOrdering__c, MonthlyUnitAmount__c, PreviousRecord__r.MembershipStartDate__c,
                                                            PreviousRecord__r.MembershipStopDate__c, Remarks__c,Rate__c
                                                            FROM wb_MembershipDetail__c 
                                                            where Membership__c =:Membership.id
                                                            order by f_NameforOrdering__c, id ];
        
        for ( wb_MembershipDetail__c d:MembershipDetailAll)
        {
            if ( d.ParentDetail__c == null && d.PendingAction__c == null ) {
                
                MembershipDetailsParent.add(d);
                
            } 
            else if  ( d.ParentDetail__c != null && d.ParentDetail__r.PendingAction__c == null ){
                if (d.Type__c =='入会金') {
                    MemberFeeChild.add(d);
                    
                } else {
                    MembershipDetailsChild.add(d);
                    
                }
            } 
            else if ( d.ParentDetail__c == null && d.PendingAction__c != null ){
                
                
                BeingAmendedMembershipDetailsParent.add(d);
                MyBeingAmendedChild = new List<wb_MembershipDetail__c>();
                
            } 
            else if ( d.ParentDetail__c != null && d.ParentDetail__r.PendingAction__c != null ){
                BeingAmendedMembershipDetailsChild.add(d);
                
            }
        }
        
    }
    
    
    public void getContractDetail(){
        
        MembershipDetailsParent = new List<wb_MembershipDetail__c>();
        MembershipDetailsChild = new List<wb_MembershipDetail__c>();
        List<wb_MembershipDetail__c> MyChild = new List<wb_MembershipDetail__c>();
        theMembershipDetail = new List<wb_MembershipDetailRow>();
        
        BeingAmendedMembershipDetailsParent = new List<wb_MembershipDetail__c>();
        BeingAmendedMembershipDetailsChild = new List<wb_MembershipDetail__c>();
        List<wb_MembershipDetail__c> MyBeingAmendedChild = new List<wb_MembershipDetail__c>();
        theBeingAmendedMembershipDetail = new List<wb_MembershipDetailRow>();
        List<wb_MembershipDetailRow> theBeingAmendedMembershipDetail_Org =  new List<wb_MembershipDetailRow>();
        
        MemberFeeChild = new List<wb_MembershipDetail__c>();
        
        List<wb_MembershipDetail__c> ReplacedRows = [select PreviousRecord__c 
                                                     FROM wb_MembershipDetail__c 
                                                     where Membership__c =:Membership.id 
                                                     and PreviousRecord__c != null
                                                     order by PreviousRecord__r.f_NameforOrdering__c ];
        
        List<wb_MembershipDetail__c> MembershipDetailAll = [SELECT  MembershipPlan__c, Quantity__c,
                                                            Name, Id,  Service__c, Service__r.CardPrefix__c, Service__r.DataType__c,
                                                            Membership__c, MembershipEndDate__c, MembershipStartDate__c,
                                                            Individual__c,  Individual__r.name, Individual__r.FamilyNo__c,
                                                            WorkingCompany__c, WorkingCompany__r.CountryCode__c, 
                                                            ParentDetail__c, ParentDetail__r.PendingAction__c,
                                                            MemberName__c, Type__c, MemberNo__c, CancellationDate__c, Classification__c,
                                                            CrossReference__c, CrossReference__r.name,  CrossReference__r.Membership__r.ContractCompany__c,
                                                            CrossReference__r.ParentDetail__r.name, 
                                                            SecondType__c, CrossReference__r.ParentDetail__r.CancellationDate__c,
                                                            PreviousRecord__c, PendingAction__c, MembershipStopDate__c,  Amount__c,
                                                            UnitAmount__c, BalanceAmount__c, BillingAmount__c,
                                                            f_BillingAmount__c, f_NameforOrdering__c, MonthlyUnitAmount__c, PreviousRecord__r.MembershipStartDate__c,
                                                            PreviousRecord__r.MembershipStopDate__c, Remarks__c,Rate__c
                                                            FROM wb_MembershipDetail__c 
                                                            where Membership__c =:Membership.id
                                                            order by f_NameforOrdering__c, id ];
        
        for ( wb_MembershipDetail__c d:MembershipDetailAll)
        {
            if ( d.ParentDetail__c == null && d.PendingAction__c == null ) {
                if (MyChild.size() > 0){
                    system.debug(MyChild[0].name);
                    theMembershipDetail[MembershipDetailsParent.size() - 1].theChildRow = MyChild;
                    theMembershipDetail[MembershipDetailsParent.size() - 1].fetchtheFamilies();
                }
                MembershipDetailsParent.add(d);
                // integer idx = MembershipDetailsParent.size();
                theMembershipDetail.add( new wb_MembershipDetailRow(MembershipDetailsParent.size() - 1,
                                                                    d, null, 
                                                                    MDService, RateAndRoundUp, Membership.Currency__c, null, null // Membership.DiscountPercentage__c 
                                                                   ));
                
                if ( ReplacedRows.size() > 0 ) {
                    
                    for ( integer i = 0; i < ReplacedRows.size(); i ++){
                        
                        if (ReplacedRows[i].PreviousRecord__c == d.id){
                            theMembershipDetail[MembershipDetailsParent.size() - 1].IsReplaced = true;
                            ReplacedRows.remove(i);
                            i = ReplacedRows.size();
                        }
                    }
                } 
                
                MyChild = new List<wb_MembershipDetail__c>();
                
            } 
            else if  ( d.ParentDetail__c != null && d.ParentDetail__r.PendingAction__c == null ){
                if (d.Type__c =='入会金') {
                    MemberFeeChild.add(d);
                    MyChild.add(d);
                } else {
                    MembershipDetailsChild.add(d);
                    MyChild.add(d);
                }
            } 
            else if ( d.ParentDetail__c == null && d.PendingAction__c != null ){

                
                BeingAmendedMembershipDetailsParent.add(d);
                MyBeingAmendedChild = new List<wb_MembershipDetail__c>();
                
                wb_MembershipDetailRow AR = new wb_MembershipDetailRow( BeingAmendedMembershipDetailsParent.size() - 1, d, 
                                                                       null, MDService, RateAndRoundUp, Membership.Currency__c, null, null //Membership.DiscountPercentage__c 
                                                                      );
                AR.isSelected = true;
                
                string AR_Name = AR.theRow.Name;
                if (AR_Name.contains('A'))
                    AR.theRowAttribute = 'A';
                if (d.PendingAction__c == '交替') {
                    AR.theRowChangeType = '交替退会';
                    AR.Calculatenoofmonth(AR.theRow.MembershipStartDate__c, AR.theRow.MembershipStopDate__c, null, AR.theRow.MembershipEndDate__c);
                }
                else if (d.Classification__c == '交替' && d.PendingAction__c == '確認'){
                    AR.theRowChangeType = '交替増員';
                    if ( d.PreviousRecord__r.MembershipStartDate__c != null)
                        AR.Calculatenoofmonth(d.PreviousRecord__r.MembershipStartDate__c, d.PreviousRecord__r.MembershipStopDate__c, AR.theRow.MembershipStartDate__c ,AR.theRow.MembershipEndDate__c);
                    else {
                        
                        AR.Calculatenoofmonth(AR.theRow.MembershipStartDate__c, null, null, AR.theRow.MembershipEndDate__c);   
                        //system.debug('交替増員Calculatenoofmonth:'+ AR.theRow.Name +';' +AR.theRow.MembershipStartDate__c + ';' + AR.theRow.MembershipEndDate__c +':' + AR.noofmonth);
                    }
                }
                else if (d.PendingAction__c == '変更') {
                    AR.theRowChangeType = '変更前';
                    AR.Calculatenoofmonth(AR.theRow.MembershipStartDate__c, AR.theRow.MembershipStopDate__c,  null, AR.theRow.MembershipEndDate__c);
                }
                else if (d.Classification__c == '変更' && d.PendingAction__c == '確認') {
                    AR.theRowChangeType = '変更後';
                    
                    AR.Calculatenoofmonth(AR.theRow.PreviousRecord__r.MembershipStartDate__c, AR.theRow.PreviousRecord__r.MembershipStopDate__c, AR.theRow.MembershipStartDate__c, AR.theRow.MembershipEndDate__c);
                    
                }
                else if (d.Classification__c == '追加' && d.PendingAction__c == '確認') {
                    AR.theRowChangeType = '新規追加';
                    if (d.Type__c !='入会金')
                        AR.Calculatenoofmonth(AR.theRow.MembershipStartDate__c, null, null, AR.theRow.MembershipEndDate__c);
                }  else if (d.PendingAction__c == '解約') {
                    AR.theRowChangeType = '退会';
                    AR.Calculatenoofmonth(AR.theRow.MembershipStartDate__c,  AR.theRow.MembershipStopDate__c, null, AR.theRow.MembershipEndDate__c);
                }
                // system.debug(AR.theRow.PendingAction__c + ',' + AR.theRow.Classification__c + ',' + AR.theChildRow.size() );
                
                If ( AR.theRow.PendingAction__c == '確認' || AR.theRow.PendingAction__c == '解約' ) {
                    boolean added = false;
                    for ( integer i = 0; i < theBeingAmendedMembershipDetail.size() && added == false; i++){
                        if (theBeingAmendedMembershipDetail[i].theRow.Id > AR.theRow.Id){
                            theBeingAmendedMembershipDetail.add(i, AR);
                            added = true;
                        }
                    }
                    if (added == false)
                        theBeingAmendedMembershipDetail.add( AR );
                } else
                    theBeingAmendedMembershipDetail_Org.add(AR);
                
                
                
            } 
            else if ( d.ParentDetail__c != null && d.ParentDetail__r.PendingAction__c != null ){
                BeingAmendedMembershipDetailsChild.add(d);
                //MyBeingAmendedChild.add(d);
            }
        }
        
        if (BeingAmendedMembershipDetailsChild.size()>0){
            BeingAmendedMembershipDetailsChild2ParentIndx = bulidChildIndex(BeingAmendedMembershipDetailsChild);
            for (integer i = 0 ; i < theBeingAmendedMembershipDetail.size(); i ++){
                if (theBeingAmendedMembershipDetail[i].theRow.Type__c=='家族' || theBeingAmendedMembershipDetail[i].theRow.Type__c=='入会金') {
                    integer [] idx = SearchIndex(theBeingAmendedMembershipDetail[i].theRow.Id,BeingAmendedMembershipDetailsChild2ParentIndx);
                    if (idx[0]!=null){
                        theBeingAmendedMembershipDetail[i].theChildRow = new List<wb_MembershipDetail__c>(); 
                        for( integer j = idx[0]; j <= idx[1]; j ++){
                            theBeingAmendedMembershipDetail[i].theChildRow.add(BeingAmendedMembershipDetailsChild[j]);
                        }
                        theBeingAmendedMembershipDetail[i].fetchtheFamilies();
                    }
                }
            }
        }
        
        if (MyChild.size() > 0){
            system.debug(MyChild[0].name);
            theMembershipDetail[MembershipDetailsParent.size() - 1].theChildRow = MyChild;
            theMembershipDetail[MembershipDetailsParent.size() - 1].fetchtheFamilies();
        }
        

        
        system.debug('theBeingAmendedMembershipDetail_Org:' + theBeingAmendedMembershipDetail_Org.size());
        for ( integer j = theBeingAmendedMembershipDetail_Org.size() - 1 ; j >= 0; j--){
            for ( integer i = 0; i < theBeingAmendedMembershipDetail.size() ; i++){
                system.debug('theBeingAmendedMembershipDetail[i].theRow.PreviousRecord__c:' +i + ':' + theBeingAmendedMembershipDetail[i].theRow.PreviousRecord__c);
                if (theBeingAmendedMembershipDetail[i].theRow.PreviousRecord__c == theBeingAmendedMembershipDetail_Org[j].theRow.Id){
                    theBeingAmendedMembershipDetail.add(i, theBeingAmendedMembershipDetail_Org[j]);
                    theBeingAmendedMembershipDetail_Org.remove(j);
                    i = theBeingAmendedMembershipDetail.size();
                }
            }
        }
        
        for ( integer i = 0; i < theBeingAmendedMembershipDetail.size(); i ++){
            theBeingAmendedMembershipDetail[i].theRowIndex = i;
        }
        
        List<wb_MembershipDetail__c> UsableReplacementMember = new  List<wb_MembershipDetail__c>() ;
        
        for ( wb_MembershipDetailRow d:theMembershipDetail ) {
            if ( d.theRow.CancellationDate__c == null && d.theRow.Individual__c != null) {
                UsableReplacementMember.add(d.theRow);
            }
        } 
        
        for ( wb_MembershipDetailRow d:theBeingAmendedMembershipDetail) {
            if ( d.theRow.name =='C' && d.theRow.Classification__c == '交替' && d.theRow.PendingAction__c =='確認' ){
                d.UsableCancallationMemberAsReplacement = UsableReplacementMember;
                d.SetMemberAsReplacementOptions();
            }
        }
        List<String> Ptype = new List<String>();         
        NoofMembershipDetails = theMembershipDetail.size();
        // system.debug(MembershipDetailsParent.size() +',' + MembershipDetailsChild.size());
        Ptype.add('単身');
        Ptype.add('家族');
        Ptype.add('無記名');
        MembershipDetailsParent_CIndx = bulidChildIndex(MembershipDetailsParent, MembershipDetailsChild);
        system.debug(MembershipDetailsParent_CIndx);
        
        Ptype = new List<String>(); 
        Ptype.add('入会金');
        MemberFee_CIndx = bulidChildIndex(MembershipDetailsParent, MemberFeeChild, Ptype);
        system.debug(MemberFee_CIndx);
    }
    
    public wb_MembershipDetail__c getContractDetail(Id aId){
        List<ID> IDs = new List<ID>();
        IDs.add(aID);
        return getContractDetail(IDs)[0];
    }
    
    public List<wb_MembershipDetail__c> getContractDetail(List<Id> Ids){
        return [SELECT  MembershipPlan__c, Quantity__c,
                Name, Id,  Service__c, Service__r.CardPrefix__c, Service__r.DataType__c,
                Membership__c, MembershipEndDate__c, MembershipStartDate__c,
                Individual__c,  Individual__r.name, Individual__r.FamilyNo__c,
                WorkingCompany__c, WorkingCompany__r.CountryCode__c, 
                ParentDetail__c, ParentDetail__r.PendingAction__c,
                MemberName__c, Type__c, MemberNo__c, CancellationDate__c, Classification__c,
                CrossReference__c, CrossReference__r.name,  CrossReference__r.Membership__r.ContractCompany__c,
                CrossReference__r.ParentDetail__r.name, 
                SecondType__c, CrossReference__r.ParentDetail__r.CancellationDate__c,
                PreviousRecord__c, PendingAction__c, MembershipStopDate__c,  Amount__c,
                UnitAmount__c, BalanceAmount__c, BillingAmount__c,
                f_BillingAmount__c, f_NameforOrdering__c, MonthlyUnitAmount__c, PreviousRecord__r.MembershipStartDate__c,
                PreviousRecord__r.MembershipStopDate__c, Remarks__c,Rate__c
                FROM wb_MembershipDetail__c 
                where Id =:Ids
                order by f_NameforOrdering__c, id ];
    }
    
    public List<ChildIndex> bulidChildIndex(List<wb_MembershipDetail__c> Parent, 
                                            List<wb_MembershipDetail__c> Child,
                                            List<string> ParentType){
                                                List<ChildIndex> idx = new  List<ChildIndex>();
                                                integer fchild;
                                                integer lchild;
                                                boolean breakloop;
                                                integer i = 0;
                                                set<string> myset = new set<string>(); 
                                                For(string s :ParentType){ 
                                                    myset.add(s); 
                                                }
                                                
                                                for (integer h = 0; h < Parent.size(); h ++){
                                                    if ( myset.contains(Parent[h].Type__c)){
                                                        ChildIndex ix = new ChildIndex(Parent[h].Id,h);
                                                        fchild = null;
                                                        lchild = null;
                                                        breakloop = false;
                                                        if (Child != null ){
                                                            for (;i<Child.size() && breakloop == false;i++){
                                                                if (Child[i].ParentDetail__c > Parent[h].Id){
                                                                    breakloop = true;
                                                                    if (fchild != null)
                                                                        lchild = i - 1;
                                                                } else if ( Child[i].ParentDetail__c == Parent[h].Id && fchild == null ){
                                                                    fchild = i;
                                                                }
                                                            }
                                                            if ( i ==Child.size() && fchild != null )
                                                                lchild = i - 1;
                                                        }
                                                        ix.firstChildIndx = fchild;
                                                        ix.lastChildIndx = lchild;
                                                        idx.add(ix);
                                                    }
                                                }
                                                
                                                return idx;
                                            }
    public List<wb_MembershipDetail__c> sortList  {get;set;}
    
    public Integer sortNum  {get;set;}
    
    public void sortcustomObjList(List<wb_MembershipDetail__c> customObjList) {
        if(customObjList!=null && customObjList.size()>0) {
            this.sortList = customObjList;
            this.sortNum = customObjList.size();
            quickSort(0, sortNum-1);
            
            Integer sortedCount = 1;
            
        }
    }
    
    private void quickSort(Integer low, Integer high ) {
        Integer i = low;
        Integer j = high;
        // Get the pivot element from the middle of the list
        wb_MembershipDetail__c pivot = sortList[low + (high-low)/2];
        
        // Divide into two lists
        while (i <= j) {
            
            
            while (Id.valueof(sortList[i].Id) < Id.valueof(pivot.Id)) {
                i++;
            }
            
            while (Id.valueof(sortList[j].Id) > Id.valueof(pivot.Id)) {
                j--;
            }
            
            
            
            
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
        wb_MembershipDetail__c temp = sortList[i];
        sortList[i] = sortList[j];
        sortList[j] = temp;
    }  
    
    public integer theCurrentRowIndex {get; set;}
    
    public void AutoAddEmptyRow(){
        if (theCurrentRowIndex == theMembershipDetail.size()){
            if ( theMembershipDetail[theCurrentRowIndex-1].theRow.Service__c != null && 
                ( theMembershipDetail[theCurrentRowIndex-1].theRow.MembershipEndDate__c!= null || theMembershipDetail[theCurrentRowIndex-1].theRow.Amount__c != null)) 
            {
                add_empty_row();
            }
        }
    }
    public void removeEmptyRow(){
        for ( integer i = theMembershipDetail.size() - 1 ; i >= 0 ; i--){
            if ( theMembershipDetail[i].theRow.id  == null && theMembershipDetail[i].theRow.Service__c == null) {  
                theMembershipDetail.remove(i); 
            } 
        }
        for ( integer i = MembershipDetailsParent.size() - 1 ; i >= 0 ; i--){
            if ( MembershipDetailsParent[i].id  == null && MembershipDetailsParent[i].Service__c == null) {  
                MembershipDetailsParent.remove(i); 
            } 
        }
    }
    public void AutoAddEmptyAmendRowModeNoOff(){
        system.debug(AmendmentAdditionItemMode);
        if (AmendmentAdditionItemMode==true) {
            
            add_empty_amend_row();
        } else 
            remove_empty_amend_row();
    }
    public integer theCurrentAmendRowIndex {get; set;}
    public void AutoAddEmptyAmendRow(){
        
        
        if (theBeingAmendedMembershipDetail.size() == 0)
            add_empty_amend_row();
        else if (theCurrentAmendRowIndex == theBeingAmendedMembershipDetail.size() && AmendmentAdditionItemMode==true ){
            if ( theBeingAmendedMembershipDetail[theCurrentAmendRowIndex-1].theRow.Service__c != null && 
                ( theBeingAmendedMembershipDetail[theCurrentAmendRowIndex-1].theRow.MembershipEndDate__c!= null || theBeingAmendedMembershipDetail[theCurrentAmendRowIndex-1].theRow.Amount__c != null)) 
            {
                
                add_empty_amend_row();
            }
        }
        
        
    }
    public void add_empty_amend_row(){
        wb_MembershipDetail__c d = new wb_MembershipDetail__c(name ='A', Classification__c='追加',PendingAction__c='確認');
        // Copy the End Date from the last row
        if ( theMembershipDetail.size()>0){
            if (theMembershipDetail[theMembershipDetail.size()-1].theRow.MembershipEndDate__c != null )
                d.MembershipEndDate__c = theMembershipDetail[theMembershipDetail.size()-1].theRow.MembershipEndDate__c ;
        }
        
        if (Membership != null) {
            if (Membership.id != null){
                //wb_MembershipDetail__c d = new wb_MembershipDetail__c(Membership__c=Membership.id, Classification__c='新規');
                d.Membership__c = Membership.id;
                BeingAmendedMembershipDetailsParent.add(d);
                //wb_MembershipDetailRow NAR = new wb_MembershipDetailRow( theBeingAmendedMembershipDetail.size(),d, null, MDService,Membership.Currency__c, Membership.DiscountPercentage__c,RoundUp  );
                wb_MembershipDetailRow NAR = new wb_MembershipDetailRow( theBeingAmendedMembershipDetail.size(),d, null, MDService, RateAndRoundUp, Membership.Currency__c, null, null // Membership.DiscountPercentage__c 
                                                                       );
                NAR.theRowAttribute = 'A';
                NAR.theRowChangeType = '新規追加';
                NAR.IsSelected = true;
                
                // NAR.theRowIndex = BeingAmendMembershipDetails.size() - 1 ;
                // To Check if any cancelled member in last one month can be used for replacement 
                date datelastmth = system.today();
                datelastmth = datelastmth.addMonths(-1);
                
                List<wb_MembershipDetail__c> UsedCancelledMember = [select PreviousRecord__c  FROM wb_MembershipDetail__c
                                                                    where Membership__c =: Membership.id and 
                                                                    PreviousRecord__r.CancellationDate__c != null];
                List<Id> UsedID = New List<Id>();
                for (wb_MembershipDetail__c ud:UsedCancelledMember){
                    UsedID.add(ud.PreviousRecord__c);
                }
                List<wb_MembershipDetail__c> UsableCancelledMember = [SELECT Id, Individual__r.name, Name, CancellationDate__c 
                                                                      FROM wb_MembershipDetail__c
                                                                      where Membership__c =: Membership.id
                                                                      and CancellationDate__c != null 
                                                                      and CancellationDate__c >=:datelastmth and Id !=:UsedID];
                system.debug('UsableCancelledMember:' + UsableCancelledMember.size());
                if (UsableCancelledMember.size() > 0){
                    NAR.UsableCancallationMemberAsReplacement = UsableCancelledMember;
                    NAR.SetCancallationMemberAsReplacementOptions();
                }
                theBeingAmendedMembershipDetail.add(NAR);
            } 
        } 
    }
    public void remove_empty_amend_row(){
        // Remove the empty record
        
        for ( integer i = theBeingAmendedMembershipDetail.size() - 1 ; i >= 0 ; i--){
            //      system.debug(i +',' + theBeingAmendedMembershipDetail[i].theRow.id + ',' + theBeingAmendedMembershipDetail[i].theRow.Service__c);
            if ( theBeingAmendedMembershipDetail[i].theRow.id  == null && theBeingAmendedMembershipDetail[i].theRow.Service__c == null) {  
                theBeingAmendedMembershipDetail.remove(i); 
            } 
        }
        for ( integer i = BeingAmendedMembershipDetailsParent.size() - 1 ; i >= 0 ; i--){
            if ( BeingAmendedMembershipDetailsParent[i].id  == null && BeingAmendedMembershipDetailsParent[i].Service__c == null) {  
                BeingAmendedMembershipDetailsParent.remove(i); 
            } 
        }
        // system.debug( BeingAmendMembershipDetails.size());
        // system.debug( BeingAmendMembershipDetails);
    }
    
    public void add_replacement_amend_row(){
        wb_MembershipDetail__c d = new wb_MembershipDetail__c(name ='C', Classification__c='交替',PendingAction__c='確認');
        // Copy the End Date from the last row
        date startdate;
        if ( theMembershipDetail.size()>0){
            if (theMembershipDetail[theMembershipDetail.size()-1].theRow.MembershipEndDate__c != null )
                d.MembershipEndDate__c = theMembershipDetail[theMembershipDetail.size()-1].theRow.MembershipEndDate__c ;
            startdate = theMembershipDetail[theMembershipDetail.size()-1].theRow.MembershipStartDate__c;
        }
        
        if (Membership != null) {
            if (Membership.id != null){
                //wb_MembershipDetail__c d = new wb_MembershipDetail__c(Membership__c=Membership.id, Classification__c='新規');
                d.Membership__c = Membership.id;
                BeingAmendMembershipDetails.add(d);
                //wb_MembershipDetailRow NAR = new wb_MembershipDetailRow( theBeingAmendedMembershipDetail.size(),d, null, MDService,Membership.Currency__c, Membership.DiscountPercentage__c,RoundUp  );
                wb_MembershipDetailRow NAR = new wb_MembershipDetailRow( theBeingAmendedMembershipDetail.size(),d, null, MDService,RateAndRoundUp,Membership.Currency__c, null, null //Membership.DiscountPercentage__c
                                                                       );
                NAR.theRowAttribute = 'A';
                NAR.theRowChangeType = '交替増員';
                
                NAR.ChangeSelectionPeriousStartDate = startdate;
                theBeingAmendedMembershipDetail.add(NAR);
            } 
        }  
    }
    
    public void add_empty_row(date StartDate, date EndDate){
        wb_MembershipDetail__c d = new wb_MembershipDetail__c(Classification__c='新規', 
                                                              MembershipStartDate__c=StartDate,
                                                              MembershipEndDate__c=EndDate
                                                             );
        integer seq = theMembershipDetail.size() + 1;
        if (Membership.id != null){
            d.Name = Membership.name + '-' +  seq;
        } else {
            d.Name = string.valueof(seq);
        }
        if (Membership != null) {
            if (Membership.id != null){
                
                d.Membership__c = Membership.id;
                MembershipDetailsParent.add(d);
                
                theMembershipDetail.add( new wb_MembershipDetailRow(theMembershipDetail.size(),d, null, MDService,RateAndRoundUp,Membership.Currency__c, null, null //Membership.DiscountPercentage__c
                                                                   ));
            } else
            {
                
                MembershipDetailsParent.add(d);
                theMembershipDetail.add( new wb_MembershipDetailRow(theMembershipDetail.size(),d, null, MDService,RateAndRoundUp,Membership.Currency__c, null, null // Membership.DiscountPercentage__c
                                                                   ));
            }
        } 
        
    }
    public void add_empty_row(){

        // Copy the Start Date from the last row
        Date StartDate;
        Date EndDate;
        if ( theMembershipDetail.size()>0){
            if (theMembershipDetail[theMembershipDetail.size()-1].theRow.MembershipStartDate__c != null )
                StartDate = theMembershipDetail[theMembershipDetail.size()-1].theRow.MembershipStartDate__c ;
            if (theMembershipDetail[theMembershipDetail.size()-1].theRow.MembershipEndDate__c != null )
                EndDate = theMembershipDetail[theMembershipDetail.size()-1].theRow.MembershipEndDate__c ;
            
        }
        add_empty_row(StartDate,EndDate);

    }
    
    public string theRowID  {get; set;}
    public integer theRowIndex  {get; set;}
    public string theIndividual {get; set;}
    public string theService {get; set;}
    
    public void update_row_at(){
        system.debug(theRowID + ':' + theRowIndex +':' +  theMembershipDetail.size() + ':' + theIndividual + ':' +theService +':' + theStartDate);
        if (theRowID !=''){
            system.debug(theRowID);
            return;
        } else if (theRowIndex >= 0 && theRowIndex < theMembershipDetail.size() ) {
            if ( theMembershipDetail[theRowIndex].selectedValue == null)
                theMembershipDetail[theRowIndex].selectedValue ='2';
            theMembershipDetail[theRowIndex].theRow.Service__c = theService;
            theMembershipDetail[theRowIndex].fetchServiceFee();
            theMembershipDetail[theRowIndex].theRow.Individual__c = theIndividual;
            if ( theMembershipDetail[theRowIndex].GetServiceType()=='家族'){
                Family theFamily = new Family(theMembershipDetail[theRowIndex].theRow.Individual__c);  
                theMembershipDetail[theRowIndex].fetchFamily(theFamily.theMember, theFamily.FamilyMembers);
            }
            theMembershipDetail[theRowIndex].theRow.MembershipStartDate__c = theStartDate;
            theMembershipDetail[theRowIndex].fetchEndDate();
            
        }
        
        theCurrentRowIndex = theRowIndex + 1;
        AutoAddEmptyRow();
    }
    
    public string theStartRowID  {get; set;}
    public integer theStartRowIndex  {get; set;} // 0 ...
    public string theIndividualList {get; set;}
    public string theServiceList {get; set;}
    public date theStartDate {get; set;}
    public string UpdateTo {get; set;}

    public wb_MembershipDetailRow UpdateRowServiceIndividual(Id SId, Id IndId, date StartDate, wb_MembershipDetailRow Row ) {
        
        if ( Row.selectedValue == null) {
            Row.selectedValue ='2';
            Row.fetchServiceOptions();
        }
        
      //  Row.theRow.Service__c = SId;
        Row.theRow.Service__c = SId;
        Row.fetchServiceFeeOnly();
        Row.theRow.Individual__c = IndId;
        Row.fetchMemberNo();
        Family theFamily = new Family(Row.theRow.Individual__c); 
        system.debug(theFamily.theMember);
        system.debug(Row.theRow.WorkingCompany__c +':' + theFamily.theMember.WorkingCompany__c +':'+SId+':'+IndId);
        if (Row.theRow.WorkingCompany__c == null || Row.theRow.WorkingCompany__c != theFamily.theMember.WorkingCompany__c){
            Row.theRow.WorkingCompany__c = theFamily.theMember.WorkingCompany__c;
        }
        
        Row.theRow.MemberName__c = theFamily.theMember.name;
        
        if (Row.GetServiceType() =='家族') {
            Row.theChildRow = new List<wb_MembershipDetail__c>(); 
            
            if ( theFamily.FamilyMembers.size() > 0) {
                for (wb_Individual__c f: theFamily.FamilyMembers) {
                    Row.theChildRow.add( new wb_MembershipDetail__c(Individual__c = f.id , MemberName__c = f.name, Type__c ='家族'));
                    
                    MembershipDetailsChild.add(
                        new wb_MembershipDetail__c(name=Row.theRow.Name,
                                                   Membership__c = Membership.id, ParentDetail__c = Row.theRow.Id,
                                                   Individual__c = f.id , MemberName__c = f.name, Type__c ='家族')
                    );
                    
                    
                }
            }
           // Row.fectchtheFamilies();
             Row.fetchFamily(Row.theChildRow);
        }
        
        
        Row.theRow.MembershipStartDate__c=StartDate;
        Row.fetchEndDate();
                
        return Row;
    }
    public void UpdateAndInsertRow_at(){
        //system.debug(theStartRowID + ':' + theStartRowIndex +':' +  theIndividualList + ':' + theServiceList  +':' + theStartDate +':' + UpdateTo);
        List<Id> IndividualID = new List<Id>();
        List<Id> ServiceID = new List<Id>();
        
        while(theIndividualList.indexOf(',') > - 1){
            IndividualID.add(theIndividualList.substringBefore(','));
            theIndividualList = theIndividualList.substringAfter(',');
        }
        if (theIndividualList.length()>0)
            IndividualID.add(theIndividualList);
        
        while(theServiceList.indexOf(',') > - 1){
            ServiceID.add(theServiceList.substringBefore(','));
            theServiceList = theServiceList.substringAfter(',');
        }
        if (theServiceList.length()>0)
            ServiceID.add(theServiceList);
        
        if (theStartRowID !=''){
            system.debug(theStartRowID);
            return;
        } 

        integer DetailRowSize = 0;
        if (UpdateTo =='AMEND'){
            DetailRowSize = theBeingAmendedMembershipDetail.size();}
        else{
            DetailRowSize = theMembershipDetail.size();}

        if (theStartRowIndex >= 0 && theStartRowIndex < DetailRowSize && IndividualID.size() == 1) {
            system.debug(UpdateTo);    
            if( UpdateTo == 'AMEND'){
                if ( theBeingAmendedMembershipDetail[theStartRowIndex].selectedValue == null)
                    theBeingAmendedMembershipDetail[theStartRowIndex].selectedValue ='2';
                if (ServiceID.size() > 0)
                    theBeingAmendedMembershipDetail[theStartRowIndex].theRow.Service__c = ServiceID[0];
                theBeingAmendedMembershipDetail[theStartRowIndex].theRow.Individual__c = IndividualID[0];
                // theBeingAmendedMembershipDetail[theStartRowIndex].fetchFamily();
                
                if (theBeingAmendedMembershipDetail[theStartRowIndex].GetServiceType() =='家族') {
                    
                    theBeingAmendedMembershipDetail[theStartRowIndex].theChildRow = new List<wb_MembershipDetail__c>(); 
                    
                    if ( theBeingAmendedMembershipDetail[theStartRowIndex].theRow.Individual__c != null){
                        Family theFamily = new Family(theBeingAmendedMembershipDetail[theStartRowIndex].theRow.Individual__c);
                        // wb_Individual__c theMember = [select id, name from wb_Individual__c where id=:theBeingAmendedMembershipDetail[theStartRowIndex].theRow.Individual__c ];
                        
                        theBeingAmendedMembershipDetail[theStartRowIndex].theRow.MemberName__c = theFamily.theMember.name;
                        //theBeingAmendedMembershipDetail[theStartRowIndex].theRow.WorkingCompany__c = theFamily.theMember.WorkingCompany__c;
                        // List<wb_Individual__c> FamilyMembers =[SELECT FamilyNo__c, Id, Sex__c, Parent__c, Name FROM wb_Individual__c where Parent__c=: theBeingAmendedMembershipDetail[theStartRowIndex].theRow.Individual__c];  
                        if ( theFamily.FamilyMembers.size() > 0) {
                            for (wb_Individual__c f: theFamily.FamilyMembers) {
                                theBeingAmendedMembershipDetail[theStartRowIndex].theChildRow.add( new wb_MembershipDetail__c(Individual__c = f.id , MemberName__c = f.name, Type__c ='家族'));
                                
                                BeingAmendedMembershipDetailsChild.add(
                                    new wb_MembershipDetail__c(name=theBeingAmendedMembershipDetail[theStartRowIndex].theRow.Name,//name=string.valueof(theStartRowIndex),
                                                               Membership__c = Membership.id, ParentDetail__c = theBeingAmendedMembershipDetail[theStartRowIndex].theRow.Id,
                                                               Individual__c = f.id , MemberName__c = f.name, Type__c ='家族')
                                );
                                
                                
                            }
                            theBeingAmendedMembershipDetail[theStartRowIndex].fetchFamily(theFamily.theMember,theFamily.FamilyMembers);
                        }
                    }
                    
                    // theBeingAmendedMembershipDetail[theStartRowIndex].fetchFamily(); //fectchtheFamilies();
                }
                
            } 
            else {
             
               theMembershipDetail[theStartRowIndex] = UpdateRowServiceIndividual(ServiceID[0],IndividualID[0],theStartDate, theMembershipDetail[theStartRowIndex]);
 
            }
            
        } else if (theStartRowIndex >= 0 && theStartRowIndex < DetailRowSize && IndividualID.size() > 1) {
            // add_empty_row_at(theStartRowIndex,IndividualID.size() - 1 );
            for (integer i=0 ; i < IndividualID.size() ; i ++){
                system.debug('i:' + i +':'+ IndividualID[i]+ ':' + ServiceID[i]);
                if ( i==0) {
                     theMembershipDetail[theStartRowIndex + i] = UpdateRowServiceIndividual(ServiceID[i],IndividualID[i],theStartDate, theMembershipDetail[theStartRowIndex]);
                    
                }  else{
                    add_empty_row(theStartDate, null);
                    theMembershipDetail[theStartRowIndex + i] = UpdateRowServiceIndividual(ServiceID[i],IndividualID[i],theStartDate, theMembershipDetail[theStartRowIndex + i]);
           
                }
            }
        }
        
        theCurrentRowIndex = theStartRowIndex + IndividualID.size();
        if( UpdateTo != 'AMEND') 
            AutoAddEmptyRow();
    }
    
    
    public string theRowIDbeforeExchangeOrCancel {get; set;}
    public void ExchangeAfterRow(){
        system.debug('ExchangeAfterRow:' + theRowIDbeforeExchangeOrCancel);
        if (theRowIDbeforeExchangeOrCancel.length() > 0){
            for (integer i = 0; i < theMembershipDetail.size(); i++){
                if (theMembershipDetail[i].theRow.id == theRowIDbeforeExchangeOrCancel  ) {
                    theMembershipDetail[i].theRow.PendingAction__c ='入替';
                    Add_empty_row_after(i,'入替',theMembershipDetail[i].theRow.id, null, theMembershipDetail[i].theRow.MembershipEndDate__c);
                    i = theMembershipDetail.size();
                }
            }
        } 
    } 
    
    public string theExchangeeRowID {get; set;}
    public void ExchangeConfirmedRow(){
        //system.debug('ExchangeRow:' + theExchangeeRowID);
        if (theExchangeeRowID.length() > 0){
            wb_MembershipDetail__c theExchangeRow = [select id,  PendingAction__c, CancellationDate__c from wb_MembershipDetail__c where id=:theExchangeeRowID];
            if (theExchangeRow.PendingAction__c == null && theExchangeRow.CancellationDate__c == null ) {
                for (integer i = 0; i < theMembershipDetail.size(); i++){
                    // system.debug('ExchangeRow:' + i +',' + theMembershipDetail[i].theRow.id);
                    if (theMembershipDetail[i].theRow.id == theExchangeeRowID  ) {
                        theMembershipDetail[i].theRow.PendingAction__c ='交替';
                        theMembershipDetail[i].theRowChangeType ='退会（交替）';
                        theMembershipDetail[i].fetchMonthlyfee();
                        string theType = theMembershipDetail[i].theRow.Type__c;
                        Move2BeingAmended(theMembershipDetail[i]);
                        
                        wb_MembershipDetail__c d = new wb_MembershipDetail__c(Name =theMembershipDetail[i].theRow.name + 'R',
                                                                              Type__c=theType,
                                                                              Classification__c='交替', 
                                                                              PreviousRecord__c =theMembershipDetail[i].theRow.id, 
                                                                              PendingAction__c ='確認' );
                        
                        //  d.MembershipStartDate__c = StartDate;
                        d.MembershipEndDate__c = theMembershipDetail[i].theRow.MembershipEndDate__c;
                        d.Membership__c = Membership.id;
                        //  BeingAmendMembershipDetails.add(d);
                        BeingAmendedMembershipDetailsParent.add(d);
                        //wb_MembershipDetailRow MDR = new wb_MembershipDetailRow(theBeingAmendedMembershipDetail.size(),d, null, MDService,Membership.Currency__c, Membership.DiscountPercentage__c,RoundUp );
                        wb_MembershipDetailRow MDR = new wb_MembershipDetailRow(theBeingAmendedMembershipDetail.size(),d, null, MDService,RateAndRoundUp,Membership.Currency__c, null, null //Membership.DiscountPercentage__c
                                                                               );
                        MDR.theRowChangeType ='増員（交替）';
                        MDR.IsSelected = true;
                        MDR.selectedValue ='2';
                        MDR.fetchServiceOptions();
                        theBeingAmendedMembershipDetail.add( MDR);
                        system.debug(theBeingAmendedMembershipDetail.size());
                        
                        theMembershipDetail.remove(i);
                        
                        // Add_empty_row_after(i,'入替',theMembershipDetail[i].theRow.id, null, theMembershipDetail[i].theRow.MembershipEndDate__c);
                        i = theMembershipDetail.size();
                    }
                }
            } else
                getContractDetail();
        } 
    }
    
    public string theChangeeRowID {get; set;}
    public void ChangeConfirmedRow(){
        //system.debug('ExchangeRow:' + theExchangeeRowID);
        if (theChangeeRowID.length() > 0){
            wb_MembershipDetail__c theExchangeRow = [select id,  PendingAction__c, CancellationDate__c from wb_MembershipDetail__c where id=:theChangeeRowID];
            if (theExchangeRow.PendingAction__c == null && theExchangeRow.CancellationDate__c == null ) {
                for (integer i = 0; i < theMembershipDetail.size(); i++){
                    // system.debug('ExchangeRow:' + i +',' + theMembershipDetail[i].theRow.id);
                    if (theMembershipDetail[i].theRow.id == theChangeeRowID  ) {
                        theMembershipDetail[i].theRow.PendingAction__c ='変更';
                        theMembershipDetail[i].theRowChangeType ='変更前';
                        theMembershipDetail[i].fetchMonthlyfee();
                        
                        Move2BeingAmended(theMembershipDetail[i]);
                        
                        wb_MembershipDetail__c d = new wb_MembershipDetail__c(Name =theMembershipDetail[i].theRow.name + 'C',
                                                                              Classification__c='変更', 
                                                                              // Type__c = theMembershipDetail[i].theRow.Type__c,
                                                                              Service__c = theMembershipDetail[i].theRow.Service__c,
                                                                              MembershipPlan__c = theMembershipDetail[i].theRow.MembershipPlan__c,
                                                                              Individual__c = theMembershipDetail[i].theRow.Individual__c,
                                                                              WorkingCompany__c = theMembershipDetail[i].theRow.WorkingCompany__c,
                                                                              MembershipEndDate__c = theMembershipDetail[i].theRow.MembershipEndDate__c,
                                                                              PreviousRecord__c =theMembershipDetail[i].theRow.id, 
                                                                              PendingAction__c ='確認' );
                        
                        //  d.MembershipStartDate__c = StartDate;
                        d.MembershipEndDate__c = theMembershipDetail[i].theRow.MembershipEndDate__c;
                        d.Membership__c = Membership.id;
                        // BeingAmendMembershipDetails.add(d);
                        BeingAmendedMembershipDetailsParent.add(d);
                        
                        //wb_MembershipDetailRow MDR = new wb_MembershipDetailRow(theBeingAmendedMembershipDetail.size(),d, null, MDService,Membership.Currency__c, Membership.DiscountPercentage__c,RoundUp );
                        wb_MembershipDetailRow MDR = new wb_MembershipDetailRow(theBeingAmendedMembershipDetail.size(),d, null, MDService,RateAndRoundUp,Membership.Currency__c, null, null //Membership.DiscountPercentage__c
                                                                               );
                        MDR.theRowChangeType ='変更後';
                        MDR.IsSelected = true;
                        MDR.selectedValue ='2';
                        MDR.fetchServiceFee();
                        MDR.fetchMonthlyfee();
                        MDR.fetchServiceOptions();
                        theBeingAmendedMembershipDetail.add( MDR);
                        system.debug(theBeingAmendedMembershipDetail.size());
                        
                        theMembershipDetail.remove(i);
                        
                        // Add_empty_row_after(i,'入替',theMembershipDetail[i].theRow.id, null, theMembershipDetail[i].theRow.MembershipEndDate__c);
                        i = theMembershipDetail.size();
                    }
                }
            } else
                getContractDetail();
        } 
    }
    
    public void Move2BeingAmended(  wb_MembershipDetailRow exchangeerow ){
        system.debug('Move2BeingAmended:' + exchangeerow.theRow.id);
        
        if( BeingAmendMembershipDetails == null)
            BeingAmendMembershipDetails = new List<wb_MembershipDetail__c>();
        if ( theBeingAmendedMembershipDetail == null)
            theBeingAmendedMembershipDetail = new List<wb_MembershipDetailRow>();
        
        for (wb_MembershipDetail__c d :MembershipDetailsParent ) {
            if (d.id == exchangeerow.theRow.id || d.ParentDetail__c == exchangeerow.theRow.id  ) {
                // BeingAmendMembershipDetails.add(d);
                BeingAmendedMembershipDetailsParent.add(d);
            }
        }
        boolean added = false;
        for ( integer i = 0 ; i < theBeingAmendedMembershipDetail.size(); i ++){
            if ( theBeingAmendedMembershipDetail[i].theRow.PreviousRecord__c == exchangeerow.theRow.id ){
                theBeingAmendedMembershipDetail.add(i, exchangeerow);
                added = true;
                i = theBeingAmendedMembershipDetail.size();
            }
        }
        if (added == false) theBeingAmendedMembershipDetail.add(exchangeerow) ;
        
        for (integer i = MembershipDetailsParent.size() - 1 ; i >= 0 ; i --) {
            if ( MembershipDetailsParent[i].id ==exchangeerow.theRow.id || MembershipDetailsParent[i].ParentDetail__c ==exchangeerow.theRow.id )
                MembershipDetailsParent.remove(i);
        }
        
        
    }
    
    public void MoveOutfromBeingAmended(  wb_MembershipDetailRow outrow ){
        system.debug('MoveOutfromBeingAmended:' + outrow.theRow.name + ',' + theMembershipDetail.size() );
        
        for (wb_MembershipDetail__c d :BeingAmendMembershipDetails ) {
            if (d.id == outrow.theRow.id || d.ParentDetail__c == outrow.theRow.id  ) {
                MembershipDetailsParent.add(d);
            }
        }
        
        boolean added = false;
        for ( integer i = 0 ; i < theMembershipDetail.size() && added == false ; i ++){
            if ( theMembershipDetail[i].theRow.f_NameforOrdering__c > outrow.theRow.f_NameforOrdering__c) {
                theMembershipDetail.add(i,outrow );
                added = true;
            }
            
        }
        if ( added == false)
            theMembershipDetail.add(outrow );
        
        system.debug('MoveOutfromBeingAmended:' + theMembershipDetail.size() );
        
        for (integer i = BeingAmendMembershipDetails.size() - 1 ; i >= 0 ; i --) {
            if ( BeingAmendMembershipDetails[i].id ==outrow.theRow.id || 
                BeingAmendMembershipDetails[i].ParentDetail__c ==outrow.theRow.id )
                BeingAmendMembershipDetails.remove(i);
        }
        
        for (integer i = theBeingAmendedMembershipDetail.size() - 1 ; i >= 0 ; i --) {
            if ( theBeingAmendedMembershipDetail[i].theRow.id ==outrow.theRow.id )
                theBeingAmendedMembershipDetail.remove(i);
        }
        
        
    }
    public string theCancalRowID {get;set;}
    public void CancelConfirmedRow(){
        if (theCancalRowID.length() > 0){
            wb_MembershipDetail__c theCancelRow = [select id,  PendingAction__c, CancellationDate__c from wb_MembershipDetail__c where id=:theCancalRowID];
            if (theCancelRow.PendingAction__c == null && theCancelRow.CancellationDate__c == null ) {
                for (integer i = 0; i < theMembershipDetail.size(); i++){
                    // system.debug('ExchangeRow:' + i +',' + theMembershipDetail[i].theRow.id);
                    if (theMembershipDetail[i].theRow.id == theCancalRowID  ) {
                        theMembershipDetail[i].theRow.PendingAction__c ='解約';
                        theMembershipDetail[i].theRowChangeType ='退会';
                        theMembershipDetail[i].fetchMonthlyfee();
                        theMembershipDetail[i].IsSelected = true;
                        Move2BeingAmended(theMembershipDetail[i]);
                        theMembershipDetail.remove(i);
                    }
                }
            }
        }
    }
    
    public void Add_empty_row_after(integer ridx, string classification, Id p_row, date StartDate, date EndDate){
        
        wb_MembershipDetail__c d = new wb_MembershipDetail__c(Name =theMembershipDetail[ridx].theRow.name + 'R',
                                                              Classification__c=classification, 
                                                              PreviousRecord__c =p_row, PendingAction__c ='確認' );
        d.MembershipStartDate__c = StartDate;
        d.MembershipEndDate__c = EndDate;
        d.Membership__c = Membership.id;
        MembershipDetailsParent.add(d);
        //wb_MembershipDetailRow MDR = new wb_MembershipDetailRow(theMembershipDetail.size(),d, null, MDService,Membership.Currency__c, Membership.DiscountPercentage__c,RoundUp );
        wb_MembershipDetailRow MDR = new wb_MembershipDetailRow(theMembershipDetail.size(),d, null, MDService,RateAndRoundUp,Membership.Currency__c, null, null //Membership.DiscountPercentage__c
                                                               );
        MDR.selectedValue ='2';
        MDR.fetchServiceOptions();
        if (theMembershipDetail.size() > ridx + 1)
            theMembershipDetail.add(ridx + 1, MDR);
        else 
            theMembershipDetail.add( MDR);
        
    }
    
    public string theRemainingMembershipQtyList {get; set;}
    
    public void AddRemainingMembershipQty(){
        List<string> RemainingMembershipID = new List<string>();
        List<string> RemainingMembershipQty = new List<string>();
        SplitTwoEleList(theRemainingMembershipQtyList, RemainingMembershipID, RemainingMembershipQty);

        
        List<wb_MembershipDetail__c> theMDs = new List<wb_MembershipDetail__c>();
        List<wb_MembershipDetail__c> theMDsP = new List<wb_MembershipDetail__c>();
        List<wb_MembershipDetail__c> theMDsC = new List<wb_MembershipDetail__c>();
        theMDs = [SELECT Id, Membership__c, Quantity__c,  name,
                  Type__c, SecondType__c, ParentDetail__c
                  FROM wb_MembershipDetail__c
                  where ( id=:RemainingMembershipID or ParentDetail__c=:RemainingMembershipID )
                  and  Membership__r.Status__c ='確定' and Type__c = '入会金'];
        system.debug(theMDs);
        for (wb_MembershipDetail__c d:theMDs){
            if(d.ParentDetail__c==null)
                theMDsP.add(d);
            else
                theMDsC.add(d);
        }
        

        
        integer [] lseq = GetChildIndex(theMembershipDetail[theStartRowIndex-1].theRow.Id, MemberFee_CIndx , MemberFeeChild);
        integer nseq = lseq[2];
        system.debug(RemainingMembershipID);
        system.debug(RemainingMembershipQty);
        for ( integer r = 0; r < RemainingMembershipID.size(); r ++){
            integer Qty = 0;
            wb_MembershipDetail__c TrnP;
            integer nct = 1;
            for (integer i = 0 ; i < theMDsP.size();i++ ){
                if (theMDsP[i].id == RemainingMembershipID[r]) {
                    TrnP = theMDsP[i];
                    if ( TrnP.Quantity__c != null) Qty += integer.valueof(TrnP.Quantity__c);
                    i = theMDsP.size();
                }
            }
            for (wb_MembershipDetail__c c:theMDsC){
                if ( c.ParentDetail__c == RemainingMembershipID[r] ){
                    if ( c.Quantity__c != null) Qty += integer.valueof(c.Quantity__c);
                    nct++;
                }
            }
            system.debug(Qty +',' + Integer.valueof(RemainingMembershipQty[r]));
            if ( Qty >= Integer.valueof(RemainingMembershipQty[r]) ){ 
                //string PN = 
                wb_MembershipDetail__c TranOut = new wb_MembershipDetail__c(
                    Name =TrnP.Name +'-' + nct,
                    Membership__c = TrnP.Membership__c,
                    ParentDetail__c = TrnP.Id,
                    Type__c='入会金',
                    SecondType__c='OUT',
                    Quantity__c=-Integer.valueof(RemainingMembershipQty[r]));
                
                
                if (MemberFeeChildOut==null)
                    MemberFeeChildOut = new List<wb_MembershipDetail__c>();
                MemberFeeChildOut.add(TranOut);
                
                Id InPID;
                if (theStartRowID == ''){
                    // theMembershipDetail[theStartRowIndex-1].theOutChildRow.add(TranOut);
                    InPID = theMembershipDetail[theStartRowIndex-1].theRow.Id;
                } else if ( theMembershipDetail[theStartRowIndex-1].theRow.id ==  theStartRowID ) {
                    //theMembershipDetail[theStartRowIndex-1].theOutChildRow.add(TranOut);
                    //theMembershipDetail[theStartRowIndex-1].theInChildRow.add(TranIn);
                    InPID = theMembershipDetail[theStartRowIndex-1].theRow.Id;
                }
                
                
                nseq = nseq + 1;
                wb_MembershipDetail__c TranIn = new wb_MembershipDetail__c(
                    Name = theMembershipDetail[theStartRowIndex-1].theRow.name +'-' + nseq,
                    Membership__c = Membership.id,
                    Type__c='入会金',
                    SecondType__c='IN',
                    ParentDetail__c = InPID,
                    Quantity__c= Integer.valueof(RemainingMembershipQty[r]));
                
                if (MemberFeeChildIn==null)
                    MemberFeeChildIn = new List<wb_MembershipDetail__c>();
                MemberFeeChildIn.add(TranIn);
                if (theMembershipDetail[theStartRowIndex-1].theChildRow == null)
                    theMembershipDetail[theStartRowIndex-1].theChildRow = new List<wb_MembershipDetail__c>();
                theMembershipDetail[theStartRowIndex-1].theChildRow.add(TranIn);
                // theMembershipDetail[theStartRowIndex-1].fetchInQty();
                
            } else return;
        }
        system.debug(MemberFeeChildIn);
        system.debug(MemberFeeChildOut);
        
        // system.debug( theMembershipDetail[theStartRowIndex-1].theRow.name + ':' + theMembershipDetail[theStartRowIndex-1].theInChildRow.size() + 
        //              ':' + theMembershipDetail[theStartRowIndex-1].theOutChildRow.size() );
        theMembershipDetail[theStartRowIndex-1].fetchInQty();
        theMembershipDetail[theStartRowIndex-1].fectchtheFamilies();
    }
    
    public void SplitTwoEleList( string theList, List<string> e1, List<string> e2 ){        
        while(theList.indexOf(',') > - 1){
            e1.add(theList.substringBefore(','));
            theList = theList.substringAfter(',');
            if (theList.indexOf(',') > - 1){
                e2.add(theList.substringBefore(','));
                theList = theList.substringAfter(',');
            } else if ( theList.length() > 0) {
                e2.add(theList);
            }  else {
                e2.add(null);  
            } 
        }            
    }
    
    public void getCountryDistrict(){
        AgRCountryDistrict = [SELECT Region__c, Country__c, District__c, Jurisdiction__c, Affiliation__c, count(Id)
                              FROM wb_CountryDistrict__c
                              //  where service__c = 'MD会員'
                              where service__c = 'MD'
                              group by Region__c, Country__c, District__c, Jurisdiction__c, Affiliation__c
                              order by Region__c, Country__c, District__c, Jurisdiction__c, Affiliation__c ];
    }
    
    public void getCurrencySymbol(){
        CurrencySymbol= [SELECT CurrencySymbol__c, Name 
                         FROM wb_Currency__c
                         order by CurrencySymbol__c];
    }
    
    public list<wb_BudgetRate__c> getRateAndRoundUp(){

        if (Membership.ContractDate__c != null && Membership.Currency__c != null )
            return [ select FromCurrency__c, ToCurrency__c, FromDate__c, ToDate__c, rate__c, 
                    //CeilingUnit__c
                    YearCeilingUnit__c, MonthCeilingUnit__c
                    from wb_BudgetRate__c 
                    where ToCurrency__c=:Membership.Currency__c
                    and FromDate__c <=:Membership.ContractDate__c 
                    and ToDate__c >=:Membership.ContractDate__c
                    order by ToDate__c ];
        else
            return null;
    }
    public void getServiceMaster(){
        
        MDService =[SELECT id, Service__c, CardPrefix__c, Currency__c, ServiceFee__c, Discountable__c,
                    DataType__c
                    FROM wb_Service__c
                    where ServiceClassification__c = '会員' and Enable__c = true];
        
    }
    
    public SelectOption[] getCountryOptions() {  
        
        SelectOption[] opt = new SelectOption[]{};  
            opt.add(new SelectOption('','--None--'));  
        
        string Country='';
        
        for (AggregateResult l : AgRCountryDistrict) {  
            if ( Country !=  string.valueof(l.get('Country__c'))) {
                opt.add(new SelectOption(String.valueOf(l.get('Country__c')), String.valueOf(l.get('Country__c')) ));  
                Country = string.valueof(l.get('Country__c'));
            }
        }                           
        return opt;  
    } 
    
    public void fetchDistrictOptions(){
        system.debug('fetchDistrictOptions');
        DistrictOptions= getDistrictOptions();
        BillingDistrictOptions= getDistrictOptions();
    }
    
    public void fetchAffiliationOptions(){
        AffiliationOptions = getAffiliationOptions();
        BillingDistrictOptions= getJurisdictionOptions();
    }
    
    public SelectOption[] getDistrictOptions() {  
        // system.debug('getDistrictOptions');
        SelectOption[] opt = new SelectOption[]{};  
            opt.add(new SelectOption('','--None--'));  
        
        //  string District='';
        for (wb_CountryDistrict__c l : [SELECT  Id, District__c
                                        FROM wb_CountryDistrict__c
                                        where service__c = 'MD契約' 
                                        order by id ]) {  
                                            //   if (  string.valueof(l.get('Country__c')) == Membership.ContractCountry__c &&  string.valueof(l.get('District__c')) != District ) {
                                            opt.add(new SelectOption(String.valueOf(l.get('District__c')), String.valueOf(l.get('District__c')) ));  
                                            //       District = string.valueof(l.get('District__c'));
                                            //  }
                                        }                           
        return opt;  
    } 
    
    public SelectOption[] getAffiliationOptions() {  
        SelectOption[] opt = new SelectOption[]{};  
            opt.add(new SelectOption('','--None--'));  
        
        string Affiliation='';
        for (AggregateResult l : AgRCountryDistrict) {  
            if (  string.valueof(l.get('Country__c')) == Membership.ContractCountry__c 
                // &&  string.valueof(l.get('District__c')) == Membership.ContractDistrict__c 
                &&  string.valueof(l.get('Affiliation__c')) != Affiliation ) {
                    opt.add(new SelectOption(String.valueOf(l.get('Affiliation__c')), String.valueOf(l.get('Affiliation__c')) ));  
                    Affiliation = string.valueof(l.get('Affiliation__c'));
                }
        }                           
        return opt;  
    } 
    
    public SelectOption[] getJurisdictionOptions(){
        SelectOption[] opt = new SelectOption[]{};  
            opt.add(new SelectOption('','--None--'));  
        string Jurisdiction='';
        for (AggregateResult l : AgRCountryDistrict) {  
            if (  string.valueof(l.get('Country__c')) == Membership.ContractCountry__c 
                &&  string.valueof(l.get('Jurisdiction__c')) != Jurisdiction ) {
                    opt.add(new SelectOption(String.valueOf(l.get('Jurisdiction__c')), String.valueOf(l.get('Jurisdiction__c')) ));  
                    Jurisdiction = string.valueof(l.get('Jurisdiction__c'));
                }
        }                           
        return opt;  
    }
    
    public SelectOption[] getCurrencySymbolOptions() {  
        SelectOption[] opt = new SelectOption[]{};  
            opt.add(new SelectOption('','--None--'));  
        
        for (wb_Currency__c c : CurrencySymbol) {  
            
            opt.add(new SelectOption(c.CurrencySymbol__c, c.CurrencySymbol__c +' (' + c.Name +')' ));  
            
        }                           
        return opt;  
    } 
    
    public void ChangeCurrency(){
        RateAndRoundUp = getRateAndRoundUp();
        for( wb_MembershipDetailRow r:theMembershipDetail){
            r.theContractCurrency = Membership.Currency__c;
            r.theRateAndRoundUp = RateAndRoundUp;
            r.fetchServiceFee();
            
        }
    }
    
    public void ChangeGroupDiscountPercentage(){
        for( wb_MembershipDetailRow r:theMembershipDetail){
            r.theDiscountPercentage = null; // Membership.DiscountPercentage__c;
            r.fetchServiceFee();
        }
    }
    public void ChangeOfContractDate(){
        GetGroupDiscountPercentage();
        RateAndRoundUp = getRateAndRoundUp();
        for( wb_MembershipDetailRow r:theMembershipDetail){
            //  r.theContractCurrency = Membership.Currency__c;
            r.theRateAndRoundUp = RateAndRoundUp;
            r.fetchServiceFee();
            
        }
    }
    public void GetGroupDiscountPercentage(){
        if (Membership.ContractCompany__c != null ) {
            Account CA = [ select GroupName__c, GroupName__r.GroupWaribikiPer__c, GroupName__r.GroupTekiyouDiscountDate__c 
                          from Account 
                          where id =:Membership.ContractCompany__c];
            
            if (CA.GroupName__c != null) {
                if (CA.GroupName__r.GroupTekiyouDiscountDate__c == null) {
                   // Membership.DiscountPercentage__c = CA.GroupName__r.GroupWaribikiPer__c ;
                }
                else if(  Membership.ContractDate__c <= CA.GroupName__r.GroupTekiyouDiscountDate__c ) {
                   // Membership.DiscountPercentage__c = CA.GroupName__r.GroupWaribikiPer__c ;
                } else {
                 //   Membership.DiscountPercentage__c = 0;
                }
                
                
            } else
            {
               // if ( Membership.DiscountPercentage__c == null )
               //     Membership.DiscountPercentage__c = 0;
            } 
        }
    }
    
    
}