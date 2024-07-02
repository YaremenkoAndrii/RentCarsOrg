trigger CarTrigger on Car__c (after update) {


    if (Trigger.isAfter) {
        if (Trigger.isUpdate) {
            CarTriggerHandler.updateOpenDealsWithBrokenCars(Trigger.newMap);

        }
    }
}