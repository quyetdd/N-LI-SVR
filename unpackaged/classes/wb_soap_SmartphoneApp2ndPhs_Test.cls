@isTest
public class wb_soap_SmartphoneApp2ndPhs_Test {
    
    
    @isTest static void testgetMemberLoginInfo() {
        Account theCompany = createtestCompany();
        ContractInfo__c theContract = createtestContract(theCompany);
        MemberInfo__c theMember = createtestMember(theCompany, theContract);
        FamilyInfo__c theFamily = createtestFamily(theCompany, theMember);
        MemberInfo__c theMemberHC = createtestMember(theCompany, theContract);
        MemberInfo__c theMemberCB = createtestMember(theCompany, theContract);
        MemberInfo__c theMemberML = createtestMember(theCompany, theContract);
        MemberInfo__c theMemberOMS = createtestMember(theCompany, theContract);
        
 
        
         system.debug(theMember.MemberNo__c);
        
        RestRequest request = new RestRequest();

        request.requestUri = 'https://cs72.salesforce.com/services/apexrest/2ndPhs/MobileAppLogin/MemberNo=' + theMember.MemberNo__c;
        request.httpMethod = 'GET';
        RestContext.request = request;
  
		wb_soap_MobileAppLogin_2ndPhs.getMemberLoginInfo();
        
        request.requestUri = 'https://cs72.salesforce.com/services/apexrest/2ndPhs/MobileAppLogin/MemberNo=' + theMember.MemberNo__c;
        request.httpMethod = 'GET';
        RestContext.request = request;
        
        wb_soap_MobileAppLogin_2ndPhs.getMemberLoginInfo();
        
        
        request = new RestRequest();
        system.debug(theFamily.MemberNo__c);
        request.requestUri = 'https://cs72.salesforce.com/services/apexrest/2ndPhs/MobileAppLogin/MemberNo=' + theFamily.MemberNo__c;
        request.httpMethod = 'GET';
        RestContext.request = request;
        
        wb_soap_MobileAppLogin_2ndPhs.getMemberLoginInfo();
        
        request.requestUri = 'https://cs72.salesforce.com/services/apexrest/2ndPhs/MobileAppLogin/MemberNo=' + theFamily.MemberNo__c;
        request.httpMethod = 'GET';
        RestContext.request = request;
        
        wb_soap_MobileAppLogin_2ndPhs.getMemberLoginInfo();
        


        request = new RestRequest();
        request.requestUri ='curl https://cs72.salesforce.com/services/apexrest/2ndPhs/MobileAppMemberInfo/Id=' +theMember.id ;
        request.httpMethod = 'GET';
        RestContext.request = request;
  
		wb_soap_MobileAppMemberInfo_2ndPhs.getMemberInfo();
        
        request = new RestRequest();
        request.requestUri ='curl https://cs72.salesforce.com/services/apexrest/2ndPhs/MobileAppMemberInfo/Id=' +theFamily.id ;
        request.httpMethod = 'GET';
        RestContext.request = request;
  
		wb_soap_MobileAppMemberInfo_2ndPhs.getMemberInfo();
        
        
        
        
        wb_Member__c member = wb_Membership_Test.CreateMember();
        
        if ( member != null) {
            
             request = new RestRequest();
            
            request.requestUri = 'https://cs72.salesforce.com/services/apexrest/2ndPhs/MobileAppLogin/MemberNo=' + member.f_MemberNo__c;
            request.httpMethod = 'GET';
            RestContext.request = request;
            
            wb_soap_MobileAppLogin_2ndPhs.getMemberLoginInfo();
            
            request = new RestRequest();
            request.requestUri ='curl https://cs72.salesforce.com/services/apexrest/2ndPhs/MobileAppMemberInfo/Id=' +member.id ;
            request.httpMethod = 'GET';
            RestContext.request = request;
            
            wb_soap_MobileAppMemberInfo_2ndPhs.getMemberInfo();
            
        }
        
        
    }
    
