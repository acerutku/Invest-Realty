public class BatchLeaseExpiryDateScheduler implements Schedulable{
    public void execute(SchedulableContext sc){
        BatchLeaseExpiryDateNotification myBatch = new BatchLeaseExpiryDateNotification();
		Database.executeBatch(myBatch, 1);
    }
}