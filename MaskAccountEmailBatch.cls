public class MaskAccountEmailBatch implements Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext context) {
        String query = 'SELECT Id, Email__c FROM Account WHERE Email__c != null';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext context, List<sObject> records) {
        List<Account> accountsToUpdate = new List<Account>();
        
        for (sObject record : records) {
            Account account = (Account)record;
            String email = account.Email__c;
            
            if (email != null) {
                if (!String.isBlank(email) && (!Pattern.matches('^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$', email) || email.endsWith('.invalid'))) {
                    // Skip updating invalid email addresses or those already ending with ".invalid"
                    System.debug('Skipping Contact record Id: ' + account.Id + ' due to invalid or already masked email address: ' + email);
                    continue;
                }                
                account.Email__c = email + '.invalid';
                accountsToUpdate.add(account);
                System.debug('Email masked for Account record Id: ' + account.Id);
            }
        }
        
        update accountsToUpdate;
        System.debug('Masked ' + accountsToUpdate.size() + ' Account email addresses');
    }
    
    public void finish(Database.BatchableContext context) {
        System.debug('Batch execution finished');
    }
}