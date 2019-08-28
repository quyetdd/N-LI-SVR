@RestResource(urlMapping='/2ndPhs/MobileAppMembershipCheck/*')
global with sharing class wb_soap_MobileAppMembershipCheck_2ndPhs {
    
    global class MembershipStatus{
        global string Id; 
        global string Status;
        global string Commodity;
        global string lastmodifieddate; 
        global wb_soap_MobileAppMemberInfo_2ndPhs.AreaControl AreaControl;
        global string ServiceAreaCode; 
        global string Type;
       public MembershipStatus (string theID, string theStatus,datetime dt){
            Id = theID;
            Status = theStatus;
            if ( dt != null) {
           // String formatedDt = dt.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
           // lastmodifieddate = formatedDt;
            lastmodifieddate = dt.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
            }
        } 
        
        public MembershipStatus (MemberInfo__c I){
            Id = I.Id;
            Status = I.MemberKubunB__c;
            Commodity =  I.Commodity__c;
            datetime dt = I.lastmodifieddate;
            if ( dt != null) {
           // String formatedDt = dt.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
           // lastmodifieddate = formatedDt;
           lastmodifieddate = dt.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
            }
             ServiceAreaCode = I.ServiceAreaCd__c;
             AreaControl = new wb_soap_MobileAppMemberInfo_2ndPhs.AreaControl(I);
            Type = 'M';
        }
        
        public MembershipStatus (FamilyInfo__c I){
            Id = I.Id;
            Status = I.MemberKubunB__c;
            Commodity =  I.Commodity__c;
            datetime dt = I.lastmodifieddate;
            if ( dt != null) {
                //String formatedDt = dt.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
               // lastmodifieddate = formatedDt;
               lastmodifieddate = dt.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
            }
             ServiceAreaCode = I.ServiceAreaCd__c;
            AreaControl = new wb_soap_MobileAppMemberInfo_2ndPhs.AreaControl(I);
            Type = 'F';
        }
    }


    global class MemberID{
        global string Id;
        public MemberID(String i){
            Id = i;
        }
    }     

    @HttpGet
    global static List<MembershipStatus> getMembershipStatusParam() {
  //  global static string getMembershipStatusParam() {
        RestRequest req = RestContext.request;
        //system.debug(req);
      //  return String.valueOf( req);
        
        string lastmodifieddate;
        string dtype;
        if ( req.params.get('lastmodifieddate') != null) {
            lastmodifieddate= req.params.get('lastmodifieddate');
              dtype = req.params.get('type');
          //  if (lastmodifieddate != null ) {
               Datetime dt1 = Datetime.valueOf(lastmodifieddate); //= date.parse(mlastmodifieddate); //Datetime.valueOf(plastmodifieddate);
               return getStatus(dt1, dtype);
          /*  } else {
                   dtype = req.params.get('type');
                 return getStatus(null, dtype );
            }*/
        } else {
            dtype = req.params.get('type');
            return getStatus(null, dtype );
        }
      //  return null; 
        
    } 
    
    global static  List<MembershipStatus> getStatus(datetime plastmodifieddate, string dtype){
         
        List<MembershipStatus> MS = new  List<MembershipStatus>();       
        if (dtype == 'M') {
        List<MemberInfo__c>  M = [select id, MemberNo__c, CompanyKeiyakuNo__r.MankiDate__c, MemberKubunB__c,lastmodifieddate,
                                  //KinmuCompany__r.Region_and_Area__c, KinmuCompany__r.CountryName__c, KinmuCompany__r.Jurisdiction__c, KinmuCompany__r.ShozokuArea__c,
                                  Region_and_Area__c, CountryName__c, Jurisdiction__c, ShozokuArea__c,
                                  Commodity__c, ServiceAreaCd__c
                                  from MemberInfo__c 
                                  where lastmodifieddate >=:plastmodifieddate order by lastmodifieddate limit 5000];
        
            for ( MemberInfo__c l:M){
                MS.add( new MembershipStatus(l));
            } 
        } else if (dtype == 'F'){
        
        
        List<FamilyInfo__c>  F =  [select id, MemberShimei__r.CompanyKeiyakuNo__r.MankiDate__c,
                                   MemberKubunB__c, lastmodifieddate,
                                   //MemberShimei__r.KinmuCompany__r.Region_and_Area__c, MemberShimei__r.KinmuCompany__r.CountryName__c, 
                                   //MemberShimei__r.KinmuCompany__r.Jurisdiction__c, MemberShimei__r.KinmuCompany__r.ShozokuArea__c,
                                   Region_and_Area__c, CountryName__c, Jurisdiction__c, ShozokuArea__c,
                                   Commodity__c,  ServiceAreaCd__c
                                   from FamilyInfo__c 
                                   where lastmodifieddate >=:plastmodifieddate order by lastmodifieddate limit 5000];
        
        for ( FamilyInfo__c l:F){
            MS.add( new MembershipStatus(l));
        } 
            
        }
        
        return MS;
    }
    
        
    @HttpPost
    global static List<MembershipStatus> getMembershipStatus( List<MemberID> MemberList){
        
        List <String> IDs = New List <String>();
   		List <String> FoundIDs = New List <String>();
        
        for ( MemberID l:MemberList){
            IDs.add(l.Id );
        } 
        
        List<MembershipStatus> MS = new  List<MembershipStatus>();        
        List<MemberInfo__c>  M =  [select id, MemberNo__c, CompanyKeiyakuNo__r.MankiDate__c, MemberKubunB__c,lastmodifieddate,
                                  // KinmuCompany__r.Region_and_Area__c, KinmuCompany__r.CountryName__c, KinmuCompany__r.Jurisdiction__c, KinmuCompany__r.ShozokuArea__c,
                                   Region_and_Area__c, CountryName__c, Jurisdiction__c, ShozokuArea__c,
                                   Commodity__c, ServiceAreaCd__c
                                   from MemberInfo__c 
                                   where Id =:IDs];
        
        for ( MemberInfo__c l:M){
           // MS.add( new MembershipStatus(l.Id, l.MemberKubunB__c,l.lastmodifieddate));
             MS.add( new MembershipStatus(l));
            FoundIDs.add(l.Id);
        } 
        
        
        List<FamilyInfo__c>  F =  [select id, MemberShimei__r.CompanyKeiyakuNo__r.MankiDate__c,
                                   MemberKubunB__c, lastmodifieddate,
                                   //MemberShimei__r.KinmuCompany__r.Region_and_Area__c, MemberShimei__r.KinmuCompany__r.CountryName__c, 
                                   //MemberShimei__r.KinmuCompany__r.Jurisdiction__c, MemberShimei__r.KinmuCompany__r.ShozokuArea__c,
                                   Region_and_Area__c, CountryName__c, Jurisdiction__c, ShozokuArea__c,
                                   Commodity__c,  ServiceAreaCd__c
                                   from FamilyInfo__c 
                                   where Id =:IDs];
        
        for ( FamilyInfo__c l:F){
            //MS.add( new MembershipStatus(l.Id, l.MemberKubunB__c,l.lastmodifieddate));
            MS.add( new MembershipStatus(l));
            FoundIDs.add(l.Id);
        } 
        
        for ( MemberID l:MemberList){
            if ( !FoundIDs.contains(l.Id)){
                MS.add( new MembershipStatus(l.Id, 'Not Exist',null));
            }
        }
        
      //  String str = JSON.serialize(FoundIDs); 
     //   InsertLog(str);
        InsertLog(FoundIDs);
        return MS;
    }
    /*
    public static void InsertLog( string Str ){
             
            insert new wb_soap_log__c(LastAcessDate__c= System.today(),JStr__c=Str,Type__c ='2ND');

        
    }
    */
     public static void InsertLog( List<string> IDs ){
         
         List <String> LogIDs = New List <String>();
         
         for ( integer i = 0; i < IDs.size(); i ++ ){
             
             if (math.mod(i + 1, 1000) == 0 ) {
                 LogIDs.add(IDs[i]);        
                 string str = JSON.serialize(LogIDs);
                 insert new wb_soap_log__c(LastAcessDate__c= System.today(),JStr__c=Str,Type__c ='2ND');
                 LogIDs = New List <String>();
                 
             } else {
                 LogIDs.add(IDs[i]);
             }
         }
         
         if (LogIDs.size() > 0 ){
              string str = JSON.serialize(LogIDs);
              insert new wb_soap_log__c(LastAcessDate__c= System.today(),JStr__c=Str,Type__c ='2ND');
         }
         
     }


}