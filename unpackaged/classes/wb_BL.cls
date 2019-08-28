public class wb_BL {
    ApexPages.StandardController stdController;
    public BL__c BL {get;set;}
    public List<wb_Service__c> bl_service {get;set;}
    public List<wb_Service__c> bl_serviceContent {get;set;}
    
    
    public wb_bl_Insurance theInsurance {get;set;}

    
    
    Public SelectOption[] BranchOfInsuranceyOptions {get;set;}
    
    public wb_BL(ApexPages.StandardController stdController){
        this.stdController = stdController;
        BL = (BL__c) stdController.getRecord();
        if ( BL.id == null) {
            bl_service = new List<wb_Service__c>();
            bl_service = [select id, Service__c from wb_Service__c where ServiceCompany__c = 'ALL' 
                          and ParentService__c = null and ServiceClassification__c ='BL' ];
            bl_serviceContent = new List<wb_Service__c>();
            bl_serviceContent = [select id, Service__c, ParentService__c from wb_Service__c where ServiceCompany__c = 'ALL' 
                                 and ParentService__c <> null and ServiceClassification__c ='BL' ];
        } else {
            BL = [SELECT BLNaimuTanto__c, BlEigyoTanto__c, BlEigyoTanto9__c, Name, BrokerKeiyakuStartDate__c, DPAppoint__c, OpenPolicy__c, Id, 
                  InsuranceCompanyName__c, InsuranceShiki__c, InsuranceShikiMonth__c, InsuranceAmount__c, Currency__c, InsuranceManki__c, Insurance__c, 
                  BranchOfInsurance__c, PersonalKeiyakuInsurant__c, Note__c, EigyoTanto__c, KeiyakuCompanyName__c, KeiyakuArea__c, Agency__c, 
                  KeiyakuShubetsu__c, Insurant__c, ShozokuArea__c, CommissionAmount__c, CommissionRate__c, CommissionCurrency__c, Branch__c, 
                  TransferDate__c, CommodityName__c, InsuranceContent__c, PayRule__c, CancelDate__c, CancelReason__c, KeijoMonthBl__c, ShokenNo__c, 
                  NoticeRule__c, NoticeTanto__c, NoticeTantoMail__c, NoticeMonth__c, TransferBeforeInsuranceCompany__c
                  FROM BL__c where id =:BL.id];
            
        }
        
        BranchOfInsuranceyOptions = getBranchOfInsuranceyOptions();

        fetchInsuranceContent();

        
        
    }
    
    public SelectOption[] getBranchOfInsuranceyOptions() {  
        List<SelectOption>  opt = new  List<SelectOption>();

        opt.add(new SelectOption('','--None--'));  
        for (AggregateResult l : [ select  Service__c, count(id) 
                                  from wb_Service__c where ServiceCompany__c = 'ALL' 
                                  and ParentService__c = null and ServiceClassification__c ='BL'    
                                  group by Service__c	]) {  
                                      opt.add(new SelectOption(String.valueOf(l.get('Service__c')), String.valueOf(l.get('Service__c')) ));  
                                  }        

        return opt;  
    }  
    
    public void fetchInsuranceContent(){
        system.debug(' BL.Insurance__c:' +  BL.Insurance__c + ' ' + BL.InsuranceContent__c);
        if (BL.InsuranceContent__c == null )
            theInsurance = new wb_bl_Insurance( BL.Insurance__c, bl_service, bl_serviceContent );
        else {
		//	system.debug(' BL.Insurance__c:' +  BL.Insurance__c);
            if ( BL.Insurance__c !=''){
                theInsurance = new wb_bl_Insurance(  BL.Insurance__c,BL.InsuranceContent__c );
                theInsurance.InsuranceItem( BL.Insurance__c,
                                           [select id, Service__c from wb_Service__c where ServiceCompany__c = 'ALL' 
                                            and ParentService__c = null and ServiceClassification__c ='BL' ],
                                           [select id, Service__c, ParentService__c from wb_Service__c where ServiceCompany__c = 'ALL' 
                                            and ParentService__c <> null and ServiceClassification__c ='BL' ] );
            }
            
        }
    }
    
    public void FieldValidation(){
        if (BL.InsuranceShiki__c== null)
            BL.InsuranceShiki__c.addError('エラー: 値を入力してください'); 
        if (BL.Currency__c== null)
            BL.Currency__c.addError('エラー: 値を入力してください'); 
        if (BL.CommissionRate__c== null)
            BL.CommissionRate__c.addError('エラー: 値を入力してください'); 
        if (BL.InsuranceAmount__c== null)
            BL.InsuranceAmount__c.addError('エラー: 値を入力してください'); 
        if (BL.CommissionCurrency__c== null)
            BL.CommissionCurrency__c.addError('エラー: 値を入力してください'); 
     
    }
    
    public PageReference PackInsuranceContentSave(){
        string InsuranceContent;
        for ( wb_bl_InsuranceContent ic:theInsurance.theContent ){
            if (InsuranceContent!=null) 
                InsuranceContent +=';' ;
            else  InsuranceContent ='';
            string theValue = ic.Value;
            theValue = theValue.replace('(', ' ').replace(')', ' ');
            theValue = theValue.replace(';', ' ');
            InsuranceContent += ic.ItemName +'(' + theValue +')' ;
            //system.debug('theValue:'+ theValue);
        }
       // system.debug('InsuranceContent:'+ InsuranceContent);
       // BL.Insurant__c=selectedInsurance;
        BL.InsuranceContent__c = InsuranceContent;
        
        if (BL.id == null) {
            insert BL;
            String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
            return new PageReference(sfdcBaseURL+'/apex/wb_BL?Id=' + BL.id);
            
            
        }
        else {
            system.debug('BranchOfInsurance__c' + BL.BranchOfInsurance__c);
			this.stdController.Save();            
            update BL;
            
            
            return null;
            
        }
    }
    
}