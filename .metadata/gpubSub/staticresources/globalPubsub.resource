(function() {
    if (window.globalPubSub)
        return globalPubSub;

    window.globalPubSub = {};
    /**
     * A basic pub-sub mechanism for sibling component communication
     *
     * TODO - adopt standard flexipage sibling communication mechanism when it's available.
     */

    let events = {};

    /**
     * Confirm that two page references have the same attributes
     * @param {object} pageRef1 - The first page reference
     * @param {object} pageRef2 - The second page reference
     */
    globalPubSub.samePageRef = (pageRef1, pageRef2) => {
        const obj1 = pageRef1.attributes;
        const obj2 = pageRef2.attributes;
        return Object.keys(obj1).concat(Object.keys(obj2)).every((key) => {
            let test = obj1[key] === obj2[key];
            if (!test) {
                console.log(
                    `${key}:${obj1[key]} != ${key}:${obj2[key]}`
                );
            }
            return test;
        });
    };

    /**
     * Registers a callback for an event
     * @param {string} eventName - Name of the event to listen for.
     * @param {function} callback - Function to invoke when said event is fired.
     * @param {object} thisArg - The value to be passed as the this parameter to the callback function is bound.
     */
    globalPubSub.registerListener = (eventName, callback, thisArg) => {
        // Checking that the listener has a pageRef property. We rely on that property for filtering purpose in fireEvent()
        if (!thisArg.pageRef) {
            throw new Error(
                'globalPubSub listeners need a "@wire(CurrentPageReference) pageRef" property'
            );
        }

        if (!events[eventName]) {
            events[eventName] = [];
        }
        const duplicate = events[eventName].find((listener) => {
            return listener.callback === callback && listener.thisArg === thisArg;
        });
        if (!duplicate) {
            events[eventName].push({ callback, thisArg });
        }
    };

    /**
     * Unregisters a callback for an event
     * @param {string} eventName - Name of the event to unregister from.
     * @param {function} callback - Function to unregister.
     * @param {object} thisArg - The value to be passed as the this parameter to the callback function is bound.
     */
    globalPubSub.unregisterListener = (eventName, callback, thisArg) => {
        if (events[eventName]) {
            events[eventName] = events[eventName].filter(
                (listener) => listener.callback !== callback || listener.thisArg !== thisArg
            );
        }
    };

    /**
     * Unregisters all event listeners bound to an object.
     * @param {object} thisArg - All the callbacks bound to this object will be removed.
     */
    globalPubSub.unregisterAllListeners = (thisArg) => {
        Object.keys(events).forEach((eventName) => {
            events[eventName] = events[eventName].filter(
                (listener) => listener.thisArg !== thisArg
            );
        });
    };

    /**
     * Fires an event to listeners.
     * @param {object} pageRef - Reference of the page that represents the event scope.
     * @param {string} eventName - Name of the event to fire.
     * @param {*} payload - Payload of the event to fire.
     */
    globalPubSub.fireEvent = (pageRef, eventName, payload) => {
        if (events[eventName]) {
            const listeners = events[eventName];
            listeners.forEach((listener) => {
                if (globalPubSub.samePageRef(pageRef, listener.thisArg.pageRef)) {
                    try {
                        listener.callback.call(listener.thisArg, payload);
                    } catch (error) {
                        // fail silently
                    }
                }
            });
        }
    };
    return globalPubSub;
})();