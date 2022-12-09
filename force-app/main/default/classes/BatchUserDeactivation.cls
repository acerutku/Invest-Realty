public class BatchUserDeactivation implements Database.Batchable<sObject>, Database.Stateful, Schedulable{
    
    List<String> systemUsers = new List<String>{'Automated Process', 'Data.com Clean', 'Integration User', 'Security User', 'Platform Integration User'};
    List<String> usersDeactivated = new List<String>();
    Integer amountOfDeactivatedUsers = 0;
    public Database.QueryLocator start (Database.BatchableContext bc){
        Global_Variable__mdt glob = [SELECT DeveloperName, Variable_Value__c 
                                     FROM Global_Variable__mdt 
                                     WHERE DeveloperName = 'AutoDeactivationDay'];
        Integer NumOfExpiryDay = Integer.valueOf(glob.Variable_Value__c);
        Datetime lastLogin = Datetime.Now() - NumOfExpiryDay;
        return Database.getQueryLocator([SELECT Id, Name, FirstName, LastName, UserName, LastLoginDate, isActive 
                                         FROM User 
                                         WHERE (LastLoginDate <= :lastLogin OR (LastLoginDate=null AND CreatedDate <= :lastLogin))
                                         AND Name NOT IN: systemUsers
                                         AND isActive = true]);
    }
    
    public void execute (Database.BatchableContext bc, List<User> userList){
        if(!userList.isEmpty()){
            for(User usr:userList){
                usr.isActive = false;
                String fullName = usr.FirstName + ' ' + usr.LastName;
                usersDeactivated.add(fullName);
                amountOfDeactivatedUsers++;
            }
            System.debug('Users Deactivated: ' + usersDeactivated);
            System.debug('Pasif Hale getirilen Kullanıcı Sayısı: ' + amountOfDeactivatedUsers);
            Database.update(userList,false);
        }
    }
    
    public void finish (Database.BatchableContext bc){
        AsyncApexJob job = [SELECT Id, Status, TotalJobItems, NumberOfErrors, CompletedDate
                            FROM AsyncApexJob
                           	WHERE Id =:bc.getJobId()];
        
        
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new List<String>{'surgunutku@gmail.com','acerrutku@gmail.com'});
        email.setSubject('User Deactivation Job');
        email.setPlainTextBody('Hi, '+'\n' 
                              	+'These users automaticly Deactivated by BatchUserDeactivation Job' + usersDeactivated
                              	+'Batch Job Bilgileri: '+'\n'
                              	+'Status: '+job.Status +'\n'
                              	+'TotalJobItems: '+job.NumberOfErrors +'\n'
                              	+'CompletedDate: '+job.CompletedDate);
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        emails.add(email);
        Messaging.sendEmail(emails);
    }
    public void execute(SchedulableContext bc){
        BatchUserDeactivation myBatch = new BatchUserDeactivation();
		Database.executeBatch(myBatch);
    }
}