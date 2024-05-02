import { Controller } from "@hotwired/stimulus"
import Iconpicker from '../iconpicker'

export default class extends Controller {
  
  connect() {
    const element = document.querySelector('.iconpicker');
    const iconpicker = new Iconpicker(element, {
      showSelectedIn: document.querySelector(".selected-icon"),
      defaultValue: document.getElementById("iconpicker").value
  });

  iconpicker.set(document.getElementById("iconpicker").value) 
  }

}