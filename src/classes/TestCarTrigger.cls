@IsTest
private class TestCarTrigger {

    @IsTest
    static void testUpdateOpenDealsWithBrokenCars() {
        Car__c testCar = new Car__c(Name = 'Sedan', Type__c = 'Sedan', Is_Valid_For_Rent__c = true);
        insert testCar;
        System.debug(testCar);
        SalesManager__c manager = TestDataFactory.createSalesManager('TestName', true);

        Deal__c testDeal = new Deal__c
                (
                        Name = 'TestCarTriggerDeal',
                        Start_Date__c = Datetime.now().addDays(-1),
                        End_Date__c = Datetime.now(),
                        Sales_Manager__c = manager.Id,
                        Car__c = testCar.Id,
                        Status__c = 'Open'
                );
        insert testDeal;
        System.debug(testDeal);


        Test.startTest();
        testCar.Is_Valid_For_Rent__c = false;
        update testCar;
        System.debug(testCar);
        Test.stopTest();

        Deal__c resultDeal = [SELECT Status__c FROM Deal__c WHERE Id = :testDeal.Id];
        System.debug(resultDeal);
        Assert.areEqual('Lost', resultDeal.Status__c);
    }
}