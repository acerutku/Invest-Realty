public class BatchLeaseExpiryDateNotification implements Database.Batchable<sObject>{
    public Database.QueryLocator start (Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT Id, EndDate, ContractNumber, Asset_Manager__r.Email, Leasing_Admin__r.Email, Leasing_Analyst__r.Email
                FROM Contract
                WHERE EndDate = NEXT_N_DAYS:5]);
    }
    
    public void execute(Database.BatchableContext bc, List<Contract> contList){
       
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        for(Contract con:contList){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            /* Uzun yazım şekli
            List<String> toEmails = new List<String>();
            toEmails.add(con.Asset_Manager__r.Email);
            toEmails.add(con.Leasing_Admin__r.Email);
            toEmails.add(con.Leasing_Analyst__r.Email);
            emails.setToAddress(toEmails); 
            ***********************/
            // Kısaltılmış yazım şekli
            email.setToAddresses(new List<String>{con.Asset_Manager__r.Email, con.Leasing_Admin__r.Email, con.Leasing_Analyst__r.Email});
            
            email.setSubject('Contract End Date Bitmek Üzere');
            email.setPlainTextBody('Merhaba, ' + '\n'
                               + 'Aşağıda bilgileri verilen Contract kısa zaman içinde son bulacaktır. Lütfen yenilenmesine yönelik işlemi başlatınız!' + '\n'
 							   + 'Contract Number: ' + con.ContractNumber +  '\n'
                               + 'Contract End Date: ' + con.EndDate
                               );

        	emails.add(email);
            
        }

        Messaging.sendEmail(emails);
    }
    
    public void finish(Database.BatchableContext bc){
        
    }
    
    
}