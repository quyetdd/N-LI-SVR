/**
*	Created By	:	Jitendra Zaa
*	Description	:	Apex based REST API which exposes POST method to send Email
*/
@RestResource(urlMapping='/sendPDFEmail/*')
Global class GETPDFContent{
     @HttpPost
    global static void sendEmail(String EmailIdCSV, String Subject, String body) {

 	//List&amp;lt;String&amp;gt; EmailIds = EmailIdCSV.split(',');
		
        List<string> EmailIds;
        EmailIds.add('colin-lee@wellbemedic.com');
        PageReference ref = Page.PDF_DEMO;
        Blob b = ref.getContentAsPDF();

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

        Messaging.EmailFileAttachment efa1 = new Messaging.EmailFileAttachment();
        efa1.setFileName('attachment_WORK.pdf');
        efa1.setBody(b);

        String addresses;
        email.setSubject( Subject +String.valueOf(DateTime.now()));
        email.setToAddresses( EmailIds  );
        email.setPlainTextBody(Body);
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa1});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});

    }
}