global with sharing class wb_bl_InsuranceContent {
    
    public string ItemName{get;set;}
    //public string Datatype{get;set;}
    public string Value{get;set;}
    
    public wb_bl_InsuranceContent(string nm){
        ItemName =nm;
        
    }
    public wb_bl_InsuranceContent(string nm,string vl){
        ItemName =nm;
        Value =vl;
    }

}