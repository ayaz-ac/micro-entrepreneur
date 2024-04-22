import { Controller } from '@hotwired/stimulus';
import { useClickOutside } from 'stimulus-use';

export default class extends Controller {
  static outlets = ['switch-class']

  connect() {
    useClickOutside(this);
  }

  clickOutside(e) {
    e.preventDefault();
    this.switchClassOutlet.trigger()
  }
}
