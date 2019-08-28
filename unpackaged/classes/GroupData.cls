public class GroupData
{
  public List<Row> Rows {get; set;}
  
  public GroupData()
  {
    Rows = new List<Row>();
  }
  
  public Row addRow(Account okinmuCompany, Account okeiyakuCompany)
  {
  	Row r = new Row(okinmuCompany, okeiyakuCompany);
  	integer i=0;
    for(i=0; i<Rows.size(); i++)
    {
    	if( (okinmuCompany.CompanyCd__c < Rows[i].KinmuCompany.CompanyCd__c) ||
    	    ( (okinmuCompany.CompanyCd__c == Rows[i].KinmuCompany.CompanyCd__c) &&
    	      (okeiyakuCompany.Name < Rows[i].KeiyakuCompany.Name) ) )
    		break;
    }
    if(i>=Rows.size())
    	Rows.add(r);
    else
    	Rows.add(i, r);
    return r;
  }
  
  public class Row
  {
    public Account KinmuCompany {get; set;}
    public Account KeiyakuCompany {get; set; }
    public integer KeitaiCdS { get; set; }
    public integer KeitaiCdF { get; set; }
    public integer KeitaiCdM { get; set; }
    public boolean OtaAgency {get; set; }
    public integer Ichiroheian {get; set; }
    public integer OIIchiroheian {get; set; }
    public boolean BL {get; set;}
    public integer Kenshin {get; set;}
    public Row(Account okinmuCompany, Account okeiyakuCompany)
    {
      KinmuCompany = okinmuCompany;
      KeiyakuCompany = okeiyakuCompany;
      KeitaiCdS = 0;
      KeitaiCdF = 0;
      KeitaiCdM = 0;
      OtaAgency = false;
      Ichiroheian = 0;
      OIIchiroheian = 0;
      BL = false;
      Kenshin = 0;
    }
    public boolean Match(Account okinmuCompany, Account okeiyakuCompany)
    {
      return ((KinmuCompany.Id==okinmuCompany.Id) && (KeiyakuCompany.Id==okeiyakuCompany.Id));
    }
    public boolean Match(Account okinmuCompany)
    {
      return (KinmuCompany.Id==okinmuCompany.Id);
    }
  }
  
  
  
  static testMethod void GroupData_Test()
  {
  	Account ac1 = TestUtil.createTestAccount();
  	Account ac2 = TestUtil.createTestAccount();	
  	
  	GroupData data = new GroupData();
  	data.Rows.add(new Row(ac1,ac2));
  	
  	boolean b = data.Rows[0].Match(ac1, ac2);
  	b = data.Rows[0].Match(ac1);
  }
  
}