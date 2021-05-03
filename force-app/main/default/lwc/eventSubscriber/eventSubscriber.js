import { LightningElement, wire, track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import {
    registerListener,
    fireEvent
} from 'gpubsub/pubsub';

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
            registerListener('sendMessage', this.handleMessageReceived, this);

            fireEvent(this.pageRef, 'getMessage', '');
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
        console.log(`this.messages: ${JSON.stringify(this.messages,null,2)}`);
        this.messages = [...this.messages];
    }
}