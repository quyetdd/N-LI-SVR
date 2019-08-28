@isTest
public class wb_soap_Member_test {
      @isTest static void test1(){
          Account theCompany = createtestCompany();
          ContractInfo__c theContract = createtestContract(theCompany);
          MemberInfo__c theMember = createtestMember(theCompany, theContract);
          FamilyInfo__c theFamily = createtestFamily(theCompany, theMember);
          
            system.debug(theMember.MemberNo__c);
          
       //   RestRequest request = new RestRequest();   
          
          RestRequest req = new RestRequest();  
          RestResponse res = new RestResponse();
          
         // request.requestUri = 'https://cs72.salesforce.com/services/apexrest/Member?MemberNo=CHN';
        //  request.httpMethod = 'GET';
        //  RestContext.request = request;
          
          req.requestURI = '/services/apexrest/Member/';  
          req.addParameter('MemberNo', theMember.MemberNo__c);
          req.addParameter('isQueueOwner', 'false');
          req.httpMethod = 'GET';
          RestContext.request = req;
          RestContext.response = res;
          
          wb_soap_Member.getMemberInfo();
          
          req.requestURI = '/services/apexrest/Member/';  
          req.addParameter('MemberNo', theFamily.MemberNo__c);
          req.addParameter('isQueueOwner', 'false');
          req.httpMethod = 'GET';
          RestContext.request = req;
          RestContext.response = res;
          
           wb_soap_Member.getMemberInfo();
          
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
    
    static FamilyInfo__c createtestFamily(Account theCompany, MemberInfo__c Member) {
        
        string mno =  Member.MemberNo__c;
        mno = mno.left(12);
        FamilyInfo__c theFamily = new FamilyInfo__c (MemberShimei__c = Member.id,
                                                     FamilyNo__c='1',
                                                     MemberNo__c= mno + '1',
                                                     Region_and_Area__c='アジア',
                                                     CountryName__c='中国',
                                                     Jurisdiction__c='上海',
                                                     ShozokuArea__c='上海',
                                                     Commodity__c='メディック',
                                                     KeiyakuKeitai__c='法人／家族Global Plus Member',
                                                     KeiyakuCompanyName__c=theCompany.id,
                                                     Name='福山一恵',
                                                     SeiRoma__c='FUKUYAMA',
                                                     MeiRoma__c='KAZUE',
                                                     Relationship__c='会員本人',
                                                     Sex__c='女',
                                                     DateOfBirth__c= Date.valueOf('1979-12-20'),
                                                     SeiKana__c='フクヤマ',
                                                     MeiKana__c='カズエ'
                                                    );
        insert theFamily;
        theFamily = [select id, MemberNo__c from FamilyInfo__c where id =:theFamily.id];
        
        return theFamily;
        
    }
        
}