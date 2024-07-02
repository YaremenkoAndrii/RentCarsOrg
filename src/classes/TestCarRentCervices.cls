/**
 * Created by 2lego on 28.01.2024.
 */

@IsTest
private class TestCarRentCervices {
    @IsTest
    static void testSetEndDate() {

        SalesManager__c testManager = TestDataFactory.createSalesManager('manager', true);
        Car__c testCar = TestDataFactory.createNewCar('testCar');
        Deal__c testDeal = TestDataFactory.createNewDealWithStatusWon(testManager.Name, testCar.Name );


        Test.startTest();
        CarRentServices.setEndDate(testDeal.Id);
        Test.stopTest();

        Assert.areNotEqual([SELECT End_Date__c FROM Deal__c WHERE Id = :testDeal.Id].End_Date__c, Datetime.now());
    }

    @IsTest
    static void testFilterFinished() {

        SalesManager__c testManager = TestDataFactory.createSalesManager('manager', true);
        SalesManager__c testManager2 = TestDataFactory.createSalesManager('manager2', true);
        Car__c testCar = TestDataFactory.createNewCar('testCar');
        Car__c testCar2 = TestDataFactory.createNewCar('testCar2');
        CarRentServices.createNewDeal(Datetime.now()+1, Datetime.now()+2, testManager.Id, testCar.Id);
        CarRentServices.createNewDeal(Datetime.now()+2, Datetime.now()+3, testManager2.Id, testCar2.Id);

        Test.startTest();
      List <Deal__c> testListDeal= CarRentServices.filterFinished();
        Test.stopTest();

        System.debug(testListDeal);
    }

    @IsTest
    static void testCreateSalesManager() {

        Test.startTest();
        CarRentServices.createSalesManager('testSM', Date.today());
        Test.stopTest();

        Assert.isNotNull([SELECT Name FROM SalesManager__c WHERE Name = 'testSM' AND Birth_Date__c = :Date.today()],
                'Sales Manager should be created');

    }

    @IsTest
    static void testCreateNewDeal() {

        SalesManager__c testManager = TestDataFactory.createSalesManager('manager', true);
        Car__c testCar = TestDataFactory.createNewCar('testCar');

        Test.startTest();
        CarRentServices.createNewDeal(Datetime.now().addDays(1), Datetime.now().addDays(2), testManager.Id, testCar.Id);
        Test.stopTest();

        Assert.isNotNull([SELECT Name FROM Deal__c WHERE Start_Date__c = :Datetime.now().addDays(1)
        AND End_Date__c= :Datetime.now().addDays(2)], 'napusatu poyasnennia');




    }


    @IsTest
    static void testDeactivateCar() {
        Car__c testCar = new Car__c();
        testCar.Name = 'Test Car';
        testCar.Is_Valid_For_Rent__c = true;
        insert testCar;

        SalesManager__c c = TestDataFactory.createSalesManager(true);

        Deal__c testDeal = new Deal__c(Name = 'Test Deal 1',
                Car__c = testCar.Id,
                Sales_Manager__c = c.Id,
                Start_Date__c = Datetime.now().addDays(-11),
                End_Date__c = Datetime.now(),
                Status__c = 'Open');
        insert testDeal;

        Test.startTest();
        CarRentServices.deactivateCar(testCar.Id);
        Test.stopTest();


        Car__c deactivatedCar = [SELECT Is_Valid_For_Rent__c FROM Car__c WHERE Id = :testCar.Id];
        System.assertEquals(false, deactivatedCar.Is_Valid_For_Rent__c);

        List<Deal__c> updatedDeals = [SELECT Status__c FROM Deal__c WHERE Car__c = :testCar.Id];
        for (Deal__c deal : updatedDeals) {
            System.assertEquals('Lost', deal.Status__c);

        }
    }



}