public with sharing class ExportToExcelMultipleSheets {
    
    public List<account> accountList{get;set;}
    public List<contact> contactList{get;set;}
    public String xlsHeader{
        get{
            String strHeader = '';
            strHeader += '<?xml version="1.0"?>';
            strHeader += '<?mso-application progid="Excel.Sheet"?>';
            return strHeader;
        }
    }
    public ExportToExcelMultipleSheets(){
        accountList = [select Name,Id from Account LIMIT 10];
        contactList = [SELECT id,Name, LastName, Account.Name, Email FROM Contact WHERE Email != '' AND Account.Name != '' LIMIT 5];
    }
    public Pagereference exportAll(){
        return new Pagereference('/apex/exportAll');
    }
}