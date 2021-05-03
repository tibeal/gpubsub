({
    sendMessage : function(component) {
        console.log('firing event');
        var input = component.find("messageInput");
        var messageEvent = $A.get("e.gpubSub:SendMessage");
        if (messageEvent) {
            messageEvent.setParam('message', input.get('v.value'));
            messageEvent.fire();
        }

        var pubsub = component.find('pubsub');

        if(pubsub) {
            pubsub.fireEvent('sendMessage', {message: input.get('v.value')});
        }
    }
})
