import { Application } from "@hotwired/stimulus"
import "flowbite/dist/flowbite.turbo.js";

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
