public class wb_rpt_MDMemberDistribution {
    
    public string filename{
        get{
            return 'MDMemberReport.xls';
        }
    }
    public String xlsHeader{
        get{
            String strHeader = '';
            strHeader += '<?xml version="1.0"?>';
            strHeader += '<?mso-application progid="Excel.Sheet"?>';
            return strHeader;
        }
    }
    
   // public AggregateResult[] RptContractArea {get;set;}
   // public AggregateResult[] RptShozoArea {get;set;}
    
    public class ReportRow{
        public string C1 {get;set;}
        public string C2 {get;set;}
        public string C3 {get;set;}
        public string C4 {get;set;}
        public string C5 {get;set;}
        public string C6 {get;set;}
        public string C7 {get;set;}
        public string C8 {get;set;}
        public string C9 {get;set;}
        public string C10 {get;set;}
        
        public ReportRow(string s1, string s2, string s3, string s4, string s5, 
                        string s6, string s7, string s8, string s9, string s10)
        {
            C1 = s1;
            C2 = s2;
            C3 = s3;
            C4 = s4;   
            C5 = s5;
            C6 = s6;
            C7 = s7;
            C8 = s8;  
            C9 = s9;
            C10 = s10;  
        }
    }
    
    public List<ReportRow> RptContractArea {get;set;}
    public List<ReportRow> RptShozoArea {get;set;}
    
    public wb_rpt_MDMemberDistribution(){
        
        AggregateResult[] Rpt = [SELECT Membership__r.ContractCountry__c ContractCountry__c, 
                           Membership__r.ContractDistrict__c ContractDistrict__c,
                                  Type__c, MembershipPlan__c,   sum(Quantity__c) Qty
                                  FROM wb_MembershipDetail__c
                                  where Type__c in ('単身','家族','無記名')
                                  group by  Membership__r.ContractCountry__c, Membership__r.ContractDistrict__c,
                                  Type__c, MembershipPlan__c];
        RptContractArea = new List<ReportRow>();
        for ( AggregateResult r:Rpt){
            RptContractArea.add( new ReportRow( String.valueOf(r.get('ContractCountry__c')),
                                               String.valueOf(r.get('ContractDistrict__c')),
                                               String.valueOf(r.get('Type__c')),
                                                String.valueOf(r.get('MembershipPlan__c')),
                                               String.valueOf(r.get('Qty')),
                                               null,null,null,null,null
                                              )
                               );
        }
        Rpt  = [SELECT Membership__r.ContractCompany__r.ShozokuArea__c ShozokuArea__c, Type__c, MembershipPlan__c,   sum(Quantity__c) Qty
                                 FROM wb_MembershipDetail__c
                                 where Type__c in ('単身','家族','無記名')
                                 group by  Membership__r.ContractCompany__r.ShozokuArea__c, 
                                 Membership__r.ContractDistrict__c,
                                 Type__c, MembershipPlan__c];
        RptShozoArea = new List<ReportRow>();
         for ( AggregateResult r:Rpt){
             RptShozoArea.add(
                 new ReportRow( String.valueOf(r.get('ShozokuArea__c')),
                               String.valueOf(r.get('Type__c')),
                               String.valueOf(r.get('MembershipPlan__c')),
                               String.valueOf(r.get('Qty')),
                               null, null,null,null,null,null
                              )
             );
         }
        
    }
}