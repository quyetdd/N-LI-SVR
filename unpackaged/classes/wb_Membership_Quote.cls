public class wb_Membership_Quote {
    private ApexPages.StandardController standardController;
    public wb_Membership__c Membership {get; private set; }
    
     public String getFont() {
        return font;
    }

    private static final String font = 'Arial Unicode MS' ;
        
    //controls how many quote line items are displayed on page 1
    private static Integer FIRST_BREAK = 10;
    //controls how many quote line items are displayed on subsequent pages
    private static Integer SUBSEQ_BREAKS = 20;
    
    public List<wb_MembershipDetail__c[]> pageBrokenQuoteLines {get; private set; }
    public List<wb_MembershipDetail__c> quoteLineItems {get; private set; }
    public void wb_Membership_Quote(Id MembershipID){
        
        Membership = [SELECT BillingCompany__c, ContractDate__c, ContractCompany__c, ContractCompany__r.name,
                      BillingCompany__r.name, BillingCompany__r.BillingStreet, BillingCompany__r.BillingPostalCode,
                      BillingCompany__r.BillingCity,
                      Id, Name, OwnerId, Owner.LastName, Owner.FirstName, ApplicationDate__c,
                      (select id, Type__c, name, MemberNo__c, MemberName__c, Quantity__c, UnitAmount__c, BillingAmount__c
                       from MDMemberDetail__r
                       where ParentDetail__c = null 
                      order by name)  
                      FROM wb_Membership__c where Id =:MembershipID ];
        
        quoteLineItems = Membership.MDMemberDetail__r;
        
    }
    public wb_Membership_Quote(ApexPages.StandardController stdController){
        standardController = stdController;
        
        Membership = (wb_Membership__c) stdController.getRecord();
        
        if (Membership.Id != null )
            wb_Membership_Quote(Membership.Id);
        else
            wb_Membership_Quote('a0o5D000000PJ76QAG');
        
        
    }
    /*
    private void prepareQuoteLinesForPrinting()
    {
        pageBrokenQuoteLines = new List<wb_MembershipDetail__c[]>();
        
        wb_MembershipDetail__c[] pageOfQuotes = new wb_MembershipDetail__c[]{};
            Integer counter = 0;
        
        boolean firstBreakFound = false;
        boolean setSubSeqBreak = false;        
        Integer breakPoint = FIRST_BREAK;
        
        for(wb_MembershipDetail__c q : quoteLineItems)
        {
            if(counter <= breakPoint)
            {
                pageOfQuotes.add(q);
                counter++;	
            }
            if(counter == breakPoint)
            {
                if (!firstBreakFound) 
                {
                    firstBreakFound = true;
                    setSubSeqBreak  = true;
                }
                counter = 0;
                pageBrokenQuoteLines.add(pageOfQuotes);
                pageOfQuotes.clear();
            }
            if(setSubSeqBreak) 
            {
                breakPoint = SUBSEQ_BREAKS;
                setSubSeqBreak = false;
            }
        }
        //if we have finished looping and have some quotes left let's assign them
        if(!pageOfQuotes.isEmpty())
            pageBrokenQuoteLines.add(pageOfQuotes);
    }
    */
}