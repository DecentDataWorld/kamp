import { Controller } from "@hotwired/stimulus"
import { TableSortController } from "stimulus-library";

export default class extends Controller {
  // static values = { adminrole: String, memberrole: String };
  connect() {
    console.log('hi?')
    // this.element.textContent = "Users list controller?";
  }
}
