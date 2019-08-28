public class ContractMassUpdateControllerEx
{
  public class MiscException Extends Exception{}
 
  public class MRow
  {
    public boolean Selected {get; set; }
    public MemberInfo__c Member {get; set;}
    public List<FRow> FamilyMembers {get; set;}
    public MRow(MemberInfo__c m)
    {
      Selected = false;
      Member = m;
      FamilyMembers = new List<FRow>();
      if(m.FamilyMembers__r!=null)
          for(integer i=0; i<m.FamilyMembers__r.size(); i++)
          {
            FamilyMembers.add(new FRow(m.FamilyMembers__r[i]));
          }
    }
  }
  
  public class FRow
  {
    public boolean Selected {get; set; }
    public FamilyInfo__c Family {get; set;}
    public FRow(FamilyInfo__c f)
    {
      Selected = false;
      Family = f;
    }
  }
  
  public class Action
  {
    public boolean isDelete = false;
    public OTAHistory__c Record = null;
    public Action(boolean isDelete, OTAHistory__c record)
    {
        this.isDelete = isDelete;
        this.Record = record;
    }
  }

  public class MRow2
  {  
  	public Boolean hasMember {get;set;}
    public MemberInfo__c Member {get; set;}
    public List<FRow2> FamilyMembers {get; set;}
    public OTAHistory__c History {get; set;}

    private MemberInfo__c m_oriMember;
    private boolean m_isOriEmpty = false;
    
    public MRow2(MemberInfo__c m, Boolean addMember)
    {
      hasMember = addMember;
      Member = m;
      m_oriMember = Member.clone(true, true);
      m_isOriEmpty = IsEmpty(m_oriMember); 
      History = null;
      
      FamilyMembers = new List<FRow2>();
      if(m.FamilyMembers__r!=null)
          for(integer i=0; i<m.FamilyMembers__r.size(); i++)
          {
            FamilyMembers.add(new FRow2(m.FamilyMembers__r[i]));
          }
    }
    
    private boolean IsEmpty(MemberInfo__c m)
    {
      return
        (m.OtaName__c==null) &&
        (m.InsuranceKind__c==null) &&
        (m.OtaAgency__c==null) &&
        (m.ShokenNo__c==null) &&
        (m.ShokenGetSituation__c==null) &&
        (m.OtaKeepPlace__c==null) &&
        (m.MedicalBillKessaiHouhou__c==null) &&
        (m.Shonendo_Shiki__c==null) &&
        (m.OtaInsuranceShiki__c==null) &&
        (m.OtaInsuranceShuki__c==null) &&
        (m.InsurancePlan__c==null) &&
        (m.InsuranceCurrency__c==null) &&
        (m.InjuryDeathCost__c==null) &&
        (m.TreatmentCost__c==null) &&
        (m.TreatmentRescueCost__c==null) &&
        (m.DiseaseCost__c==null) &&
        (m.InjuryCost__c==null) &&
        (m.DiseaseDeathCost__c==null) &&
        (m.RescueCost__c==null) &&
        (m.DamagesCost__c==null) &&
        (m.CarryCost__c==null) &&
        (m.OtaNote__c==null) &&
        (m.HomeCountryCoverage__c==false) &&
          (m.Issues_To_AC__c==null); // 20180129
    }
    
    private boolean IsChanged()
    {
      return (Member.OtaName__c != m_oriMember.OtaName__c) 
          || (Member.InsuranceKind__c != m_oriMember.InsuranceKind__c)
          || (Member.OtaAgency__c != m_oriMember.OtaAgency__c)
          || (Member.ShokenNo__c != m_oriMember.ShokenNo__c)
          || (Member.ShokenGetSituation__c != m_oriMember.ShokenGetSituation__c)
          || (Member.OtaKeepPlace__c != m_oriMember.OtaKeepPlace__c)
          || (Member.MedicalBillKessaiHouhou__c != m_oriMember.MedicalBillKessaiHouhou__c)
           || (Member.Shonendo_Shiki__c != m_oriMember.Shonendo_Shiki__c) //20180112
          || (Member.OtaInsuranceShiki__c != m_oriMember.OtaInsuranceShiki__c)
          || (Member.OtaInsuranceShuki__c != m_oriMember.OtaInsuranceShuki__c)
          || (Member.InsurancePlan__c != m_oriMember.InsurancePlan__c)
          || (Member.InsuranceCurrency__c != m_oriMember.InsuranceCurrency__c)
          || (Member.InjuryDeathCost__c != m_oriMember.InjuryDeathCost__c)
          || (Member.TreatmentCost__c != m_oriMember.TreatmentCost__c)
          || (Member.TreatmentRescueCost__c != m_oriMember.TreatmentRescueCost__c)
          || (Member.DiseaseCost__c != m_oriMember.DiseaseCost__c)
          || (Member.InjuryCost__c != m_oriMember.InjuryCost__c)
          || (Member.DiseaseDeathCost__c != m_oriMember.DiseaseDeathCost__c)
          || (Member.RescueCost__c != m_oriMember.RescueCost__c)
          || (Member.DamagesCost__c != m_oriMember.DamagesCost__c)
          || (Member.CarryCost__c != m_oriMember.CarryCost__c)
          || ((Member.OtaNote__c==''?null:Member.OtaNote__c) != m_oriMember.OtaNote__c)
          || (Member.HomeCountryCoverage__c != m_oriMember.HomeCountryCoverage__c)
          || (Member.Issues_To_AC__c != m_oriMember.Issues_To_AC__c); //20180129
    }
      
    public Action CreateHistory()
    {
      if(IsChanged())
      {
        if(!m_isOriEmpty)
        {
          if(History==null)
          {
              History = new OTAHistory__c();
              History.MemberName__c = m_oriMember.Id;
              History.OtaName__c = m_oriMember.OtaName__c;
              History.InsuranceKind__c = m_oriMember.InsuranceKind__c;
              History.OtaAgency__c = m_oriMember.OtaAgency__c;
              History.ShokenNo__c = m_oriMember.ShokenNo__c;
              History.ShokenGetSituation__c = m_oriMember.ShokenGetSituation__c;
              History.OtaKeepPlace__c = m_oriMember.OtaKeepPlace__c;
              History.MedicalBillKessaiHouhou__c = m_oriMember.MedicalBillKessaiHouhou__c;
              History.Shonendo_Shiki__c = m_oriMember.Shonendo_Shiki__c; //20180112
              History.OtaInsuranceShiki__c = m_oriMember.OtaInsuranceShiki__c;
              History.OtaInsuranceShuki__c = m_oriMember.OtaInsuranceShuki__c;
              History.InsurancePlan__c = m_oriMember.InsurancePlan__c;
              History.InsuranceCurrency__c = m_oriMember.InsuranceCurrency__c;
              History.InjuryDeathCost__c = m_oriMember.InjuryDeathCost__c;
              History.TreatmentCost__c = m_oriMember.TreatmentCost__c;
              History.TreatmentRescueCost__c = m_oriMember.TreatmentRescueCost__c;
              History.DiseaseCost__c = m_oriMember.DiseaseCost__c;
              History.InjuryCost__c = m_oriMember.InjuryCost__c;
              History.DiseaseDeathCost__c = m_oriMember.DiseaseDeathCost__c;
              History.RescueCost__c = m_oriMember.RescueCost__c;
              History.DamagesCost__c = m_oriMember.DamagesCost__c;
              History.CarryCost__c = m_oriMember.CarryCost__c;
              History.OtaNote__c = m_oriMember.OtaNote__c;
              History.HomeCountryCoverage__c = m_oriMember.HomeCountryCoverage__c;
               History.Issues_To_AC__c = m_oriMember.Issues_To_AC__c; //20180129
              return new Action(false, History);
          }
          else
              return null;
        }
        else
          return null;
      }
      else
      {
        if(History==null)
            return null;
        else
            return new Action(true, History);
      }
    }
  }
  
  public class FRow2
  {
    public FamilyInfo__c Family {get; set;}
    public OTAHistory__c History {get; set;}
    
    private FamilyInfo__c m_oriFamily;
    private boolean m_isOriEmpty = false;
    
    public FRow2(FamilyInfo__c f)
    {
      Family = f;
      m_oriFamily= Family.clone(true, true);
      m_isOriEmpty = IsEmpty(m_oriFamily); 
      History = null;
    }
      
    private boolean IsEmpty(FamilyInfo__c f)
    {
        return 
          (f.OtaName__c==null) &&
          (f.InsuranceKind__c==null) &&
          (f.OtaAgency__c==null) &&
          (f.ShokenNo__c==null) &&
          (f.ShokenGetSituation__c==null) &&
          (f.OtaKeepPlace__c==null) &&
          (f.MedicalBillKessaiHouhou__c==null) &&
           (f.Shonendo_Shiki__c==null) && //20180112
          (f.OtaInsuranceShiki__c==null) &&
          (f.OtaInsuranceShuki__c==null) &&
          (f.InsurancePlan__c==null) &&
          (f.InsuranceCurrency__c==null) &&
          (f.InjuryDeathCost__c==null) &&
          (f.TreatmentCost__c==null) &&
          (f.TreatmentRescueCost__c==null) &&
          (f.DiseaseCost__c==null) &&
          (f.InjuryCost__c==null) &&
          (f.DiseaseDeathCost__c==null) &&
          (f.RescueCost__c==null) &&
          (f.DamagesCost__c==null) &&
          (f.CarryCost__c==null) &&
          (f.OtaNote__c==null) &&
          (f.HomeCountryCoverage__c==false) &&
          (f.Issues_To_AC__c==null);  //20180129
    }
    
    private boolean IsChanged()
    {
      return (Family.OtaName__c != m_oriFamily.OtaName__c)
            || (Family.InsuranceKind__c != m_oriFamily.InsuranceKind__c)
            || (Family.OtaAgency__c != m_oriFamily.OtaAgency__c)
            || (Family.ShokenNo__c != m_oriFamily.ShokenNo__c)
            || (Family.ShokenGetSituation__c != m_oriFamily.ShokenGetSituation__c)
            || (Family.OtaKeepPlace__c != m_oriFamily.OtaKeepPlace__c)
            || (Family.MedicalBillKessaiHouhou__c != m_oriFamily.MedicalBillKessaiHouhou__c)
          	|| (Family.Shonendo_Shiki__c != m_oriFamily.Shonendo_Shiki__c) //20180112
            || (Family.OtaInsuranceShiki__c != m_oriFamily.OtaInsuranceShiki__c)
            || (Family.OtaInsuranceShuki__c != m_oriFamily.OtaInsuranceShuki__c)
            || (Family.InsurancePlan__c != m_oriFamily.InsurancePlan__c)
            || (Family.InsuranceCurrency__c != m_oriFamily.InsuranceCurrency__c)
            || (Family.InjuryDeathCost__c != m_oriFamily.InjuryDeathCost__c)
            || (Family.TreatmentCost__c != m_oriFamily.TreatmentCost__c)
            || (Family.TreatmentRescueCost__c != m_oriFamily.TreatmentRescueCost__c)
            || (Family.DiseaseCost__c != m_oriFamily.DiseaseCost__c)
            || (Family.InjuryCost__c != m_oriFamily.InjuryCost__c)
            || (Family.DiseaseDeathCost__c != m_oriFamily.DiseaseDeathCost__c)
            || (Family.RescueCost__c != m_oriFamily.RescueCost__c)
            || (Family.DamagesCost__c != m_oriFamily.DamagesCost__c)
            || (Family.CarryCost__c != m_oriFamily.CarryCost__c)
            || ((Family.OtaNote__c==''?null:Family.OtaNote__c) != m_oriFamily.OtaNote__c)
            || (Family.HomeCountryCoverage__c != m_oriFamily.HomeCountryCoverage__c)
        //20180129
            || (Family.Issues_To_AC__c != m_oriFamily.Issues_To_AC__c);
    }
      
    public Action CreateHistory()
    {
      if(IsChanged())
      {
        if(!m_isOriEmpty)
        {
          if(History==null)
          { 
              History = new OTAHistory__c();
              History.MemberFamilyName__c = m_oriFamily.Id;
              History.OtaName__c = m_oriFamily.OtaName__c;
              History.InsuranceKind__c = m_oriFamily.InsuranceKind__c;
              History.OtaAgency__c = m_oriFamily.OtaAgency__c;
              History.ShokenNo__c = m_oriFamily.ShokenNo__c;
              History.ShokenGetSituation__c = m_oriFamily.ShokenGetSituation__c;
              History.OtaKeepPlace__c = m_oriFamily.OtaKeepPlace__c;
              History.MedicalBillKessaiHouhou__c = m_oriFamily.MedicalBillKessaiHouhou__c;
              History.Shonendo_Shiki__c = m_oriFamily.Shonendo_Shiki__c; //20180112
              History.OtaInsuranceShiki__c = m_oriFamily.OtaInsuranceShiki__c;
              History.OtaInsuranceShuki__c = m_oriFamily.OtaInsuranceShuki__c;
              History.InsurancePlan__c = m_oriFamily.InsurancePlan__c;
              History.InsuranceCurrency__c = m_oriFamily.InsuranceCurrency__c;
              History.InjuryDeathCost__c = m_oriFamily.InjuryDeathCost__c;
              History.TreatmentCost__c = m_oriFamily.TreatmentCost__c;
              History.TreatmentRescueCost__c = m_oriFamily.TreatmentRescueCost__c;
              History.DiseaseCost__c = m_oriFamily.DiseaseCost__c;
              History.InjuryCost__c = m_oriFamily.InjuryCost__c;
              History.DiseaseDeathCost__c = m_oriFamily.DiseaseDeathCost__c;
              History.RescueCost__c = m_oriFamily.RescueCost__c;
              History.DamagesCost__c = m_oriFamily.DamagesCost__c;
              History.CarryCost__c = m_oriFamily.CarryCost__c;
              History.OtaNote__c = m_oriFamily.OtaNote__c;
              History.HomeCountryCoverage__c = m_oriFamily.HomeCountryCoverage__c;
              //20180129
              History.Issues_To_AC__c = m_oriFamily.Issues_To_AC__c;
              return new Action(false, History);
          }
          else
              return null;
        }
        else
          return null;
      }
      else
      {
        if(History==null)
            return null;
        else
            return new Action(true, History);
      }
    }
  }

  private ApexPages.StandardController scon;
  private ContractInfo__c ci;
  public List<MRow> Rows {get; set;}
  public List<MRow2> Rows2 {get; set;}
  public List<MRow2> Rows2Member {get; set;}
  public List<MRow2> Rows2FamilyMember {get; set;}
  public MemberInfo__c Common {get; set;}
  public string PopupMessage {get; set;}
  
  //20180129
  public string pv0 {get; set;}
  public ContractMassUpdateControllerEx(ApexPages.StandardController scon)
  {
    this.scon = scon;
    this.ci = (ContractInfo__c)scon.getRecord();
    Rows = new List<MRow>();
    Rows2 = new List<MRow2>();
    Rows2Member = new List<MRow2>();
    Rows2FamilyMember = new List<MRow2>();
    //20180129 
    pv0 = ApexPages.currentPage().getParameters().get('pv0');
    system.debug('' +pv0 );
    List<MemberInfo__c> ms = [select Id, KinmuCompany__r.Name, MemberNo__c, ShozokuArea__c, Name,
        (select Id, MemberNo__c, ShozokuArea__c, Name from FamilyMembers__r 
        where TaikaiDate__c=:null or TaikaiDate__c>:system.today()
        order by MemberNo__c)
        from MemberInfo__c
        where CompanyKeiyakuNo__c=:ci.Id 
        and (TaikaiDate__c=:null or TaikaiDate__c>:system.today()) 
        order by KinmuCompany__r.Name, MemberNo__c];
    for(integer i=0; i<ms.size(); i++)
      Rows.add(new MRow(ms[i]));
  }
  
  public PageReference page2()
  {
    set<string> ids = new set<string>();
    set<string> MemberOnlyids = new set<string>();
    set<string> FamilyMemberOnlyids = new set<string>();
    set<string> FamilyMemberOwnids = new set<string>();
    for(integer i=0; i<Rows.size(); i++)
    {
      if(Rows[i].Selected)
      {
        ids.add(Rows[i].Member.Id);
        MemberOnlyids.add(Rows[i].Member.Id);
      }
      //else 
      {
        for(integer j=0; j<Rows[i].FamilyMembers.size(); j++)
            if(Rows[i].FamilyMembers[j].Selected)
            {
                ids.add(Rows[i].Member.Id);
                FamilyMemberOnlyids.add(Rows[i].Member.Id);
                FamilyMemberOwnids.add(Rows[i].FamilyMembers[j].family.id);
            }
      }
    }
    
    if(ids.size()<=0)
    {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No member selected!')); 
      return null;
    }
    
    Common = new MemberInfo__c();
    
    Rows2.clear();
    //Extract selected member/family member whole family
    List<MemberInfo__c> members = [select Id, KinmuCompany__r.Name, MemberNo__c, Name,
        OtaName__c, InsuranceKind__c, OtaAgency__c, ShokenNo__c, ShokenGetSituation__c, OtaKeepPlace__c,
        MedicalBillKessaiHouhou__c, Shonendo_Shiki__c, //20180112
                                   OtaInsuranceShiki__c, OtaInsuranceShuki__c, InsurancePlan__c,
        InsuranceCurrency__c, InjuryDeathCost__c, TreatmentCost__c, TreatmentRescueCost__c, DiseaseCost__c,
        InjuryCost__c, DiseaseDeathCost__c, RescueCost__c, DamagesCost__c, CarryCost__c, OtaNote__c,
        HomeCountryCoverage__c, ShozokuArea__c,
         // 20180129
         Issues_To_AC__c, 
        (select Id, MemberNo__c, Name, ShozokuArea__c,
        OtaName__c, InsuranceKind__c, OtaAgency__c, ShokenNo__c, ShokenGetSituation__c, OtaKeepPlace__c,
        MedicalBillKessaiHouhou__c, Shonendo_Shiki__c, //20180112
         OtaInsuranceShiki__c, OtaInsuranceShuki__c, InsurancePlan__c,
        InsuranceCurrency__c, InjuryDeathCost__c, TreatmentCost__c, TreatmentRescueCost__c, DiseaseCost__c,
        InjuryCost__c, DiseaseDeathCost__c, RescueCost__c, DamagesCost__c, CarryCost__c, OtaNote__c,
        HomeCountryCoverage__c,
         // 20180129
         Issues_To_AC__c
        from FamilyMembers__r where (TaikaiDate__c=:null or TaikaiDate__c>:system.today()) and id in :FamilyMemberOwnids order by MemberNo__c)       
        from MemberInfo__c 
        where Id in :ids 
        order by KinmuCompany__r.Name, MemberNo__c];
    
    //for(integer i=0; i<members.size(); i++)
    //  Rows2.add(new MRow2(members[i]));
     
    Rows2Member.clear(); 
    //Extract selected members  
    List<MemberInfo__c> membersOnly = [select Id, KinmuCompany__r.Name, MemberNo__c, Name
        from MemberInfo__c 
        where Id in :MemberOnlyids 
        order by KinmuCompany__r.Name, MemberNo__c];
    
    //for(integer i=0; i<membersOnly.size(); i++)
    //  Rows2Member.add(new MRow2(membersOnly[i]));
    

    Rows2FamilyMember.clear();   
    //Extract selected family members
    List<MemberInfo__c> familyMembersOnly = [select Id, KinmuCompany__r.Name, MemberNo__c, Name,
        (select Id, MemberNo__c
        from FamilyMembers__r where TaikaiDate__c=:null or TaikaiDate__c>:system.today())
        from MemberInfo__c 
        where Id in :FamilyMemberOnlyids 
        order by KinmuCompany__r.Name, MemberNo__c];
    
    //for(integer i=0; i<familyMembersOnly.size(); i++)
    //  Rows2FamilyMember.add(new MRow2(familyMembersOnly[i]));    
    for(integer i=0; i<members.size(); i++){
      	if(MemberOnlyids.contains(members[i].id))
      	Rows2.add(new MRow2(members[i],true));
      	else
    	Rows2.add(new MRow2(members[i],false));
    }
   system.debug('pv0:' + pv0);    
    PopupMessage = '';
  
      if (pv0=='sales')
          return Page.ContractMassUpdateSalesIssue;
      else
          return Page.ContractMassUpdate2;
  }
  
  public void checkAll()
  {
    for(integer i=0; i<Rows.size(); i++)
    {
      Rows[i].Selected = true;
      for(integer j=0; j<Rows[i].FamilyMembers.size(); j++)
        Rows[i].FamilyMembers[j].Selected = true;
    }
  }
  
  public void uncheckAll()
  {
    for(integer i=0; i<Rows.size(); i++)
    {
      Rows[i].Selected = false;
      for(integer j=0; j<Rows[i].FamilyMembers.size(); j++)
        Rows[i].FamilyMembers[j].Selected = false;
    }
  }
  
  public void save2()
  {
    PopupMessage = '';
    list<MemberInfo__c> lm = new list<MemberInfo__c>();
    list<FamilyInfo__c> lf = new list<FamilyInfo__c>();
    list<OTAHistory__c> lhistNew = new list<OTAHistory__c>();
    list<OTAHistory__c> lhistDel = new list<OTAHistory__c>();
    list<MRow2> lMRow2Del = new list<MRow2>();
    list<FRow2> lFRow2Del = new list<FRow2>();
    for(integer i=0; i<Rows2.size(); i++)
    {
      MRow2 r = Rows2[i];
      if(r.Member != null)//edit
      lm.add(r.Member);
      
      Action a = r.CreateHistory();
      if(a!=null)
      {
          if(a.isDelete)
          {
            lhistDel.add(a.Record);
            lMRow2Del.add(r);
          }
          else
            lhistNew.add(a.Record);
      }
        
      for(integer j=0; j<Rows2[i].FamilyMembers.size(); j++)
      {
          FRow2 fr = Rows2[i].FamilyMembers[j];
          lf.add(fr.Family);
          
          Action fa = fr.CreateHistory();
          if(fa!=null)
          {
              if(fa.isDelete)
              {
                lhistDel.add(fa.Record);
                lFRow2Del.add(fr);
              }
              else
                lhistNew.add(fa.Record);
          }
      }
    }
    
    SavePoint sp = Database.setSavepoint();
    try
    {
        update lm;
        update lf;
        insert lhistNew;
        delete lhistDel;
    }
    catch(Exception e)
    {
        Database.rollBack(sp);
        PopupMessage = e.getMessage();
        return;
    }
    
    for(MRow2 r : lMRow2Del)
        r.History = null;
    for(FRow2 fr : lFRow2Del)
        fr.History = null;
    
    PopupMessage = ' 更新しました。';
  }
  
  public void copyCommon()
  {
    PopupMessage = '';
    for(integer i=0; i<Rows2.size(); i++)
    {
    	if(Rows2[i].hasMember){
	      MemberInfo__c m = Rows2[i].Member;
	      if(Common.OtaName__c!=null) m.OtaName__c = Common.OtaName__c;
	      if(Common.InsuranceKind__c!=null) m.InsuranceKind__c = Common.InsuranceKind__c;
	      if(Common.OtaAgency__c!=null) m.OtaAgency__c = Common.OtaAgency__c;
	      if(Common.ShokenNo__c!=null) m.ShokenNo__c = Common.ShokenNo__c;
	      if(Common.ShokenGetSituation__c!=null) m.ShokenGetSituation__c = Common.ShokenGetSituation__c;
	      if(Common.OtaKeepPlace__c!=null) m.OtaKeepPlace__c = Common.OtaKeepPlace__c;
	      if(Common.MedicalBillKessaiHouhou__c!=null) m.MedicalBillKessaiHouhou__c = Common.MedicalBillKessaiHouhou__c;
          if(Common.Shonendo_Shiki__c!=null) m.Shonendo_Shiki__c = Common.Shonendo_Shiki__c; //20180112
	      if(Common.OtaInsuranceShiki__c!=null) m.OtaInsuranceShiki__c = Common.OtaInsuranceShiki__c;
	      if(Common.OtaInsuranceShuki__c!=null) m.OtaInsuranceShuki__c = Common.OtaInsuranceShuki__c;
	      if(Common.InsurancePlan__c!=null) m.InsurancePlan__c = Common.InsurancePlan__c;
	      if(Common.InsuranceCurrency__c!=null) m.InsuranceCurrency__c = Common.InsuranceCurrency__c;
	      if(Common.InjuryDeathCost__c!=null) m.InjuryDeathCost__c = Common.InjuryDeathCost__c;
	      if(Common.TreatmentCost__c!=null) m.TreatmentCost__c = Common.TreatmentCost__c;
	      if(Common.TreatmentRescueCost__c!=null) m.TreatmentRescueCost__c = Common.TreatmentRescueCost__c;
	      if(Common.DiseaseCost__c!=null) m.DiseaseCost__c = Common.DiseaseCost__c;
	      if(Common.InjuryCost__c!=null) m.InjuryCost__c = Common.InjuryCost__c;
	      if(Common.DiseaseDeathCost__c!=null) m.DiseaseDeathCost__c = Common.DiseaseDeathCost__c;
	      if(Common.RescueCost__c!=null) m.RescueCost__c = Common.RescueCost__c;
	      if(Common.DamagesCost__c!=null) m.DamagesCost__c = Common.DamagesCost__c;
	      if(Common.CarryCost__c!=null) m.CarryCost__c = Common.CarryCost__c;
	      if(Common.HomeCountryCoverage__c) m.HomeCountryCoverage__c = Common.HomeCountryCoverage__c;
	      if(Common.OtaNote__c!=null&&Common.OtaNote__c!='') m.OtaNote__c = Common.OtaNote__c;
            //20180129
          if(Common.Issues_To_AC__c!=null&&Common.Issues_To_AC__c!='') m.Issues_To_AC__c = Common.Issues_To_AC__c;
    	}
        for(integer j=0; j<Rows2[i].FamilyMembers.size(); j++)
        {
          FamilyInfo__c f = Rows2[i].FamilyMembers[j].Family;
          if(Common.OtaName__c!=null) f.OtaName__c = Common.OtaName__c;
          if(Common.InsuranceKind__c!=null) f.InsuranceKind__c = Common.InsuranceKind__c;
          if(Common.OtaAgency__c!=null) f.OtaAgency__c = Common.OtaAgency__c;
          if(Common.ShokenNo__c!=null) f.ShokenNo__c = Common.ShokenNo__c;
          if(Common.ShokenGetSituation__c!=null) f.ShokenGetSituation__c = Common.ShokenGetSituation__c;
          if(Common.OtaKeepPlace__c!=null) f.OtaKeepPlace__c = Common.OtaKeepPlace__c;
          if(Common.MedicalBillKessaiHouhou__c!=null) f.MedicalBillKessaiHouhou__c = Common.MedicalBillKessaiHouhou__c;
          if(Common.Shonendo_Shiki__c!=null) f.Shonendo_Shiki__c = Common.Shonendo_Shiki__c; //20180112
          if(Common.OtaInsuranceShiki__c!=null) f.OtaInsuranceShiki__c = Common.OtaInsuranceShiki__c;
          if(Common.OtaInsuranceShuki__c!=null) f.OtaInsuranceShuki__c = Common.OtaInsuranceShuki__c;
          if(Common.InsurancePlan__c!=null) f.InsurancePlan__c = Common.InsurancePlan__c;
          if(Common.InsuranceCurrency__c!=null) f.InsuranceCurrency__c = Common.InsuranceCurrency__c;
          if(Common.InjuryDeathCost__c!=null) f.InjuryDeathCost__c = Common.InjuryDeathCost__c;
          if(Common.TreatmentCost__c!=null) f.TreatmentCost__c = Common.TreatmentCost__c;
          if(Common.TreatmentRescueCost__c!=null) f.TreatmentRescueCost__c = Common.TreatmentRescueCost__c;
          if(Common.DiseaseCost__c!=null) f.DiseaseCost__c = Common.DiseaseCost__c;
          if(Common.InjuryCost__c!=null) f.InjuryCost__c = Common.InjuryCost__c;
          if(Common.DiseaseDeathCost__c!=null) f.DiseaseDeathCost__c = Common.DiseaseDeathCost__c;
          if(Common.RescueCost__c!=null) f.RescueCost__c = Common.RescueCost__c;
          if(Common.DamagesCost__c!=null) f.DamagesCost__c = Common.DamagesCost__c;
          if(Common.CarryCost__c!=null) f.CarryCost__c = Common.CarryCost__c;
          if(Common.HomeCountryCoverage__c) f.HomeCountryCoverage__c = Common.HomeCountryCoverage__c;
          if(Common.OtaNote__c!=null&&Common.OtaNote__c!='') f.OtaNote__c = Common.OtaNote__c;
            //20180129
          if(Common.Issues_To_AC__c!=null&&Common.Issues_To_AC__c!='') f.Issues_To_AC__c = Common.Issues_To_AC__c;
          
        }
    
    }
    
    Common.OtaName__c = null;
    Common.InsuranceKind__c = null;
    Common.OtaAgency__c = null;
    Common.ShokenNo__c = null;
    Common.ShokenGetSituation__c = null;
    Common.OtaKeepPlace__c = null;
    Common.MedicalBillKessaiHouhou__c = null;
    Common.Shonendo_Shiki__c = null; //20180112
    Common.OtaInsuranceShiki__c = null;
    Common.OtaInsuranceShuki__c = null;
    Common.InsurancePlan__c = null;
    Common.InsuranceCurrency__c = null;
    Common.InjuryDeathCost__c = null;
    Common.TreatmentCost__c = null;
    Common.TreatmentRescueCost__c = null;
    Common.DiseaseCost__c = null;
    Common.InjuryCost__c = null;
    Common.DiseaseDeathCost__c = null;
    Common.RescueCost__c = null;
    Common.DamagesCost__c = null;
    Common.CarryCost__c = null;
    Common.HomeCountryCoverage__c = false;
    Common.OtaNote__c = null;
    Common.Issues_To_AC__c = null; //20180129
    PopupMessage = 'コピーしました。';
  }
  
  public PageReference cancel2()
  {
    PopupMessage = '';
    Rows2.clear();
    return Page.ContractMassUpdate;
  }
  
  public PageReference end()
  {
    return new PageReference('/' + ci.Id);
  }
  
  
  /*
  static testMethod void ContractMassUpdateControllerEx_Test()
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
    FamilyInfo__c fi = TestUtil.createTestFamilyInfo(mi.Id);
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
    ContractMassUpdateControllerEx con = new ContractMassUpdateControllerEx(scon);
    con.uncheckAll();
    con.page2();
    con.checkAll();
    con.page2();
    
    con.Common.OtaName__c = 'Test';
      con.Common.InsuranceKind__c = 'Test';
      con.Common.OtaAgency__c = 'Test';
      con.Common.ShokenNo__c = 'Test';
      con.Common.ShokenGetSituation__c = 'Test';
      con.Common.OtaKeepPlace__c = 'Test';
      con.Common.MedicalBillKessaiHouhou__c = 'Test';
      con.Common.OtaInsuranceShiki__c = system.today();  
      con.Common.OtaInsuranceShuki__c = system.today();  
      con.Common.InsurancePlan__c = 'Test';  
      con.Common.InsuranceCurrency__c = 'Test';
      con.Common.InjuryDeathCost__c = 1;  
      con.Common.TreatmentCost__c = 1;  
      con.Common.TreatmentRescueCost__c = 1;
      con.Common.DiseaseCost__c = 1;
      con.Common.InjuryCost__c = 1;  
      con.Common.DiseaseDeathCost__c = 1;
      con.Common.RescueCost__c = 1; 
      con.Common.DamagesCost__c = 1;  
      con.Common.CarryCost__c = 1; 
      con.Common.HomeCountryCoverage__c = true; 
      con.Common.OtaNote__c = 'Test';  
    
    con.copyCommon();
    con.save2();
  } */
}