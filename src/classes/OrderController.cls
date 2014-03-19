public class OrderController{
    public Contact c {get;set;}
    public Part_Request__c pr {get;set;}
    
    public OrderController(ApexPages.StandardController controller){
        String cid = controller.getRecord().Id;
        c = [SELECT Name, Id, MailingStreet, MailingCity, MailingState, MailingPostalCode, 
            Phone, Email FROM Contact WHERE Id=: cid];
        pr = new Part_Request__c();
    }
    
    public pageReference submitOrder(){
        update c;

        pr.Contact__c = c.Id;
        insert pr;
        System.debug(pr);
        return new PageReference('/'+pr.id).setRedirect(true);
        
    }
}