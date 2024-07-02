/**
 * Created by 2lego on 25.12.2023.
 */

@IsTest
private class TestCarRentDao {

    @IsTest
    static void testGetWonDeals() {
        Deal__c testDeal1 = TestDataFactory.createNewDealWithStatusWon('manager', 'car1');

        Test.startTest();
        List<Deal__c> result = CarRentDAO.getWonDeals(testDeal1.Start_Date__c,
                testDeal1.End_Date__c);
        Test.stopTest();

        Assert.isNotNull(result, 'Must be returned Won deals');

    }

    @IsTest
    static void testGetWonDealsBySalesRepIds() {
        Car__c testCar1 = TestDataFactory.createNewCar('testCar1');
        SalesManager__c testManager = TestDataFactory.createSalesManager('manager', true);
        SalesManager__c testManager2 = TestDataFactory.createSalesManager('manager2', true);
        Deal__c testOpenDeal = new Deal__c(
                Name = 'Test Deal 1',
                Car__c = testCar1.Id,
                Sales_Manager__c = testManager.Id,
                Start_Date__c = Datetime.now().addDays(-10),
                End_Date__c = Datetime.now().addDays(-9),
                Status__c = 'Open'
        );
        Deal__c testOpenDeal1 = new Deal__c(
                Name = 'Test Deal 1',
                Car__c = testCar1.Id,
                Sales_Manager__c = testManager.Id,
                Start_Date__c = Datetime.now().addDays(-8),
                End_Date__c = Datetime.now().addDays(-7),
                Status__c = 'Open'
        );
        insert testOpenDeal;
        insert testOpenDeal1;
        testOpenDeal.Status__c = 'Won';
        update testOpenDeal;
        testOpenDeal1.Status__c = 'Won';
        update testOpenDeal1;
        Deal__c testDeal2 = TestDataFactory.createNewDealWithStatusOpen(testManager2.Name, 'car2');
        Set<Id> ids = new Set<Id>();
        for (Deal__c b : [
                SELECT Id, Sales_Manager__c, Status__c
                FROM Deal__c
        ]) {
            ids.add(b.Sales_Manager__c);
        }

        Test.startTest();
        Map<Id, Integer> result = CarRentDAO.getWonDealsBySalesRepIds(ids);
        Test.stopTest();

        Assert.isNotNull(result, 'Must be returned Won deals for Sales Managers');


    }

    @IsTest
    static void testGetCarsAvailableForRent_Positive() {

        List<Car__c> availableCars = new List<Car__c>();
        Car__c testAvailableCar1 = TestDataFactory.createNewCar('testAvailableCar');
        Car__c testAvailableCar2 = TestDataFactory.createNewCar('testAvailableCar2');
        Deal__c testDeal = TestDataFactory.createNewDealWithStatusOpen('manager', testAvailableCar1.Name);
        Deal__c testDeal2 = TestDataFactory.createNewDealWithStatusWon('manager2', testAvailableCar2.Name);
        testDeal.Start_Date__c = TestDataFactory.START_DATE_TO_TEST_DEAL;
        testDeal.End_Date__c = TestDataFactory.END_DATE_TO_TEST_DEAL;
        update testDeal;

        Test.startTest();
        availableCars = CarRentDAO.getCarsAvailableForRent(TestDataFactory.START_DATE_TO_TEST_DEAL - 1,
                TestDataFactory.END_DATE_TO_TEST_DEAL + 1);
        Test.stopTest();

        Assert.isNotNull(availableCars, 'Must be returned available Cars to rent');


    }

    @IsTest
    static void testGetCarsAvailableForRentNegative() {
        List<Car__c> availableCars = new List<Car__c>();
        Test.startTest();
        availableCars = CarRentDAO.getCarsAvailableForRent(TestDataFactory.START_DATE_TO_TEST_DEAL - 1000,
                TestDataFactory.END_DATE_TO_TEST_DEAL -999);
        Test.stopTest();

        Assert.isNotNull(availableCars, 'Must be returned available Cars to rent');
    }

