import { Controller } from "@hotwired/stimulus"
import { Modal } from "bootstrap"

export default class extends Controller {
  connect() {
    this.modal = new Modal(this.element)
    this.modal.show()
    this.element.addEventListener('hidden.bs.modal', (event) => {
      location.reload();
    })
  }

  hideBeforeRender(event) {
    if (this.isOpen()) {
      console.log("hideBeforeRender - isOpen");
      event.preventDefault()
      this.element.addEventListener('hidden.bs.modal', event.detail.resume)
      this.modal.hide()
    }
  }

  isOpen() {
    return this.element.classList.contains("show")
  }
}