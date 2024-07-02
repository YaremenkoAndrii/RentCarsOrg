public class CarRentServices {

    public static void setEndDate(Id recordId) {

        Deal__c d = [
                SELECT Id, End_Date__c
                FROM Deal__c
                WHERE Id = :recordId
        ];

        d.End_Date__c = Datetime.now();
        update d;

    }

    public static List<Deal__c> filterFinished() {

        List <Deal__c> deal = [
                SELECT Name__c
                FROM Deal__c
                ORDER BY Status__c
        ];

        return deal;

    }

    public static void createSalesManager(String name, Date birthdate) {

        SalesManager__c newSM = new SalesManager__c(Name = name, Birth_Date__c = birthdate);

        insert newSM;

    }

    public static void createNewDeal(Datetime startDate, Datetime endDate, Id salesRepId, Id carId) {

        Deal__c newDeal = new Deal__c(Start_Date__c = startDate, End_Date__c = endDate, Sales_Manager__c = salesRepId,
                Car__c = carId, Status__c = 'Open');

        insert newDeal;
    }


    public static void deactivateCar(Id carId) {
        List<Deal__c> dealsToUpdate = [
                SELECT Id, Status__c
                FROM Deal__c
                WHERE Car__c = :carId AND Status__c = 'Open'
        ];

        for (Deal__c deal : dealsToUpdate) {
            deal.Status__c = 'Lost';
        }
        update dealsToUpdate;
        System.debug(dealsToUpdate);

        Car__c brokenCar = [
                SELECT Id, Is_Valid_For_Rent__c
                FROM Car__c
                WHERE Id = :carId
        ];


            brokenCar.Is_Valid_For_Rent__c = false;
            update brokenCar;


    }

}