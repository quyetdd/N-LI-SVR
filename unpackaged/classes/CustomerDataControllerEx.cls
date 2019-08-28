public class CustomerDataControllerEx
{

  private ApexPages.StandardController m_con;
  private Account m_ac;

  public List<CustomerData.AccountSelection> AccSelections { get; set; }
  public CustomerData Data { get; set; }
  public boolean DisableButtons { get { return AccSelections.size()<=0; } }
  public boolean forPrinting { get; set; }
  public boolean dataReady { get; set; }
  public boolean hasData { get { return data.data.size()>0; } }

  public CustomerDataControllerEx(ApexPages.StandardController con)
  {
    m_con = con;
    m_ac = (Account)m_con.getRecord();
  }
  
  public void init()
  {
    dataReady = false;
    AccSelections = new List<CustomerData.AccountSelection>();
    
    String userAgent = ApexPages.currentPage().getHeaders().get('USER-AGENT');
    if(!userAgent.contains('MSIE')) 
    {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'お使いのブラウザでは処理できません。'));
      //return;
    }
    
    try
    {
      AccSelections.add(new CustomerData.AccountSelection(getTopAccount(m_ac),''));
    }
    catch(Exception ex)
    {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '親会社取得時にエラーが発生しました。'));
      ApexPages.addMessages(ex);
    }
    
    try
    {
      appendChildAccount(AccSelections[0].Acc.Id, '');
    }
    catch(Exception ex)
    {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '子会社取得時にエラーが発生しました。'));
      ApexPages.addMessages(ex);
    }
  }
  
  public void checkAll()
  {
    for(integer i=0; i<AccSelections.size(); i++)
      AccSelections[i].Selected = true;
  }
  
  public void uncheckAll()
  {
    for(integer i=0; i<AccSelections.size(); i++)
      AccSelections[i].Selected = false;
  }
  
  public void Execute1()
  {
    forPrinting = false;
    dataReady = false;
    Execute();
  }
  
  public void Execute2()
  {
    forPrinting = true;
    dataReady = false;
    Execute();
  }
  
  private void Execute()
  {
    try
    {
    List<string> ids = getSelectedIds(AccSelections);

    //Member Data    

    List<MemberInfo__c> lmi = 
        [select Id, Name, MemberNo__c, Tanto__c, Commodity__c, ServiceKeitaiCd__c, InsuranceKind__c,InsuranceKindRyaku__c, KeiyakuKeitai__c, MankiDate__c, Address__c, 
        Tel__c, Mobile__c, OtaName__c, OtaAgency__c, ShokenNo__c, OtaInsuranceShuki__c, OtaRyaku__c,
        InsurancePlan__c, ShokenGetSituation__c, Email__c, MailHaishin__c, 
        
        CompanyKeiyakuNo__r.KeiyakuArea__c, 
        KinmuCompany__r.Jurisdiction__c, 
        KinmuCompany__r.ShozokuArea__c, //[72]
        
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
            ShokenGetSituation__c, Email__c, MailHaishin__c, InsurancePlan__c
            from FamilyMembers__r
            where (TaikaiDate__c=null or TaikaiDate__c>=:System.today()) 
            order by MemberNo__c)
        from MemberInfo__c
        where (TaikaiDate__c=null or TaikaiDate__c>:System.today()) 
        and KinmuCompany__c in :ids
        order by MemberNo__c];
    
    Data = new CustomerData();
    for(integer i=0; i<lmi.size(); i++)
    {
        CustomerData.MemberHeader mh = new CustomerData.MemberHeader(lmi[i].KinmuCompany__r, lmi[i].CompanyKeiyakuNo__r, lmi[i].CompanyKeiyakuNo__r.KeiyakuCompanyName__r,false);
        boolean match = false;
        for(integer j=0; j<Data.Data.size(); j++)
        {
            if(mh.Match(Data.Data[j]))
            {
                Data.Data[j].Members.add(lmi[i]);
                match = true;
                break;
            }
        }
        if(!match)
        {
            Data.Data.add(mh);
            mh.Index = Data.Data.size();
            mh.Members.add(lmi[i]);
        }
    }
    
    // 自動車関連
    
    List<Ichiroheian__c> lih = [select Id,
        OI_KeiyakuCompanyName__r.Id, KeiyakuCompanyName__r.Id, KeiyakuCompanyName__r.Name, 
        ShiyoCompanyName__r.Name, Name, Seat__c, OwnerKubun__c, InsuranceShuki__c,CancelDate__c,
        InsurancePlan__c, OI_CompanyName__c, OI_InsuranceShuki__c, OI_InsuranceCancel__c,
        VI_CompanyName__c, VI_InsuranceShuki__c,VI_InsuranceCancel__c,agency__c
        from Ichiroheian__c
        where (OI_KeiyakuCompanyName__c in :ids or KeiyakuCompanyName__c in :ids) and
        ((KeiyakuCompanyName__c in :ids and CancelDate__c=:null)
         or (OI_InsuranceShuki__c>=:system.today() and OI_InsuranceCancel__c=:null)
         or (VI_InsuranceShuki__c>=:system.today() and VI_InsuranceCancel__c=:null))
         order by agency__c,KeiyakuCompanyName__r.Name,InsurancePlan__c];

    for(integer i=0; i<lih.size(); i++)
    {
        for(integer j=0; j<Data.Data.size(); j++)
        {
            if((Data.Data[j].KinmuCompanyId==lih[i].OI_KeiyakuCompanyName__r.Id)||
               (Data.Data[j].KinmuCompanyId==lih[i].KeiyakuCompanyName__r.Id))
            {
              if((lih[i].insuranceShuki__c >= system.today() && lih[i].CancelDate__c == null)|| (lih[i].OI_InsuranceShuki__c >= system.today() && lih[i].OI_InsuranceCancel__c == null) || (lih[i].VI_InsuranceShuki__c >= system.today() && lih[i].VI_InsuranceCancel__c == null))
                {
                  if(lih[i].insuranceShuki__c < system.today() || lih[i].CancelDate__c != null)
                  {
                    lih[i].InsuranceShuki__c= null; 
                    lih[i].InsurancePlan__c= null; 
                  }
                  if(lih[i].OI_InsuranceShuki__c < system.today() || lih[i].OI_InsuranceCancel__c != null)
                  {
                    lih[i].OI_CompanyName__c= null; 
                    lih[i].OI_InsuranceShuki__c= null; 
                  }
                  if(lih[i].VI_InsuranceShuki__c < system.today() || lih[i].VI_InsuranceCancel__c != null)
                  {
                    lih[i].VI_CompanyName__c= null; 
                    lih[i].VI_InsuranceShuki__c= null; 
                  }
                  Data.Data[j].Ichiroheian.add(lih[i]);
                  break;
                }
                else
                  break;
            }
        }
    }
    
    // BL
    
    List<BL__c> lbl = [select Id,
        KeiyakuCompanyName__r.Id, KeiyakuCompanyName__r.Name, DPAppoint__c, ShozokuArea__c, KeiyakuArea__c,
        Agency__c, Insurant__r.Name, BranchOfInsurance__c, InsuranceCompanyName__c, InsuranceManki__c
        from BL__c
        where (KeiyakuCompanyName__c in :ids and CancelDate__c=:null)
        order by Agency__c, KeiyakuArea__c, ShozokuArea__c, KeiyakuCompanyName__r.Name];

    for(integer i=0; i<lbl.size(); i++)
    {
        for(integer j=0; j<Data.Data.size(); j++)
        {
            if(Data.Data[j].KinmuCompanyId==lbl[i].KeiyakuCompanyName__r.Id)
            {
                Data.Data[j].BL.add(lbl[i]);
                break;
            }
        }
    }
 
    // Kenshin
    date sd = date.newInstance(system.today().year(), 1, 1);
    date ed = date.newInstance(system.today().year()+1, 1, 1);
    List<string> mids = getMemberIds(Data);
    List<string> fids = getFamilyMemberIds(Data);
    List<Kenshin__c> lks = [select Id,
        MemberShimei__r.KinmuCompany__r.Id, MemberShimei__r.KinmuCompany__r.Name, MemberShimei__r.MemberKubunB__c, MemberFamilyShimei__r.MemberKubunB__c,
        MemberFamilyShimei__c, MemberFamilyShimei__r.Name, MemberFamilyShimei__r.MemberShimei__r.KinmuCompany__r.Id,
        MemberFamilyShimei__r.MemberShimei__r.KinmuCompany__r.Name, 
        MemberNo__c, MemberShimei__r.Name, KenshinArea__c, KenshinDate__c, KenshinPlan__c
        from Kenshin__c
        //where (MemberShimei__c in :mids or MemberFamilyShimei__c in :fids)
        where (MemberShimei__r.KinmuCompany__c in :ids or MemberFamilyShimei__r.MemberShimei__r.KinmuCompany__c in :ids)
        and (KenshinDate__c>=:sd)
        and (KenshinDate__c<:ed)
        and (CancelDate__c=:null)
        order by MemberNo__c];

    for(integer i=0; i<lks.size(); i++)
    {
        for(integer j=0; j<Data.Data.size(); j++)
        {
            if((Data.Data[j].KinmuCompanyId==lks[i].MemberShimei__r.KinmuCompany__r.Id) ||
               (Data.Data[j].KinmuCompanyId==lks[i].MemberFamilyShimei__r.MemberShimei__r.KinmuCompany__r.Id))
            {
                Data.Data[j].Kenshin.add(lks[i]);
                break;
            }
        }
    }  
    
    date sd2 = date.newInstance(system.today().year()-1, 1, 1);
    date ed2 = date.newInstance(system.today().year(), 1, 1); 
    List<Kenshin__c> lks2 = [select Id, MemberShimei__r.KinmuCompany__r.Id, MemberShimei__r.KinmuCompany__r.Name, MemberShimei__r.MemberKubunB__c, MemberFamilyShimei__r.MemberKubunB__c,
        MemberFamilyShimei__c, MemberFamilyShimei__r.Name, MemberFamilyShimei__r.MemberShimei__r.KinmuCompany__r.Id,
        MemberFamilyShimei__r.MemberShimei__r.KinmuCompany__r.Name, 
        MemberNo__c, MemberShimei__r.Name, KenshinArea__c, KenshinDate__c, KenshinPlan__c
        from Kenshin__c
        where (MemberShimei__r.KinmuCompany__c in :ids or MemberFamilyShimei__r.MemberShimei__r.KinmuCompany__c in :ids)
        and (KenshinDate__c>=:sd2)
        and (KenshinDate__c<:ed2)
        and (CancelDate__c=:null)
        order by MemberNo__c];

    for(integer i=0; i<lks2.size(); i++)
    {
        for(integer j=0; j<Data.Data.size(); j++)
        {
            if((Data.Data[j].KinmuCompanyId==lks2[i].MemberShimei__r.KinmuCompany__r.Id) ||
               (Data.Data[j].KinmuCompanyId==lks2[i].MemberFamilyShimei__r.MemberShimei__r.KinmuCompany__r.Id))
            {
                Data.Data[j].KenshinLastYear.add(lks2[i]);
                break;
            }
        }
    }
    
    List<Kenshin__c> lksName = [select Id, MemberShimei__r.KinmuCompany__r.Id, MemberShimei__r.KinmuCompany__r.Name, MemberShimei__r.MemberKubunB__c, MemberFamilyShimei__r.MemberKubunB__c,
        MemberFamilyShimei__c, MemberFamilyShimei__r.Name, MemberFamilyShimei__r.MemberShimei__r.KinmuCompany__r.Id,
        MemberFamilyShimei__r.MemberShimei__r.KinmuCompany__r.Name, 
        MemberNo__c, MemberShimei__r.Name, KenshinArea__c, KenshinDate__c, KenshinPlan__c
        from Kenshin__c
        where (MemberShimei__r.KinmuCompany__c in :ids or MemberFamilyShimei__r.MemberShimei__r.KinmuCompany__c in :ids)
        and (KenshinDate__c>=:sd2)
        and (KenshinDate__c<:ed)
        and (CancelDate__c=:null)
        order by MemberNo__c];

    for(integer i=0; i<lksName.size(); i++)
    {
        for(integer j=0; j<Data.Data.size(); j++)
        {
            if((Data.Data[j].KinmuCompanyId==lksName[i].MemberShimei__r.KinmuCompany__r.Id) ||
               (Data.Data[j].KinmuCompanyId==lksName[i].MemberFamilyShimei__r.MemberShimei__r.KinmuCompany__r.Id))
            {
                boolean isAdd = true;
                for(integer k=0; k<Data.Data[j].KenshinName.size(); k++)
                {
                  if(Data.Data[j].KenshinName[k].MemberNo__c == lksName[i].MemberNo__c)
                  {
                    isAdd = false;
                    break;
                  }
                }
                if(isAdd) 
                  Data.Data[j].KenshinName.add(lksName[i]);
                break;
            }
        }
    }   

    dataReady = true;
    }
    catch(Exception ex)
    {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '会員情報取得時にエラーが発生しました。'));
      ApexPages.addMessages(ex);
      dataReady = false;
    }
  }
  
  private List<string> getSelectedIds(List<CustomerData.AccountSelection> ls)
  {
    List<string> ids = new List<string>();
    for(integer i=0; i<ls.size(); i++)
      if(ls[i].Selected)
        ids.add(ls[i].Acc.Id);
    return ids;
  }
  
  private List<string> getMemberIds(CustomerData data)
  {
    List<string> ids = new List<string>();
    for(integer i=0; i<data.data.size(); i++)
        for(integer j=0; j<data.data[i].Members.size(); j++)
            ids.add(data.data[i].Members[j].Id);
    return ids;
  }
  
  private List<string> getFamilyMemberIds(CustomerData data)
  {
    List<string> ids = new List<string>();
    for(integer i=0; i<data.data.size(); i++)
        for(integer j=0; j<data.data[i].Members.size(); j++)
          for(integer k=0; k<data.data[i].Members[j].FamilyMembers__r.size(); k++)
            ids.add(data.data[i].Members[j].FamilyMembers__r[k].Id);
    return ids;
  }
  
  private Account getTopAccount(Account ac)
  {
    if(ac.ParentId==null) return ac;
    return getTopAccount(getAccount(ac.ParentId));
  }
  
  private Account getAccount(string id)
  {
    if((id==null)||(id=='')) return null;
    
    return [select Id, Name, ParentId, CompanyPopularName__c, CompanyCd__c, Jurisdiction__c
            from Account where Id=:id];
  }
  
  private void appendChildAccount(string parentId, string indent)
  {
    List<Account> la = getChildAccounts(parentId);
    string indentN = indent + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
    for(integer i=0; i<la.size(); i++)
    {
      AccSelections.add(new CustomerData.AccountSelection(la[i], indentN));
      appendChildAccount(la[i].Id, indentN);
    }
  }
  
  private List<Account> getChildAccounts(string parentId)
  {
    if((parentId==null)||(parentId=='')) return new List<Account>();
    
    return [select Id, Name, ParentId, CompanyPopularName__c, CompanyCd__c, Jurisdiction__c
            from Account where ParentId=:parentId order by CompanyCd__c];
  }
  
  
  /*
  static testMethod void CustomerDataControllerEx_Test()
  {
    Account ac = new Account();
    ac.Name = 'Test';
    insert(ac);
    
    //Account ac = [select Id, ParentId from Account where Id='001S000000E8sIe' limit 1];
    
    ApexPages.currentPage().getHeaders().put('USER-AGENT','MSIE');
    
    ApexPages.StandardController scon = new ApexPages.StandardController(ac); 
    CustomerDataControllerEx con = new CustomerDataControllerEx(scon);
    con.init();
    con.uncheckAll();
    con.checkAll();
    con.Execute1();
    con.Execute2();
  }
  */
  
}