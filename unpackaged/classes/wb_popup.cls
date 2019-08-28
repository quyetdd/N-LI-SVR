public class wb_popup {
    public string param {get; set;}    
    public Id theId {get; set;}    
    public string theName {get; set;}    
  
    public boolean displayPopup {get; set;}     
    
    public void closePopup() {        
        displayPopup = false;    
    }     
    public void showPopup() {        
        displayPopup = true;    
    }
    
    public void getURLparameters(){
        
        if (apexpages.currentpage() != null ) {
            if (apexpages.currentpage().getparameters().get('param') !='')
                param = apexpages.currentpage().getparameters().get('param');
            if (apexpages.currentpage().getparameters().get('id') !='')
                theId = apexpages.currentpage().getparameters().get('id');
            if (apexpages.currentpage().getparameters().get('Name') !='')
                theName = apexpages.currentpage().getparameters().get('Name');
           
        }
        
    }
    
    
}