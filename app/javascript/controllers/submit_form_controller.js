import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['form'];

  submit(e) {
    e.stopPropagation();
    this.formTarget.requestSubmit();
  }
}
