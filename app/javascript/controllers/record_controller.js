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
      const button = tab.querySelector('button')

      if (i == index) {
        // アクティブなタブに枠線クラスを追加
        button.classList.add("text-blue-600", "border-blue-600", "dark:text-blue-500", "dark:border-blue-500", "border-b", "border-gray-400")
        button.classList.remove("hover:text-gray-400", "hover:border-gray-400")
      } else {
        // 非アクティブなタブから枠線クラスを削除
        button.classList.remove("text-blue-600", "border-blue-600", "dark:text-blue-500", "dark:border-blue-500", "border-b", "border-gray-400")
        button.classList.add("hover:text-gray-400", "hover:border-gray-400")
      }
    })

    this.contentTargets.forEach((content, i) => {
      content.classList.toggle("hidden", i != index)
    })
  }

  closeModal(event) {
    if (event.detail.success) {
      const modalCloseButton = document.querySelector("[data-modal-hide='record-modal']")
      if (modalCloseButton) {
        modalCloseButton.click()
      }
    }
  }
}