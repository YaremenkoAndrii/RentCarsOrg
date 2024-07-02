/**
 * Created by 2lego on 30.11.2023.
 */

public class CarRentDAO {
    public static List<Deal__c> getWonDeals(Datetime startDate, Datetime endDate) {
        List<Deal__c> listOfActualDeals = [
                SELECT Id, Name
                FROM Deal__c
                WHERE Start_Date__c >= :startDate
                AND End_Date__c <= :endDate
                AND Status__c = 'Won'
        ];
        System.debug('debug :' + listOfActualDeals);
        return listOfActualDeals;
    }

    public static Map<Id, Integer> getWonDealsBySalesRepIds(Set<Id> salesRepIds) {
        Map<Id, Integer> wonDealsBySalesRepIds = new Map<Id, Integer>();
        List<Deal__c> deals = [SELECT Id, Status__c, Sales_Manager__c FROM Deal__c WHERE Sales_Manager__c IN :salesRepIds];

        for (Deal__c deal : deals) {
            if (deal.Status__c.equals('Won')) {
                if (wonDealsBySalesRepIds.containsKey(deal.Sales_Manager__c)) {
                    wonDealsBySalesRepIds.put(deal.Sales_Manager__c, wonDealsBySalesRepIds.get(deal.Sales_Manager__c) + 1);
                } else {
                    wonDealsBySalesRepIds.put(deal.Sales_Manager__c, 1);
                }
            }
        }

        System.debug('managers: ' + wonDealsBySalesRepIds);

        return wonDealsBySalesRepIds;
    }

    public static List<Car__c> getCarsAvailableForRent(Datetime rentStart, Datetime rentEnd) {
        List<Car__c> availableCars = new List<Car__c>();

        List<Deal__c> overlappingDeals = [
                SELECT Id, Car__c, Start_Date__c, End_Date__c, Status__c
                FROM Deal__c
                WHERE (Start_Date__c <= :rentEnd AND End_Date__c >= :rentStart)
                OR (Start_Date__c >= :rentStart AND Start_Date__c <= :rentEnd)
                OR (End_Date__c >= :rentStart AND End_Date__c <= :rentEnd)
        ];

        Set<Id> bookedCarIds = new Set<Id>();
        for (Deal__c deal : overlappingDeals) {
            bookedCarIds.add(deal.Car__c);
        }

        if (!bookedCarIds.isEmpty()) {
            availableCars = [
                    SELECT Id, Name
                    FROM Car__c
                    WHERE Id NOT IN :bookedCarIds
            ];
        } else {
            availableCars = [SELECT Id, Name FROM Car__c];
        }

        return availableCars;
    }

    @AuraEnabled
    public static List<AvailableCars> getAvailableCars() {
        List<Car__c> cars = [SELECT Id, Name, Model__c FROM Car__c WHERE Is_Valid_For_Rent__c = TRUE];
        List<AvailableCars> availableCars = new List<CarRentDAO.AvailableCars>();
        for (Car__c car : cars) {
            AvailableCars carClass = new AvailableCars(car.Id, car.Name, car.Model__c);
            availableCars.add(carClass);
        }
        return availableCars;
    }

    public class AvailableCars {

        @AuraEnabled public String Id { get; set; }
        @AuraEnabled public String Name { get; set; }
        @AuraEnabled public String Model { get; set; }

        public AvailableCars(String id, String name, String model) {
            this.Id = id;
            this.Name = name;
            this.Model = model;
        }
    }

    public static Map<Id, Integer> getCarRentStatistic() {
        Map<Id, Integer> carRentCountMap = new Map<Id, Integer>();


        List<Deal__c> rentalDeals = [SELECT Id, Car__c FROM Deal__c WHERE Status__c = 'Won'];

        for (Deal__c deal : rentalDeals) {
            Id carId = deal.Car__c;

            if (carRentCountMap.containsKey(carId)) {
                carRentCountMap.put(carId, carRentCountMap.get(carId) + 1);
            } else {
                carRentCountMap.put(carId, 1);
            }
        }

        return carRentCountMap;
    }

    public static SalesManager__c getTopRatedSalesRepOfYear(Integer year) {
        SalesManager__c topSalesRep = null;
        Integer maxDealsCount = 0;

        List<SalesManager__c> salesRepsWithDeals = [
                SELECT Id, Name, (SELECT Id FROM Deal__r WHERE CALENDAR_YEAR(End_Date__c) = :year)
                FROM SalesManager__c
        ];

        for (SalesManager__c salesRep : salesRepsWithDeals) {
            Integer dealsCount = salesRep.Deal__r.size();

            if (dealsCount > maxDealsCount) {
                topSalesRep = salesRep;
                maxDealsCount = dealsCount;
            }
        }

        return topSalesRep;
    }

    public static List<Deal__c> getOpenDealsWitchRelatedCars(Set<Id> carIDs) {
        List<Deal__c> dealsWithBrokenCar = [
                SELECT Id
                FROM Deal__c
                WHERE Car__c IN :carIDs AND Status__c = 'Open'
        ] ;

        return dealsWithBrokenCar;
    }
}