/**
 * Created by 2lego on 21.02.2024.
 */

({
    doInit : function(component, event, helper) {
        var action = component.get("c.getAvailableCars");

        action.setCallback(this, function(response) {
            console.log(response.getReturnValue())
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.cars", response.getReturnValue());
            }
            // handle error state as well
        });

        // Setup the columns for the datatable
        var cols = [
            {label: 'Car Name', fieldName: 'Name', type: 'text'},
            {label: 'Model', fieldName: 'Model', type: 'text'}
        ];
        component.set("v.columns", cols);

        $A.enqueueAction(action);
    }
});