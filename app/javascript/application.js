// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import "flowbite/dist/flowbite.turbo.js";
import * as ActiveStorage from "@rails/activestorage"
ActiveStorage.start()

document.addEventListener('direct-upload:progress', event => {
    const { progress } = event.detail
    // 進行状況バーの更新
    const progressElement = document.querySelector(`#progress-bar-${event.target.id}`)
    if (progressElement) {
      progressElement.style.width = `${progress}%`
    }
  })