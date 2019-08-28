@isTest
public class wb_utility_test {
    
     @isTest static void testquicksort(){
         wb_utility_quicksort qs = new wb_utility_quicksort();
         qs.sortList = new List<wb_utility_quicksort.IdIndex>();

         Account Company1 = new Account ( Name = 'ABC',
                                         Region_and_Area__c='アジア',
                                         CountryName__c= '日本',
                                         Jurisdiction__c='名古屋',
                                         ShozokuArea__c='名古屋'
                                        );
         
         Account Company2 = new Account ( Name = 'DEF',
                                         Region_and_Area__c='アジア',
                                         CountryName__c= '日本',
                                         Jurisdiction__c='名古屋',
                                         ShozokuArea__c='名古屋'
                                        );
         insert Company1;
         insert Company2;
         
         qs.sortList.add(new wb_utility_quicksort.IdIndex(Company2.id,1));
         qs.sortList.add(new wb_utility_quicksort.IdIndex(Company1.id,0));
         qs.sortcustomObjList();
         qs.sortcustomObjList(qs.sortList);
         
     }
}