/**
 * Created by 2lego on 21.02.2024.
 */

public with sharing class AvailableCarsController {
    @AuraEnabled
    public static List<Car__c> getAvailableCars() {
        return [SELECT Id, Name, Model__c FROM Car__c WHERE Is_Valid_For_Rent__c = TRUE];
    }
}