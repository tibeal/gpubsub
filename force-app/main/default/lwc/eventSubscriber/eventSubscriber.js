import { LightningElement, wire, track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { loadScript } from 'lightning/platformResourceLoader';
import gpubsubJS from '@salesforce/resourceUrl/globalPubsub'

const columns = [
    { label: 'Message', fieldName: 'message' }
];

export default class EventSubscriber extends LightningElement {
    @wire(CurrentPageReference) pageRef;

    @track messages = [];
    @track columns = columns;
    num = 0;

    connectedCallback() {
        try{
            loadScript(this, gpubsubJS)
            .then(() => {
                console.log('globalPubSub loaded in subscriber');
                if (globalPubSub) {
                    globalPubSub.registerListener('sendMessage', this.handleMessageReceived, this);

                    globalPubSub.fireEvent(this.pageRef, 'getMessage', '');
                }
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error loading pubsub',
                        message: error.message,
                        variant: 'error'
                    })
                );
            });
        } catch(e) {
            console.error(e);
        }
    }

    handleMessageReceived(payload) {
        console.log(`Msg received: ${JSON.stringify(payload, null, 2)}`);
        this.messages.push(
            Object.assign(
                {id: ++this.num},
                payload
            )
        );
        this.messages = [...this.messages];
    }
}