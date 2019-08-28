public class CustomerData 
{ 
  public class NamedItem
  {
    private string m_value;
    
    public string Name { get; set; }
    public string Value 
    { 
      get { return m_value; }
      set { m_value = (value==null ? '' : value); } 
    }
    public NamedItem(string name, string value)
    {
      this.Name = name;
      this.Value = value; 
    }
  }

  public class AccountSelection
  {
    public boolean Selected {get; set;}
    public Account Acc { get; set;}
    public string Indent {get; set;}
    public boolean expandPlus {get; set;}
    public boolean isParent{get; set;}
    public boolean hasChild{get; set;}
    public AccountSelection(Account a, string indent)
    {
      this.Selected = false;
      this.Acc = a;
      this.Indent = indent;
      this.expandPlus = false;
      this.isParent = false;
      this.hasChild = true;
    }
  }
  
  public List<MemberHeader> Data { get; set; }
  public CustomerData()
  {
    Data = new List< MemberHeader >();
  }
  
  public class MemberHeader
  {
    public string KinmuCompanyId { get; set;}
    public integer Index { get; set;}
    public List<MemberInfo__c> Members { get; set; }
    public List<Ichiroheian__c> Ichiroheian {get ; set;}
    public List<BL__c> BL {get ; set;}
    public List<Kenshin__c> Kenshin {get ; set;}
    public List<Kenshin__c> KenshinLastYear {get ; set;}
    public List<Kenshin__c> KenshinName {get ; set;}
  
    public List<NamedItem> Values { get; set; }
    
    public Account KinmuCompany { get; set; }
    public ContractInfo__c Keiyaku { get; set; }
    public Account KeiyakuCompany { get; set; }
    
    public MemberHeader(Account okinmu, ContractInfo__c okeiyaku, Account okeiyakuCompany, boolean isEnglish)
    {
        KinmuCompany = okinmu;
        Keiyaku = okeiyaku;
        KeiyakuCompany = okeiyakuCompany;
    
        Values = new List<NamedItem>();
        Members = new List<MemberInfo__c>();
        Ichiroheian = new List< Ichiroheian__c>();
        BL = new List<BL__c>();
        Kenshin = new List<Kenshin__c>();
        KenshinLastYear = new List<Kenshin__c>();
        KenshinName = new List<Kenshin__c>();
        
        boolean bKinmuCompany = (KinmuCompany!=null);
        boolean bKeiyaku = (Keiyaku!=null);
        boolean bKeiyakuCompany = (KeiyakuCompany!=null);
        
        KinmuCompanyId = !bKinmuCompany ? '' : KinmuCompany.Id;
        Values.add(new NamedItem('KeiyakuArea', bKeiyaku ? Keiyaku.KeiyakuArea__c : '' ));
        Values.add(new NamedItem('KinmuCompanyJurisdiction', bKinmuCompany ? KinmuCompany.Jurisdiction__c : '' ));
        Values.add(new NamedItem('KinmuCompanyShozokuArea', bKinmuCompany ? KinmuCompany.ShozokuArea__c : '' ));//[72]
        
        if(isEnglish){
            Values.add(new NamedItem('KinmuCompany' , bKinmuCompany ? KinmuCompany.CompanyNameEng__c : '' ));
        }else{
            Values.add(new NamedItem('KinmuCompany' , bKinmuCompany ? KinmuCompany.Name : '' ));
        }
        Values.add(new NamedItem('KinmuCompanyAddress', bKinmuCompany ? KinmuCompany.OfficeAdd__c : '' ));
        Values.add(new NamedItem('KinmuCompanyPhone', bKinmuCompany ? KinmuCompany.Phone : '' ));
        Values.add(new NamedItem('KinmuCompanyFax', bKinmuCompany ? KinmuCompany.Fax : '' ));
        Values.add(new NamedItem('KinmuCompanyPresident', bKinmuCompany ? KinmuCompany.President__c : '' ));
        Values.add(new NamedItem('KinmuCompanyShimei', bKinmuCompany ? KinmuCompany.Shimei__c : '' ));
        Values.add(new NamedItem('KinmuCompanyBusho', bKinmuCompany ? KinmuCompany.Busho__c : '' ));
        Values.add(new NamedItem('KinmuCompanyYakushoku', bKinmuCompany ? KinmuCompany.Yakushoku__c : '' ));
        Values.add(new NamedItem('KinmuCompanySubShimei', bKinmuCompany ? KinmuCompany.SubShimei__c : '' ));
        Values.add(new NamedItem('KinmuCompanySubBusho', bKinmuCompany ? KinmuCompany.SubBusho__c : '' ));
        Values.add(new NamedItem('KinmuCompanySubYakushoku', bKinmuCompany ? KinmuCompany.SubYakushoku__c : '' ));
        if(isEnglish){
            Values.add(new NamedItem('KinmuCompanyEigyoTanto', bKinmuCompany ? (KinmuCompany.EigyoTanto__r==null ? '' : KinmuCompany.EigyoTanto__r.SeiMeiRoma__c) : '' ));
            Values.add(new NamedItem('KinmuCompanyNaimuTanto', bKinmuCompany ? (KinmuCompany.NaimuTanto__r==null ? '' : KinmuCompany.NaimuTanto__r.SeiMeiRoma__c) : '' ));
            Values.add(new NamedItem('KeiyakuCompanyName', bKeiyakuCompany ? KeiyakuCompany.CompanyNameEng__c : '' ));        
        }else{
            Values.add(new NamedItem('KinmuCompanyEigyoTanto', bKinmuCompany ? (KinmuCompany.EigyoTanto__r==null ? '' : KinmuCompany.EigyoTanto__r.Name) : '' ));
            Values.add(new NamedItem('KinmuCompanyNaimuTanto', bKinmuCompany ? (KinmuCompany.NaimuTanto__r==null ? '' : KinmuCompany.NaimuTanto__r.Name) : '' ));
            Values.add(new NamedItem('KeiyakuCompanyName', bKeiyakuCompany ? KeiyakuCompany.Name : '' ));
        }

        Values.add(new NamedItem('KeiyakuCompanyAddress', bKeiyakuCompany ? KeiyakuCompany.OfficeAdd__c : '' ));
        Values.add(new NamedItem('KeiyakuTel', bKeiyakuCompany ? KeiyakuCompany.Phone : '' ));
        Values.add(new NamedItem('KeiyakuFax', bKeiyakuCompany ? KeiyakuCompany.Fax : '' ));
        Values.add(new NamedItem('KeiyakuCompanyPresident', bKeiyakuCompany ? KeiyakuCompany.President__c : '' ));
        Values.add(new NamedItem('KeiyakuShimei', bKeiyakuCompany ? KeiyakuCompany.Shimei__c : '' ));
        Values.add(new NamedItem('KeiyakuBusho', bKeiyakuCompany ? KeiyakuCompany.Busho__c : '' ));
        Values.add(new NamedItem('KeiyakuYakushoku', bKeiyakuCompany ? KeiyakuCompany.Yakushoku__c : '' ));
        Values.add(new NamedItem('KeiyakuCompanySubShimei', bKeiyakuCompany ? KeiyakuCompany.SubShimei__c : '' ));
        Values.add(new NamedItem('KeiyakuCompanySubBusho', bKeiyakuCompany ? KeiyakuCompany.SubBusho__c : '' ));
        Values.add(new NamedItem('KeiyakuCompanySubYakushoku', bKeiyakuCompany ? KeiyakuCompany.SubYakushoku__c : '' ));
        
        if(isEnglish){
            Values.add(new NamedItem('KeiyakuEigyoTanto', bKeiyaku ? (Keiyaku.EigyoTanto__r==null ? '' : Keiyaku.EigyoTanto__r.SeiMeiRoma__c) : '' ));
            Values.add(new NamedItem('KeiyakuNaimuTanto', bKeiyaku ? (Keiyaku.NaimuTanto__r==null ? '' : Keiyaku.NaimuTanto__r.SeiMeiRoma__c) : '' ));        
            Values.add(new NamedItem('SeikyuCompanyName', bKeiyaku ? (Keiyaku.SeikyuCompanyName__r==null ? '' : Keiyaku.SeikyuCompanyName__r.CompanyNameEng__c ) : '' ));
            Values.add(new NamedItem('KeiyakuCompanyAffiliated', bKeiyakuCompany ? (KeiyakuCompany.AffiliatedCompanyName__r==null?'': KeiyakuCompany.AffiliatedCompanyName__r.AffiliatedCompanyNameEng__c) : '' ));
            Values.add(new NamedItem('KeiyakuCompanyGroupName', bKeiyakuCompany ? (KeiyakuCompany.GroupName__r==null?'': KeiyakuCompany.GroupName__r.GroupNameEng__c) : '' ));            
        }else{
            Values.add(new NamedItem('KeiyakuEigyoTanto', bKeiyaku ? (Keiyaku.EigyoTanto__r==null ? '' : Keiyaku.EigyoTanto__r.Name) : '' ));
            Values.add(new NamedItem('KeiyakuNaimuTanto', bKeiyaku ? (Keiyaku.NaimuTanto__r==null ? '' : Keiyaku.NaimuTanto__r.Name) : '' ));
            Values.add(new NamedItem('SeikyuCompanyName', bKeiyaku ? (Keiyaku.SeikyuCompanyName__r==null ? '' : Keiyaku.SeikyuCompanyName__r.Name) : '' ));
            Values.add(new NamedItem('KeiyakuCompanyAffiliated', bKeiyakuCompany ? (KeiyakuCompany.AffiliatedCompanyName__r==null?'': KeiyakuCompany.AffiliatedCompanyName__r.Name) : '' ));
            Values.add(new NamedItem('KeiyakuCompanyGroupName', bKeiyakuCompany ? (KeiyakuCompany.GroupName__r==null?'': KeiyakuCompany.GroupName__r.Name) : '' ));            
        }


    }
    
    public boolean Match(MemberHeader mh)
    {
        for(integer i=0; i<Values.size(); i++)
          if(Values[i].Value!=mh.Values[i].Value) return false;
        
        return true;
    }
  }
  
  
  
  
  
  static testMethod void CustomData_Test()
  {
    Account acKinmu = TestUtil.createTestAccount('KinmuTest');
    Account acKinmu2 = TestUtil.createTestAccount('KinmuTest2');
    Account acKeiyaku = TestUtil.createTestAccount('KeiyakuTest');
    Account acKeiyaku2 = TestUtil.createTestAccount('KeiyakuTest2');
    ContractInfo__c ci = TestUtil.createTestContract(acKeiyaku.Id);
    ContractInfo__c ci2 = TestUtil.createTestContract(acKeiyaku2.Id);
    Account acKeiyakuCompany = TestUtil.createTestAccount('KeiyakuCompanyTest');
    MemberInfo__c mi = TestUtil.createTestMemberInfo(acKinmu.Id, ci.Id, acKeiyakuCompany.Id);
    MemberInfo__c mi2 = TestUtil.createTestMemberInfo(acKinmu2.Id, ci2.Id, acKeiyakuCompany.Id);
    
    CustomerData cd = new CustomerData();   
    //MemberHeader mh = new MemberHeader(mi.KinmuCompany__r, mi.CompanyKeiyakuNo__r, mi.KeiyakuCompanyName__r);
    //MemberHeader mh2 = new MemberHeader(mi2.KinmuCompany__r, mi2.CompanyKeiyakuNo__r, mi2.KeiyakuCompanyName__r);
    //cd.Data.add(mh);
    //mh.Match(mh);
    //mh.Match(mh2);
  
 
    NamedItem ni = new NamedItem('Test','Test') ;
    string s;
    
    s = ni.Name;
    ni.Name = s;
    s = ni.Value;
    ni.Value = s;
    
    Account ac = TestUtil.createTestAccount();
    AccountSelection acs = new AccountSelection(ac, 'test');
    s = acs.Indent;
    acs.Indent = s;
    ac = acs.Acc;
    acs.Acc = ac;
    Boolean b;
    b = acs.Selected;
    acs.Selected = b;
  }
  
}