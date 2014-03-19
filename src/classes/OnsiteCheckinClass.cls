global class OnsiteCheckinClass{
        
    @RemoteAction
    global static List<InternalEvent__c> getNearby(String lat, String lon) {
        //geolocationが設定されていない場合は東京とする
        if(lat == null || lon == null || lat.equals('') || lon.equals('')) {
            lat = '35.680638';
            lon = '139.764887';
        }

        // SOQLクエリで近くのイベントを検索
        String queryString =
            'SELECT Id, Name, Description__c, Needs__c, ' +
                'Address__c, City__c, Event_Date__c, State__c ' +
            'FROM InternalEvent__c ' +
            'WHERE DISTANCE(Location__c, GEOLOCATION('+lat+','+lon+'), \'mi\') < 3 ' +
            'ORDER BY DISTANCE(Location__c, GEOLOCATION('+lat+','+lon+'), \'mi\') ' +
            'LIMIT 10';

        // Run and return the query results
        return(database.Query(queryString)); 
    }

    @RemoteAction
    global static InternalEventAttendee__c CreateAttendeeRec(Integer hours, String mobile, String confNum, String eventId){
        InternalEventAttendee__c attendee = new InternalEventAttendee__c();
        attendee.Total_Hours__c = hours;
        attendee.InternalEvent__c = eventId;
        attendee.User__c = UserInfo.getUserId();
        attendee.Confirmation_Number__c = confNum;
        attendee.Mobile__c = mobile;
        attendee.Check_In_Time__c = datetime.now();
        insert attendee;
        
        return attendee;
    }
    
    @RemoteAction
    public static Id makeContentPublic(String contentVersionId) {
        ContentVersion cv = [SELECT ContentDocumentId 
                             FROM ContentVersion 
                             WHERE Id = :contentVersionId];
        ContentDocumentLink cdl = new ContentDocumentLink(
            ContentDocumentId = cv.ContentDocumentId, 
            LinkedEntityId = UserInfo.getOrganizationId(), 
            ShareType = 'V');
        insert cdl;
        
        return cv.ContentDocumentId;
    }
   
}