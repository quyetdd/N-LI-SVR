global class KenshinImportBatch implements Database.Batchable<sObject>, Database.Stateful
{
    private Id m_userId;
    private Kenshin_Import__c m_ks;
    private string m_msg;
    private string m_msgHead;
    private Integer accuLineNum = 1;

    global KenshinImportBatch(Id userId, Kenshin_Import__c ks)
    {
        m_userId = userId;
        m_ks = ks;   
    }
    
    global Iterable<sObject> start(Database.BatchableContext BC)
    {
        return new List<Kenshin_Import__c>{m_ks};
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        for(sobject s : scope)
        {
            Kenshin_Import__c i = (Kenshin_Import__c)s;
         
            string filename;
            
            integer incount = 0;
            integer upcount = 0;
            integer delcount = 0;
            integer failcount = 0;
            integer skipcount = 0;
         
            List<Row> rows = new List<Row>();
            set<string> mnos = new set<string>();
            set<string> fnos = new set<string>();
            integer sy = 9999;
            integer ey = 0;
            String msg='';    
            String wbMemberCdErrorMsg='';
            try
             {
                string s2 = '';
                for(Attachment att : [select Id, Name, Body from Attachment where ParentId=:i.Id])
                {
                    filename = att.Name; 
                    
                    string body = att.Body.toString();
                    string line;
                    
                    integer p = body.indexOf('\r\n');
                    
                    if(p<1)
                        throw new MiscException('Invalid file format');
                        
                    line = body.substring(0,p);
                    if(p+2>=body.length())
                        body = '';
                    else
                        body = body.substring(p+2);
                    integer lineno = 2;
                   
                    wbMemberCdErrorMsg ='';

                    try
                    {
                        line = line.replace('"','').trim();   
                        if( (!line.startsWith('status,wb_member_cd,order_num,order_detail_num,wish_date,wish_time,cancel_datetime,item_cd,jurisdiction_division_name,name')) &&
                            (!line.endsWith('status,wb_member_cd,order_num,order_detail_num,wish_date,wish_time,cancel_datetime,item_cd,jurisdiction_division_name,name') ))
                            throw new MiscException('Invalid file header');
                            
                        p = body.indexOf('\r\n');

                        if(p<0)
                        {   line = body;                   body = ''; }
                        else
                        {   line = body.substring(0,p);  body = body.substring(p+2); 
                        
                        }
                        while(line!=''||body!='')
                        {         
                            //string msg;
                            Row r = new Row(line);
                            // insrt the line number of CSV file
                            accuLineNum++;
                            r.lineNumber = accuLineNum;
                                                    
                            if(r.wb_member_cd != null && r.wb_member_cd !=''){
                                rows.add(r);
                            }                         
                            
                            if(r.wb_member_cd != null && r.wb_member_cd !=''){
                                if(r.ismember)
                                {
                                      mnos.add(r.wb_member_cd.substring(4,r.wb_member_cd.length()-1));
                                }
                                else
                                {    
                                      fnos.add(r.wb_member_cd.substring(4,r.wb_member_cd.length()-1));
                                }
                            }    
                            else{
                                    wbMemberCdErrorMsg  += 'wb_member_cd is empty.status:' 
                                        + r.status + ', order_num:'
                                        + r.order_num + ',  order_detail_num:'
                                        + r.order_detail_num + ','+'line Number:'+  lineno+'\r\n';                                
                            }
                            system.debug('wb_member_cd: '+r.wb_member_cd +'lineno '+lineno);
                             
                            if(r.wish_date.year()<sy) sy = r.wish_date.year();
                            if(r.wish_date.year()>ey) ey = r.wish_date.year();
                            
                            p = body.indexOf('\r\n');
                            if(p<0)
                            {   line = body; body = ''; }
                            else
                            {   line = body.substring(0,p);  
                                if(p+2>=body.length())
                                    body = '';
                                else
                                    body = body.substring(p+2); 
                            }
                            lineno++;
                        }
                    }
                    catch(Exception ex)
                    {
                        throw new MiscException('Invalid format at line ' + lineno + '\r\n' + 
                                    ex.getMessage() + '\r\n' + line);
                                    break;
                    }
                }
                
                if(wbMemberCdErrorMsg!=null && wbMemberCdErrorMsg!= ''){
                    msg += '\r\n' + wbMemberCdErrorMsg;
                    failcount++;
                }
                
                system.debug('rows: ' + rows);
                system.debug('mnos: ' + mnos);
                system.debug('fnos: ' + fnos);
             
                set<Id> mids = new set<Id>();                
                map<string, string> mm = new map<string, string>();
                
                for(MemberInfo__c mi : [select Id, MemberNo__c from MemberInfo__c where KeiyakuNo__c in :mnos])
                {
                    mids.add(mi.Id);
                    //mm.put(mi.MemberNo__c.substring(4,11), mi.Id);
                    mm.put(mi.MemberNo__c, mi.Id);
                }
               
                set<Id> fids = new set<Id>();
                map<string, string> mf = new map<string, string>();
                for(FamilyInfo__c fi : [select Id, MemberNo__c from FamilyInfo__c where KeiyakuNo__c in :fnos])
                {
                    fids.add(fi.Id);
                    //mf.put(fi.MemberNo__c.substring(4,11), fi.Id);
                    mf.put(fi.MemberNo__c, fi.Id);
                }
                    
                date sd = date.newInstance(sy, 1, 1);
                date ed = date.newInstance(ey+1, 1, 1);
                map<string, Kenshin__c> ks = new map<string, Kenshin__c>();               
                
                for(Kenshin__c k : [select Id, MemberShimei__c, MemberFamilyShimei__c,
                                      MemberShimei__r.MemberNo__c, MemberFamilyShimei__r.MemberNo__c, 
                                      KenshinDate__c,ReceiptNo__c 
                                      from Kenshin__c
                                      where (MemberShimei__c in :mids or MemberFamilyShimei__c in :fids)
                                      and KenshinDate__c>=:sd and KenshinDate__c<:ed])
                {
                    if(k.MemberShimei__c!=null) 
                        ks.put(k.MemberShimei__r.MemberNo__c + ':'//ks.put(k.MemberShimei__r.MemberNo__c.substring(4,11) + ':' 
                            + k.KenshinDate__c.year().format() +':'+k.ReceiptNo__c , k); 
                    else if(k.MemberFamilyShimei__c!=null)
                        ks.put(k.MemberFamilyShimei__r.MemberNo__c + ':' //ks.put(k.MemberFamilyShimei__r.MemberNo__c.substring(4,11) + ':' 
                            + k.KenshinDate__c.year().format() +':'+k.ReceiptNo__c, k);
                }
                system.debug(ks);
                
                //scan through all rows to reduce multiple update/delete to same record
                //only the last actions will be applied
                map<string, Row> mrows = new map<string, Row>();               
                
                for(Row r : rows)
                {      
                    //string mkey = r.wb_member_cd.substring(4,r.wb_member_cd.length());
                    string mkey = r.wb_member_cd;
                    system.debug(mkey);
                    string kkey = mkey + ':' + r.wish_date.year().format()+':'+r.order_num;
                    if(mrows.containsKey(kkey)) skipcount++;
                    mrows.put(kkey+r.lineNumber, r);
                }
                
                //string msg = '';    
                list<Kenshin__c> lkd = new list<Kenshin__c>();
                list<Kenshin__c> lk = new list<Kenshin__c>();
                for(Row r : mrows.values())
                {       
                    //string mkey = r.wb_member_cd.substring(4,r.wb_member_cd.length());
                    string mkey = r.wb_member_cd;
                    
                    string kkey = mkey + ':' + r.wish_date.year().format()+':'+r.order_num;
                    Kenshin__c k;
                    
                   
                    if(r.status=='D')
                    {
                        if(ks.containsKey(kkey))
                        {
                            k = ks.get(kkey);
                            lkd.add(k);
                        }
                        else{
                            msg += '    Member ' + mkey + ' not found.   status:' 
                                + r.status + ',  wb_member_cd:' 
                                + r.wb_member_cd + ',  order_num:'
                                + r.order_num + ',  order_detail_num:'
                                + r.order_detail_num + ','+'line:'+  r.lineNumber+'\r\n';
                            failcount++;
                            continue;                        
                        }
                    }
                    else
                    {
                        if(ks.containsKey(kkey))
                            k = ks.get(kkey);
                        else
                        {
                            k = new Kenshin__c();
                            
                            if(r.ismember)
                            {
                                if(mm.containsKey(mkey))
                                    k.MemberShimei__c = mm.get(mkey);
                                else
                                {
                                    msg += '    Member ' + mkey + ' not found.   status:' 
                                        + r.status + ',  wb_member_cd:' 
                                        + r.wb_member_cd + ',  order_num:'
                                        + r.order_num + ',  order_detail_num:'
                                        + r.order_detail_num + ','+'line:'+  r.lineNumber+'\r\n';
                                    failcount++;
                                    continue;
                                }
                            }
                            else
                            {
                                if(mf.containsKey(mkey))
                                    k.MemberFamilyShimei__c = mf.get(mkey);
                                else
                                {
                                    msg += '    Member ' + mkey + ' not found.   status:' 
                                        + r.status + ',  wb_member_cd:' 
                                        + r.wb_member_cd + ',  order_num:'
                                        + r.order_num + ',  order_detail_num:'
                                        + r.order_detail_num + ' '+'line:'+  r.lineNumber+'\r\n';
                                    failcount++;
                                    continue;
                                }
                            }
                        }
                
                        k.ReceiptNo__c = r.order_num;
                        k.PersonalReceiptNo__c = r.order_detail_num;
                        k.Status__c = r.status;
                        k.KenshinDate__c = r.wish_date;
                        k.wish_time__c = r.wish_time;
                        k.CancelDate__c = r.cancel_datetime;
                        //k.KenshinPlan__c = r.item_cd;
                        k.KenshinPlan_new__c = r.item_cd;
                        k.KenshinArea__c = r.jurisdiction_division_name;
                        k.KenshinHospital__c = r.name;
                            
                        lk.add(k);
                    }
                }
                
                /*string msg = '';    
                list<Kenshin__c> lkd = new list<Kenshin__c>();
                list<Kenshin__c> lk = new list<Kenshin__c>();
                set<string> keysd = new set<string>();
                set<string> keys = new set<string>();
                for(Row r : rows)
                {       
                    string mkey = r.wb_member_cd.substring(4,11);
                    string kkey = mkey + ':' + r.wish_date.year().format();
                    Kenshin__c k;
                    
                    if(r.status=='D')
                    {
                        if(ks.containsKey(kkey))
                        {
                            k = ks.get(kkey);
                            if(!keysd.contains(kkey))
                            {
                                keysd.add(kkey);
                                lkd.add(k);
                            }
                        }
                    }
                    else
                    {
                        if(ks.containsKey(kkey))
                            k = ks.get(kkey);
                        else
                        {
                            k = new Kenshin__c();
                            
                            if(r.ismember)
                            {
                                if(mm.containsKey(mkey))
                                    k.MemberShimei__c = mm.get(mkey);
                                else
                                {
                                    msg += '    Member ' + mkey + ' not found.   status:' 
                                        + r.status + ',  wb_member_cd:' 
                                        + r.wb_member_cd + ',  order_num:'
                                        + r.order_num + ',  order_detail_num:'
                                        + r.order_detail_num + '\r\n';
                                    failcount++;
                                    continue;
                                }
                            }
                            else
                            {
                                if(mf.containsKey(mkey))
                                    k.MemberFamilyShimei__c = mf.get(mkey);
                                else
                                {
                                    msg += '    Member ' + mkey + ' not found.   status:' 
                                        + r.status + ',  wb_member_cd:' 
                                        + r.wb_member_cd + ',  order_num:'
                                        + r.order_num + ',  order_detail_num:'
                                        + r.order_detail_num + '\r\n';
                                    failcount++;
                                    continue;
                                }
                            }
                        }
                
                        k.ReceiptNo__c = r.order_num;
                        k.PersonalReceiptNo__c = r.order_detail_num;
                        k.Status__c = r.status;
                        k.KenshinDate__c = r.wish_date;
                        k.wish_time__c = r.wish_time;
                        k.CancelDate__c = r.cancel_datetime;
                        k.KenshinPlan__c = r.item_cd;
                        k.KenshinArea__c = r.jurisdiction_division_name;
                        k.KenshinHospital__c = r.name;
                        
                        if(k.Id==null)
                            ks.put(kkey, k);
                            
                        if(!keys.contains(kkey))
                        {
                            lk.add(k);
                            keys.add(kkey);
                        }
                    }
                }*/
                
                List<Database.UpsertResult> uresults = Database.upsert(lk, false);
                List<Database.DeleteResult> dresults = Database.delete(lkd, false);
                
                i.Fail__c = false;
                
                for(Database.UpsertResult ur: uresults)
                    if(ur.isSuccess())
                    {
                        if(ur.isCreated())
                            incount++;
                        else
                            upcount++;
                    }
                    else
                    {
                        failcount++;
                        msg += '    ' + ur.getErrors() + '\r\n';
                    }
                  
                for(Database.DeleteResult dr: dresults)
                    if(dr.isSuccess())
                        delcount++;
                    else
                    {
                        failcount++;
                        msg += '    ' + dr.getErrors() + '\r\n';
                    }
                       
                /*string msgh = '完了\r\n\r\n';
                if(incount+infail>0) msgh += 'Add: ' + incount.format() + '\r\n';
                if(upcount+upfail>0) msgh += 'Update: ' + upcount.format() + '\r\n';
                if(lkd.size()>0) msgh += 'Delete: ' + delcount.format() + '\r\n';
                if(
                        
                if(msg!='') msgh += '\r\n\r\n' + msg;*/
                
                string msgh = '処理件数\r\n' +
                 '    追加   :   ' + incount.format() + '\r\n' +
                 '    更新   :   ' + upcount.format() + '\r\n' + 
                 '    削除   :   ' + delcount.format() + '\r\n' + 
                 '    エラー  :   ' + failcount.format() + '\r\n' +
                 '    スキップ :   ' + skipcount.format() + '\r\n' + 
                 '    合計   :   ' + (incount+upcount+delcount+failcount+skipcount).format() + '\r\n\r\n' +
                 'エラー情報\r\n' +
                 (msg==null? '' : msg);
                    
                m_msg = msgh;
                system.debug(m_msg.length());
                if(m_msg.length()>32000) m_msg = m_msg.substring(0,32000);
                i.Import_Status__c = m_msg; 
                
                datetime dt = i.Last_Import_Date__c;
                m_msgHead = '処理日時:   ' + dt.format('yyyy/MM/dd hh:mm') + '\r\n'
                    + 'ファイル名:    ' + filename;

            }
            
            catch(Exception ex)
            {
                i.Import_Status__c = ex.getMessage();
                i.Fail__c = true;
                
                m_msg = ex.getMessage();
                
                datetime dt = i.Last_Import_Date__c;
                m_msgHead = '処理日時:   ' + dt.format('yyyy/MM/dd hh:mm') + '\r\n'
                    + 'ファイル名:    ' + filename;

            }
        }
        
        system.debug(m_msg);
        update scope;
    }

    global void finish(Database.BatchableContext BC)
    {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        //mail.setToAddresses(new string[]{'patrick.fung@introv.com'});
        mail.setTargetObjectId(m_userId);
        mail.setSubject('健診インポート');
        mail.setSaveAsActivity(false);
        mail.setPlainTextBody(m_msgHead + '\r\n\r\n' + m_msg);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        system.debug(mail);
    }
    
    
    private class MiscException extends Exception{}
    
    private class Row
    {
        public string status;
        public string wb_member_cd;
        public boolean ismember;
        public string order_num;
        public string order_detail_num;
        public date wish_date;
        public string wish_time;
        public date cancel_datetime;
        public string item_cd;
        public string jurisdiction_division_name;
        public string name;
        public Integer lineNumber = 0;
        
        public Row(string s)
        {
            integer offset = 0;
            integer p = FindNextComma(s, offset);
            if((p<offset) || (p<offset+1)) { throw new MiscException ('status'); }
            status = RemoveDoubleQuote(s.substring(offset, p));
            
            offset = p+1;
            p = FindNextComma(s, offset);
            system.debug(p);
            system.debug(offset);
            //if((p<offset) || (p<offset+1)) { throw new MiscException ('wb_member_cd'); }
                if(p==offset || p<offset)
                wb_member_cd  = null;
                else{ 
                    wb_member_cd = RemoveDoubleQuote(s.substring(offset, p));
                    system.debug(wb_member_cd);
                    ismember = (wb_member_cd.endsWith('0'));
                }
            
            offset = p+1;
            p = FindNextComma(s, offset);
            if(p<offset) { throw new MiscException ('order_num'); }
            order_num = RemoveDoubleQuote(s.substring(offset, p));
            
            offset = p+1;
            p = FindNextComma(s, offset);
            if(p<offset) { throw new MiscException ('order_detail_num'); }
            order_detail_num = RemoveDoubleQuote(s.substring(offset, p));
            
            offset = p+1;
            p = FindNextComma(s, offset);
            if(p<offset) { throw new MiscException ('wish_date'); }
            if(p==offset)
                wish_date = null;
            else
                wish_date = date.valueOf(RemoveDoubleQuote(s.substring(offset, p)).replace('/','-'));
                
            offset = p+1;
            p = FindNextComma(s, offset);
            if(p<offset) { throw new MiscException ('wish_time'); }
            wish_time = RemoveDoubleQuote(s.substring(offset, p));
            
            offset = p+1;
            p = FindNextComma(s, offset);
            if(p<offset) { throw new MiscException ('cancel_datetime'); }
            if(p==offset)
                cancel_datetime = null;
            else
                cancel_datetime = date.valueOf(RemoveDoubleQuote(s.substring(offset, p)).replace('/','-'));
                
            offset = p+1;
            p = FindNextComma(s, offset);
            if(p<offset) { throw new MiscException ('item_cd'); }
            item_cd = RemoveDoubleQuote(s.substring(offset, p)).replace(',',';');
            
            offset = p+1;
            p = FindNextComma(s, offset);
            if(p<offset) { throw new MiscException ('jurisdiction_division_name'); }
            jurisdiction_division_name = RemoveDoubleQuote(s.substring(offset, p));

            offset = p+1;
            p = FindNextComma(s, offset);
            if(p>=offset) { throw new MiscException ('name'); }
            if(offset<s.length())
                name = RemoveDoubleQuote(s.substring(offset));
            else
                name = '';
        }
        
        private integer FindNextComma(string s, integer offset)
        {
            if(s.length()<=offset) return -1;
    
            if(s.substring(offset).startsWith('"'))
            {
              integer p = s.indexOf('"', offset+1);
              return s.indexOf(',', p);
            }
            else
              return s.indexOf(',', offset);
        }
        
        private string RemoveDoubleQuote(string s)
        {
            if(s.startsWith('"')&&s.endsWith('"'))
                return s.substring(1,s.length()-1);
            else
                return s;
        }
        
    }
 
    static testMethod void KenshinImportBatch_Test()
    {
        Test.startTest();
        test1();
        test2();
        Test.stopTest();
    }
    
    static void Test1()
    {
        Kenshin_Import__c ki = new Kenshin_Import__c();
        insert ki;
        
        Attachment att = new Attachment();
        att.Name = 'TEST';
        att.Body = Blob.valueOf('');
        att.ParentId = ki.Id;
        insert att;

        KenshinImportBatch bat = new KenshinImportBatch(UserInfo.getUserId(), ki);
        Database.executeBatch(bat);
    }
    
    static void Test2()
    {
        Kenshin_Import__c ki = new Kenshin_Import__c();
        insert ki;
        
        Attachment att = new Attachment();
        att.Name = 'TEST';
        att.Body = Blob.valueOf('"status","wb_member_cd","order_num","order_detail_num","wish_date","wish_time","cancel_datetime","item_cd","jurisdiction_division_name","name"' 
            + '\r\n'
            + '"E","1NDL1264861",104936,117693,2009/12/19,16:00:00,,"101",,'
            + '\r\n'
            + '"D","1NDL1264862",104936,117693,2009/12/19,16:00:00,,"101",,'  
            + '\r\n'
            + '"D","1NDL1264860",104936,117693,2009/12/19,16:00:00,,"101",,'                      
            );
        att.ParentId = ki.Id;
        insert att;

        KenshinImportBatch bat = new KenshinImportBatch(UserInfo.getUserId(), ki);
        Database.executeBatch(bat);
    }
}