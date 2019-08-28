public class sendEmail {
    public String subject { get; set; }
    public String body { get; set; }

    private final Account account;

    // Create a constructor that populates the Account object
    public sendEmail() {
        account = [SELECT Name, 
                  (SELECT Contact.Name, Contact.Email FROM Account.Contacts) 
                   FROM Account WHERE Id ='0015D00000DEbMY'];
                 //  WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
    }

    public Account getAccount() {
        return account;
    }

    public PageReference send() {
        // Define the email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 

        // Reference the attachment page and pass in the account ID
       // PageReference pdf =  Page.attachmentPDF;
        PageReference pdf =  Page.wb_Membership_InvoiceExport;
       // pdf.getParameters().put('id',(String)account.id); 
        pdf.getParameters().put('id','a0o5D000000RdEj'); 
        pdf.setRedirect(true);

        // Take the PDF content
        Blob b = pdf.getContent();

        // Create the email attachment
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('attachment.pdf');
        efa.setBody(b);
List<String> EmailIds = new List<String>();

EmailIds.add('colin-lee@wellbemedic.com');
        /*
        String addresses;
        if (account.Contacts[0].Email != null) {
            addresses = account.Contacts[0].Email;
            // Loop through the whole list of contacts and their emails
            for (Integer i = 1; i < account.Contacts.size(); i++) {
                if (account.Contacts[i].Email != null) {
                    addresses += ':' + account.Contacts[i].Email;
                }
            }
        }

        String[] toAddresses = addresses.split(':', 0);
*/
        // Sets the paramaters of the email
        email.setSubject( subject );
       // email.setToAddresses( toAddresses );
        email.setToAddresses( EmailIds  );
        email.setPlainTextBody( body );

        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});

        // Sends the email
        Messaging.SendEmailResult [] r = 
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
		
        return null;
    }
}