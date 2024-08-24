import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { timeout: { type: Number, default: 3000 } }

  connect() {
    this.startFadeOut();

    // Turbo Streamsのレンダリング時にもフェードアウト処理を適用
    document.addEventListener("turbo:frame-load", () => {
      this.startFadeOut();
    });
  }

  startFadeOut() {
    setTimeout(() => {
      this.fadeOut();
    }, this.timeoutValue);
  }

  fadeOut() {
    this.element.classList.add("fade-out"); // 既存のfadeOutアニメーションを適用
    setTimeout(() => {
      this.element.style.visibility = "hidden";
    }, 500); // フェードアウトの時間に合わせて設定
  }
}