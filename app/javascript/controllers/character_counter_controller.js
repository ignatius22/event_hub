import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "count"]

  connect() {
    this.count()
  }

  count() {
    const length = this.inputTarget.value.length
    this.countTarget.textContent = length

    // Change color based on limit
    if (length > 4500) {
      this.countTarget.classList.add("text-red-600")
      this.countTarget.classList.remove("text-gray-500")
    } else if (length > 4000) {
      this.countTarget.classList.add("text-yellow-600")
      this.countTarget.classList.remove("text-gray-500", "text-red-600")
    } else {
      this.countTarget.classList.remove("text-red-600", "text-yellow-600")
      this.countTarget.classList.add("text-gray-500")
    }
  }
}
