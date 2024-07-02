/**
 * Created by 2lego on 25.12.2023.
 */

public with sharing class DealTriggerHandler {

    public static void setDateTodayForDeals(List <Deal__c> deals) {

        for (Deal__c record : deals) {

            if (record.Status__c == 'Won' || record.Status__c == 'Lost') {

                record.End_Date__c = System.today();
            }
        }
    }

    public static void preventDuplicatesWithSameTimePeriodAndStatusWonOrOpen(List<Deal__c> triggerNew) {
        Set<Id> cars = new Set<Id>();
        Set<Id> dealIds = new Set<Id>();
        for (Deal__c deal : triggerNew) {
            cars.add(deal.Car__c);
            dealIds.add(deal.Car__c);
        }
        List<Deal__c> queryDeals = [
                SELECT Car__c, Start_Date__c, End_Date__c, Status__c
                FROM Deal__c
                WHERE Car__c IN :cars
                AND (Status__c = 'Won' OR Status__c = 'Open')
                AND Id NOT IN :dealIds
        ];


        Map<Id, List<Deal__c>> dealMap = new Map<Id, List<Deal__c>>();
        for (Deal__c dealItem : queryDeals) {
            if (!dealMap.containsKey(dealItem.Car__c)) {
                dealMap.put(dealItem.Car__c, new List<Deal__c>());
            }
            dealMap.get(dealItem.Car__c).add(dealItem);
        }



        for (Deal__c deal : triggerNew) {
            if (dealMap.containsKey(deal.Car__c) && deal.Status__c == 'Open') {
                for (Deal__c dealItem : dealMap.get(deal.Car__c)) {
                    if (deal.Start_Date__c < dealItem.End_Date__c && deal.End_Date__c > dealItem.Start_Date__c) {
                        deal.addError('Duplicate deal with overlapping period found.');
                    }
                }
            }
        }
    }
}