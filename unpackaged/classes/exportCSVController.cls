public class exportCSVController {
    public List<wb_Individual__c> ExistIndividual {get;set;}
    public List<MemberInfo__c> theMemberInfo  {get;set;}
    
    public exportCSVController() {
        sortList = [Select Id, name
                    From MemberInfo__c 
                    where CompanyKeiyakuNo__c ='a0A5D0000011HzUUAU' 
                    order by id];
        
        theMemberInfo = sortList;
        
        List<string> MemberInfoIDs = new List<string>();  
        for ( MemberInfo__c m:theMemberInfo){
            MemberInfoIDs.add(m.Id);
        }
        
        ExistIndividual = [select Id, name, WorkingCompany__c, Old_Id__c 
                           from wb_Individual__c 
                           where Old_Id__c =:MemberInfoIDs 
                           order by Old_Id__c limit 1000];
        sortcustomObjList(sortList);
       // ExistIndividual = sortList;
        
    }
    
   // public List<wb_Individual__c> sortList  {get;set;}
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