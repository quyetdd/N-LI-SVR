public class TestUtil {

  static testMethod void TestUtil_Test()
  {
    Account kinmu = createTestAccount();
    Account keiyakuCompany = createTestAccount();
    ContractInfo__c keiyaku = createTestContract(keiyakuCompany);
    MemberInfo__c m = createTestMemberInfo(kinmu.Id, keiyaku.Id, keiyakuCompany.Id);
    Ichiroheian__c i = createTestIchiroheian(keiyakuCompany.Id);
    BL__c bl = createTestBL(keiyakuCompany.Id);
    Kenshin__c k = createTestKenshin(m.Id);
    AffiliatedCompany__c gp = createTestGroup();
  }

  static public Account createTestAccount()
  {
    return createTestAccount('Test');
  }
  
  static public Account createTestAccount(string name)
  {
    Account ac = new Account();
    ac.Name = name;
    insert(ac);
    return ac;
  }
    
    static public ContractInfo__c createTestContract(string company)
    {
        ContractInfo__c ci = new ContractInfo__c();
        ci.KeiyakuCompanyName__c = company;
        ci.KeiyakuDate__c = system.today();
        ci.MankiDate__c = system.today().addYears(1);
        insert(ci);
        return ci;
    }
  
  static public ContractInfo__c createTestContract(Account company)
  {
	return createTestContract(company.id);
  }
  
  static public MemberInfo__c createTestMemberInfo(string kinmu, string keiyaku, string keiyakuCompany)
  {
    MemberInfo__c mi = new MemberInfo__c();
    mi.Name = 'TEST';
    mi.SeiRoma__c = 'Test';
    mi.MeiRoma__c = 'Test';
    mi.KinmuCompany__c = kinmu;
    mi.KeiyakuCompanyName__c = keiyakuCompany;
    mi.KeiyakuKeitai__c = '法人／家族Asian';
    mi.Commodity__c ='留学生';
    mi.CompanyKeiyakuNo__c = keiyaku;
    mi.MankiDate__c = system.today().addYears(1);
    //mi.OtaAgency__c = 'test';
    mi.TaikaiDate__c = null;
    insert(mi);
    return mi;
  }
    
    static public MemberInfo__c createTestMemberInfo(string kinmu, string keiyaku, string keiyakuCompany, string KeiyakuKeitai)
  {
    MemberInfo__c mi = new MemberInfo__c();
    mi.Name = 'TEST';
    mi.SeiRoma__c = 'Test';
    mi.MeiRoma__c = 'Test';
    mi.KinmuCompany__c = kinmu;
    mi.KeiyakuCompanyName__c = keiyakuCompany;
    mi.KeiyakuKeitai__c = KeiyakuKeitai;
    mi.Commodity__c ='メディック';
    mi.CompanyKeiyakuNo__c = keiyaku;
    mi.MankiDate__c = system.today().addYears(1);
    //mi.OtaAgency__c = 'test';
    mi.TaikaiDate__c = null;
      mi.CountryName__c ='日本';
    insert(mi);
    account kimu = [select id, CountryCd__c from account where id =:kinmu];
    system.debug(kimu);
      
    mi = [select id, MemberNo__c, Name, SeiRoma__c, MeiRoma__c, KinmuCompany__c, KeiyakuCompanyName__c, KeiyakuKeitai__c, Commodity__c,
        CompanyKeiyakuNo__c, MankiDate__c, TaikaiDate__c
        from MemberInfo__c where id =: mi.id];
    return mi;
  }
  
  
  static public FamilyInfo__c createTestFamilyInfo(string member)
  {
    FamilyInfo__c fi = new FamilyInfo__c();
    fi.Name = 'TEST';
    fi.MemberShimei__c = member;
    //fi.OtaName__c ='test';
    //fi.InsuranceKind__c = 'test';
    fi.TaikaiDate__c = null;
    insert(fi);
    return fi;
  }
  
  
  static public Ichiroheian__c createTestIchiroheian(string keiyakuCompany)
  {
    Ichiroheian__c i = new Ichiroheian__c();
    i.Name = 'Test';
    i.KeiyakuCompanyName__c = keiyakuCompany;
    i.OI_KeiyakuCompanyName__c = keiyakuCompany;
    i.OI_InsuranceShuki__c = system.today();
    i.InsuranceShuki__c = system.today();
    i.ShiyoCompanyName__c = keiyakuCompany;
    i.OI_KeiyakuArea__c = '上海';
    i.Seat__c = 4;
    i.OwnerKubun__c = '所有';
    insert(i);
    return i;
  }
  
  static public BL__c createTestBL(string ac)
  {
    BL__c bl = new BL__c();
    bl.Insurant__c = ac;
    bl.InsuranceManki__c = system.today();
    insert(bl);
    return bl;
  }
  
  static public Kenshin__c createTestKenshin(string member)
  {
    Kenshin__c k = new Kenshin__c();
    k.MemberShimei__c = member;
    date sd = date.newInstance(system.today().year()-1, 1, 1);
    k.KenshinDate__c = sd;
    insert(k);
    return k;
  }
  
  static public AffiliatedCompany__c createTestGroup()
  {
    AffiliatedCompany__c gp = new AffiliatedCompany__c();
    gp.Name = 'Test';
    insert(gp);
    return gp;
  }

   static public Shimei__c createShimei(string name, string Cd, string SeiRoma, string MeiRoma,
                                       string EmploymentSystem, string CompanyName, string Field1,
                                       string Busho, string Shokumu, string Field2,
                                       string KinmuArea, date NyusyaDate, string Sex,
                                       string Nationality, date DateOfBirth )
   {
       Shimei__c staff = new Shimei__c(name =name,Cd__c=Cd, SeiRoma__c =SeiRoma,
                                       MeiRoma__c=MeiRoma, EmploymentSystem__c=EmploymentSystem,
                                       CompanyName__c=CompanyName, Field1__c =Field1 , 
                                       Busho__c=Busho, Shokumu__c=Shokumu, Field2__c=Field2,
                                       KinmuArea__c=KinmuArea, NyusyaDate__c=NyusyaDate, Sex__c = Sex, 
                                       Nationality__c = Nationality, DateOfBirth__c = DateOfBirth);
       insert(staff);
       return staff;
   }
    
    
    static public Account CreateCompany(string theName,string CompanyNameEng,string Region_and_Area,
                                 string CountryName,string Jurisdiction,string ShozokuArea  )
    {
        Account theCompany = new Account ( Name = theName,
                                          CompanyNameEng__c =CompanyNameEng,
                                          Region_and_Area__c=Region_and_Area,
                                          CountryName__c=CountryName,
                                          Jurisdiction__c=Jurisdiction,
                                          ShozokuArea__c=ShozokuArea
                                          // CountryCode__c=CountryCode
                                         );
        insert theCompany;
        
        
        return [select id, Name, CompanyNameEng__c, Region_and_Area__c , CountryName__c, Jurisdiction__c, ShozokuArea__c, 
                CountryCd__c from account where id =: theCompany.id
               ];
        
    }
    
        static public Account CreateCompany(string theName,string CompanyNameEng,string Region_and_Area,
                                 string CountryName,string Jurisdiction,string ShozokuArea, string  CountryCode )
    {
        Account theCompany = new Account ( Name = theName,
                                          CompanyNameEng__c =CompanyNameEng,
                                          Region_and_Area__c=Region_and_Area,
                                          CountryName__c=CountryName,
                                          Jurisdiction__c=Jurisdiction,
                                          ShozokuArea__c=ShozokuArea
                                          // CountryCode__c=CountryCode
                                         );
        insert theCompany;
        
        
        return [select id, Name, CompanyNameEng__c, Region_and_Area__c , CountryName__c, Jurisdiction__c, ShozokuArea__c, 
                CountryCd__c from account where id =: theCompany.id
               ];
        
    }
    
    static public void createService(){
        
        List<wb_Service__c> Service = new List<wb_Service__c>();
        
        Service.add( new wb_Service__c ( SERVICE__C = 'Global',CARDPREFIX__C='',CURRENCY__C='USD',SERVICEFEE__C=120,
                                        DISCOUNTABLE__C=FALSE,DATATYPE__C='入会金',SERVICECLASSIFICATION__C='会員',
                                        ENABLE__C=TRUE));
        Service.add( new wb_Service__c ( SERVICE__C = 'Biz Trip Pass',CARDPREFIX__C='1',CURRENCY__C='USD',SERVICEFEE__C=300,
                                        DISCOUNTABLE__C=TRUE,DATATYPE__C='無記名',SERVICECLASSIFICATION__C='会員',
                                        ENABLE__C=TRUE));
        Service.add( new wb_Service__c ( SERVICE__C = 'Global Member',CARDPREFIX__C='1',CURRENCY__C='USD',SERVICEFEE__C=100,
                                        DISCOUNTABLE__C=FALSE,DATATYPE__C='家族',SERVICECLASSIFICATION__C='会員',
                                        ENABLE__C=TRUE));
        Service.add( new wb_Service__c ( SERVICE__C = 'Global Member',CARDPREFIX__C='1',CURRENCY__C='USD',SERVICEFEE__C=60,
                                        DISCOUNTABLE__C=FALSE,DATATYPE__C='単身',SERVICECLASSIFICATION__C='会員',
                                        ENABLE__C=TRUE));
        Service.add( new wb_Service__c ( SERVICE__C = 'Global Plus Member',CARDPREFIX__C='1',CURRENCY__C='USD',SERVICEFEE__C=500,
                                        DISCOUNTABLE__C=TRUE,DATATYPE__C='家族',SERVICECLASSIFICATION__C='会員',
                                        ENABLE__C=TRUE));
        Service.add( new wb_Service__c ( SERVICE__C = 'Global Plus Member',CARDPREFIX__C='1',CURRENCY__C='USD',SERVICEFEE__C=300,
                                        DISCOUNTABLE__C=TRUE,DATATYPE__C='単身',SERVICECLASSIFICATION__C='会員',
                                        ENABLE__C=TRUE));
        insert Service;
        //return Service;
    }
    
    static public void CreateCurrency(){
        List<wb_Currency__c> Curr = new List<wb_Currency__c>();
        Curr.add( new wb_Currency__c( CurrencySymbol__c='USD', Name='USD') );
        Curr.add( new wb_Currency__c( CurrencySymbol__c='JPY', Name='JPY') );
        insert Curr;
        // return Curr;
    }
    
    static public void CreateBudgetRate(){
        List<wb_BudgetRate__c> BRate = new List<wb_BudgetRate__c>();
        BRate.add( new wb_BudgetRate__c(FROMCURRENCY__C='USD',TOCURRENCY__C='JPY',
                                        FROMDATE__C=date.valueOf('2017-04-01'),TODATE__C=date.valueOf('2018-03-31'),RATE__C=110.7,
                                        YEARCEILINGUNIT__C=100.0,MONTHCEILINGUNIT__C=10.0));
        BRate.add( new wb_BudgetRate__c(FROMCURRENCY__C='USD',TOCURRENCY__C='JPY',
                                        FROMDATE__C=date.valueOf('2018-04-01'),TODATE__C=date.valueOf('2019-03-31'),RATE__C=112.75,
                                        YEARCEILINGUNIT__C=100.0,MONTHCEILINGUNIT__C=10.0));
        BRate.add( new wb_BudgetRate__c(FROMCURRENCY__C='USD',TOCURRENCY__C='USD',
                                        FROMDATE__C=date.valueOf('2017-04-01'),TODATE__C=date.valueOf('2018-03-31'),RATE__C=1,
                                        YEARCEILINGUNIT__C=null,MONTHCEILINGUNIT__C=null));
        BRate.add( new wb_BudgetRate__c(FROMCURRENCY__C='USD',TOCURRENCY__C='USD',
                                        FROMDATE__C=date.valueOf('2018-04-01'),TODATE__C=date.valueOf('2019-03-31'),RATE__C=1,
                                        YEARCEILINGUNIT__C=null,MONTHCEILINGUNIT__C=null));
        insert BRate;
        
       // return BRate;
    }
    
     static public void CreateCountryDistrict(){
        List<wb_CountryDistrict__c> CountryDistrict = new List<wb_CountryDistrict__c>();
        CountryDistrict.add( new wb_CountryDistrict__c(REGION__C='アジア',COUNTRY__C='中国',JURISDICTION__C='北京',
                                                       AFFILIATION__C='北京',SERVICE__C='MD'));
        CountryDistrict.add( new wb_CountryDistrict__c(REGION__C='アジア',COUNTRY__C='中国',JURISDICTION__C='上海',
                                                       AFFILIATION__C='上海',SERVICE__C='MD'));
        CountryDistrict.add( new wb_CountryDistrict__c(REGION__C='アジア',COUNTRY__C='中国',JURISDICTION__C='香港',
                                                       AFFILIATION__C='香港',SERVICE__C='MD'));
        CountryDistrict.add( new wb_CountryDistrict__c(REGION__C='アジア',COUNTRY__C='日本',JURISDICTION__C='東京',
                                                       AFFILIATION__C='東京',SERVICE__C='MD'));
        CountryDistrict.add( new wb_CountryDistrict__c(REGION__C='アジア',COUNTRY__C='インド',JURISDICTION__C='ニューデリー',
                                                       AFFILIATION__C='ニューデリー',SERVICE__C='MD'));
        
        CountryDistrict.add( new wb_CountryDistrict__c(District__c='東京',SERVICE__C='MD契約'));
        CountryDistrict.add( new wb_CountryDistrict__c(District__c='香港',SERVICE__C='MD契約'));
        CountryDistrict.add( new wb_CountryDistrict__c(District__c='ニューデリー',SERVICE__C='MD契約'));
    
		insert CountryDistrict;
      //  return CountryDistrict;
    }
    
    static public wb_Individual__c createMember( string Nm, Id WComp){
        wb_Individual__c theIndividual = new wb_Individual__c ( Name = Nm,
                                                               Sex__c ='男',
                                                               WorkingCompany__c=WComp,
                                                               FamilyNo__c='0'
                                                              );
        insert theIndividual;
        return theIndividual;
    }

    
    
    
}