import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['element']

  trigger () {
    this.elementTargets.forEach(element => {
      if (element.dataset.activeClass && element.dataset.inactiveClass) {
        element.dataset.activeClass.split(' ').forEach(activeClass => {
          element.classList.toggle(activeClass)
        })
        element.dataset.inactiveClass.split(' ').forEach(inactiveClass => {
          element.classList.toggle(inactiveClass)
        })
      }
    })
  }
}