     @isTest static void testMobileAppMemberInfoInsurance() {
         
         Account theCompany = createtestCompany();
         ContractInfo__c theContract = createtestContract(theCompany);

         MemberInfo__c theMemberHC = createtestMember(theCompany, theContract);
         MemberInfo__c theMemberCB = createtestMember(theCompany, theContract);
         MemberInfo__c theMemberML = createtestMember(theCompany, theContract);
         MemberInfo__c theMemberOMS = createtestMember(theCompany, theContract);
         FamilyInfo__c theFamilyOMS = createtestFamily(theCompany, theMemberOMS);
         
         BuyInsurace(theMemberHC,'Happy China',date.parse('2018/10/15'),date.parse('2018/10/15'),date.parse('2019/10/14'),null);
         
         BuyInsurace(theMemberCB,'チャイナボウル',date.parse('2018/10/15'),date.parse('2018/10/15'),date.parse('2019/10/14'),null);
         
         BuyInsurace(theMemberML,'Medi Life',date.parse('2018/10/15'),date.parse('2018/10/15'),date.parse('2019/10/14'),null);
         BuyInsurace(theMemberOMS,'OM-S',date.parse('2018/10/15'),date.parse('2018/10/15'),date.parse('2019/10/14'),null);
         BuyInsurace(theFamilyOMS,'OM-S',date.parse('2018/10/15'),date.parse('2018/10/15'),date.parse('2019/10/14'),null);
         
       	 RestRequest request = new RestRequest();
         
         request = new RestRequest();
         request.requestUri ='curl https://cs72.salesforce.com/services/apexrest/2ndPhs/MobileAppMemberInfo/Id=' +theMemberHC.id ;
         request.httpMethod = 'GET';
         RestContext.request = request;
         
         wb_soap_MobileAppMemberInfo_2ndPhs.getMemberInfo();
         
         
         request = new RestRequest();
         request.requestUri ='curl https://cs72.salesforce.com/services/apexrest/2ndPhs/MobileAppMemberInfo/Id=' +theMemberCB.id ;
         request.httpMethod = 'GET';
         RestContext.request = request;
         
         wb_soap_MobileAppMemberInfo_2ndPhs.getMemberInfo();
         
         request = new RestRequest();
         request.requestUri ='curl https://cs72.salesforce.com/services/apexrest/2ndPhs/MobileAppMemberInfo/Id=' +theMemberML.id ;
         request.httpMethod = 'GET';
         RestContext.request = request;
         
         wb_soap_MobileAppMemberInfo_2ndPhs.getMemberInfo();
         
         request = new RestRequest();
         request.requestUri ='curl https://cs72.salesforce.com/services/apexrest/2ndPhs/MobileAppMemberInfo/Id=' +theMemberOMS.id ;
         request.httpMethod = 'GET';
         RestContext.request = request;
         
         wb_soap_MobileAppMemberInfo_2ndPhs.getMemberInfo();
         
         
     }
    
      @isTest static void testMobileAppMemberInfoUpdate() {
          
          Account theCompany = createtestCompany();
          ContractInfo__c theContract = createtestContract(theCompany);
          MemberInfo__c theMember = createtestMember(theCompany, theContract);
          FamilyInfo__c theFamily = createtestFamily(theCompany, theMember);
          
          
          RestRequest request = new RestRequest();
          request.requestUri ='curl https://cs72.salesforce.com/services/apexrest/2ndPhs/MobileAppMemberInfo/';
          request.httpMethod = 'PATCH';
      //    request.addHeader('Content-Type', 'application/json');
        //  request.requestBody = Blob.valueOf('{"MemberId": "' + theMember.id+ '", "NewEmail": "mail@wellbemedic.com"}');
          // RestContext.request = request;
          wb_soap_MobileAppMemberInfo_2ndPhs.MyInfo MyInfo = new wb_soap_MobileAppMemberInfo_2ndPhs.MyInfo();
          MyInfo.Address ='abc';
           MyInfo.MailDelivery = false;

          wb_soap_MobileAppMemberInfo_2ndPhs.updateContacts(theMember.id, MyInfo, null);
          
          
          
      }
        
    
      @isTest static void testMobileAppMembershipCheck() {
          Account theCompany = createtestCompany();
          ContractInfo__c theContract = createtestContract(theCompany);
          MemberInfo__c theMember = createtestMember(theCompany, theContract);
          FamilyInfo__c theFamily = createtestFamily(theCompany, theMember);
          MemberInfo__c theMemberHC = createtestMember(theCompany, theContract);
          MemberInfo__c theMemberCB = createtestMember(theCompany, theContract);
          MemberInfo__c theMemberML = createtestMember(theCompany, theContract);
          MemberInfo__c theMemberOMS = createtestMember(theCompany, theContract);
          

  
		        
        RestRequest request = new RestRequest();
        request.requestUri ='curl https://cs72.salesforce.com/services/apexrest/2ndPhs/MobileAppMembershipCheck/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"MemberId": "' + theMember.id+ '", "NewEmail": "mail@wellbemedic.com"}');
       // RestContext.request = request;
        
