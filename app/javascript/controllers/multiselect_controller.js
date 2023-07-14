import { Controller } from "@hotwired/stimulus"
import Choices from 'choices.js';

// Connects to data-controller="multiselect"
export default class extends Controller {
  connect() {
    const element = document.querySelector('#multiselect');
    const choices = new Choices(element, {removeItemButton: true});
  }
}
