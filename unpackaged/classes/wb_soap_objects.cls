@RestResource(urlMapping='/soap/objects/*')

global with sharing class wb_soap_objects {
    

    global class ObjectWrapper{
        global string objectname; 
        global string type;
        global List<sObject> objs;
        public ObjectWrapper(string n, string t, List<sObject> obj ){
            objectname = n;
            type = t;
            objs = new List<sObject>();
            objs = obj;
        }
    }
    
    global class task{
        global string objectname; 
        global string soql; 
        global string type;
        public task (string obj, string s, string t){
            objectname = obj;
            soql = s;
            type = t; 
        }
    }

    
    @HttpPost
    global static List<ObjectWrapper> post(List<task> tasks){
        List<ObjectWrapper> rst = new List<ObjectWrapper>();
        integer lmt = 3500; 
        
        for ( integer t = 0; t < tasks.size() && lmt > 0 ; t ++){
            string SOQLstatement;
            
            if (tasks[t].type == 'getnew' ){
                SOQLstatement = tasks[t].soql + ' limit ' + string.valueOf(lmt) + ' ' ;
                
                List<sObject> listOfData = Database.query(SOQLstatement);
                if (listOfData.size() > 0 ) {
                    lmt = lmt - listOfData.size();
                    rst.add(new ObjectWrapper( tasks[t].objectname, tasks[t].type, listOfData)); 
                }
            } else if (tasks[t].type == 'checkingdeleted' || tasks[t].type == 'checkingnew' || tasks[t].type == 'checkingmodified'){
                 SOQLstatement = tasks[t].soql;
                 List<sObject> listOfData = Database.query(SOQLstatement);
                 rst.add(new ObjectWrapper( tasks[t].objectname, tasks[t].type, listOfData));
            }
            
        }
        
        return rst;
    }
    

}