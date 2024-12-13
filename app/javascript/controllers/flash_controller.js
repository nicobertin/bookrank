import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="flash"
export default class extends Controller {
  connect() {
    this.dismissToasts();
    this.enableSwipeToDismiss();
  }

  dismissToasts() {
    const toasts = this.element.querySelectorAll(".toast");
    toasts.forEach((toast) => {
      setTimeout(() => {
        toast.classList.add("hide");
        setTimeout(() => toast.remove(), 500);
      }, 2000);
    });
  }

  enableSwipeToDismiss() {
    const toasts = this.element.querySelectorAll(".toast");
    toasts.forEach((toast) => {
      let startX = 0;

      // Detect touch start
      toast.addEventListener("touchstart", (e) => {
        startX = e.touches[0].clientX;
      });

      // Detect touch end
      toast.addEventListener("touchend", (e) => {
        const endX = e.changedTouches[0].clientX;
        const diffX = endX - startX;

        if (diffX > 50) {
          this.dismissToast(toast);
        }
      });
    });
  }

  dismissToast(toast) {
    toast.classList.add("hide");
    setTimeout(() => toast.remove(), 500);
  }
}
