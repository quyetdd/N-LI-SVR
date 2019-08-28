public class GroupReportController
{ 
  private ApexPages.StandardController m_con;
  private AffiliatedCompany__c m_group;
  public GroupData Data {get; set;}
  public List<GroupData.Row> Rows {get; set;}
  
  public GroupReportController(ApexPages.StandardController con)
  {
    m_con = con;
    m_group = (AffiliatedCompany__c)con.getRecord();
    Data = new GroupData();
    Rows = Data.Rows;
  }
  
  public void Init()
  {
    List<MemberInfo__c> members;
    List<string> mids = new List<string>();
    List<string> fids = new List<string>();

     List<Id> kids = new list<Id>();
    for(Account a : [select Id from Account where AffiliatedCompanyName__c=:m_group.Id])
        kids.add(a.Id);
    
    members = [select Id, KeiyakuKeitai__c, OtaAgency__c, OtaInsuranceShuki__c, (select Id from FamilyMembers__r), 
        KeiyakuCompanyName__r.Id, KeiyakuCompanyName__r.Name, 
        KinmuCompany__r.Id, KinmuCompany__r.Name, KinmuCompany__r.CompanyCd__c, KinmuCompany__r.ShozokuArea__c, KinmuCompany__r.EigyoTanto__r.Name
        from MemberInfo__c 
        where (KinmuCompany__c in :kids)
        and (TaikaiDate__c=:null or TaikaiDate__c>:system.today())
        order by KinmuCompany__r.CompanyCd__c, KeiyakuCompanyName__r.Name];
        
    GroupData.Row r = null;
    
    for(integer i=0; i<members.size(); i++)    
    {
      MemberInfo__c m = members[i]; 
      mids.add(m.Id);
      r = null;
      for(integer j=0; j<Rows.size(); j++)
      {
        if(Rows[j].Match(m.KinmuCompany__r, m.KeiyakuCompanyName__r))
        {
          r = Rows[j];
          break;
        }
      }
      if(r==null)
      {
        r = Data.addRow(m.KinmuCompany__r, m.KeiyakuCompanyName__r);
      }
            
      if(m.KeiyakuKeitai__c.indexOf('単身')>=0)
        r.KeitaiCdS = r.KeitaiCdS + 1;
      else if(m.KeiyakuKeitai__c.indexOf('家族')>=0)
        r.KeitaiCdF = r.KeitaiCdF + 1;
      else if(m.KeiyakuKeitai__c.indexOf('無記名')>=0)
        r.KeitaiCdM = r.KeitaiCdM + 1;
        
      if(m.FamilyMembers__r!=null)  
        for(integer j=0; j<m.FamilyMembers__r.size(); j++)
          fids.add(m.FamilyMembers__r[j].Id);
      
      if((m.OtaAgency__c=='WB扱い')&&(m.OtaInsuranceShuki__c>=system.today()))
        r.OtaAgency = true;
    }
      
    
    List< Ichiroheian__c> ics;
   
    ics = [select Id, 
        ShiyoCompanyName__r.Id, ShiyoCompanyName__r.Name, ShiyoCompanyName__r.CompanyCd__c,
        ShiyoCompanyName__r.ShozokuArea__c, ShiyoCompanyName__r.EigyoTanto__r.Name
        from Ichiroheian__c 
        where ShiyoCompanyName__c in :kids 
        and InsuranceShuki__c>=:system.today()
        and CancelDate__c=:null
        order by ShiyoCompanyName__r.CompanyCd__c];
        
    for(integer i=0; i<ics.size(); i++)    
    {
      Ichiroheian__c ic = ics[i]; 
      r = null;
      for(integer j=0; j<Rows.size(); j++)
      {
        if(Rows[j].Match(ic.ShiyoCompanyName__r))
        {
          r = Rows[j];
          r.Ichiroheian = r.Ichiroheian+1;
        }
      }
      if(r==null)
      {
        r = Data.addRow(ic.ShiyoCompanyName__r, ic.ShiyoCompanyName__r);
        r.Ichiroheian = r.Ichiroheian+1;
      }
    }
    
    
    ics = [select Id, 
        ShiyoCompanyName__r.Id, ShiyoCompanyName__r.Name, ShiyoCompanyName__r.CompanyCd__c,
        ShiyoCompanyName__r.ShozokuArea__c, ShiyoCompanyName__r.EigyoTanto__r.Name
        from Ichiroheian__c 
        where ShiyoCompanyName__c in :kids
        and (    (OI_InsuranceShuki__c>=:system.today() and OI_InsuranceCancel__c=:null)
              or (VI_InsuranceShuki__c>=:system.today() and VI_InsuranceCancel__c=:null) )
        order by ShiyoCompanyName__r.CompanyCd__c];
        
    for(integer i=0; i<ics.size(); i++)    
    {
      Ichiroheian__c ic = ics[i]; 
      r = null;
      for(integer j=0; j<Rows.size(); j++)
      {
        if(Rows[j].Match(ic.ShiyoCompanyName__r))
        {
          r = Rows[j];
          r.OIIchiroheian = r.OIIchiroheian+1;
        }
      }
      if(r==null)
      {
        r = Data.addRow(ic.ShiyoCompanyName__r, ic.ShiyoCompanyName__r);
        r.OIIchiroheian = r.OIIchiroheian+1;
      }
    }
    
    
    List<BL__c> bls = [select Id, 
        Insurant__r.Id, Insurant__r.Name, Insurant__r.CompanyCd__c,
        Insurant__r.ShozokuArea__c, Insurant__r.EigyoTanto__r.Name
        from BL__c
        where Insurant__c in :kids
        and CancelDate__c=:null and InsuranceManki__c>=:system.today()
        order by Insurant__r.CompanyCd__c];
    
    for(integer i=0; i<bls.size(); i++)    
    {
      BL__c bl = bls[i]; 
      r = null;
      for(integer j=0; j<Rows.size(); j++)
      {
        if(Rows[j].Match(bl.Insurant__r))
        {
          r = Rows[j];
          r.BL = true;
        }
      }
      if(r==null)
      {
        r = Data.addRow(bl.Insurant__r, bl.Insurant__r);
        r.BL = true;
      }
    }
      
      
    date sd = date.newInstance(system.today().year()-1, 1, 1);
    date ed = date.newInstance(system.today().year(), 1, 1);  
    List<Kenshin__c> kss;
    
    kss = [select Id,
        MemberShimei__r.KeiyakuCompanyName__r.Id, MemberShimei__r.KeiyakuCompanyName__r.Name, 
        MemberShimei__r.KinmuCompany__r.Id, MemberShimei__r.KinmuCompany__r.Name, 
        MemberShimei__r.KinmuCompany__r.ShozokuArea__c, MemberShimei__r.KinmuCompany__r.EigyoTanto__r.Name,
        MemberShimei__r.KinmuCompany__r.CompanyCd__c,
        MemberFamilyShimei__r.MemberShimei__r.KeiyakuCompanyName__r.Id, MemberFamilyShimei__r.MemberShimei__r.KeiyakuCompanyName__r.Name, 
        MemberFamilyShimei__r.MemberShimei__r.KinmuCompany__r.Id, MemberFamilyShimei__r.MemberShimei__r.KinmuCompany__r.Name, 
        MemberFamilyShimei__r.MemberShimei__r.KinmuCompany__r.CompanyCd__c,
        MemberFamilyShimei__r.MemberShimei__r.KinmuCompany__r.ShozokuArea__c, MemberFamilyShimei__r.MemberShimei__r.KinmuCompany__r.EigyoTanto__r.Name
        from Kenshin__c
        where (MemberShimei__r.KinmuCompany__c in :kids or MemberFamilyShimei__r.MemberShimei__r.KinmuCompany__c in :kids)
        and (KenshinDate__c>=:sd)
        and (KenshinDate__c<:ed)
        and (CancelDate__c=:null)];
        

    for(integer i=0; i<kss.size(); i++)    
    {
      Kenshin__c ks = kss[i]; 
      r = null;
      for(integer j=0; j<Rows.size(); j++)
      {
        if(ks.MemberShimei__r!=null)
        {
        
            if(Rows[j].Match(ks.MemberShimei__r.KinmuCompany__r))
            {
              r = Rows[j];
              r.Kenshin = r.Kenshin+1;
            }
        }
        else if(ks.MemberFamilyShimei__r!=null)
        {
            if(ks.MemberFamilyShimei__r.MemberShimei__r!=null)
                if(Rows[j].Match(ks.MemberFamilyShimei__r.MemberShimei__r.KinmuCompany__r))
                {
                  r = Rows[j];
                  r.Kenshin = r.Kenshin+1;
                }
        }
      }
      System.debug('r ' + r);
      if(r==null)
      {
      System.debug(ks.MemberShimei__r);
        if(ks.MemberShimei__r!=null){
          //system.debug('in first');
          r = Data.addRow(ks.MemberShimei__r.KinmuCompany__r, ks.MemberShimei__r.KinmuCompany__r);  
        }     
        else if(ks.MemberFamilyShimei__r!=null){
          system.debug('in second');
          r = Data.addRow(ks.MemberFamilyShimei__r.MemberShimei__r.KinmuCompany__r, ks.MemberFamilyShimei__r.MemberShimei__r.KinmuCompany__r);       
        }
        if(r!=null)
          r.Kenshin = r.Kenshin+1;
      }
    }
  }
  
  /*
  static testMethod void GroupReportController_Test()
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
      
    ApexPages.StandardController scon = new ApexPages.StandardController(gp);
    GroupReportController con = new GroupReportController(scon);
    con.init();
  
  }
  */
}