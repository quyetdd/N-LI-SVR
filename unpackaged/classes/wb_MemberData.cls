global with sharing class wb_MemberData {
    private ApexPages.StandardController standardController;
    public Account theAccount  {get;set;}
    public List<Account> ChildCompanies  {get;set;}
    public List<Account> CousinCompanies {get;set;}
    public List<aSelectiveRow> CompanyFamily {get;set;}  
    
    
    public class aSelectiveRow {
        public integer index { get; set; }
        public Boolean isSelected { get; set; }
        public Id theID { get; set; }
        public string Jurisdiction { get; set; }
        public string ChildSign { get; set; }
        public string Name { get; set; }
        public string CompanyNameEng { get; set; }
        public string CompanyPopularName { get; set; }
        public Id theParentID { get; set; }
        
        public aSelectiveRow(integer idx, 
                             Id aId, string aJurisdiction, string CS, string aName, string aCompanyNameEng, string aCompanyPopularName,
                             Id aParentID ) {
                                 index = idx;
                                 theID = aId;
                                 Jurisdiction = aJurisdiction;
                                 ChildSign = CS;
                                 Name = aName;
                                 CompanyNameEng = aCompanyNameEng;
                                 CompanyPopularName = aCompanyPopularName;
                                 theParentID = aParentID;
                             }
        
    }
 
    public string selectedValue {get; set;}
    public void defautvalue(){
        selectedValue = '1';
    }
    
    public string filename  {get;set;}
    
    public List<wb_MembershipDetail__c> MDDetailList {get;set;}
    public class MDHeader{
        public string C1 {get;set;}
        public string C2 {get;set;}
        
        public MDHeader(string s1, string s2){
            C1 = s1;
            C2 = s2;
        }
    }
    public String xlsHeader{
        get{
            String strHeader = '';
            strHeader += '<?xml version="1.0"?>';
            strHeader += '<?mso-application progid="Excel.Sheet"?>';
            return strHeader;
        }
    }
    
    public List<MDHeader> MDHeaderList {get;set;}
    
    public wb_MemberData(){
        filename  = 'MDMemberData.xls' ;
      //  selectedValue = '1';
        List<Id> CompanyID = new List<Id>();
        if (apexpages.currentpage().getparameters().get('pv0') != null ){
            string pv0 =  apexpages.currentpage().getparameters().get('pv0');
            system.debug(pv0);
            while(pv0.indexOf(',') > - 1){
                CompanyID.add(pv0.substringBefore(','));
                pv0 = pv0.substringAfter(',');
            }
            if (pv0.length()>0)
                 CompanyID.add(pv0);
                
        }
        
        if (apexpages.currentpage().getparameters().get('pv1')!= null) {
            string pv1 =  apexpages.currentpage().getparameters().get('pv1');
        }
        
        system.debug(CompanyID);
        GetMDHeader(CompanyID);
        GetMDDetail(CompanyID);
 
           
    }
    
    public wb_MemberData(ApexPages.StandardController stdController){
        this.standardController = stdController;
        theAccount = (Account) stdController.getRecord();
        if (theAccount.id != null) {
            theAccount = [select id, name, Jurisdiction__c, CompanyNameEng__c, CompanyPopularName__c, 
                          ParentId, Parent.Name, Parent.Jurisdiction__c, Parent.CompanyNameEng__c, Parent.CompanyPopularName__c
                          from account 
                          where id =:theAccount.Id];
            
            if (theAccount.ParentId != null){
                
                CousinCompanies = [select id, name, Jurisdiction__c, CompanyNameEng__c, CompanyPopularName__c, 
                                   ParentId, Parent.Name
                                   from account where ParentId =:theAccount.ParentId and id !=:theAccount.Id];
                
            }
            ChildCompanies();
            
            
            CompanyFamily = new List<aSelectiveRow>();
            // Parent
            integer ChildSignIdx;
            if (theAccount.ParentId != null){
                CompanyFamily.add(new aSelectiveRow( CompanyFamily.size(),
                                                    theAccount.ParentId,
                                                    theAccount.Parent.Jurisdiction__c,
                                                    '-',
                                                    theAccount.Parent.Name,
                                                    theAccount.Parent.CompanyNameEng__c,
                                                    theAccount.Parent.CompanyPopularName__c,
                                                    null
                                                   ) );
            }
            // the Company
            CompanyFamily.add(new aSelectiveRow( CompanyFamily.size(),
                                                theAccount.Id,
                                                theAccount.Jurisdiction__c,
                                                null,
                                                theAccount.Name,
                                                theAccount.CompanyNameEng__c,
                                                theAccount.CompanyPopularName__c,
                                                theAccount.ParentId
                                               ) );
            ChildSignIdx = CompanyFamily.size() - 1;
            // Child
            for ( account c:ChildCompanies) {
                if( c.ParentId == theAccount.Id ) {
                    CompanyFamily.add(new aSelectiveRow( CompanyFamily.size(),
                                                        c.Id,
                                                        c.Jurisdiction__c,
                                                        null,
                                                        c.Name,
                                                        c.CompanyNameEng__c,
                                                        c.CompanyPopularName__c,
                                                        c.ParentId
                                                       ) );
                    CompanyFamily[ChildSignIdx].ChildSign = '-';
                }
                
            }
            // Cousin
            if (CousinCompanies != null ) {
                if ( CousinCompanies.size() > 0 ) {
                    for ( account c:CousinCompanies) {
                        CompanyFamily.add(new aSelectiveRow( CompanyFamily.size(),
                                                            c.Id,
                                                            c.Jurisdiction__c,
                                                            null,
                                                            c.Name,
                                                            c.CompanyNameEng__c,
                                                            c.CompanyPopularName__c,
                                                            c.ParentId
                                                           ) );
                        ChildSignIdx = CompanyFamily.size() - 1;
                        for ( account cc:ChildCompanies) {
                            if( cc.ParentId == c.Id ) {
                                // Cousin Child
                                CompanyFamily.add(new aSelectiveRow( CompanyFamily.size(),
                                                                    cc.Id,
                                                                    cc.Jurisdiction__c,
                                                                    null,
                                                                    cc.Name,
                                                                    cc.CompanyNameEng__c,
                                                                    cc.CompanyPopularName__c,
                                                                    cc.ParentId
                                                                   ) );
                                CompanyFamily[ChildSignIdx].ChildSign = '-';
                            }
                            
                        }
                    }
                }
            }
            
        }
        
    }
    
    public void ChildCompanies(){
        
        List<Id> CCID = new List<Id>();
        CCID.add(theAccount.Id);
        
        if ( CousinCompanies != null ) {
            for (account c:CousinCompanies){
                CCID.add(c.id);
            }
        }
        
        ChildCompanies = [select id, name, Jurisdiction__c, CompanyNameEng__c, CompanyPopularName__c, ParentId, Parent.Name
                          from account where ParentId =:CCID];
        system.debug(ChildCompanies.size());
    }
    public string theSelectedCompanyIDs {get;set;}
    public void SelectedCompanyIDs(){
        string Ids;
        for (aSelectiveRow c:CompanyFamily){
            if (c.isSelected == true ){
             
                if (Ids==null)
                    Ids=c.theID;
                else
                    Ids=Ids+','+c.theID;
            }
        }
        theSelectedCompanyIDs=Ids;
        system.debug('theSelectedCompanyIDs:'+theSelectedCompanyIDs);
    }
    
    public Pagereference ExportData(){
        List<Id> SelectedComp = new List<Id>();
        string para ='?'+'pv0=';
        string Ids;
        for (aSelectiveRow c:CompanyFamily){
            if (c.isSelected == true ){
                SelectedComp.add(c.theID);
                if (Ids==null)
                    Ids=c.theID;
                else
                    Ids=Ids+','+c.theID;
            }
        }
        
        // GetMDHeader(SelectedComp);
        // GetMDDetail(SelectedComp);
          PageReference p = new PageReference('/apex/wb_MemberDataExport'+para+Ids);
        p.setredirect(true);
        return p;
        
        //return new Pagereference('/apex/wb_MemberDataExport'+para+Ids);
    }
    public void GetMDHeader(List<Id> CompID){

        
        AggregateResult[] HeaderList = [SELECT    membership__r.id, membership__r.ContractDistrict__c ContractDistrict__c,
                                         Membership__r.ContractCompany__r.Jurisdiction__c Jurisdiction__c, Membership__r.ContractCompany__r.ShozokuArea__c ShozokuArea__c,
                                        WorkingCompany__r.name WName, WorkingCompany__r.OfficeAdd__c WOfficeAdd, WorkingCompany__r.Phone WPhone, WorkingCompany__r.Fax WFax,
                                        WorkingCompany__r.President__c WPresident, WorkingCompany__r.Shimei__c WShimei, WorkingCompany__r.Busho__c WBusho,
                                        WorkingCompany__r.Yakushoku__c WYakushoku, 
                                        WorkingCompany__r.SubShimei__c WSubShimei, WorkingCompany__r.SubBusho__c WSubBusho,
                                        WorkingCompany__r.SubYakushoku__c WSubYakushoku, WorkingCompany__r.EigyoTanto__r.name WEigyoTanto, WorkingCompany__r.NaimuTanto__r.name WNaimuTanto,
                                        Membership__r.ContractCompany__r.name CName , Membership__r.ContractCompany__r.OfficeAdd__c OfficeAdd, Membership__r.ContractCompany__r.Phone Phone, Membership__r.ContractCompany__r.Fax Fax,
                                        Membership__r.ContractCompany__r.President__c President, Membership__r.ContractCompany__r.Shimei__c Shimei, Membership__r.ContractCompany__r.Busho__c Busho,
                                        Membership__r.ContractCompany__r.Yakushoku__c Yakushoku, 
                                        Membership__r.ContractCompany__r.SubShimei__c SubShimei, Membership__r.ContractCompany__r.SubBusho__c SubBusho,
                                        Membership__r.ContractCompany__r.SubYakushoku__c SubYakushoku, Membership__r.ContractCompany__r.EigyoTanto__r.name EigyoTanto, Membership__r.ContractCompany__r.NaimuTanto__r.name NaimuTanto
                                        FROM wb_MembershipDetail__c
                                        where Individual__c != null 
                                        and Type__c in ('家族','単身')
                                        and ParentDetail__c = null and PreviousRecord__c = null
                                        and Membership__r.ContractCompany__r.id =:CompID
                                        group by Membership__r.id, membership__r.ContractDistrict__c,
                                        Membership__r.ContractCompany__r.Jurisdiction__c, Membership__r.ContractCompany__r.ShozokuArea__c,
                                        WorkingCompany__r.name, WorkingCompany__r.OfficeAdd__c, WorkingCompany__r.Phone, WorkingCompany__r.Fax,
                                        WorkingCompany__r.President__c, WorkingCompany__r.Shimei__c, WorkingCompany__r.Busho__c,
                                        WorkingCompany__r.Yakushoku__c, 
                                        WorkingCompany__r.SubShimei__c, WorkingCompany__r.SubBusho__c,
                                        WorkingCompany__r.SubYakushoku__c, WorkingCompany__r.EigyoTanto__r.name, WorkingCompany__r.NaimuTanto__r.name,
                                        Membership__r.ContractCompany__r.name, Membership__r.ContractCompany__r.OfficeAdd__c, Membership__r.ContractCompany__r.Phone, Membership__r.ContractCompany__r.Fax,
                                        Membership__r.ContractCompany__r.President__c, Membership__r.ContractCompany__r.Shimei__c, Membership__r.ContractCompany__r.Busho__c,
                                        Membership__r.ContractCompany__r.Yakushoku__c, 
                                        Membership__r.ContractCompany__r.SubShimei__c, Membership__r.ContractCompany__r.SubBusho__c,
                                        Membership__r.ContractCompany__r.SubYakushoku__c, Membership__r.ContractCompany__r.EigyoTanto__r.name, Membership__r.ContractCompany__r.NaimuTanto__r.name
                                       ];
       // system.debug(CompID);
       // system.debug(HeaderList.size());
        List<Id> IDList = new List<Id>();
        for (AggregateResult h: HeaderList){
            IDList.add(String.valueOf(h.get('id')));
        }
        
        List<wb_Membership__c> Header;
        if (IDList.size() > 0 )
            Header = [select id, name from wb_Membership__c where id=:IDList ];
        
        MDHeaderList = new List<MDHeader>();
        for (AggregateResult h: HeaderList){ 
            string no = String.valueOf(h.get('id'));
            for (integer i = 0; i < Header.size(); i ++){
                if (Header[i].id == no ){
                    no = Header[i].name;
                    i = Header.size();
                }
            }
            MDHeaderList.add(new MDHeader('No',no));
            MDHeaderList.add(new MDHeader('契約地区',String.valueOf(h.get('ContractDistrict__c'))));
            MDHeaderList.add(new MDHeader('WB管轄地区',String.valueOf(h.get('Jurisdiction__c'))));
            MDHeaderList.add(new MDHeader('WB所属地区',String.valueOf(h.get('ShozokuArea__c'))));
            MDHeaderList.add(new MDHeader('（勤務先）会社名', String.valueOf(h.get('WName'))));
            MDHeaderList.add(new MDHeader('（勤務先）住所',String.valueOf(h.get('WOfficeAdd'))));
            MDHeaderList.add(new MDHeader('（勤務先）会社情報 電話',String.valueOf(h.get('WPhone'))));
            MDHeaderList.add(new MDHeader('（勤務先）会社情報 Fax',String.valueOf(h.get('WFax'))));
            MDHeaderList.add(new MDHeader('（勤務先）代表者',String.valueOf(h.get('WPresident'))));
            MDHeaderList.add(new MDHeader('（勤務先）メディック担当者',String.valueOf(h.get('WShimei'))));
            MDHeaderList.add(new MDHeader('（勤務先）メディック担当者部署',String.valueOf(h.get('WBusho'))));
            MDHeaderList.add(new MDHeader('（勤務先）メディック担当者役職',String.valueOf(h.get('WYakushoku'))));
            MDHeaderList.add(new MDHeader('（勤務先）メディック実務担当',String.valueOf(h.get('WSubShimei'))));
            MDHeaderList.add(new MDHeader('（勤務先）メディック実務担当部署',String.valueOf(h.get('WSubBusho'))));
            MDHeaderList.add(new MDHeader('（勤務先）メディック実務担当役職',String.valueOf(h.get('WSubYakushoku'))));
            MDHeaderList.add(new MDHeader('（勤務先）WBWB営業担当',String.valueOf(h.get('WEigyoTanto'))));
            MDHeaderList.add(new MDHeader('（勤務先）WBWB内務担当',String.valueOf(h.get('WNaimuTanto'))));
            MDHeaderList.add(new MDHeader('（契約先）会社名',String.valueOf(h.get('CName'))));
            MDHeaderList.add(new MDHeader('（契約先）住所',String.valueOf(h.get('OfficeAdd'))));
            MDHeaderList.add(new MDHeader('（契約先）会社情報 電話',String.valueOf(h.get('Phone'))));
            MDHeaderList.add(new MDHeader('（契約先）会社情報 Fax',String.valueOf(h.get('Fax'))));
            MDHeaderList.add(new MDHeader('（契約先）代表者',String.valueOf(h.get('President'))));
            MDHeaderList.add(new MDHeader('（契約先）メディック担当者',String.valueOf(h.get('Shimei'))));
            MDHeaderList.add(new MDHeader('（契約先）メディック担当者部署',String.valueOf(h.get('Busho'))));
            MDHeaderList.add(new MDHeader('（契約先）メディック担当者役職',String.valueOf(h.get('Yakushoku'))));
            MDHeaderList.add(new MDHeader('（契約先）メディック実務担当',String.valueOf(h.get('SubShimei'))));
            MDHeaderList.add(new MDHeader('（契約先）メディック実務担当部署',String.valueOf(h.get('SubBusho'))));
            MDHeaderList.add(new MDHeader('（契約先）メディック実務担当役職',String.valueOf(h.get('SubYakushoku'))));
            MDHeaderList.add(new MDHeader('（契約先）WBWB営業担当',String.valueOf(h.get('EigyoTanto'))));
            MDHeaderList.add(new MDHeader('（契約先）WBWB内務担当',String.valueOf(h.get('NaimuTanto'))));
            MDHeaderList.add(new MDHeader('請求先会社名称',null));
            MDHeaderList.add(new MDHeader('営業グループ',null));
            MDHeaderList.add(new MDHeader('割引グループ',null));
        }
    }
    public void GetMDDetail(List<Id> CompID){
        MDDetailList = [select membership__r.id, membership__r.name,
                        Membership__r.ContractCompany__r.name,
                        WorkingCompany__r.name,
                        MemberNo__c,
                        MembershipEndDate__c,
                        Individual__r.name,
                        Individual__r.Address__c,
                        Individual__r.Tel__c,
                        Individual__r.Mobile__c,
                        Individual__r.EmailAddress__c
                        from wb_MembershipDetail__c 
                        where Membership__r.ContractCompany__c =:CompID
                        and Type__c in ('家族','単身') and membership__r.Status__c ='確定'];
    }
    public integer toggleChildIdx  {get;set;}
    public void toggleChild(){
        Id toggleId = CompanyFamily[toggleChildIdx].theID;
        string toggleChildSign = CompanyFamily[toggleChildIdx].ChildSign;
        if (toggleChildSign=='-'){
            for (integer i = CompanyFamily.size() -1; i >= 0 ; i--){
                if ( CompanyFamily[i].theParentID == toggleId ) {
                    CompanyFamily.remove(i);
                } else if ( CompanyFamily[i].theID == toggleId ) {
                    CompanyFamily[i].ChildSign ='+';
                }
            }
        }  else if (toggleChildSign=='+'){
            CompanyFamily[toggleChildIdx].ChildSign = '-';
            if (theAccount.ParentId == toggleId) {
                if (CompanyFamily.size() > toggleChildIdx + 1)
                    CompanyFamily.add(toggleChildIdx + 1 , new aSelectiveRow( null,
                                                                             theAccount.ParentId,
                                                                             theAccount.Parent.Jurisdiction__c,
                                                                             '-',
                                                                             theAccount.Parent.Name,
                                                                             theAccount.Parent.CompanyNameEng__c,
                                                                             theAccount.Parent.CompanyPopularName__c,
                                                                             null
                                                                            ));
                else 
                    CompanyFamily.add( new aSelectiveRow( null,
                                                         theAccount.ParentId,
                                                         theAccount.Parent.Jurisdiction__c,
                                                         '-',
                                                         theAccount.Parent.Name,
                                                         theAccount.Parent.CompanyNameEng__c,
                                                         theAccount.Parent.CompanyPopularName__c,
                                                         null
                                                        ));
            } else {
                
                if (CompanyFamily.size() > toggleChildIdx + 1) {
                    for ( integer j = ChildCompanies.size() - 1; j >= 0 ; j --) {
                        if( ChildCompanies[j].ParentId == toggleId) {
                            
                            CompanyFamily.add(toggleChildIdx + 1, new aSelectiveRow( CompanyFamily.size(),
                                                                                    ChildCompanies[j].Id,
                                                                                    ChildCompanies[j].Jurisdiction__c,
                                                                                    null,
                                                                                    ChildCompanies[j].Name,
                                                                                    ChildCompanies[j].CompanyNameEng__c,
                                                                                    ChildCompanies[j].CompanyPopularName__c,
                                                                                    ChildCompanies[j].ParentId
                                                                                   ) );
                            
                        }
                        
                    }
                } else {
                    for ( account cc:ChildCompanies) {
                        if( cc.ParentId == toggleId ) {
                            // Cousin Child
                            CompanyFamily.add(new aSelectiveRow( CompanyFamily.size(),
                                                                cc.Id,
                                                                cc.Jurisdiction__c,
                                                                null,
                                                                cc.Name,
                                                                cc.CompanyNameEng__c,
                                                                cc.CompanyPopularName__c,
                                                                cc.ParentId
                                                               ) );
                            //  CompanyFamily[ChildSignIdx].ChildSign = '-';
                        }
                        
                    }
                }
            }
            
        }
        
        for ( integer i = 0; i < CompanyFamily.size() ; i++ )
            CompanyFamily[i].index = i;
    }
    
    public Pagereference exportList(){
        return new Pagereference('/apex/wb_MemberDataExport');
    }
    
    public void ExportAsAttachment(){
        system.debug('ExportAsAttachment' + theAccount.id);
        PageReference pr = Page.wb_MemberDataExport;
        pr.getParameters().put('pv0', theAccount.id);
      
        Attachment attach = new Attachment();     
        Blob body;
        try {
            body = pr.getContent();
        } catch (VisualforceException e) {
            body = Blob.valueOf('Error : ' + e);
        }
        
        attach.Body = body;
        attach.Name = Datetime.now().format('yyyy-MM-dd HH:mm') + ' ' + 'MDMemberData' + '.xls';
        attach.IsPrivate = false;
        
        attach.ParentId = theAccount.id;
        insert attach;
    }
    
    Webservice static void saveAsAttachment(Id pv0){
        PageReference pr = Page.wb_MemberDataExport;
        pr.getParameters().put('pv0', pv0);
        // Blob content = pr.getContent();
        Attachment attach = new Attachment();     
        Blob body;
        try {
            body = pr.getContent();
        } catch (VisualforceException e) {
            body = Blob.valueOf('Error : ' + e);
        }
        
        attach.Body = body;
        attach.Name = Datetime.now().format('yyyy-MM-dd HH:mm') + ' ' + 'MDMemberData' + '.xls';
        attach.IsPrivate = false;
        
        attach.ParentId = pv0;
        insert attach;
    }
    
}