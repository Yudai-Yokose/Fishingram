import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "content"]

  connect() {
    this.showContent(0)
    this.element.addEventListener("turbo:submit-end", this.closeModal.bind(this))
  }

  show(event) {
    const index = event.currentTarget.dataset.index
    this.showContent(index)
  }

  showContent(index) {
    this.tabTargets.forEach((tab, i) => {
      if (i == index) {
        tab.querySelector('button').classList.add("text-blue-600", "border-blue-600", "dark:text-blue-500", "dark:border-blue-500")
        tab.querySelector('button').classList.remove("hover:text-gray-600", "hover:border-gray-300")
      } else {
        tab.querySelector('button').classList.remove("text-blue-600", "border-blue-600", "dark:text-blue-500", "dark:border-blue-500")
        tab.querySelector('button').classList.add("hover:text-gray-600", "hover:border-gray-300")
      }
    })

    this.contentTargets.forEach((content, i) => {
      content.classList.toggle("hidden", i != index)
    })
  }

  closeModal(event) {
    if (event.detail.success) {
      const modal = document.getElementById("record-modal");
      modal.classList.add("hidden");
      modal.setAttribute("aria-hidden", "true");
    }
  }
}