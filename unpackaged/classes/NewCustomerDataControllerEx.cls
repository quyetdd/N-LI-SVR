public class NewCustomerDataControllerEx
{

  private ApexPages.StandardController m_con;
  private Account m_ac;

  public List<CustomerData.AccountSelection> AccSelections { get; set; }
  public CustomerData Data { get; set; }
  public boolean DisableButtons { get { return AccSelections.size()<=0; } }
  public boolean forPrinting { get; set; }
  public boolean dataReady { get; set; }
  public boolean hasData { get { return data.data.size()>0; } }
  public boolean isEnglish {get; set;}
  public String accountId {get; set;}
  public String indent {get; set;}
  public String upIndent {get; set;}
  public boolean displayPlus {get; set;}
  public boolean displayMinus {get; set;}
  public String accountsId{get; set;}
  
  public NewCustomerDataControllerEx(ApexPages.StandardController con)
  {
    m_con = con;
    m_ac = (Account)m_con.getRecord();
    isEnglish = 'en_US'.equals(UserInfo.getLanguage());
    System.debug('isEnglish:' + isEnglish);
    displayPlus = true;
    displayMinus = false;    
  }
  
  public void init()
  {
    dataReady = false;
    AccSelections = new List<CustomerData.AccountSelection>();
    
    String userAgent = ApexPages.currentPage().getHeaders().get('USER-AGENT');
    System.debug('userAgent:' + userAgent);
    if(!userAgent.contains('MSIE') && !userAgent.contains('rv:11.0')) 
    {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.NotIEBrowser));
      //return;
    }
    
    /*
    try
    {
      AccSelections.add(new CustomerData.AccountSelection(getTopAccount(m_ac),''));
    }
    catch(Exception ex)
    {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.GetAccountError));
      ApexPages.addMessages(ex);
    }
    
    try
    {
      appendChildAccount(AccSelections[0].Acc.Id, '');
    }
    catch(Exception ex)
    {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.GetChildAccountError));
      ApexPages.addMessages(ex);
    }
    */
    
    //added by Patrick 20/4/2016
    //Find the parent of the company which you are standing on
    try
    {
        AccSelections.add(new CustomerData.AccountSelection(getParentAccount(m_ac),''));
        if(!(getParentAccount((getParentAccount(m_ac))) == getParentAccount(m_ac) || getParentAccount((getParentAccount(m_ac))) == m_ac)){
            AccSelections[0].isParent = true;
            AccSelections[0].expandPlus = true;
        }      
    }
    catch(Exception ex)
    {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.GetAccountError));
        ApexPages.addMessages(ex);
    }
    
    // append one level child
    try
    { 
        if(AccSelections[0].isParent == true){
            appendOneLevelChildAccount(AccSelections[0].Acc.Id,'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
        }
        else{
            appendOneLevelChildAccount(AccSelections[0].Acc.Id,' ');
        }
        AccSelections[0].expandPlus = true; // the top of the list always expend
        AccSelections = checkHaveChilds(AccSelections);
    }
    catch(Exception ex)
    {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.GetChildAccountError));
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
                [select Id, Name, MemberNo__c, Tanto__c, toLabel(Commodity__c), ServiceKeitaiCd__c, InsuranceKind__c,InsuranceKindRyaku__c, KeiyakuKeitai__c, MankiDate__c, Address__c, 
                 Tel__c, Mobile__c, toLabel(OtaName__c), OtaAgency__c, ShokenNo__c, OtaInsuranceShuki__c, OtaRyaku__c,
                 toLabel(InsurancePlan__c), ShokenGetSituation__c, Email__c, MailHaishin__c, SeiMeiRoma__c,
                 
                 toLabel(CompanyKeiyakuNo__r.KeiyakuArea__c), 
                 toLabel(KinmuCompany__r.Jurisdiction__c), 
                 toLabel(KinmuCompany__r.ShozokuArea__c), //[72]
                 
                 KinmuCompany__r.Id, 
                 KinmuCompany__r.Name,
                 KinmuCompany__r.CompanyNameEng__c, 
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
                 KinmuCompany__r.EigyoTanto__r.SeiMeiRoma__c, 
                 KinmuCompany__r.NaimuTanto__r.Name,
                 KinmuCompany__r.NaimuTanto__r.SeiMeiRoma__c, 
                 
                 CompanyKeiyakuNo__r.KeiyakuCompanyName__r.Id,
                 CompanyKeiyakuNo__r.KeiyakuCompanyName__r.Name,
                 CompanyKeiyakuNo__r.KeiyakuCompanyName__r.CompanyNameEng__c,
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
                 CompanyKeiyakuNo__r.EigyoTanto__r.SeiMeiRoma__c,  
                 CompanyKeiyakuNo__r.NaimuTanto__r.Name,
                 CompanyKeiyakuNo__r.NaimuTanto__r.SeiMeiRoma__c,
                 
                 CompanyKeiyakuNo__r.SeikyuCompanyName__r.Name,
                 CompanyKeiyakuNo__r.SeikyuCompanyName__r.CompanyNameEng__c, 
                 CompanyKeiyakuNo__r.KeiyakuCompanyName__r.AffiliatedCompanyName__r.Name,
                 CompanyKeiyakuNo__r.KeiyakuCompanyName__r.GroupName__r.Name,
                 CompanyKeiyakuNo__r.KeiyakuCompanyName__r.AffiliatedCompanyName__r.AffiliatedCompanyNameEng__c,
                 CompanyKeiyakuNo__r.KeiyakuCompanyName__r.GroupName__r.GroupNameEng__c,        
                 
                 (select Id, MemberNo__c, Name, toLabel(Commodity__c), KeiyakuKeitai__c, Mobile__c,
                  toLabel(OtaName__c), OtaAgency__c, ShokenNo__c, OtaInsuranceShuki__c, MemberShimei__c, OtaRyaku__c,
                  ShokenGetSituation__c, Email__c, MailHaishin__c, toLabel(InsurancePlan__c), SeiMeiRoma__c 
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
                CustomerData.MemberHeader mh = new CustomerData.MemberHeader(lmi[i].KinmuCompany__r, lmi[i].CompanyKeiyakuNo__r, lmi[i].CompanyKeiyakuNo__r.KeiyakuCompanyName__r,isEnglish);
                
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
            System.debug('ids:' + ids);
            List<Ichiroheian__c> lih = [select Id,
                                        OI_KeiyakuCompanyName__r.Id, KeiyakuCompanyName__r.Id, KeiyakuCompanyName__r.Name, KeiyakuCompanyName__r.CompanyNameEng__c, 
                                        ShiyoCompanyName__r.Name,ShiyoCompanyName__r.CompanyNameEng__c, Name, Seat__c, toLabel(OwnerKubun__c), InsuranceShuki__c,CancelDate__c,
                                        toLabel(InsurancePlan__c), toLabel(OI_CompanyName__c), OI_InsuranceShuki__c, OI_InsuranceCancel__c,
                                        toLabel(VI_CompanyName__c), VI_InsuranceShuki__c,VI_InsuranceCancel__c,toLabel(agency__c),WOAgency__c
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
                            System.debug('Data.Data[j].Ichiroheian:' + Data.Data[j].Ichiroheian);
                            break;
                        }
                        else
                            break;
                    }
                }
            }
            
            // BL
            
            List<BL__c> lbl = [select Id,KeiyakuCompanyName__r.Id, KeiyakuCompanyName__r.Name, KeiyakuCompanyName__r.CompanyNameEng__c, DPAppoint__c,toLabel(ShozokuArea__c),toLabel(KeiyakuArea__c),
                               toLabel(Agency__c), Insurant__r.Name, toLabel(BranchOfInsurance__c), toLabel(InsuranceCompanyName__c), InsuranceManki__c
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
            
            // 
            
            date sd = date.newInstance(system.today().year(), 1, 1);
            date ed = date.newInstance(system.today().year()+1, 1, 1);
            List<string> mids = getMemberIds(Data);
            List<string> fids = getFamilyMemberIds(Data);
            List<Kenshin__c> lks = [select Id,
                                    MemberShimei__r.KinmuCompany__r.Id, MemberShimei__r.KinmuCompany__r.Name, MemberShimei__r.KinmuCompany__r.CompanyNameEng__c, MemberShimei__r.MemberKubunB__c, MemberFamilyShimei__r.MemberKubunB__c,
                                    MemberFamilyShimei__c, MemberFamilyShimei__r.Name, MemberFamilyShimei__r.SeiMeiRoma__c ,MemberFamilyShimei__r.MemberShimei__r.KinmuCompany__r.Id,
                                    MemberFamilyShimei__r.MemberShimei__r.KinmuCompany__r.Name, MemberFamilyShimei__r.MemberShimei__r.KinmuCompany__r.CompanyNameEng__c, 
                                    MemberNo__c, MemberShimei__r.Name, MemberShimei__r.SeiMeiRoma__c ,KenshinArea__c, KenshinDate__c, KenshinPlan__c,KenshinPlan_new__c 
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
            List<Kenshin__c> lks2 = [select Id, MemberShimei__r.KinmuCompany__r.Id, MemberShimei__r.KinmuCompany__r.Name, MemberShimei__r.KinmuCompany__r.CompanyNameEng__c, MemberShimei__r.MemberKubunB__c, MemberFamilyShimei__r.MemberKubunB__c,
                                     MemberFamilyShimei__c, MemberFamilyShimei__r.Name, MemberFamilyShimei__r.SeiMeiRoma__c ,MemberFamilyShimei__r.MemberShimei__r.KinmuCompany__r.Id,
                                     MemberFamilyShimei__r.MemberShimei__r.KinmuCompany__r.Name, MemberFamilyShimei__r.MemberShimei__r.KinmuCompany__r.CompanyNameEng__c, 
                                     MemberNo__c, MemberShimei__r.Name, MemberShimei__r.SeiMeiRoma__c ,KenshinArea__c, KenshinDate__c, KenshinPlan__c,KenshinPlan_new__c 
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
            
            List<Kenshin__c> lksName = [select Id, MemberShimei__r.KinmuCompany__r.Id, MemberShimei__r.KinmuCompany__r.Name, MemberShimei__r.KinmuCompany__r.CompanyNameEng__c,MemberShimei__r.MemberKubunB__c, MemberFamilyShimei__r.MemberKubunB__c,
                                        MemberFamilyShimei__c, MemberFamilyShimei__r.Name, MemberFamilyShimei__r.SeiMeiRoma__c ,MemberFamilyShimei__r.MemberShimei__r.KinmuCompany__r.Id,
                                        MemberFamilyShimei__r.MemberShimei__r.KinmuCompany__r.Name, MemberFamilyShimei__r.MemberShimei__r.KinmuCompany__r.CompanyNameEng__c, 
                                        MemberNo__c, MemberShimei__r.Name, MemberShimei__r.SeiMeiRoma__c ,KenshinArea__c, KenshinDate__c, KenshinPlan__c,KenshinPlan_new__c   
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
           /* system.debug('hasData:' + hasData +' Data:' + data.data.size());
            if (data != null ){
                if (data.data != null)
                    system.debug(data.data);
            }*/
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.GetMemberError));
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
  /*
  private Account getTopAccount(Account ac)
  {
    System.debug('ac:'+ ac);
    if(ac.ParentId==null) return ac;
    return getTopAccount(getAccount(ac.ParentId));
  }
  */
  
  //added by Patrick 20/4/2016
  public void appendParentsParentAccount(){
      indent = indent +'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
      List<CustomerData.AccountSelection> tempAccountSelectionList = new List<CustomerData.AccountSelection>();
      
      if(accountsId != null){
         List<Account> parentAccountList = [select Id, Name, ParentId, CompanyPopularName__c, CompanyNameEng__c, CompanyCd__c, toLabel(Jurisdiction__c) from Account where id=:accountsId limit 1];
         String parentparentId = null;
         
         if(parentAccountList.size() > 0){
             for(Account parentAccount:parentAccountList){
                 parentparentId = parentAccount.ParentId;
             }
         }
         
         List<Account> parentparentList = [select Id, Name, ParentId, CompanyPopularName__c, CompanyNameEng__c, CompanyCd__c, toLabel(Jurisdiction__c) from account where id=:parentparentId limit 1];
         // find the parent's parent's clild (same level of parent)
         List<Account> parentparentchildList = [select Id, Name, ParentId, CompanyPopularName__c, CompanyNameEng__c, CompanyCd__c, toLabel(Jurisdiction__c) from account where ParentId=:parentparentId order by Name];
         
         String topAccountId = null;
         //add the parent which company you clicked (only one)
         for(Account acc:parentparentList){
            CustomerData.AccountSelection AccountSelection = new CustomerData.AccountSelection(acc,'');
            //check display up icon
            if(acc.parentId != null){
                AccountSelection.isParent = true;
            }else{
                topAccountId = acc.Id;
            }
            tempAccountSelectionList.add(AccountSelection);
         }     

         Boolean checkSame = false;
         String saveIncent ='';
         for(Account account:parentparentchildList){
             for(CustomerData.AccountSelection AccSelection:AccSelections){ 
                 if(account.id == AccSelection.Acc.id){
                     AccSelection.indent = indent;
                     if(account.parentId != topAccountId){
                         for(CustomerData.AccountSelection accountObj:AccSelections){
                             accountObj.indent += indent;
                         }
                     }
                     AccSelection.isParent = false;

                     tempAccountSelectionList.addAll(AccSelections);
                     saveIncent = tempAccountSelectionList[1].indent;
                     checkSame = true;
                 }                   
             }
             
             if(checkSame == false){
                 tempAccountSelectionList.add(new CustomerData.AccountSelection(account,saveIncent));
             }
             checkSame = false;
         }
         
         // rebuild the list show on site
         AccSelections.clear();
         AccSelections.addAll(tempAccountSelectionList);
         
         if(AccSelections[0].Acc.parentId == null){
             AccSelections[0].isparent = false;
         }
      }
      AccSelections[0].expandPlus = true; // the top of the list always expend
      dataReady = false;
   }
   
   public PageReference removeChildAccount(){
       Set<String> removedParentAccountIds = new Set<String>();
       
       if(accountId != null){
           removedParentAccountIds.add(accountId);
           
           List<CustomerData.AccountSelection> tempAccountSelectionList = new List<CustomerData.AccountSelection>();
           
           for(CustomerData.AccountSelection AccSelection:AccSelections){
               if(AccSelection.Acc.Id == accountId){
                   AccSelection.expandPlus = false;
               }
               
               if(removedParentAccountIds.contains(AccSelection.Acc.parentId)){
                   removedParentAccountIds.add(AccSelection.Acc.Id);
               }else{
                   tempAccountSelectionList.add(AccSelection);
               }
           }
                      
           // rebuild the list show on site
           AccSelections.clear();
           AccSelections.addAll(tempAccountSelectionList);           
       }
       dataReady = false;
       return null;  
   }
  
  //get parent account
  private Account getParentAccount(Account ac)
  {
      if(ac.ParentId==null) return ac;
      return getAccount(ac.ParentId);
  }
  
  private Account getAccount(string id)
  {
    if((id==null)||(id=='')) return null;
    
    return [select Id, Name, ParentId, CompanyPopularName__c, CompanyNameEng__c, CompanyCd__c, toLabel(Jurisdiction__c)
            from Account where Id=:id];
  }
  
  /*
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
  */
  
  //added by Patrick 20/4/2016
  private void appendOneLevelChildAccount(string parentId, string indent){
    List<Account> la = getChildAccounts(parentId);
    string indentN = indent + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
    for(integer i=0; i<la.size(); i++){
       AccSelections.add(new CustomerData.AccountSelection(la[i], indentN));
    }
  }  
  
    public void appendOneLevelChildAccountUnderParent(){
        system.debug(accountId);
        displayPlus = false;
        displayMinus = true;
        List<Account> la = getChildAccounts(accountId);
        system.debug(indent);
        string indentN = indent +'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
        system.debug(indentN);
        Integer index = 0;
        Integer Counter = 1;
    
        for(CustomerData.AccountSelection accountSelection:AccSelections){
            if(accountSelection.Acc.Id == accountId){
                index = Counter;
            }
            Counter++;
        }
    
        // add the company before select company '+' icon
        List<CustomerData.AccountSelection> tempAccSelections = new List<CustomerData.AccountSelection>();        
        for(integer i=0; i<index; i++){
           if(AccSelections[i].Acc.id == accountId){
               AccSelections[i].expandPlus = true;
           }       
           tempAccSelections.add(AccSelections[i]);     
        }
        system.debug(tempAccSelections);
        
        // add child company in a temp list
        List<CustomerData.AccountSelection> childAccSelectionsList = new List<CustomerData.AccountSelection>();  
        for(integer i=0; i<la.size(); i++){    
            CustomerData.AccountSelection tempAccount = new CustomerData.AccountSelection(la[i],indentN);
            childAccSelectionsList.add(tempAccount);  
        }
        system.debug(childAccSelectionsList);
        
        // add childAccSelections Company to the temp list
        for(CustomerData.AccountSelection childAccSelectionsElement:childAccSelectionsList){
        //tempAccSelections.add(childAccSelectionsElement);
            tempAccSelections.add(new CustomerData.AccountSelection(childAccSelectionsElement.Acc,indentN));
        }
        system.debug(tempAccSelections);
        
        for(integer i=0; i<AccSelections.size()-index; i++){
            tempAccSelections.add(AccSelections[index+i]);
        }        
        system.debug(tempAccSelections);
        
        AccSelections.clear();
        AccSelections.addAll(tempAccSelections);
        AccSelections = checkHaveChilds(AccSelections);
        
        system.debug(dataReady);
        dataReady = false;
    }
    
   // check the list have child or not, if the nodes have no child, use the blank.png icon 
   public List<CustomerData.AccountSelection> checkHaveChilds(List<CustomerData.AccountSelection> checkingList){
       system.debug(checkingList);
       String checkingListId = '';
       if(checkingList.size()>0){
           for(CustomerData.AccountSelection checkingAccount:checkingList){
               checkingListId = checkingListId +'\''+checkingAccount.Acc.id+'\',';
           }
           checkingListId = checkingListId.substring(0,checkingListId.length()-1);
           checkingListId = '(' + checkingListId +')';
           system.debug(checkingListId);      
       } 
       
       if(checkingListId != null){
           String sqlString = 'select parentId,count(Id) from account where parentId in '+checkingListId+' group by parentId';
           system.debug(sqlString); 
           List<AggregateResult> parentIdNumberList = Database.query(sqlString); 
           system.debug(parentIdNumberList);    
           
           Map<String,Integer> parentIdCounterMap = new Map<String,Integer>();
           
           for(AggregateResult result:parentIdNumberList){
               parentIdCounterMap.put((String)result.get('parentId'),(Integer)result.get('expr0'));
           }
           system.debug(parentIdCounterMap);
            if(parentIdCounterMap.size()>0){
                for(CustomerData.AccountSelection CustAccount:checkingList){
                    if(parentIdCounterMap.get(CustAccount.Acc.id) == 0 || parentIdCounterMap.get(CustAccount.Acc.id) == null){
                        CustAccount.hasChild = false;  
                    }  
                } 
            }   
            else{
                for(CustomerData.AccountSelection CustAccount:checkingList){
                    CustAccount.hasChild = false;  
                }        
            }
        }
        return checkingList;
   }   
  
  private List<Account> getChildAccounts(string parentId){
    if((parentId==null)||(parentId=='')) return new List<Account>();
    
    return [select Id, Name, ParentId, CompanyPopularName__c, CompanyNameEng__c, CompanyCd__c, toLabel(Jurisdiction__c)
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
    NewCustomerDataControllerEx con = new NewCustomerDataControllerEx(scon);
    con.init();
    con.uncheckAll();
    con.checkAll();
    con.Execute1();
    con.Execute2();
  }
  */
}