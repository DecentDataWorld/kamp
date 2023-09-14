import { Controller } from "@hotwired/stimulus"
import Choices from 'choices.js';

// Connects to data-controller="multiselect"
export default class extends Controller {
  connect() {
    const getChoices = (element) => {
      return new Choices(element, {removeItemButton: true})
    }
    const elements = document.querySelectorAll('#multiselect');
    elements.forEach(getChoices)
  }
}
