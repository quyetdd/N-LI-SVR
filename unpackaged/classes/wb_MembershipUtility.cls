public class wb_MembershipUtility {
    
    
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
    
    public List<ChildIndex> bulidChildIndex(List<wb_MembershipDetail__c> Child,set<string> myset){
        system.debug(Child);
        List<ChildIndex> idx = new  List<ChildIndex>();
        integer fchild;
        integer lchild;
        boolean breakloop;
        integer i = 0;
        Id PId;
        String PName;
        integer c;
        ChildIndex ix;
        
        for ( c = 0; c < Child.size(); c ++){
            
            if (PName != null){
                
                if (PName != Child[c].Name ){
                    ix.firstChildIndx = fchild;
                    ix.lastChildIndx = c-1;
                    idx.add(ix);
                    PName = Child[c].Name;
                    ix = new ChildIndex(PName,null);
                    fchild = c;
                }
                
            } else if (PId != null) {
                
                if (PId != Child[c].ParentDetail__c ){
                    ix.firstChildIndx = fchild;
                    ix.lastChildIndx = c-1;
                    idx.add(ix);
                    PId = Child[c].ParentDetail__c;
                    ix = new ChildIndex(PId,null);
                    fchild = c;
                }
                
            } else  if ( Child[c].ParentDetail__c != null){
                PId = Child[c].ParentDetail__c;
                ix = new ChildIndex(PId,null);
                fchild = c;
                PName = null;
            } else if (Child[c].Name != null){
                PName = Child[c].Name;
                ix = new ChildIndex(PName,null);
                fchild = c;
                PId = null;
            }
            
        }
        
        if (c == Child.size() && fchild != null && ix != null){
            lchild = Child.size() -1 ;
            ix.firstChildIndx = fchild;
            ix.lastChildIndx = lchild;
            idx.add(ix);
        }
        system.debug(idx);
        return idx;
    }
    
    public integer[] SearchIndex(String PName, List<ChildIndex> Index){
        system.debug(PName);
        system.debug(Index);
        Integer [] a; 
        if  (Index == null) 
            return new Integer[]{null,null};
                
                Integer low = 0;
        Integer high  = Index.size() - 1;
        // Get the pivot element from the middle of the list
        if (Index.size()>0 ){
            boolean found = false;
            boolean highequallow = false;
            
            while (found == false && high >= low && highequallow == false ){
                
                if (high == low)
                    highequallow = true;
                
                string pivotName = Index[low + (high-low)/2].ParentName;
                system.debug(low + ',' + high + ',' + pivotName +',' + PName);
                if ( PName == pivotName){
                    found = true;
                    a=new Integer[]{Index[low + (high-low)/2].firstChildIndx, 
                        Index[low + (high-low)/2].lastChildIndx };
                            }
                else if ( integer.valueof(PName) > integer.valueof(pivotName)){
                    
                    // high = low + (high-low)/2;
                    // system.debug('PName > pivotName');
                    integer increase = (high-low)/2;
                    if (increase == 0 )
                        low = low + 1;
                    else
                        low = low + increase;
                    
                    // low = low + (high-low)/2;
                    
                } else {
                    if (low == low + (high-low)/2){
                        return new Integer[]{null,null};
                            }
                    else {
                        // low = low + (high-low)/2;
                        high = high - (high-low)/2;
                    }
                    
                }
            }
        } else
            a=new Integer[]{null,null};
                return a;
    }
    
    
    public List<ChildIndex> bulidChildIndex(List<wb_MembershipDetail__c> Parent, 
                                            List<wb_MembershipDetail__c> Child
                                           )
    {
        set<string> myset = new set<string>(); 
        myset.add('単身');
        myset.add('家族');
        myset.add('無記名');
        return bulidChildIndex(Parent,Child,myset);
        
    }
    
    
    public List<ChildIndex> bulidChildIndex(List<wb_MembershipDetail__c> Parent, 
                                            List<wb_MembershipDetail__c> Child,
                                            set<string> myset
                                           )
    {
        system.debug(Parent);
        system.debug(Child);
        system.debug(myset);
        
        List<ChildIndex> idx = new  List<ChildIndex>();
        integer fchild;
        integer lchild;
        boolean breakloop;
        integer i = 0;
        
        List<ChildIndex> Childidx = bulidChildIndex(Child,myset);
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
                    
                    cidx = SearchIndex( Parent[h].Id,Childidx);    
                    if (cidx[0] == null && cidx[1] == null){
                        cidx = SearchIndex( Parent[h].Name,Childidx); 
                    }
                    
                }
                
                if (cidx != null){
                    ix.firstChildIndx = cidx[0];
                    ix.lastChildIndx = cidx[1];
                }
                
                idx.add(ix);
            }
        }
        system.debug(idx);
        return idx;
        
    }
    
    
    
    
    
}