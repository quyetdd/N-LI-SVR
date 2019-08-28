@RestResource(urlMapping='/2ndPhs/AffiliatedHospital/*')
global with sharing class wb_soap_AffiliatedHospital_2ndPhs {
    
    global class AffiliatedHospital{
        global Id Id; 
        
        global string ContractHospitalName;
        global string ContractHospitalPopularName;
        
        global string ContractArea;
        global string ContractCountry;   
        global string ContractRegion;
        global string ContractZone;
        global string ContractCategory;
        
        global string HospitalAddress;
        global string HospitalTel;
        global string HospitalInfo24Hours;
        global string HospitalInfo24HoursRemarks;
        global string HospitalInfoMedicalDepartment;
        global string HospitalInfoSurgeryHours;
        global string HospitalInfoVisitTo;
        global string HospitalInfoHospitalStaffLanguage;
        
        global string WBStaffStationedHospital;
        global string WBStaffStationedTime;
        global string LongitudeLatitude;
        
        global string HospitalCategoryOrder;    
        global string HospitalSortOrder;
        global string CountrySortOrder;
        global string RegionSortOrder;
        global string ZoneSortOrder;
        
        public AffiliatedHospital(AffiliatedHospital__c h){
            Id = h.Id;
            
            ContractHospitalName= h.Contract_HospitalName__c;
            ContractHospitalPopularName= h.Contract_HospitalPopularName__c;
            
            
            ContractArea= h.Contract_Area__c;
            ContractCountry= h.Contract_Country__c;
            ContractZone= h.Contract_Zone__c;
            ContractRegion= h.Contract_Region__c;
            ContractCategory= h.Contract_Category__c;
            
            HospitalAddress	= h.Hospital_Address__c;
            HospitalTel= h.Hospital_Tel__c;
            HospitalInfo24Hours	= h.HospitalInfo_24Hours__c;
            HospitalInfo24HoursRemarks = h.HospitalInfo_24HoursRemarks__c;
            HospitalInfoMedicalDepartment= h.HospitalInfo_MedicalDepartment__c;
            HospitalInfoVisitTo	= h.HospitalInfo_VisitTo__c;
            HospitalInfoSurgeryHours= h.HospitalInfo_SurgeryHours__c;
            HospitalInfoHospitalStaffLanguage= h.HospitalInfo_HospitalStaffLanguage__c;
            
            WBStaffStationedHospital= h.WBStaff_StationedHospital__c;
            WBStaffStationedTime= h.WBStaff_StationedTime__c;
            LongitudeLatitude= h.Longitude_Latitude__c;
            
            HospitalCategoryOrder= string.valueOf(h.Hospital_Category_Order__c);
            HospitalSortOrder= string.valueOf(h.Hospital_Sort_Order__c);
            
            CountrySortOrder= string.valueOf( h.Country_Sort_Order__c);    
            RegionSortOrder= string.valueOf(h.Region_Sort_Order__c);
            //ZoneSortOrder = h.Contract_Zone__c;
            ZoneSortOrder= string.valueOf(h.Zone_Sort_Order__c);
            
        }
        
    }
    
    
    @HttpGet
    global static List<AffiliatedHospital> getAffiliatedHospitalInfo() {

        
        RestRequest req = RestContext.request;
        
        string HospitalName;
        if ( req.params.get('HospitalName') != null)
            HospitalName= req.params.get('HospitalName');
        
        string Country;
        if (  req.params.get('Country') != null)
            Country =  req.params.get('Country') ;
        date PostRequestDate;
        if (req.params.get('PostRequestDate') != null)
            PostRequestDate = date.parse(req.params.get('PostRequestDate'));
        date DeleteRequestDate;
        if (req.params.get('DeleteRequestDate')!=null)
            DeleteRequestDate = date.parse(req.params.get('DeleteRequestDate'));
        
      //  insert new APIDebugLog__c(Log__c='@@@ params HospitalName= '+HospitalName+' Country='+Country+' PostRequestDate='+PostRequestDate);
        
        string wheresql;
        
        if (HospitalName != null) {
 
             wheresql = '  Contract_HospitalName__c like \'%' + HospitalName + '%\' ' ; 
        }
        
        if (Country != null) {
            if (wheresql == null)
       
            	wheresql = ' Contract_Country__c like \'%' + Country + '%\'  ' ; 
            else 
          
            	wheresql = wheresql + ' and Contract_Country__c like \'%' + Country + '%\' ' ; 
        }
        
        
        
        if (PostRequestDate != null) {
     
            Datetime dt = datetime.newInstance(PostRequestDate.year(), PostRequestDate.month(),PostRequestDate.day());
            String formattedDate = dt.format('YYYY-MM-dd');
            
            if (wheresql == null)
       
                wheresql = '  Post_HPPostRequestedDate__c >= ' + formattedDate + ' and f_AppPostingTarget__c = true  '  ; 
            else 
                wheresql = wheresql + ' and  Post_HPPostRequestedDate__c >= ' + formattedDate + ' and f_AppPostingTarget__c = true  ';  
        }
        
        if (DeleteRequestDate != null) {
            // Datetime dt = new Datetime(PostingRequestDate);
            Datetime dt = datetime.newInstance(DeleteRequestDate.year(), DeleteRequestDate.month(),DeleteRequestDate.day());
            String formattedDate = dt.format('YYYY-MM-dd');
            
            if (wheresql == null)
                wheresql = ' Post_HPDeleteRequestedDate__c >= ' + formattedDate + ' and f_AppDeleteTarget__c = true ' ; 
            else 
                wheresql = wheresql + ' and Post_HPDeleteRequestedDate__c >= ' + formattedDate + ' and f_AppDeleteTarget__c = true ' ;  
        }
        
        if (PostRequestDate !=null && DeleteRequestDate != null )
            return null;
        
        List<AffiliatedHospital__c> HospitalList = new List<AffiliatedHospital__c>();
        
        
        
        
        if (wheresql != null ){
  
            string soql = ' select id, Zone_Sort_Order__c, WBStaff_StationedTime__c, WBStaff_StationedHospital__c, Region_Sort_Order__c, ';
            soql = soql + ' Longitude_Latitude__c,Hospital_Tel__c,Hospital_Sort_Order__c,HospitalInfo_VisitTo__c,HospitalInfo_SurgeryHours__c,';
            soql = soql + ' HospitalInfo_MedicalDepartment__c,HospitalInfo_HospitalStaffLanguage__c,HospitalInfo_24Hours__c,HospitalInfo_24HoursRemarks__c,';
            soql = soql + ' Hospital_Category_Order__c,Hospital_Address__c,Country_Sort_Order__c,Contract_Zone__c,Contract_Region__c,';
            soql = soql + ' Contract_HospitalPopularName__c,Contract_HospitalName__c,Contract_Country__c,Contract_Category__c,Contract_Area__c';
            soql = soql + ' from AffiliatedHospital__c where ' + wheresql ; //+ ' limit 3';
           // insert new APIDebugLog__c(Log__c=soql);
            HospitalList = Database.query(soql);
            
        }
        
        List<AffiliatedHospital> Lst = new List<AffiliatedHospital>();
        if (HospitalList.size()>0) {
            
            
            for (AffiliatedHospital__c h:HospitalList){
                // Lst.add(new AffiliatedHospital(h,HospitalInfo_24HoursRemarksList) );
                Lst.add(new AffiliatedHospital(h) );
            } 
        }
        
        
        return  Lst;
        
    }
    
    global class SimularGroup{
        global string Area;
        global string Country;
        global string Region;
        global string Zone;
        global string Category;
    }
    
    global class SimularHospital{
        
        global string ContractArea;
        global string ContractCountry;   
        global string ContractRegion;
        global string ContractZone;
        global string ContractCategory;
        
        global Id Id; 
        global string ContractHospitalName;
        global string HospitalSortOrder;
        
        
        
        public SimularHospital(AffiliatedHospital__c h){
            
            ContractArea= h.Contract_Area__c;
            ContractCountry= h.Contract_Country__c;
            ContractZone= h.Contract_Zone__c;
            ContractRegion= h.Contract_Region__c;
            ContractCategory= h.Contract_Category__c;
            
            Id = h.Id;
            
            ContractHospitalName= h.Contract_HospitalName__c;
            HospitalSortOrder= string.valueOf(h.Hospital_Sort_Order__c);
            
            
        }
        
    }
     
    
    @HttpPost
    global static List<SimularHospital> returnSimularHospitalInfo(SimularGroup HGroup){
        
        List<AffiliatedHospital__c> HospitalList = new List<AffiliatedHospital__c>();
        
        if (HGroup != null ){
            
         //   insert new APIDebugLog__c(Log__c=HGroup.Area);
            HospitalList = [select Contract_Area__c,Contract_Country__c,Contract_Zone__c,Contract_Region__c,Contract_Category__c,
                            Id,Contract_HospitalName__c,Hospital_Sort_Order__c
                            from AffiliatedHospital__c
                            where Contract_Area__c=: HGroup.Area  and Contract_Country__c =:HGroup.Country
                            and Contract_Region__c =:HGroup.Region  and Contract_Zone__c =:HGroup.Zone
                            and Contract_Category__c =:HGroup.Category ];
            /*
                            where Contract_Area__c=: HGroup.Area  and Contract_Country__c =:HGroup.Country
                            and Contract_Region__c =:HGroup.Region  and Contract_Zone__c =:HGroup.Region
                            and Contract_Category__c =:HGroup.Category ]; */
            
        }
        
        List<SimularHospital> Lst = new List<SimularHospital>();
        if (HospitalList.size()>0) {
            
            for (AffiliatedHospital__c h:HospitalList){
                
                Lst.add(new SimularHospital(h) );
            } 
        }
        
        
        return  Lst;
        
    }
    
    global class AffiliatedHospitalPatchStatus{
        global string Id; 
        global string Status; 
        AffiliatedHospitalPatchStatus(Id theID, string theStatus){
            Id = theID;
            Status = theStatus;
        }
    }   

    global class HospitalOrder{
        global Id Id; 
        global integer SortOrder;
    }   
    
    global class AffiliatedHospitalPatchDate{
        global Id Id; 
        global date theDate; 
        AffiliatedHospitalPatchDate(Id aID, date aDate){
            Id = aID;
            theDate = aDate;
        }
        global AffiliatedHospitalPatchDate(){
            
        }
    }   
    
    @HttpPatch

    global static List<AffiliatedHospitalPatchStatus> updateAffiliatedHospital
        (
            List<HospitalOrder> PatchSortOrder,
            List<AffiliatedHospitalPatchDate> PatchPostingDate,
            List<AffiliatedHospitalPatchDate> PatchDeletedDate
        )
    {    
        
        if (PatchSortOrder != null && PatchPostingDate == null && PatchDeletedDate == null){
            
            if ( PatchSortOrder.size() > 0) {
                SavePoint sp = Database.setSavepoint();
                try {
                    List<wb_utility_quicksort.IdIndex> UAHIdIndex = new  List<wb_utility_quicksort.IdIndex>();
                    Id aId;
                    
                    for ( integer i = 0; i < PatchSortOrder.size(); i++){
                        aId = Id.valueOf( PatchSortOrder[i].Id);
                        UAHIdIndex.add( new wb_utility_quicksort.IdIndex(aId,i));
                    }
                    
                    wb_utility_quicksort QS = new wb_utility_quicksort();
                    QS.sortList = UAHIdIndex;
                    QS.sortcustomObjList();
                    List<Id> AHUIds = new List<Id>();
                    
                    for( wb_utility_quicksort.IdIndex i:UAHIdIndex){
                        if (i.Id != null){
                            AHUIds.add(i.Id);
                        }
                    }
                    if ( AHUIds.size() > 0){
                        
                        List<AffiliatedHospital__c> AHU = [select id, Hospital_Sort_Order__c
                                                           from AffiliatedHospital__c 
                                                           where Id =:AHUIds order by Id];
                        integer i=0;
                        integer j=0;
                        
                        for ( ; i < UAHIdIndex.size() ; i ++) {
                            for ( ; j < AHU.size() && UAHIdIndex[i].Id >= AHU[j].id ; ){
                                if (UAHIdIndex[i].Id == AHU[j].id){
                     
                                    HospitalOrder AH = PatchSortOrder[UAHIdIndex[i].Idx];

                                    AHU[j].Hospital_Sort_Order__c = Decimal.valueof(AH.SortOrder) ;

                                    j++;
                                    
                                } else
                                    j ++;
                            }
                        }
                        
                        update AHU;
                        List<AffiliatedHospitalPatchStatus> Rst = new List<AffiliatedHospitalPatchStatus>();
                        for (AffiliatedHospital__c h:AHU){
                            Rst.add( new AffiliatedHospitalPatchStatus( h.Id, 'Sorting Order Updated to:' + string.valueof(h.Hospital_Sort_Order__c)));
                        }
                        return Rst;
                        
                    }
                    
                } catch(Exception e) {
                    Database.rollBack(sp);
                    return null;
                } 
                
            }
            
        } else if (PatchSortOrder != null && PatchPostingDate != null && PatchDeletedDate == null){
            SavePoint sp = Database.setSavepoint();
            try {
                
                List<AffiliatedHospitalPatchStatus> Rst = new List<AffiliatedHospitalPatchStatus>();
                
                List<wb_utility_quicksort.IdIndex> UAHIdIndex = new  List<wb_utility_quicksort.IdIndex>();
                Id aId;
                
                for ( integer i = 0; i < PatchSortOrder.size(); i++){
                    aId = Id.valueOf( PatchSortOrder[i].Id);
                    UAHIdIndex.add( new wb_utility_quicksort.IdIndex(aId,i));
                }
                
                wb_utility_quicksort QS = new wb_utility_quicksort();
                QS.sortList = UAHIdIndex;
                QS.sortcustomObjList();
                List<Id> AHUIds = new List<Id>();
                
                for( wb_utility_quicksort.IdIndex i:UAHIdIndex){
                    if (i.Id != null){
                        AHUIds.add(i.Id);
                    }
                }
                
                if ( AHUIds.size() > 0){
                    
                    List<AffiliatedHospital__c> AHU = [select id, Hospital_Sort_Order__c
                                                       from AffiliatedHospital__c 
                                                       where Id =:AHUIds order by Id];
                    integer i=0;
                    integer j=0;
                    
                    for ( ; i < UAHIdIndex.size() ; i ++) {
                        for ( ; j < AHU.size() && UAHIdIndex[i].Id >= AHU[j].id ; ){
                            if (UAHIdIndex[i].Id == AHU[j].id){
                                HospitalOrder AH = PatchSortOrder[UAHIdIndex[i].Idx];
                                AHU[j].Hospital_Sort_Order__c = Decimal.valueof(AH.SortOrder) ;
                                j++;
                            } else
                                j ++;
                        }
                    }
                    
                    update AHU;
                    //  List<AffiliatedHospitalPatchStatus> Rst = new List<AffiliatedHospitalPatchStatus>();
                    for (AffiliatedHospital__c h:AHU){
                        Rst.add( new AffiliatedHospitalPatchStatus( h.Id, 'Sorting Order Updated to:' + string.valueof(h.Hospital_Sort_Order__c)));
                    }
                    
                    
                    
                }
                
                UAHIdIndex = new  List<wb_utility_quicksort.IdIndex>();
                //Id aId;
                
                for ( integer i = 0; i < PatchPostingDate.size(); i++){
                    aId = Id.valueOf( PatchPostingDate[i].Id);
                    UAHIdIndex.add( new wb_utility_quicksort.IdIndex(aId,i));
                }
                
                QS = new wb_utility_quicksort();
                QS.sortList = UAHIdIndex;
                QS.sortcustomObjList();
                
                AHUIds = new List<Id>();
                
                for( wb_utility_quicksort.IdIndex i:UAHIdIndex){
                    if (i.Id != null){
                        AHUIds.add(i.Id);
                    }
                }
                
                if ( AHUIds.size() > 0){
                    
                    List<AffiliatedHospital__c> AHU = [select id, appPostingDate__c //, appDeletedDate__c
                                                       from AffiliatedHospital__c 
                                                       where Id =:AHUIds 
                                                       order by Id];
                    integer i=0;
                    integer j=0;
                    
                    for ( ; i < UAHIdIndex.size() ; i ++) {
                        
                        for ( ; j < AHU.size() && UAHIdIndex[i].Id >= AHU[j].id ; ){
                            
                            if (UAHIdIndex[i].Id == AHU[j].id){
                                
                                AffiliatedHospitalPatchDate AH = PatchPostingDate[UAHIdIndex[i].Idx];
                                
                                AHU[j].appPostingDate__c = AH.theDate;
                                
                                j++;
                                
                            } else
                                j ++;
                        }
                        
                    }
                    
                    update AHU;
                    
                    for (AffiliatedHospital__c h:AHU){
                        Rst.add( new AffiliatedHospitalPatchStatus( h.Id, 'Posting Date updated to:' + string.valueof(h.appPostingDate__c)));
                        
                    }
                    
                }
                return Rst;
                
            } catch(Exception e) {
                Database.rollBack(sp);
                return null;
            } 
            
        }
        else if (PatchSortOrder == null && PatchPostingDate != null && PatchDeletedDate == null)
        {
            return updateAffiliatedHospitalDate(PatchPostingDate,'PostingDate');
        }
        else if (PatchSortOrder == null && PatchPostingDate == null && PatchDeletedDate != null){
            return updateAffiliatedHospitalDate(PatchDeletedDate,'DeletedDate' );
        }
        
        
        return null;
    }
    
    
    
    static List<AffiliatedHospitalPatchStatus> updateAffiliatedHospitalDate( List<AffiliatedHospitalPatchDate> PD, string field){
        
        if (PD.size() > 0 ){
            
            SavePoint sp = Database.setSavepoint();
            try {
                
                List<AffiliatedHospitalPatchStatus> Rst = new List<AffiliatedHospitalPatchStatus>();
                
                List<wb_utility_quicksort.IdIndex> UAHIdIndex = new  List<wb_utility_quicksort.IdIndex>();
                Id aId;
                
                for ( integer i = 0; i < PD.size(); i++){
                    aId = Id.valueOf( PD[i].Id);
                    UAHIdIndex.add( new wb_utility_quicksort.IdIndex(aId,i));
                }
                
                wb_utility_quicksort QS = new wb_utility_quicksort();
                QS.sortList = UAHIdIndex;
                QS.sortcustomObjList();
                
                List<Id> AHUIds = new List<Id>();
                
                for( wb_utility_quicksort.IdIndex i:UAHIdIndex){
                    if (i.Id != null){
                        AHUIds.add(i.Id);
                    }
                }
                
                if ( AHUIds.size() > 0){
                    
                    List<AffiliatedHospital__c> AHU = [select id, appPostingDate__c, appDeletedDate__c
                                                       from AffiliatedHospital__c 
                                                       where Id =:AHUIds 
                                                       order by Id];
                    integer i=0;
                    integer j=0;
                    
                    for ( ; i < UAHIdIndex.size() ; i ++) {
                        
                        
                        for ( ; j < AHU.size() && UAHIdIndex[i].Id >= AHU[j].id ; ){
                            
                            
                            if (UAHIdIndex[i].Id == AHU[j].id){
                                
                                AffiliatedHospitalPatchDate AH = PD[UAHIdIndex[i].Idx];
                                if ( field =='PostingDate')
                                    AHU[j].appPostingDate__c = AH.theDate;
                                else if ( field =='DeletedDate')
                                    AHU[j].appDeletedDate__c = AH.theDate;
                                
                                j++;
                                
                            } else
                                j ++;
                        }
                        
                    }
                    
                    update AHU;
                    
                    for (AffiliatedHospital__c h:AHU){
                        if ( field =='PostingDate')
                            Rst.add( new AffiliatedHospitalPatchStatus( h.Id, 'Posting Date updated to:' + string.valueof(h.appPostingDate__c)));
                        else if ( field =='DeletedDate')
                            Rst.add( new AffiliatedHospitalPatchStatus( h.Id, 'Deleted Date updated to:' + string.valueof(h.appDeletedDate__c)));
                    }
                    
                    return Rst;
                }
                
            } catch(Exception e) {
                Database.rollBack(sp);
                return null;
            } 
            
        }
        
        return null;
    }
    
}