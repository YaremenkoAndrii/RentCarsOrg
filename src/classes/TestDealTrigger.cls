/**
 * Created by 2lego on 23.12.2023.
 */

@IsTest
private class TestDealTrigger {
    @IsTest
    static void testPreventDuplicatesWithSameTimePeriodAndStatusWonOrOpen() {
        Car__c newCar = TestDataFactory.createNewCar('dealCar');
        Car__c newCar1 = TestDataFactory.createNewCar('dealCar1');
        SalesManager__c newSalesManager = TestDataFactory.createSalesManager('manager', true);
        SalesManager__c newSalesManager1 = TestDataFactory.createSalesManager('manager1', true);
        Deal__c newDeal = new Deal__c(Name = 'Test Name', Car__c = newCar.Id,
                Sales_Manager__c = newSalesManager.Id, Status__c = 'Open', Start_Date__c = Datetime.now().addDays(-1),
                End_Date__c = System.today().addDays(+1));
        Deal__c newDeal2 = new Deal__c(Name = 'Test Name', Car__c = newCar1.Id,
                Sales_Manager__c = newSalesManager1.Id, Status__c = 'Open', Start_Date__c = Datetime.now().addDays(-1),
                End_Date__c = System.today().addDays(+1));
        Deal__c newDeal3 = new Deal__c(Name = 'Test Name', Car__c = newCar1.Id,
                Sales_Manager__c = newSalesManager1.Id, Status__c = 'Open', Start_Date__c = Datetime.now().addDays(-1),
                End_Date__c = System.today().addDays(+1));
        Test.startTest();
        try {
            insert newDeal;
        } catch (Exception e) {
        } try {
            insert newDeal2;
        } catch (Exception e) {
        }
        try {
            insert newDeal3;
        } catch (Exception e) {
            System.debug('Cant create duplicate deal');
        }
        Test.stopTest();
    }

    @IsTest
    static void testSetDateTodayForDeals() {
        Car__c newCar = TestDataFactory.createNewCar('dealCar');
        SalesManager__c newSalesManager = TestDataFactory.createSalesManager('manager', true);
        Deal__c newDeal = new Deal__c(Name = 'Test Name', Car__c = newCar.Id,
                Sales_Manager__c = newSalesManager.Id, Status__c = 'Open', Start_Date__c = Datetime.now().addDays(-1),
                End_Date__c = System.today().addDays(+1));
        insert newDeal;

        Test.startTest();
        newDeal.Status__c = 'Lost';
        update newDeal;
        Test.stopTest();

        Deal__c endDate = [SELECT End_Date__c FROM Deal__c WHERE Id = :newDeal.Id];
        System.debug(endDate.End_Date__c);
        Assert.areEqual(endDate.End_Date__c.date(), Date.today());
    }


}





