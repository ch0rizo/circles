import { Controller } from '@hotwired/stimulus';
import { createConsumer } from '@rails/actioncable';

// Connects to data-controller="circle-chatroom-subscription"
export default class extends Controller {
  static values = { chatroomId: Number };
  static targets = ['messages'];

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: 'CircleChatroomChannel', id: this.chatroomIdValue },
      {
        received: (data) => {
          console.log(data);
          this.#insertMessageAndScrollDown(data);
        },
      }
    );
    console.log(this.channel);
    console.log(
      `Subscribe to the chatroom with the id ${this.chatroomIdValue}.`
    );
  }

  #insertMessageAndScrollDown(data) {
    console.log(data);
    this.messagesTarget.insertAdjacentHTML('beforeend', data);
    this.messagesTarget.scrollTo(0, this.messagesTarget.scrollHeight);
  }

  resetForm(event) {
    event.target.reset();
  }

  disconnect() {
    console.log('Unsubscribed from the chatroom');
    this.channel.unsubscribe();
  }
}