        List<wb_soap_MobileAppMembershipCheck_2ndPhs.MemberID> Ids =  new   List<wb_soap_MobileAppMembershipCheck_2ndPhs.MemberID>();
        Ids.add( new wb_soap_MobileAppMembershipCheck_2ndPhs.MemberID(String.valueof(theMember.id)));
           Ids.add( new wb_soap_MobileAppMembershipCheck_2ndPhs.MemberID(String.valueof(theFamily.id)));
              Ids.add( new wb_soap_MobileAppMembershipCheck_2ndPhs.MemberID('aaa'));
       // Ids.add(theFamily.id);
        wb_soap_MobileAppMembershipCheck_2ndPhs.getMembershipStatus(Ids);
          

              
          request = new RestRequest();
          request.requestUri ='https://cs72.salesforce.com/services/apexrest/2ndPhs/MobileAppMembershipCheck/?type=M' ;
          request.httpMethod = 'GET';
          RestContext.request = request;
         
         wb_soap_MobileAppMembershipCheck_2ndPhs.getMembershipStatusParam();
          
      }
        
    /*
        @isTest static void testAffiliatedHospital() {
        createtestAffiliatedHospital();
        
        
        RestRequest request = new RestRequest();
        
        request.requestUri = 'https://cs72.salesforce.com/services/apexrest/2ndPhs/AffiliatedHospital/?HospitalName=ウェルビー' ;
        request.httpMethod = 'GET';
        RestContext.request = request;
        
        wb_soap_AffiliatedHospital_2ndPhs.getAffiliatedHospitalInfo();
        
    }
    */
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
    
    static void BuyInsurace( MemberInfo__c m, 
                            string theInsuranceName, date InitialDate, date theStartDate, date theEndDate, string policyNo)
    {
        MemberInfo__c theMember = [select id, InsuranceKind__c, Shonendo_Shiki__c, OtaInsuranceShiki__c, OtaInsuranceShuki__c, ShokenNo__c, MedicalBillKessaiHouhou__c
                                   from MemberInfo__c where id =:m.id];   
        if (theInsuranceName =='OM-S'){
            theMember.MedicalBillKessaiHouhou__c = 'OM-S';
             theMember.InsuranceKind__c = 'OM-S';
        } else
        theMember.InsuranceKind__c = theInsuranceName;
        theMember.Shonendo_Shiki__c = InitialDate;
        theMember.OtaInsuranceShiki__c = theStartDate;
        theMember.OtaInsuranceShuki__c = theEndDate;
        theMember.ShokenNo__c = policyNo;
        
        update theMember;
        
    }
    
    static void BuyInsurace( FamilyInfo__c m, 
                            string theInsuranceName, date InitialDate, date theStartDate, date theEndDate, string policyNo)
    {
        FamilyInfo__c theMember = [select id, InsuranceKind__c, Shonendo_Shiki__c, OtaInsuranceShiki__c, OtaInsuranceShuki__c, ShokenNo__c, MedicalBillKessaiHouhou__c
                                   from FamilyInfo__c where id =:m.id];   
        if (theInsuranceName =='OM-S'){
            theMember.MedicalBillKessaiHouhou__c = 'OM-S';
            theMember.InsuranceKind__c = 'OM-S';
        } else
            theMember.InsuranceKind__c = theInsuranceName;
        theMember.Shonendo_Shiki__c = InitialDate;
        theMember.OtaInsuranceShiki__c = theStartDate;
        theMember.OtaInsuranceShuki__c = theEndDate;
        theMember.ShokenNo__c = policyNo;
        
        update theMember;
        
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
    
        static AffiliatedHospital__c createtestAffiliatedHospital(){
        
        
        AffiliatedHospital__c AH = 
            new AffiliatedHospital__c (CONTRACT_HOSPITALNAME__C='City International Hospital copy1',
                                       CONTRACT_HOSPITALADDRESS__C='Hi-Tech Healthcare Park, 532A Kinh Duong Vuong, Binh Tri Dong B ward, Binh Tan district, Ho Chi Minh city, Vietnam',
                                       POST_HP__C = true,
                                       FILING_COUNTRY__C='VND',
                                       CONTRACT_MAILHAISHIN__C = false,
                                       CONTRACT_COUNTRY__C ='ベトナム',
                                       CONTRACT_AREA__C ='アジア',
                                       CONTRACT_ZONE__C ='ホーチミン',
                                       CONTRACT_HOSPITALTEL__C='+84 8-6280-3333',
                                       CONTRACT_NAME__C='City International Hospital Company Limited',
                                       CONTRACT_CATEGORY__C='総合',
                                       CONTRACT_TYPE__C ='通常キャッシュレス',
                                       HOSPITAL_ADDRESS__C='03, 17A Street, Binh Tri Dong B, Tan Binh District, Ho Chi Minh, Vietnam');
        insert AH;
        
        return AH;
    }
    
    


}