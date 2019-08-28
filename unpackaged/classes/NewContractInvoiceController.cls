public class NewContractInvoiceController
{
  public date MankiDateP { get; set; }
  /*
  public integer KeitaiCdS1 { get; set; }
  public integer KeitaiCdF1 { get; set; }
  public integer KeitaiCdM1 { get; set; }
  public integer KeitaiCdS2 { get; set; }
  public integer KeitaiCdF2 { get; set; }
  public integer KeitaiCdM2 { get; set; }
  public integer KeitaiCdS3 { get; set; }
  public integer KeitaiCdF3 { get; set; }
  public integer KeitaiCdM3 { get; set; }
  public integer KeitaiCdS4 { get; set; }
  public integer KeitaiCdF4 { get; set; }
  public integer KeitaiCdM4 { get; set; }
  public integer KeitaiCdS5 { get; set; }
  public integer KeitaiCdF5 { get; set; }
  public integer KeitaiCdM5 { get; set; }  
  */
  public Map<String, Integer> KeitaiCdMap { get; set;}    
  public CustomerData Data { get; set; }
  public boolean IsPersonal {get; set; }
  public boolean isEnglish {get; set;}
  public MemberInfo__c Member {get; set;}
  public ContractInfo__c translationContractInfo{ get; set; }  
 
  private ApexPages.StandardController m_con;
  private ContractInfo__c m_ci;
    
  private string m_selTemplate = '';
  private List<SelectOption> m_options = new List<SelectOption>();
  
  public NewContractInvoiceController(ApexPages.StandardController con)
  {
    translationContractInfo = new ContractInfo__c();
    m_con = con;
    m_ci = (ContractInfo__c)con.getRecord();
    IsPersonal = false;
    isEnglish = 'en_US'.equals(UserInfo.getLanguage()); //check profile language
    System.debug('isEnglish:' + isEnglish);
    
    if(m_ci.KeiyakuCompanyName__r.Name.indexOf(System.Label.IndividualContract)>=0)
    {
      IsPersonal = true;
      Member = [select Id, Name
        from MemberInfo__c 
        where (TaikaiDate__c=:null or TaikaiDate__c>:System.today()) 
        and MankiDate__c=:m_ci.MankiDate__c
        and CompanyKeiyakuNo__c=:m_ci.Id];
    }
    
    MankiDateP = m_ci.MankiDate__c.addYears(-1);
    
    List<Document> ls =  new List<Document>();
    
    if(isEnglish)
    {
        ls = [select Id, Name from Document where Folder.Name='Invoice Template_ENG'];
    }
    else
    {
        ls = [select Id, Name from Document where Folder.Name='Invoice Template_JPN'];
    }
    
    for(integer i=0; i<ls.size(); i++)
    {
      m_options.add(new SelectOption(ls[i].Id, ls[i].Name));
      if(m_selTemplate=='') m_selTemplate = ls[i].Id;
    }
    
     // translation of DiscountShubetsu__c and TaxIncentives__c
    ContractInfo__c translatedConTract = [select toLabel(DiscountShubetsu__c) ,toLabel(KeiyakuCompanyName__r.TaxIncentives__c) from ContractInfo__c where id = :m_ci.id limit 1 ];
    //m_ci.DiscountShubetsu__c = translatedConTract.DiscountShubetsu__c;
    m_ci.KeiyakuCompanyName__r.TaxIncentives__c = translatedConTract.KeiyakuCompanyName__r.TaxIncentives__c;        
    translationContractInfo.DiscountShubetsu__c = translatedConTract.DiscountShubetsu__c;    
  }
  
  public void Init()
  {
    List<MemberInfo__c> lmi = 
        [select Id, Name, SeiMeiRoma__c, MemberNo__c, Tanto__c, Commodity__c, KeiyakuKeitai__c, MankiDate__c, Address__c, KeitaiCd__c, IVPrintPositionCd__c,
        Tel__c, Mobile__c, OtaName__c, OtaAgency__c, ShokenNo__c, OtaInsuranceShuki__c, OtaRyaku__c,ServiceKeitaiCd__c ,InsuranceKindRyaku__c ,
        InsurancePlan__c, ShokenGetSituation__c, Email__c, MailHaishin__c, 
        
        toLabel(CompanyKeiyakuNo__r.KeiyakuArea__c), 
        toLabel(KinmuCompany__r.Jurisdiction__c), 
        toLabel(KinmuCompany__r.ShozokuArea__c),//Added
        
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
        KinmuCompany__r.EigyoTanto__r.SeiMeiRoma__c, 
        KinmuCompany__r.EigyoTanto__r.Name, 
        KinmuCompany__r.NaimuTanto__r.SeiMeiRoma__c, 
        KinmuCompany__r.NaimuTanto__r.Name, 
        
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
        CompanyKeiyakuNo__r.KeiyakuCompanyName__r.AffiliatedCompanyName__r.AffiliatedCompanyNameEng__c,
        CompanyKeiyakuNo__r.KeiyakuCompanyName__r.GroupName__r.Name,
        CompanyKeiyakuNo__r.KeiyakuCompanyName__r.GroupName__r.GroupNameEng__c,
        
            (select Id, SeiMeiRoma__c ,MemberNo__c, Name, Commodity__c, KeiyakuKeitai__c, Mobile__c,InsurancePlan__c,
            OtaName__c, OtaAgency__c, ShokenNo__c, OtaInsuranceShuki__c, MemberShimei__c, OtaRyaku__c,
            ShokenGetSituation__c, Email__c, MailHaishin__c
            from FamilyMembers__r
            where (TaikaiDate__c=null or TaikaiDate__c>:m_ci.MankiDate__c) 
            order by MemberNo__c)
        from MemberInfo__c
        where (TaikaiDate__c=:null or TaikaiDate__c>:m_ci.MankiDate__c) 
        and MankiDate__c=:m_ci.MankiDate__c
        and CompanyKeiyakuNo__c=:m_ci.Id
        order by MemberNo__c];
    
    Data = new CustomerData();
   /* KeitaiCdS1 = 0;
    KeitaiCdF1 = 0;
    KeitaiCdM1 = 0;
    KeitaiCdS2 = 0;
    KeitaiCdF2 = 0;
    KeitaiCdM2 = 0;
    KeitaiCdS3 = 0;
    KeitaiCdF3 = 0;
    KeitaiCdM3 = 0;
    KeitaiCdS4 = 0;
    KeitaiCdF4 = 0;
    KeitaiCdM4 = 0;
    KeitaiCdS5 = 0;
    KeitaiCdF5 = 0;
    KeitaiCdM5 = 0;    
    */
    KeitaiCdMap = new Map<String, Integer>();   
    
    for(integer i=0; i<lmi.size(); i++)
    {
        MemberInfo__c m = lmi[i];
        
        Integer keitaiCd = KeitaiCdMap.get(m.KeitaiCd__c + m.IVPrintPositionCd__c);
        if(keitaiCd !=null){
            KeitaiCdMap.put(m.KeitaiCd__c + m.IVPrintPositionCd__c, keitaiCd + 1);
        }else{
            KeitaiCdMap.put(m.KeitaiCd__c + m.IVPrintPositionCd__c, 1);
        }
        /*        
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
        else if(m.KeitaiCd__c=='S'&& m.IVPrintPositionCd__c=='4')
          KeitaiCdS4 = KeitaiCdS4 + 1;
        else if(m.KeitaiCd__c=='F'&& m.IVPrintPositionCd__c=='4')
          KeitaiCdF4 = KeitaiCdF4 + 1;
        else if(m.KeitaiCd__c=='M'&& m.IVPrintPositionCd__c=='4')
          KeitaiCdM4 = KeitaiCdM4 + 1;  
        else if(m.KeitaiCd__c=='S'&& m.IVPrintPositionCd__c=='5')
          KeitaiCdS5 = KeitaiCdS5 + 1;
        else if(m.KeitaiCd__c=='F'&& m.IVPrintPositionCd__c=='5')
          KeitaiCdF5 = KeitaiCdF5 + 1;
        else if(m.KeitaiCd__c=='M'&& m.IVPrintPositionCd__c=='5')
          KeitaiCdM5 = KeitaiCdM5 + 1;  
        */  
          
          
                         
        CustomerData.MemberHeader mh = new CustomerData.MemberHeader(m.KinmuCompany__r, m.CompanyKeiyakuNo__r, m.CompanyKeiyakuNo__r.KeiyakuCompanyName__r,isEnglish);  
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
    system.debug(KeitaiCdMap);
  }
  
  public PageReference complete()
  {
    m_ci.SeikyuIssueDate__c = system.today();
    update(m_ci);
    return m_con.cancel();
  }
  
  public string SelectedTemplate { get { return m_selTemplate; } set { m_selTemplate = value; } }
  public List<SelectOption> TemplateOptions { get { return m_options; } }
  public string SessionId { get { return UserInfo.getSessionId(); } }
 
}