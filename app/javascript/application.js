// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import "flowbite/dist/flowbite.turbo.js";
import * as ActiveStorage from "@rails/activestorage"
ActiveStorage.start()