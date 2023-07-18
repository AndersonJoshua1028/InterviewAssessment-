public class MaskContactEmailBatch implements Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext context) {
        String query = 'SELECT Id, Email FROM Contact WHERE Email != null';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext context, List<sObject> records) {
        List<Contact> contactsToUpdate = new List<Contact>();
        
        for (sObject record : records) {
            Contact contact = (Contact) record;
            String email = contact.Email;
            
            if (email != null) {
                if (!String.isBlank(email) && (!Pattern.matches('^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$', email) || email.endsWith('.invalid'))) {
                    // Skip updating invalid email addresses or those already ending with ".invalid"
                    System.debug('Skipping Contact record Id: ' + contact.Id + ' due to invalid or already masked email address: ' + email);
                    continue;
                }
                
                contact.Email = email + '.invalid';
                contactsToUpdate.add(contact);
                System.debug('Email masked for Contact record Id: ' + contact.Id);
            }
        }
        
        update contactsToUpdate;
        System.debug('Masked ' + contactsToUpdate.size() + ' Contact email addresses');
    }
    
    
    public void finish(Database.BatchableContext context) {
        System.debug('Batch execution finished');
    }
}