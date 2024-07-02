/**
 * Created by 2lego on 20.12.2023.
 */

public with sharing class CarTriggerHandler {

    public static void updateOpenDealsWithBrokenCars(Map<Id, Car__c> carNewMap) {

        List <Deal__c> dealsWithBrokenCar = CarRentDAO.getOpenDealsWitchRelatedCars(carNewMap.keySet());

        if (!dealsWithBrokenCar.isEmpty()) {

            for (Deal__c d : dealsWithBrokenCar) {

                d.Status__c = 'Lost';

            }

                update dealsWithBrokenCar;


        }

    }

}