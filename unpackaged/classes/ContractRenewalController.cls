public class ContractRenewalController
{ 
  public date MankiDateN { get; set; }
  public integer KeitaiCdS1 { get; set; }
  public integer KeitaiCdF1 { get; set; }
  public integer KeitaiCdM1 { get; set; }
  public integer KeitaiCdS2 { get; set; }
  public integer KeitaiCdF2 { get; set; }
  public integer KeitaiCdM2 { get; set; }
  public integer KeitaiCdS3 { get; set; }
  public integer KeitaiCdF3 { get; set; }
  public integer KeitaiCdM3 { get; set; }
  public CustomerData Data { get; set; }
  public boolean IsPersonal {get; set; }
  public MemberInfo__c Member {get; set;}
  
  private ApexPages.StandardController m_con;
  private ContractInfo__c m_ci;
  
  private string m_selTemplate = '';
  private List<SelectOption> m_options = new List<SelectOption>();
  
  public ContractRenewalController(ApexPages.StandardController con)
  {
    
    m_con = con;
    m_ci = (ContractInfo__c)con.getRecord();
    IsPersonal = false;
    
    if(m_ci.KeiyakuCompanyName__r.Name.indexOf('個人契約')>=0)
    {
      IsPersonal = true;
      Member = [select Id, Name, Postcd__c, Address__c, Yakushoku__c, Tel__c, Fax__c, Email__c
        from MemberInfo__c 
        where (TaikaiDate__c=:null or TaikaiDate__c>:System.today()) 
        and MankiDate__c=:m_ci.MankiDate__c
        and CompanyKeiyakuNo__c=:m_ci.Id];
    }
    
    MankiDateN = m_ci.MankiDate__c.addYears(1);
    
    List<Document> ls = [select Id, Name from Document where Folder.Name='Renewal Form Template'];
    for(integer i=0; i<ls.size(); i++)
    {
      m_options.add(new SelectOption(ls[i].Id, ls[i].Name));
      if(m_selTemplate=='') m_selTemplate = ls[i].Id;
    }
  }
  
  public void Init()
  {
    List<MemberInfo__c> lmi = 
        [select Id, Name, MemberNo__c, Tanto__c, Commodity__c, ServiceKeitaiCd__c, KeiyakuKeitai__c, MankiDate__c, Address__c, KeitaiCd__c, IVPrintPositionCd__c,
        Tel__c, Mobile__c, OtaName__c, OtaAgency__c, ShokenNo__c, OtaInsuranceShuki__c, OtaRyaku__c,
        InsurancePlan__c, ShokenGetSituation__c, Email__c, MailHaishin__c, 
        
        CompanyKeiyakuNo__r.KeiyakuArea__c, 
        KinmuCompany__r.Jurisdiction__c,
        KinmuCompany__r.ShozokuArea__c, 
        
        KinmuCompany__r.Id, 
        KinmuCompany__r.Name, 
        KinmuCompany__r.OfficeAdd__c, 
        KinmuCompany__r.Phone,
        KinmuCompany__r.Fax, 
        KinmuCompany__r.President__c, 
        KinmuCompany__r.Shimei__c, 
        KinmuCompany__r.Busho__c, 
        KinmuCompany__r.Yakushoku__c, 
        KinmuCompany__r.SubShimei__c, 
        KinmuCompany__r.SubBusho__c,
        KinmuCompany__r.SubYakushoku__c,
        KinmuCompany__r.EigyoTanto__r.Name, 
        KinmuCompany__r.NaimuTanto__r.Name, 
        
        CompanyKeiyakuNo__r.KeiyakuCompanyName__r.Id,
        CompanyKeiyakuNo__r.KeiyakuCompanyName__r.Name,
        CompanyKeiyakuNo__r.KeiyakuCompanyName__r.OfficeAdd__c,
        CompanyKeiyakuNo__r.KeiyakuCompanyName__r.Phone,
        CompanyKeiyakuNo__r.KeiyakuCompanyName__r.Fax,
        CompanyKeiyakuNo__r.KeiyakuCompanyName__r.President__c,
        CompanyKeiyakuNo__r.KeiyakuCompanyName__r.Shimei__c,
        CompanyKeiyakuNo__r.KeiyakuCompanyName__r.Busho__c,
        CompanyKeiyakuNo__r.KeiyakuCompanyName__r.Yakushoku__c,
        CompanyKeiyakuNo__r.KeiyakuCompanyName__r.SubShimei__c,
        CompanyKeiyakuNo__r.KeiyakuCompanyName__r.SubBusho__c,
        CompanyKeiyakuNo__r.KeiyakuCompanyName__r.SubYakushoku__c,
        CompanyKeiyakuNo__r.EigyoTanto__r.Name, 
        CompanyKeiyakuNo__r.NaimuTanto__r.Name,
        
        CompanyKeiyakuNo__r.SeikyuCompanyName__r.Name, 
        CompanyKeiyakuNo__r.KeiyakuCompanyName__r.AffiliatedCompanyName__r.Name,
        CompanyKeiyakuNo__r.KeiyakuCompanyName__r.GroupName__r.Name,
        
            (select Id, MemberNo__c, Name, Commodity__c, KeiyakuKeitai__c, Mobile__c,
            OtaName__c, OtaAgency__c, ShokenNo__c, OtaInsuranceShuki__c, MemberShimei__c, OtaRyaku__c,
            ShokenGetSituation__c, Email__c, MailHaishin__c
            from FamilyMembers__r
            where (TaikaiDate__c=:null or TaikaiDate__c>:m_ci.MankiDate__c) 
            order by MemberNo__c)
        from MemberInfo__c
        where (TaikaiDate__c=:null or TaikaiDate__c>:m_ci.MankiDate__c) 
        and MankiDate__c=:m_ci.MankiDate__c
        and CompanyKeiyakuNo__c=:m_ci.Id
        order by MemberNo__c];
    
    Data = new CustomerData();
    KeitaiCdS1 = 0;
    KeitaiCdF1 = 0;
    KeitaiCdM1 = 0;
    KeitaiCdS2 = 0;
    KeitaiCdF2 = 0;
    KeitaiCdM2 = 0;
    KeitaiCdS3 = 0;
    KeitaiCdF3 = 0;
    KeitaiCdM3 = 0;
    for(integer i=0; i<lmi.size(); i++)
    {
        MemberInfo__c m = lmi[i];
        if(m.KeitaiCd__c=='S' && m.IVPrintPositionCd__c=='1')
          KeitaiCdS1 = KeitaiCdS1 + 1;
        else if(m.KeitaiCd__c=='F'&& m.IVPrintPositionCd__c=='1')
          KeitaiCdF1 = KeitaiCdF1 + 1;
        else if(m.KeitaiCd__c=='M'&& m.IVPrintPositionCd__c=='1')
          KeitaiCdM1 = KeitaiCdM1 + 1;
        else if(m.KeitaiCd__c=='S'&& m.IVPrintPositionCd__c=='2')
          KeitaiCdS2 = KeitaiCdS2 + 1;
        else if(m.KeitaiCd__c=='F'&& m.IVPrintPositionCd__c=='2')
          KeitaiCdF2 = KeitaiCdF2 + 1;
        else if(m.KeitaiCd__c=='M'&& m.IVPrintPositionCd__c=='2')
          KeitaiCdM2 = KeitaiCdM2 + 1;
        else if(m.KeitaiCd__c=='S'&& m.IVPrintPositionCd__c=='3')
          KeitaiCdS3 = KeitaiCdS3 + 1;
        else if(m.KeitaiCd__c=='F'&& m.IVPrintPositionCd__c=='3')
          KeitaiCdF3 = KeitaiCdF3 + 1;
        else if(m.KeitaiCd__c=='M'&& m.IVPrintPositionCd__c=='3')
          KeitaiCdM3 = KeitaiCdM3 + 1;  
    
        CustomerData.MemberHeader mh = new CustomerData.MemberHeader(m.KinmuCompany__r, m.CompanyKeiyakuNo__r, m.CompanyKeiyakuNo__r.KeiyakuCompanyName__r,false);
        boolean match = false;
        for(integer j=0; j<Data.Data.size(); j++)
        {
            if(mh.Match(Data.Data[j]))
            {
                Data.Data[j].Members.add(m);
                match = true;
                break;
            }
        }
        if(!match)
        {
            Data.Data.add(mh);
            mh.Index = Data.Data.size();
            mh.Members.add(m);
        }
    }
  }
  
  public string SelectedTemplate { get { return m_selTemplate; } set { m_selTemplate = value; } }
  public List<SelectOption> TemplateOptions { get { return m_options; } }
  public string SessionId { get { return UserInfo.getSessionId(); } }
  
  
  /*
  static testMethod void ContractRenewalController_Test()
  {
    AffiliatedCompany__c gp = TestUtil.createTestGroup();
    Account acKinmu = TestUtil.createTestAccount('KinmuTest');
    Account acKinmu2 = TestUtil.createTestAccount('KinmuTest2');
    Account acKeiyaku = TestUtil.createTestAccount('KeiyakuTest');
    Account acKeiyaku2 = TestUtil.createTestAccount('KeiyakuTest2');
    ContractInfo__c ci = TestUtil.createTestContract(acKeiyaku.Id);
    ContractInfo__c ci2 = TestUtil.createTestContract(acKeiyaku2.Id);
    Account acKeiyakuCompany = TestUtil.createTestAccount('KeiyakuCompanyTest');
    MemberInfo__c mi = TestUtil.createTestMemberInfo(acKinmu.Id, ci.Id, acKeiyakuCompany.Id);
    MemberInfo__c mi2 = TestUtil.createTestMemberInfo(acKinmu.Id, ci.Id, acKeiyakuCompany.Id);
    Ichiroheian__c i1 = TestUtil.createTestIchiroheian(acKeiyaku.Id);
    Ichiroheian__c i2 = TestUtil.createTestIchiroheian(acKeiyaku.Id);
    BL__c bl1 = TestUtil.createTestBL(acKeiyaku.Id);
    BL__c bl2 = TestUtil.createTestBL(acKeiyaku.Id);
    Kenshin__c k1 = TestUtil.createTestKenshin(mi.Id);
    Kenshin__c k2 = TestUtil.createTestKenshin(mi.Id);
    acKinmu.AffiliatedCompanyName__c = gp.Id;
    update(acKinmu);
    acKeiyaku.AffiliatedCompanyName__c = gp.Id;
    update(acKeiyaku);
    acKinmu2.AffiliatedCompanyName__c = gp.Id;
    update(acKinmu);
    acKeiyaku2.AffiliatedCompanyName__c = gp.Id;
    update(acKeiyaku);
    mi.KeiyakuKeitai__c = '法人／家族';
    mi.OtaAgency__c = 'WB扱い';
    mi.OtaInsuranceShuki__c = system.today();
    update(mi);
    mi2.KeiyakuKeitai__c = '法人／無記名';
    update(mi2);
    i1.OI_InsuranceShuki__c = system.today();
    update(i1);
    i2.OI_InsuranceShuki__c = system.today();
    update(i2);
    
    ci = [select Id, Name, KeiyakuCompanyName__r.Id, KeiyakuCompanyName__r.Name,
     MankiDate__c
     from ContractInfo__c where Id=:ci.Id];
    
    ApexPages.StandardController scon = new ApexPages.StandardController(ci); 
    ContractRenewalController con = new ContractRenewalController(scon);
    con.init();
  }*/
}