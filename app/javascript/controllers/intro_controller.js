import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="intro"
export default class extends Controller {
  static targets = ["element"];
  static values = { delay: Number };

  connect() {
    this.showFirstElement();
  }

  showFirstElement() {
    // 最初の要素 (Welcome to Fishingram) を上からフェードイン
    const firstElement = this.elementTargets[0];
    firstElement.classList.remove("hidden");
    firstElement.classList.add("fade-in-top");

    // 1秒後に次の要素を表示
    setTimeout(() => {
      this.showSecondElement();
    }, 500); // 500ms = 0.5秒
  }

  showSecondElement() {
    // 2番目の要素 (さぁ記録しよう、より手軽に) を下からフェードイン
    const secondElement = this.elementTargets[1];
    secondElement.classList.remove("hidden");
    secondElement.classList.add("fade-in-bottom");

    // さらに2秒後に最初の2つの要素を非表示にして次の要素を表示
    setTimeout(() => {
      this.hideFirstElements();
      this.showRemainingElements();
    }, 2000); // 2000ms = 2秒
  }

  hideFirstElements() {
    // 最初の2つの要素を再び非表示にする
    this.elementTargets.slice(0, 2).forEach((element) => {
      element.classList.add("hidden");
    });
  }

  showRemainingElements() {
    // 残りの要素を上から順に表示
    this.elementTargets.slice(2).forEach((element, index) => {
      setTimeout(() => {
        element.classList.remove("hidden");

        // <hr>タグの場合は、fade-in-bottomではなくshowクラスを適用
        if (element.tagName === "HR") {
          element.classList.add("show");
        } else {
          element.classList.add("fade-in-bottom");
        }
      }, this.delayValue * index);
    });
  }
}