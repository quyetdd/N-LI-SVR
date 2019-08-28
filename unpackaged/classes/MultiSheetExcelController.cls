public class MultiSheetExcelController{
    public string xmlheader {get;set;}
    public DataModel dModel {get;set;}
    public string endfile{get;set;}
    public string endSheet {set;get;}
    public Date currentDate {set;get;}
	public String Year {set;get;}
	public String Month {set;get;}
    public MultiSheetExcelController(){
    	currentDate = date.today();
    	Year = string.valueof(currentDate.year());
    	Month = string.valueof(currentDate.month());

        //VF page gives some issues directly using the below code there, so wrap up in variable
        xmlheader ='<?xml version="1.0"?><?mso-application progid="Excel.Sheet"?>';
        //Dont know why i did this :) , But xml was not generating without it.
        endfile = '</Workbook>';
        endSheet = '</Worksheet>';
    }

}