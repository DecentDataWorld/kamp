import { Controller } from "@hotwired/stimulus"
import introJs from "intro.js";

// Connects to data-controller="intro"
export default class extends Controller {
  connect() {
    const helpLink = document.getElementById('help_link');
    helpLink.addEventListener("click", () => { introJs().start() })
  }
}
