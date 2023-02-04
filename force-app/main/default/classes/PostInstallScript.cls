// Steve Berley - steve@leftpropeller.com
//
global with sharing class PostInstallScript implements InstallHandler {   
    
    global void onInstall(InstallContext context) {
        string textBody = 'Thanks for installing Yahrzeits for Salesforce, we appreciate your support.\r\n\r\n';
        textBody += 'Left Propeller helps nonprofits, especially Jewish ones, make the most of Salesforce.com to deepen relationships, increase sales/donations, and streamline operations.\r\n\r\n';
        textBody += 'We also specialize in the needs of Jewish organizations.\r\n\r\n';
        textBody += 'Please feel free to reach out and talk about how we can make Salesforce easier for you.\r\n\r\n';
        textBody += 'Thanks,\r\n\r\nSteve\r\nsteve@leftpropeller.com\r\nwww.leftpropeller.com';
        
        string htmlBody = '<style>p {font-family: helvetica;font-size: 14px;}</style><p>Thanks for installing Yahrzeits for Salesforce, we appreciate your support.</p><p>Left Propeller helps nonprofits, especially Jewish ones, make the most of Salesforce.com to deepen relationships, increase donations, and streamline operations.</p><p>Please feel free to reach out and talk about how we can make Salesforce easier for you.</p><p>Thanks,</p><p>Steve<br/><a href="mailto:steve@leftpropeller.com">steve@leftpropeller.com</a><br/><a href="https://www.leftpropeller.com">www.leftpropeller.com</a><br/></p>';
        
        User u = [Select Id, Email from User where Id =:context.installerID()]; 
        list<string> toAddresses = new list<string>(); 
        toAddresses.add(u.Email);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
        mail.setToAddresses(toAddresses); 
        mail.setReplyTo('support@package.dev'); 
        mail.setSenderDisplayName('My Package Support'); 
        mail.setSubject('Package install successful'); 
        mail.setPlainTextBody(textBody); 
        mail.setHtmlBody(htmlBody); 
        Messaging.sendEmail(new Messaging.Email[] { mail });
        
        updateYahrzeits.start(1);
    }
}