    @IsTest
    static void testGetCarRentStatistic() {
        Map<Id, Integer> carRentCountMap = new Map<Id, Integer>();
        SalesManager__c testManager = TestDataFactory.createSalesManager('manager', true);
        SalesManager__c testManager1 = TestDataFactory.createSalesManager('manager', true);
        Car__c testCar1 = TestDataFactory.createNewCar('testCar1');
        Car__c testCar2 = TestDataFactory.createNewCar('testCar2');
        Deal__c testOpenDeal = new Deal__c(
                Name = 'Test Deal 1',
                Car__c = testCar1.Id,
                Sales_Manager__c = testManager.Id,
                Start_Date__c = Datetime.now().addDays(-1),
                End_Date__c = Datetime.now(),
                Status__c = 'Open'
        ); Deal__c testOpenDeal1 = new Deal__c(
                Name = 'Test Deal 1',
                Car__c = testCar1.Id,
                Sales_Manager__c = testManager.Id,
                Start_Date__c = Datetime.now().addDays(-4),
                End_Date__c = Datetime.now().addDays(-2),
                Status__c = 'Open'
        );
        insert testOpenDeal;
        insert testOpenDeal1;
        testOpenDeal.Status__c = 'Won';
        update testOpenDeal;
        testOpenDeal1.Status__c = 'Won';
        update testOpenDeal1;
        Deal__c testDeal3 = TestDataFactory.createNewDealWithStatusWon('manager', testCar2.Name);

        Test.startTest();
        carRentCountMap = CarRentDAO.getCarRentStatistic();
        Test.stopTest();

        Assert.isNotNull(carRentCountMap, 'Must be returned map of cars and winning deals');


    }

    @IsTest
    static void testGetTopRatedSalesRepOfYear() {

        SalesManager__c topSalesManager = new SalesManager__c();
        SalesManager__c testManager = TestDataFactory.createSalesManager('manager', true);
        SalesManager__c testManager2 = TestDataFactory.createSalesManager('manager2', true);
        Deal__c testDeal = TestDataFactory.createNewDealWithStatusWon(testManager.Name, 'car');
        Deal__c testDeal2 = TestDataFactory.createNewDealWithStatusOpen(testManager2.Name, 'car2');

        Test.startTest();
        topSalesManager = CarRentDAO.getTopRatedSalesRepOfYear(2024);
        Test.stopTest();

        Assert.isNotNull(topSalesManager, 'Must be returned Top Sales Manager of the year');


    }

    @IsTest
    static void testGetOpenDealsWitchRelatedCars() {

        SalesManager__c testManager = TestDataFactory.createSalesManager('manager', true);
        SalesManager__c testManager2 = TestDataFactory.createSalesManager('manager2', true);
        Deal__c testDeal = TestDataFactory.createNewDealWithStatusOpen(testManager.Name, 'car');
        Deal__c testDeal1 = TestDataFactory.createNewDealWithStatusOpen(testManager.Name, 'car');
        Deal__c testDeal2 = TestDataFactory.createNewDealWithStatusWon(testManager2.Name, 'car2');

        Set<Id> ids = new Set<Id>();
        for (Car__c b : [
                SELECT Id
                FROM Car__c
        ]) {
            ids.add(b.Id);
        }

        Test.startTest();
                List<Deal__c> openDealsWitchRelatedCars = CarRentDAO.getOpenDealsWitchRelatedCars(ids);
        Test.stopTest();

        Assert.isNotNull(openDealsWitchRelatedCars, 'Must be returned Top Sales Manager of the year');



    }

    @IsTest
    static void testGetAvailableCars() {

        Car__c car1 = TestDataFactory.createNewCar('car1');
        Car__c car2 = TestDataFactory.createNewCar('car2');
        car2.Is_Valid_For_Rent__c = false;
        update car2;

        Test.startTest();
        List<CarRentDAO.AvailableCars> availableCars = CarRentDAO.getAvailableCars();
        Test.stopTest();

        Assert.areEqual(availableCars.size(), 1);
    }

}