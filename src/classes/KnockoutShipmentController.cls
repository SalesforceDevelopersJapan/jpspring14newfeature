global class KnockoutShipmentController {

    public PageReference save() {
        return null;
    }

  public KnockoutShipmentController() {}
  
  public List<Merchandise__c> getMerchandise() {
    return (List<Merchandise__c>)[select id, name, imgURL__c, quantity__c, description__c from Merchandise__c where active__c = true order by name asc];
  }
  
  public String getMerchandiseJson() {
    return JSON.serialize(getMerchandise());
  }
  
  @RemoteAction
  global static List<Merchandise__c> getMerchandiseRemoted() {
    return (List<Merchandise__c>)[SELECT id, name, imgURL__c, quantity__c, description__c FROM Merchandise__c Where Active__c = true ORDER BY name ASC];
  }
  
  public List<Merchandise__c> getMerchandiseInitial() {
    return (List<Merchandise__c>)[SELECT id, name, imgURL__c, quantity__c, description__c FROM Merchandise__c Where Active__c = true ORDER BY name ASC];
  }
  
  @RemoteAction
  global static boolean insertShipment(String merchId, String quantity, String status, String receivedAt){
    try {
        Shipment__c s = new Shipment__c();
        s.Merchandise__c = merchId;
        s.Quantity__c = Integer.valueOf(quantity);
        s.Status__c = status;
        s.Received_At__c = date.valueOf(receivedAt);
        insert s;
        
        Merchandise__c m = [Select Name from Merchandise__c where Id =: merchId];
        
        FeedItem post = new FeedItem();
        post.ParentId = merchId;
        post.Body = UserInfo.getName() + ' が配送データを作成しました';
        post.type = 'LinkPost'; 
        post.LinkUrl = '/' + s.Id;
        post.Title = m.Name + ': Qty' + s.quantity__c;
        insert post;
        
        FeedItem post2 = new FeedItem();
        post2.ParentId = UserInfo.getUserId();
        post2.Body = UserInfo.getName() + ' によって配送商品データが作成されました '+m.Name+'s';
        post2.type = 'LinkPost'; 
        post2.LinkUrl = '/' + merchId;
        post2.Title = m.Name + ': ' + s.quantity__c;
        insert post2;
    } catch(System.Exception ex) {
        system.debug(ex.getMessage());
    } 
    
    return true;
  }
}