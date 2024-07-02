/**
 * Created by 2lego on 13.12.2023.
 */

trigger DealTrigger on Deal__c (before insert, before update) {


    if (Trigger.isBefore) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            DealTriggerHandler.setDateTodayForDeals(Trigger.new);
            DealTriggerHandler.preventDuplicatesWithSameTimePeriodAndStatusWonOrOpen(Trigger.new);


        }
    }
}