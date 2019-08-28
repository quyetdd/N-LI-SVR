public class wb_MD_datamigrate {
    public List<Id> ContractIDs{get;set;}
    public wb_MD_datamigrate(){
        ContractIDs = new List<Id>();
          List<Id> IndID = new List<ID>();
        for ( AggregateResult r:[select CompanyKeiyakuNo__c
                         from Memberinfo__c
                         where CompanyKeiyakuNo__c != null
                         group by CompanyKeiyakuNo__c
                         order by count(Id) desc limit 7]){
                             ContractIDs.add(String.valueof(r.get('CompanyKeiyakuNo__c')));   
    }
    }

}