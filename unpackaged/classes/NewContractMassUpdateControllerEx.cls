public class NewContractMassUpdateControllerEx
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
        (m.HomeCountryCoverage__c==false);
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
          || (Member.HomeCountryCoverage__c != m_oriMember.HomeCountryCoverage__c);
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
          (f.HomeCountryCoverage__c==false);
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
            || (Family.HomeCountryCoverage__c != m_oriFamily.HomeCountryCoverage__c);
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
  public ContractInfo__C searchContractLookUp {get; set;}
  public MemberInfo__c searchMemberLookUp {get; set;}
  public MemberInfo__c searchMemberLookUp2 {get; set;}
  public String searchInput {get;set;}
  public Boolean IsComeFromViewList {get;set;}
  public Boolean openSearchResult {get;set;}
  public String parameterId {get;set;}
  public boolean isEnglish {get; set;}
  public boolean bLDocumentCheckbox{get; set;}
  public boolean bLDocumentKeepingPlaceCheckbox{get; set;}
  public boolean homeCountryCoverageCheckbox{get; set;}
  public boolean oTaRemarksCheckbox{get; set;}    
  public String RecordId {get;set;} 
  
  public NewContractMassUpdateControllerEx(ApexPages.StandardController scon)
  {
    this.scon = scon;
    this.ci = (ContractInfo__c)scon.getRecord();
    RecordId = ci.id;
    Rows = new List<MRow>();
    Rows2 = new List<MRow2>();
    Rows2Member = new List<MRow2>();
    Rows2FamilyMember = new List<MRow2>();
    searchContractLookUp = new ContractInfo__c();
    searchMemberLookUp = new MemberInfo__c();
    searchMemberLookUp2 = new MemberInfo__c();
    IsComeFromViewList = false;
    isEnglish = 'en_US'.equals(UserInfo.getLanguage()); //check profile language

    if (ci.id == null){
        IsComeFromViewList = true;
    }
    else{
        IsComeFromViewList = false;
    }
    
  }
  
  public void search(){
    Rows = new List<MRow>();
    openSearchResult = true; 
    system.debug(searchMemberLookUp.KinmuCompany__r.name);
    system.debug(searchMemberLookUp.InsuranceKind__c);
    system.debug(searchMemberLookUp.OtaInsuranceShuki__c);
    system.debug(searchMemberLookUp2.OtaInsuranceShuki__c);
    
    String kinmuCompanyName= null;
    String otaInsuranceShuki = null;
    String otaInsuranceShuki2 = null;   
       
    kinmuCompanyName= searchMemberLookUp.KinmuCompany__c;   
    otaInsuranceShuki =  string.valueof(searchMemberLookUp.OtaInsuranceShuki__c);
    otaInsuranceShuki2 = string.valueof(searchMemberLookUp2.OtaInsuranceShuki__c);   
          
    if(kinmuCompanyName!=null){   
        kinmuCompanyName= ' and KinmuCompany__c =\'' + searchMemberLookUp.KinmuCompany__c+'\'';
    }
    else{ 
        kinmuCompanyName='';
    }
    if(otaInsuranceShuki!=null && otaInsuranceShuki2 == null){
        otaInsuranceShuki = ' and OtaInsuranceShuki__c >=' + string.valueof(searchMemberLookUp.OtaInsuranceShuki__c);
    }
    if(otaInsuranceShuki2!=null && otaInsuranceShuki == null){
        otaInsuranceShuki2 = ' and OtaInsuranceShuki__c <=' + string.valueof(searchMemberLookUp2.OtaInsuranceShuki__c);
    }
    if(otaInsuranceShuki2!=null && otaInsuranceShuki != null){
        otaInsuranceShuki = ' and (OtaInsuranceShuki__c >=' + string.valueof(searchMemberLookUp.OtaInsuranceShuki__c);
        otaInsuranceShuki2 = ' and OtaInsuranceShuki__c <=' + string.valueof(searchMemberLookUp2.OtaInsuranceShuki__c)+')';
    }

    if(otaInsuranceShuki==null){
        otaInsuranceShuki='';
    }   
    if(otaInsuranceShuki2==null){
        otaInsuranceShuki2='';
    }
        
    string todayDate=  string.valueof(system.today());
       
    // check where the page enter in
    List<MemberInfo__c> ms = null;
    if(ci.id == null){
        IsComeFromViewList = true;        
             ms = [select Id, Name,KinmuCompany__r.Name, MankiDate__c,MemberNo__c, ShozokuArea__c,OtaInsuranceShuki__c,KeiyakuKeitai__c,KinmuCompany__r.CompanyNameEng__c,SeiMeiRoma__c,
            (select Id, Name ,MemberNo__c, ShozokuArea__c,SeiMeiRoma__c  from FamilyMembers__r 
            where TaikaiDate__c=:null or TaikaiDate__c>=:system.today()
            order by MemberNo__c)
            from MemberInfo__c
            where (OtaInsuranceShuki__c >=:searchMemberLookUp.OtaInsuranceShuki__c and OtaInsuranceShuki__c <=:searchMemberLookUp2.OtaInsuranceShuki__c)
            and InsuranceKind__c =: searchMemberLookUp.InsuranceKind__c and (TaikaiDate__c =:null or TaikaiDate__c >=:system.today()) 
            order by KinmuCompany__r.Name, MemberNo__c];        
    } 
    else{
          IsComeFromViewList = false;
          String query = 'select Id, Name,KinmuCompany__r.Name, MemberNo__c,MankiDate__c, ShozokuArea__c,OtaInsuranceShuki__c,KeiyakuKeitai__c,KinmuCompany__r.CompanyNameEng__c,SeiMeiRoma__c,(select Id, Name ,MemberNo__c, ShozokuArea__c,SeiMeiRoma__c from FamilyMembers__r where TaikaiDate__c = null or TaikaiDate__c >= '+ todayDate+' order by MemberNo__c) from MemberInfo__c where CompanyKeiyakuNo__c=\''+ci.Id+'\''+otaInsuranceShuki + otaInsuranceShuki2 +kinmuCompanyName+' and (TaikaiDate__c =null or TaikaiDate__c >='+ todayDate+') order by KinmuCompany__r.Name, MemberNo__c ';    
          system.debug(query);
          ms = Database.query(query);
          system.debug('This is MS result:' + ms);
    }  

     
    for(integer i=0; i<ms.size(); i++)
      Rows.add(new MRow(ms[i]));         
  }
  
  public void closeSearchResult(){
      openSearchResult = false;
  }
  
  public void itemClear(){    
     Map <String,Boolean> stringToBoolean = new Map <String,Boolean>();
     stringToBoolean.put('on',true);
     stringToBoolean.put('null',false);
     
     
    //get checkbox value from the page 
    bLDocumentCheckbox = stringToBoolean.get(ApexPages.currentPage().getParameters().get('bLDocument'));
    bLDocumentKeepingPlaceCheckbox = stringToBoolean.get(ApexPages.currentPage().getParameters().get('bLDocumentKeepingPlace'));
    homeCountryCoverageCheckbox = stringToBoolean.get(ApexPages.currentPage().getParameters().get('homeCountryCoverage'));
    oTaRemarksCheckbox = stringToBoolean.get(ApexPages.currentPage().getParameters().get('oTaRemarks'));
  
    system.debug(bLDocumentCheckbox);  
    system.debug(bLDocumentKeepingPlaceCheckbox);  
    system.debug(homeCountryCoverageCheckbox );  
    system.debug(oTaRemarksCheckbox );  
    
  
     if(bLDocumentCheckbox == true){
        for(integer i=0; i<Rows2.size(); i++)
        {
              MemberInfo__c m = Rows2[i].Member;
              m.ShokenNo__c = null;
           
            for(integer j=0; j<Rows2[i].FamilyMembers.size(); j++)
            {
              system.debug(Rows2[i]);
              FamilyInfo__c f = Rows2[i].FamilyMembers[j].Family;
              f.ShokenNo__c = null;
            }
        
        }
      }    
  
     if(bLDocumentKeepingPlaceCheckbox == true){
        for(integer i=0; i<Rows2.size(); i++)
        {
              MemberInfo__c m = Rows2[i].Member;
              m.OtaKeepPlace__c = null;
           
            for(integer j=0; j<Rows2[i].FamilyMembers.size(); j++)
            {
              FamilyInfo__c f = Rows2[i].FamilyMembers[j].Family;
              f.OtaKeepPlace__c = null;
            }
        
        }
      }
      
     if(homeCountryCoverageCheckbox == true){
        for(integer i=0; i<Rows2.size(); i++)
        {
              MemberInfo__c m = Rows2[i].Member;
              m.HomeCountryCoverage__c = false;
           
            for(integer j=0; j<Rows2[i].FamilyMembers.size(); j++)
            {
              FamilyInfo__c f = Rows2[i].FamilyMembers[j].Family;
              f.HomeCountryCoverage__c = false;
            }
        
        }
      }      
      
     if(oTaRemarksCheckbox == true){
        for(integer i=0; i<Rows2.size(); i++)
        {
              MemberInfo__c m = Rows2[i].Member;
              m.OtaNote__c = null;
           
            for(integer j=0; j<Rows2[i].FamilyMembers.size(); j++)
            {
              FamilyInfo__c f = Rows2[i].FamilyMembers[j].Family;
              f.OtaNote__c = null;
            }
        
        }
      }         
  }
  
  public PageReference searchPageBack(){ 
     String id = null;
     String spaceDelimeted = null;
     if (recordId == null){
         if(ApexPages.currentPage().getParameters().get('retURL')!=null){
             id = ApexPages.currentPage().getParameters().get('retURL').right(15); //get pervious page id
         }
         spaceDelimeted = '/a0A?fcf='+id;
     }
     else 
      spaceDelimeted  = '/'+recordId;
     
     PageReference reference = new PageReference(spaceDelimeted);  
     reference.setRedirect(true);
     return reference;
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
    List<MemberInfo__c> members = [select Id, KinmuCompany__r.Name, MemberNo__c, Name,KinmuCompany__r.CompanyNameEng__c,SeiMeiRoma__c,
        OtaName__c, InsuranceKind__c, OtaAgency__c, ShokenNo__c, ShokenGetSituation__c, OtaKeepPlace__c,
        MedicalBillKessaiHouhou__c, OtaInsuranceShiki__c, OtaInsuranceShuki__c, InsurancePlan__c,
        InsuranceCurrency__c, InjuryDeathCost__c, TreatmentCost__c, TreatmentRescueCost__c, DiseaseCost__c,
        InjuryCost__c, DiseaseDeathCost__c, RescueCost__c, DamagesCost__c, CarryCost__c, OtaNote__c,
        HomeCountryCoverage__c, ShozokuArea__c,
        (select Id, MemberNo__c, Name, ShozokuArea__c,
        OtaName__c, InsuranceKind__c, OtaAgency__c, ShokenNo__c, ShokenGetSituation__c, OtaKeepPlace__c,
        MedicalBillKessaiHouhou__c, OtaInsuranceShiki__c, OtaInsuranceShuki__c, InsurancePlan__c,
        InsuranceCurrency__c, InjuryDeathCost__c, TreatmentCost__c, TreatmentRescueCost__c, DiseaseCost__c,
        InjuryCost__c, DiseaseDeathCost__c, RescueCost__c, DamagesCost__c, CarryCost__c, OtaNote__c,
        HomeCountryCoverage__c,SeiMeiRoma__c
        from FamilyMembers__r where (TaikaiDate__c=:null or TaikaiDate__c>:system.today()) and id in :FamilyMemberOwnids order by MemberNo__c)       
        from MemberInfo__c 
        where Id in :ids 
        order by KinmuCompany__r.Name, MemberNo__c];
    
    system.debug('members: ' +members);
    //for(integer i=0; i<members.size(); i++)
    //  Rows2.add(new MRow2(members[i]));
     
    Rows2Member.clear(); 
    //Extract selected members  
    List<MemberInfo__c> membersOnly = [select Id, KinmuCompany__r.Name, MemberNo__c, Name,KinmuCompany__r.CompanyNameEng__c,SeiMeiRoma__c
        from MemberInfo__c 
        where Id in :MemberOnlyids 
        order by KinmuCompany__r.Name, MemberNo__c];
    
    //for(integer i=0; i<membersOnly.size(); i++)
    //  Rows2Member.add(new MRow2(membersOnly[i]));
    

    Rows2FamilyMember.clear();   
    //Extract selected family members
    List<MemberInfo__c> familyMembersOnly = [select Id, KinmuCompany__r.Name, MemberNo__c, Name,KinmuCompany__r.CompanyNameEng__c,SeiMeiRoma__c,
        (select Id, MemberNo__c,SeiMeiRoma__c
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
    
    PopupMessage = '';
    
    return Page.NewContractMassUpdate2;
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
    
    PopupMessage = System.Label.Updated;
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
        }
    
    }
    
    Common.OtaName__c = null;
    Common.InsuranceKind__c = null;
    Common.OtaAgency__c = null;
    Common.ShokenNo__c = null;
    Common.ShokenGetSituation__c = null;
    Common.OtaKeepPlace__c = null;
    Common.MedicalBillKessaiHouhou__c = null;
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
    
    PopupMessage = System.Label.Copied;
  }
  
  public PageReference cancel2()
  {
    PopupMessage = '';
    Rows2.clear();
    return Page.NewContractMassUpdate;
  }
  
  public PageReference end()
  {
    return new PageReference('/' + ci.Id);
  }
}