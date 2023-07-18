public class SandboxPostCopyClass implements SandboxPostCopy {
    
    public void runApexClass(SandboxContext context) {
        // Instantiate the MaskContactEmailBatch class
        MaskContactEmailBatch contactBatch = new MaskContactEmailBatch();
        
        // Start the contact batch job
        Database.executeBatch(contactBatch);
        
        // Instantiate the MaskAccountEmailBatch class
        MaskAccountEmailBatch accountBatch = new MaskAccountEmailBatch();
        
        // Start the account batch job
        Database.executeBatch(accountBatch);
    }
}