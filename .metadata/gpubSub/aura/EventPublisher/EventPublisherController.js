({
    doInit : function(component, event, helper) {
        console.info('Event Publisher Init');
        helper.sendMessage(component);
    },
    handlePubsubReady : function(component, event, helper) {
        console.info('pubsub ready');

        var pubsub = component.find('pubsub');

        if (!pubsub) console.error('globalPubSub not ready');

        pubsub.registerListener(
            'getMessage',
            $A.getCallback(function () {
                helper.sendMessage(component);
            })
        );
        helper.sendMessage(component);
    },
    handleSendMessage : function(component, event, helper) {
        try{
            helper.sendMessage(component);
        } catch(e) {
            console.log(e);
        }
    }
})
