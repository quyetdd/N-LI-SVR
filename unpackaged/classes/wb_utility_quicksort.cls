public class wb_utility_quicksort {
    
    public class IdIndex{
        public Id Id;
        public integer Idx;
        
        public IdIndex(Id aId, integer anIdx){
            Id = aId;
            Idx = anIdx;
        }
    }
    
    public class IntIndex{
        public integer Key;
        public integer Idx;
        
        public IntIndex(integer aKey, integer anIdx){
            Key = aKey;
            Idx = anIdx;
        }
    }
    
    public List<IdIndex> sortList  {get;set;}
    public List<IntIndex> sortIntList  {get;set;}
    
    public Integer sortNum  {get;set;}
    
    public void sortcustomObjList() {
        
        if(this.sortList!=null && this.sortList.size()>0) {
            //  this.sortList = customObjList;
            this.sortNum = this.sortList.size();
            quickSort(0, sortNum-1);
            Integer sortedCount = 1;
            
        }
    }
    
    
    public void sortcustomObjList(List<IdIndex> customObjList) {
        
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
        IdIndex pivot = sortList[low + (high-low)/2];
        
        // Divide into two lists
        while (i <= j) {
            
            
            while (sortList[i].Id < pivot.Id) {
                i++;
            }
            
            while (sortList[j].Id > pivot.Id) {
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
        IdIndex temp = sortList[i];
        sortList[i] = sortList[j];
        sortList[j] = temp;
    }  

}