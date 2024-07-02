@IsTest
public class TestDataFactory {
    public static final Datetime SECOND_DAY = Datetime.now().addDays(1);
    public static final Datetime THIRD_DAY = Datetime.now().addDays(2);

    public static final Datetime START_DATE_TO_TEST_DEAL = Datetime.now().addDays(300);
    public static final Datetime END_DATE_TO_TEST_DEAL = Datetime.now().addDays(301);

        public static SalesManager__c createSalesManager(String managerName, Boolean isInsert) {
        SalesManager__c manager = new SalesManager__c(Name = managerName);
        if (isInsert) {
            insert manager;
        }
        return manager;
    }
    public static SalesManager__c createSalesManager(Boolean isInsert) {
        SalesManager__c manager = new SalesManager__c(Name = 'managerName');
        if (isInsert) {
            insert manager;
        }
        return manager;
    }

    public static Car__c createNewCar (String name){
        Car__c testCar = new Car__c(Name = name, Is_Valid_For_Rent__c = true);
        insert testCar;
        return testCar;
    }

    public static Deal__c createNewDealWithStatusOpen (String managerName, String carName){
        SalesManager__c testManager = createSalesManager(managerName,true);
                Car__c testCar1 = createNewCar(carName);


            Deal__c testOpenDeal = new Deal__c(
                    Name = 'Test Deal 1',
                    Car__c = testCar1.Id,
                    Sales_Manager__c = testManager.Id,
                    Start_Date__c = Datetime.now().addDays(2),
                    End_Date__c = Datetime.now().addDays(10),
                    Status__c = 'Open'
            );
            insert testOpenDeal;
            return testOpenDeal;
        }

    public static Deal__c createNewDealWithStatusWon (String managerName, String carName){
        SalesManager__c testManager = createSalesManager(managerName,true);
        Car__c testCar1 = createNewCar(carName);


        Deal__c newWonDeal = new Deal__c(
                Name = 'Test Deal 1',
                Car__c = testCar1.Id,
                Sales_Manager__c = testManager.Id,
                Start_Date__c = Datetime.now().addDays(-56),
                End_Date__c = Datetime.now(),
                Status__c = 'Open'
        );
        insert newWonDeal;
        System.debug('newWonDeal : ' + newWonDeal);
        System.debug('newWonDeal  s: ' + newWonDeal.Start_Date__c);
        System.debug('newWonDeal  d: ' + newWonDeal.End_Date__c);
        newWonDeal.Status__c = 'Won';
        update newWonDeal;
        return newWonDeal;
    }

    }