@isTest
public class wb_soap_MobileApp_2ndPhs_Test {
    
    
    @isTest static void testgetMemberLoginInfo() {
        Account theCompany = createtestCompany();
        ContractInfo__c theContract = createtestContract(theCompany);
        MemberInfo__c theMember = createtestMember(theCompany, theContract);
        FamilyInfo__c theFamily = createtestFamily(theCompany, theMember);
        
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
        
        
        theMember.OtaName__c ='株式会社損害保険ジャパン　香港支店';
        theMember.InsuranceKind__c ='チャイナボウル';
        update theMember;
        
        request = new RestRequest();
        request.requestUri ='curl https://cs72.salesforce.com/services/apexrest/2ndPhs/MobileAppMemberInfo/Id=' +theMember.id ;
        request.httpMethod = 'GET';
        RestContext.request = request;
        wb_soap_MobileAppMemberInfo_2ndPhs.getMemberInfo();
        
        theMember.OtaName__c ='United Insurance Company of Vietnam';
        theMember.InsuranceKind__c ='Medi Life';
        update theMember;
        
        request = new RestRequest();
        request.requestUri ='curl https://cs72.salesforce.com/services/apexrest/2ndPhs/MobileAppMemberInfo/Id=' +theMember.id ;
        request.httpMethod = 'GET';
        RestContext.request = request;
        wb_soap_MobileAppMemberInfo_2ndPhs.getMemberInfo();
        
        
        theMember.OtaName__c ='保険なし';
        theMember.InsuranceKind__c ='OM-S';
        theMember.OtaInsuranceShiki__c =  system.today();
        update theMember;
        
        request = new RestRequest();
        request.requestUri ='curl https://cs72.salesforce.com/services/apexrest/2ndPhs/MobileAppMemberInfo/Id=' +theMember.id ;
        request.httpMethod = 'GET';
        RestContext.request = request;
        wb_soap_MobileAppMemberInfo_2ndPhs.getMemberInfo();
        
        
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
        
        
        request = new RestRequest();
        request.requestUri ='curl https://cs72.salesforce.com/services/apexrest/2ndPhs/MobileAppMemberInfo/';
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"Id": "' + theMember.id+ '", "MyInfo": {"EmailAddress" : "kou-minamide@gate.sws.co.jp"},"Contacts" : null }');
        
        
        RestContext.request = request;
        // string myInfo = '{"EmailAddress" : "kou-minamide@gate.sws.co.jp","PostalCode" : "300161","Address" : "Nathan Road"}';
        wb_soap_MobileAppMemberInfo_2ndPhs.MyInfo myinfo = new wb_soap_MobileAppMemberInfo_2ndPhs.MyInfo();
        myInfo.EmailAddress ='kou-minamide@gate.sws.co.jp';
         myInfo.MailDelivery =true;
        wb_soap_MobileAppMemberInfo_2ndPhs.Contact Contact = new wb_soap_MobileAppMemberInfo_2ndPhs.Contact();
        
        Contact.ContactAddress_1='kou-minamide@gate.sws.co.jp';
        
