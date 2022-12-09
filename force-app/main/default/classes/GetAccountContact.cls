
public with sharing class GetAccountContact {

    @AuraEnabled (cacheable=true)
    public static List<Account> getChildAccounts (String parentAccId){
        return [SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingCountry FROM Account WHERE ParentId=:parentAccId with SECURITY_ENFORCED];
    }

        @AuraEnabled (cacheable=true)
    public static List<Contact> getRelatedContacts (String childAccId){
        return [SELECT Id, Name, MailingStreet, MailingCity, MailingState, MailingCountry FROM Contact WHERE AccountId=:childAccId with SECURITY_ENFORCED];
    }
} 