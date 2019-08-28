@isTest
public class wb_soap_objects_test {
    
    @isTest static void test1(){
        
        RestRequest request = new RestRequest();
        

        
        Account theCompany = createtestCompany();
        ContractInfo__c theContract = createtestContract(theCompany);
        MemberInfo__c theMember = createtestMember(theCompany, theContract);
        
        request = new RestRequest();
        request.requestUri ='curl https://sb--wb.cs72.my.salesforce.com/services/apexrest/soap/objects/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
       // request.requestBody = Blob.valueOf('{"Id": "' + theMember.id + '", "lastmodifieddate":"' +theMember.lastmodifieddate + '"}');
        
        List<wb_soap_objects.task> tasks = new  List<wb_soap_objects.task>();
        
        tasks.add( new wb_soap_objects.task('Account','select Id, Name from Account ','getnew'));
        
        wb_soap_objects.post(tasks);
        
		tasks = new  List<wb_soap_objects.task>();
        tasks.add( new wb_soap_objects.task('Account','select Id, Name from Account ','checkingdeleted'));
        
         wb_soap_objects.post(tasks);
	        
    }
    
    static Account createtestCompany(){
        Account theCompany = new Account ( Name = 'ウェルビーマーケティングチャイナ',
                                          CompanyNameEng__c ='WellBe Marketing China',
                                          Region_and_Area__c='アジア',
                                          CountryName__c='中国',
                                          Jurisdiction__c='上海',
                                          ShozokuArea__c='上海'
                                         );
        insert theCompany;
        
        return theCompany;
    }
    
    static ContractInfo__c createtestContract(Account theCompany ){
        date d = system.today();
        
        wb_BudgetRate__c theRate = new wb_BudgetRate__c(FromCurrency__c='USD',ToCurrency__c='RMB',
                                                        BudgetYear__c= d.year(), ToDate__c = d.addDays(100), 
                                                        FromDate__c = d.addDays(-100), Rate__c = 6.93 );
        insert theRate;
        ContractInfo__c theContract = new ContractInfo__c (KeiyakuCompanyName__c=theCompany.id,
                                                           SeikyuCompanyName__c=theCompany.id,
                                                           KeiyakuArea__c='上海',
                                                           SeikyuArea__c='上海',
                                                           Currency__c='RMB',
                                                           MoushikomiDate__c=system.today(),
                                                           KeiyakuDate__c=system.today(),
                                                           MankiDate__c=system.today());
        insert theContract;
        
        return theContract;
    }
    
    static MemberInfo__c createtestMember(Account theCompany,  ContractInfo__c theContract){
        
        MemberInfo__c theMember = new MemberInfo__c (CompanyKeiyakuNo__c=theContract.id,
                                                     Region_and_Area__c='アジア',
                                                     CountryName__c='中国',
                                                     Jurisdiction__c='上海',
                                                     ShozokuArea__c='上海',
                                                     Commodity__c='メディック',
                                                     KeiyakuKeitai__c='法人／家族Global Plus Member',
                                                     KeiyakuCompanyName__c=theCompany.id,
                                                     KinmuCompany__c=theCompany.id,
                                                     Name='福山雅治',
                                                     SeiRoma__c='FUKUYAMA',
                                                     MeiRoma__c='MASAHARU',
                                                     Relationship__c='会員本人',
                                                     Sex__c='男',
                                                     DateOfBirth__c= Date.valueOf('1969-12-20'),
                                                     SeiKana__c='フクヤマ',
                                                     MeiKana__c='マサハル'
                                                    );
        insert theMember;
        theMember = [select id, MemberNo__c from MemberInfo__c where id =:theMember.id];
        
        return theMember;
    }
    
    
}