        wb_soap_MobileAppMemberInfo_2ndPhs.updateContacts(theMember.id,myinfo,Contact);
        /*
        wb_Member__c member = wb_Membership_Test.CreateMember();
        
        if ( member != null) {
            
            request = new RestRequest();
            
            request.requestUri = 'https://cs72.salesforce.com/services/apexrest/2ndPhs/MobileAppMemberInfo/MemberNo=' + member.f_MemberNo__c;
            request.httpMethod = 'GET';
            RestContext.request = request;
            
            wb_soap_MobileAppLogin_2ndPhs.getMemberLoginInfo();
            
            request = new RestRequest();
            request.requestUri ='curl https://cs72.salesforce.com/services/apexrest/2ndPhs/MobileAppMemberInfo/Id=' +member.id ;
            request.httpMethod = 'GET';
            RestContext.request = request;
            
            wb_soap_MobileAppMemberInfo_2ndPhs.getMemberInfo();
            
            
			       
        }
	        
        
        List<wb_soap_MobileAppMembershipCheck_2ndPhs.MemberID> M = new List<wb_soap_MobileAppMembershipCheck_2ndPhs.MemberID>();
        
        M.add( new wb_soap_MobileAppMembershipCheck_2ndPhs.MemberID(member.id) );
        
        wb_soap_MobileAppMembershipCheck_2ndPhs.getMembershipStatus(M);     
        */
        
    }
    
    
    @isTest static void testAffiliatedHospital() {
        createtestAffiliatedHospital();
        
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();        
        
        
        req.requestURI = '/services/apexrest/2ndPhs/AffiliatedHospital/';  
        req.addParameter('HospitalName', 'ウェルビー');
        req.addParameter('isQueueOwner', 'false');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        wb_soap_AffiliatedHospital_2ndPhs.getAffiliatedHospitalInfo();
        
        req.requestURI = '/services/apexrest/2ndPhs/AffiliatedHospital/';  
        req.addParameter('Country', 'ベトナム');
        req.addParameter('isQueueOwner', 'false');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        wb_soap_AffiliatedHospital_2ndPhs.getAffiliatedHospitalInfo();
        
        
        req.requestURI = '/services/apexrest/2ndPhs/AffiliatedHospital/';  
        req.addParameter('PostRequestDate', '2018/01/01');
        req.addParameter('isQueueOwner', 'false');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        wb_soap_AffiliatedHospital_2ndPhs.getAffiliatedHospitalInfo();
        
        req.requestURI = '/services/apexrest/2ndPhs/AffiliatedHospital/';  
        req.addParameter('DeleteRequestDate', '2018/01/01');
        req.addParameter('isQueueOwner', 'false');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        wb_soap_AffiliatedHospital_2ndPhs.getAffiliatedHospitalInfo();
        
        
        // POST
         wb_soap_AffiliatedHospital_2ndPhs.SimularGroup G = new wb_soap_AffiliatedHospital_2ndPhs.SimularGroup();
        
            G.Area ='アジア';
            G.Country ='ベトナム';
            G.Region ='ベトナム';
            G.Zone ='ホーチミン';
            G.Category ='総合';

        List<wb_soap_AffiliatedHospital_2ndPhs.SimularHospital> R;
        
        R = wb_soap_AffiliatedHospital_2ndPhs.returnSimularHospitalInfo(G);
   // Hospital Order
   // 
   
        List<wb_soap_AffiliatedHospital_2ndPhs.HospitalOrder> HO = new  List<wb_soap_AffiliatedHospital_2ndPhs.HospitalOrder>();
        
        //List <AffiliatedHospital__c> AH = [select id from AffiliatedHospital__c];
        
        for ( AffiliatedHospital__c h: [select id from AffiliatedHospital__c]){
            wb_soap_AffiliatedHospital_2ndPhs.HospitalOrder ah = new wb_soap_AffiliatedHospital_2ndPhs.HospitalOrder();
            ah.Id = h.id;
            ah.SortOrder = 10;
            HO.add( ah );
        }
        
        wb_soap_AffiliatedHospital_2ndPhs.updateAffiliatedHospital(HO,null,null);
        
        List<wb_soap_AffiliatedHospital_2ndPhs.AffiliatedHospitalPatchDate> PD = new List<wb_soap_AffiliatedHospital_2ndPhs.AffiliatedHospitalPatchDate>();
        
        for ( AffiliatedHospital__c h: [select id from AffiliatedHospital__c]){
            wb_soap_AffiliatedHospital_2ndPhs.AffiliatedHospitalPatchDate ah = new wb_soap_AffiliatedHospital_2ndPhs.AffiliatedHospitalPatchDate();
            ah.Id = h.id;
            ah.theDate = date.parse('2019/01/01');
            PD.add( ah );
        }

        wb_soap_AffiliatedHospital_2ndPhs.updateAffiliatedHospital(null,PD,null);
        
        wb_soap_AffiliatedHospital_2ndPhs.updateAffiliatedHospital(HO,PD,null);
        
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
                                                     MeiKana__c='マサハル',
                                                     OtaName__c='中国人民保険',
                                                     OtaAgency__c='WB扱い',
                                                     Shonendo_Shiki__c= Date.valueOf('2017-01-02'),
                                                     OtaInsuranceShiki__c=  Date.valueOf('2017-11-01'),
                                                     OtaInsuranceShuki__c=Date.valueOf('2018-10-31'),
                                                     InsuranceKind__c='Happy China',
                                                     MEDICALBILLKESSAIHOUHOU__C ='ウェルビー現地医療保険'
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
                                       Contract_Region__c='ホーチミン',
                                       CONTRACT_HOSPITALTEL__C='+84 8-6280-3333',
                                       CONTRACT_NAME__C='City International Hospital Company Limited',
                                       CONTRACT_CATEGORY__C='総合',
                                       CONTRACT_TYPE__C ='通常キャッシュレス',
                                       HOSPITAL_ADDRESS__C='03, 17A Street, Binh Tri Dong B, Tan Binh District, Ho Chi Minh, Vietnam');
       // Contract_Region__c =:HGroup.Region  and Contract_Zone__c
        insert AH;
        
        return AH;
    }
    
    
    
}