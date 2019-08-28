public class wb_utility_datapaging {
    public List<wb_Membership__c> Memberships{get;set;}
    public List<wb_Membership__c> pageMemberships{get;set;}
    
    public List<wb_MembershipDetail__c> MembershipsDetails{get;set;}
    public List<wb_MembershipDetail__c> pageMembershipsDetails{get;set;}
    
    public List<wb_Member__c> MemberDetails{get;set;}
    public List<wb_Member__c> pageMemberDetails{get;set;}
    public List<wb_MembershipDetail__c> ContractedMemberFamilies {get;set;}
    public List<MemberContractFamily> pageMemberContractFamilies {get;set;}
    
    public List<wb_MemberHistory__c> MemberHistories{get;set;}
    public List<wb_MemberHistory__c> pageMemberHistories{get;set;}
    
    public class MemberContractFamily{
        public wb_Member__c theMember {get;set;}
        public integer NoOfFamily {get;set;}
        public  Map<String, List<wb_MembershipDetail__c>> theFamilies{get;set;}
        public MemberContractFamily(wb_Member__c M, List<wb_MembershipDetail__c> F){
            theMember = M;
            NoOfFamily = F.size();
            theFamilies = new  Map<String, List<wb_MembershipDetail__c>>();
            theFamilies.put(theMember.name, new List<wb_MembershipDetail__c>());
            for ( wb_MembershipDetail__c c :F ){
                theFamilies.get(theMember.name ).add(c);
            }
        }
    }
        
    public string datasource{get;set;}
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
        if (Memberships == null) return true;
        else
            return ((pageNumber * pageSize) >= Memberships.size());
    }
    public Integer getTotalPageNumber()
    {
        if (totalPageNumber == 0 && Memberships !=null)
        {
            totalPageNumber = Memberships.size() / pageSize;
            Integer mod = Memberships.size() - (totalPageNumber * pageSize);
            if (mod > 0)
                totalPageNumber++;
        }
        return totalPageNumber;
    }
    public wb_utility_datapaging(List<wb_MembershipDetail__c> MS)
    {
        datasource ='wb_MembershipDetail__c';
        MembershipsDetails = new List<wb_MembershipDetail__c>();
        MembershipsDetails = MS;
        pageNumber = 0;
        totalPageNumber = 0;
        pageSize = 5;
        ViewData();
    }

    public wb_utility_datapaging(List<wb_Membership__c> MS)
    {
        datasource ='wb_Membership__c';
        Memberships = new List<wb_Membership__c>();
        Memberships = MS;
        pageNumber = 0;
        totalPageNumber = 0;
        pageSize = 5;
        ViewData();
    }
    
    public wb_utility_datapaging(List<wb_Member__c> MS, List<wb_MembershipDetail__c> F)
    {
        datasource ='wb_Member__c';
        MemberDetails = new List<wb_Member__c>();
        MemberDetails = MS;
        system.debug(MemberDetails.size());
        ContractedMemberFamilies = new List<wb_MembershipDetail__c>();
        ContractedMemberFamilies = F;
        pageNumber = 0;
        totalPageNumber = 0;
        pageSize = 5;
        ViewData();
    }
    
        public wb_utility_datapaging(List<wb_Member__c> MS)
    {
        datasource ='wb_Member__c';
        MemberDetails = new List<wb_Member__c>();
        MemberDetails = MS;
        pageNumber = 0;
        totalPageNumber = 0;
        pageSize = 5;
        ViewData();
    }
    
     public wb_utility_datapaging(List<wb_MemberHistory__c> MS)
    {
        datasource ='wb_MemberHistory__c';
        MemberHistories = new List<wb_MemberHistory__c>();
        MemberHistories = MS;
        pageNumber = 0;
        totalPageNumber = 0;
        pageSize = 5;
        ViewData();
    }
    
    
    public PageReference ViewData()
    {
        if (datasource =='wb_Membership__c')
            pageMemberships = null;
        if (datasource =='wb_MembershipDetail__c')
            pageMembershipsDetails = null;
        if (datasource =='wb_Member__c')
            pageMemberDetails = null;
        if (datasource =='wb_MemberHistory__c')
            pageMemberHistories = null;
        totalPageNumber = 0;
        BindData(1);
       // if (pageMembershipsDetails != null)
       // system.debug('ViewData:' +datasource + ':' + pageMembershipsDetails.size());
        return null;
    }
    
    private void BindData(Integer newPageIndex)
    {
        try
        {

            if (datasource =='wb_Membership__c')
                pageMemberships = new List<wb_Membership__c>();
            else if (datasource =='wb_MembershipDetail__c')
                pageMembershipsDetails = new List<wb_MembershipDetail__c>();
            else if (datasource =='wb_Member__c') {
                pageMemberDetails = new List<wb_Member__c>();
                pageMemberContractFamilies = new List<MemberContractFamily>();
            }
            else if (datasource =='wb_MemberHistory__c')
                pageMemberHistories = new List<wb_MemberHistory__c>();
            
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
                //  min = (min <>
            }
            
            if (datasource =='wb_Membership__c') {
                for(wb_Membership__c a : Memberships)
                {
                    counter++;
                    if (counter > min && counter <= max)
                        pageMemberships.add(a);
                }
            }
            else if (datasource =='wb_MembershipDetail__c') {
                for(wb_MembershipDetail__c a : MembershipsDetails)
                {
                    counter++;
                    if (counter > min && counter <= max)
                        pageMembershipsDetails.add(a);
                }
            }
            else if (datasource =='wb_Member__c') {
                system.debug(MemberDetails.size() + ',' + counter + ',' + min + ',' + max );
                for(wb_Member__c a : MemberDetails)
                {
                    counter++;
                    if (counter > min && counter <= max) {
                        pageMemberDetails.add(a);
                        //if (ContractedMemberFamilies != null) {
                            List<wb_MembershipDetail__c> f = new List<wb_MembershipDetail__c>();
                        	if (ContractedMemberFamilies != null) {
                            for (wb_MembershipDetail__c c:ContractedMemberFamilies){
                                if (c.ParentDetail__c==a.MembershipDetail__c){
                                    f.add(c);
                                }
                            }
                            }
                            pageMemberContractFamilies.add( new MemberContractFamily(a,f));
                       // }
                       
                    }
                }
                system.debug(MemberDetails.size() + ',' + counter + ',' + min + ',' + max +',' + pageMemberDetails.size() + ',' + pageMemberContractFamilies.size());
            }
            else if (datasource =='wb_MemberHistory__c') {
                for(wb_MemberHistory__c a : MemberHistories)
                {
                    counter++;
                    if (counter > min && counter <= max)
                        pageMemberHistories.add(a);
                }
            }
            
            pageNumber = newPageIndex;
            if (pageMemberships == null || pageMemberships.size() <= 0)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Data not available for this view.'));
        }
        catch(Exception ex)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,ex.getMessage()));
        }
    }
    
    public PageReference nextBtnClick() {
           system.debug('nextBtnClick:' + pageNumber );
        BindData(pageNumber + 1);
        return null;
    }
    public PageReference previousBtnClick() {
        system.debug('previousBtnClick:' + pageNumber  );
        BindData(pageNumber - 1);
        return null;
    }
    
}