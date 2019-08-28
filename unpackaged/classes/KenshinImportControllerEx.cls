public class KenshinImportControllerEx
{
    public Kenshin_Import__c KenshinImport {get; set;}
    public Attachment Attachment {get; set;}
    public Boolean showUploadMesssage {get; set;}
    private Id batchId;

    public KenshinImportControllerEx(ApexPages.StandardSetController scon)
    { 
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,Label.KenshinImportloadingMessage));
    }
    
    public void init()
    {
        List<Kenshin_Import__c> l = [select Id, Import_Status__c, Fail__c, Last_Import_Date__c
            from Kenshin_Import__c
            order by LastModifiedDate desc];
        
        if(l.size()<=0)
        {
            KenshinImport = new Kenshin_Import__c();
            Attachment = new Attachment();
        }
        else
        {
            KenshinImport = l[0];
            List<Attachment> la = [select Id, Body, Name, ParentId from Attachment 
                where ParentId=:KenshinImport.Id
                order by LastModifiedDate desc];
            if(la.size()<=0)
                Attachment = new Attachment();
            else
                Attachment = la[0];
        }
    }
    
    public PageReference upload()
    {
        showUploadMesssage = true;
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,Label.KenshinImportloadingMessage));
        KenshinImport.Last_Import_Date__c = system.now();
        KenshinImport.Import_Status__c = '';
        upsert(KenshinImport);
        if(Attachment.ParentId==null) Attachment.ParentId = KenshinImport.Id;
        upsert(Attachment);
        
        KenshinImportBatch bat = new KenshinImportBatch(UserInfo.getUserId(), KenshinImport);
        batchId = Database.executeBatch(bat);
        
        String a = [SELECT Id, Status FROM AsyncApexJob where id=:batchId].status;
        if(a!=null){
            if(a == 'Completed'){
                showUploadMesssage = false;
            }
        }
        
        //PageReference page = new PageReference('/apex/KenshinImport?processing=true');
        //page.setRedirect(true);
        return null;
    }
    
    public PageReference runBatch()
    {
        showUploadMesssage = true;
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,Label.KenshinImportloadingMessage));
        KenshinImport.Last_Import_Date__c = system.now();
        KenshinImport.Import_Status__c = '';
        upsert(KenshinImport);
        
        KenshinImportBatch bat = new KenshinImportBatch(UserInfo.getUserId(), KenshinImport);
        batchId = Database.executeBatch(bat);

        
        String a = [SELECT Id, Status FROM AsyncApexJob where id=:batchId].status;
        if(a!=null){
            if(a == 'Completed'){
                showUploadMesssage = false;
            }
        }
         
        //PageReference page = new PageReference('/apex/KenshinImport?processing=true');
        //page.setRedirect(true);
        return null;
    }
    
    /*public PageReference run()
    {
        list<Kenshin_Import__c> kis = [select Id, status__c, wb_member_cd__c, order_num__c, 
                                        order_detail_num__c, wish_date__c, wish_time__c, cancel_datetime__c,
                                        item_cd__c, jurisdiction_division_name__c, name__c
                                        from Kenshin_Import__c];
        KenshinImportControllerEx.Execute(kis);
        return null;
    }

    public static void Execute(List<Kenshin_Import__c> ls)
    {
        list<Kenshin_Import__c> kis = new list<Kenshin_Import__c>();
        set<string> ordernums = new set<string>();
        set<string> orderdetailnums = new set<string>();
        for(Kenshin_Import__c ki : ls)
        {
            kis.add(new Kenshin_Import__c(Id=ki.Id));
            ordernums.add(ki.order_num__c);
            orderdetailnums.add(ki.order_detail_num__c);
        }
        
        map<string, Kenshin__c> ks = new map<string, Kenshin__c>();
        for(Kenshin__c k : [select Id, ReceiptNo__c, PersonalReceiptNo__c from Kenshin__c
                              where ReceiptNo__c in :ordernums
                              and PersonalReceiptNo__c in :orderdetailnums])
        {
            ks.put(k.ReceiptNo__c + ':' + k.PersonalReceiptNo__c, k);
        }
        
        List<Kenshin__c> lk = new List<Kenshin__c>();
        for(Kenshin_Import__c ki : ls)
        {
            string memberNo = ki.wb_member_cd__c;
            boolean isMember = (memberno.endsWith('0'));
            string receiptNo = ki.order_num__c;
            string personalReceiptNo = ki.order_detail_num__c;
            string status = ki.status__c;
            date kenshinDate = ki.wish_date__c;
            string wishTime = ki.wish_time__c;
            date cancelDate = null;
            if(ki.cancel_datetime__c!=null)
                cancelDate = date.valueOf(ki.cancel_datetime__c.replace('/','-'));
            string kenshinPlan = '';
            if(ki.item_cd__c!=null) kenshinPlan = ki.item_cd__c.replace(',',';');
            string kenshinArea = ki.jurisdiction_division_name__c;
            string kenshinHospital = ki.name__c;
            
            MemberInfo__c mi = null;
            FamilyInfo__c fi = null;
            if(isMember) 
                mi = new MemberInfo__c(MemberNo__c=memberNo);
            else
                fi = new FamilyInfo__c(MemberNo__c=memberNo);
            
            string key = ki.order_num__c + ':' + ki.order_detail_num__c;
            Kenshin__c k;
            if(ks.containsKey(key))
                k = ks.get(key);
            else
            {
                k = new Kenshin__c();
                k.ReceiptNo__c = receiptNo;
                k.PersonalReceiptNo__c = personalReceiptNo;
                k.MemberShimei__r = mi;
                k.MemberFamilyShimei__r = fi;
            }
    
            k.Status__c = status;
            k.KenshinDate__c = kenshinDate;
            k.wish_time__c = wishTime;
            k.CancelDate__c = cancelDate;
            k.KenshinPlan__c = kenshinPlan;
            k.KenshinArea__c = kenshinArea;
            k.KenshinHospital__C = kenshinHospital;
            lk.add(k);
        }
        
        upsert lk;
    
        delete kis;
    }*/
    
    static testMethod void KenshinImportControllerEx_Test()
    {
        KenshinImportControllerEx con = new KenshinImportControllerEx(null); 
        
        Kenshin_Import__c ki = new Kenshin_Import__c();
        insert ki;
        con.init();
        
        Attachment att = new Attachment();
        att.Name = 'TEST';
        att.Body = Blob.valueOf('"status","wb_member_cd","order_num","order_detail_num","wish_date","wish_time","cancel_datetime","item_cd","jurisdiction_division_name","name"' 
            + '\r\n'
            + '"E","1NDL1264862",104936,117693,2009/12/19,16:00:00,,"101",",');
        att.ParentId = ki.Id;
        insert att;
        con.init();
        
        con.runBatch();
        
        delete [select Id from Kenshin_Import__c];
        con.init();
        con.Attachment.Name = 'TEST';
        con.Attachment.Body = Blob.valueOf('"status","wb_member_cd","order_num","order_detail_num","wish_date","wish_time","cancel_datetime","item_cd","jurisdiction_division_name","name"' 
            + '\r\n'
            + '"E","1NDL1264862",104936,117693,2009/12/19,16:00:00,,"101",",');
        con.upload();
    }
}