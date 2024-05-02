import { Controller } from "@hotwired/stimulus"
import { Modal } from "bootstrap"

export default class extends Controller {
  connect() {
    this.modal = new Modal(this.element)
    this.modal.show()
  }

  hideBeforeRender(event) {
    this.element.removeAttribute('class')
  }

  isOpen() {
    return this.element.classList.contains("show")
  }
}