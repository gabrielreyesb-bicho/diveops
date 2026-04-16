import { Controller } from "@hotwired/stimulus"

// Web Share API si existe; si no, copia el enlace al portapapeles.
export default class extends Controller {
  static values = { url: String, title: String }

  async handleClick(event) {
    event.preventDefault()
    event.stopPropagation()

    const url = this.urlValue
    const title = this.titleValue || ""

    if (navigator.share) {
      try {
        await navigator.share({ title, text: title, url })
        return
      } catch (err) {
        if (err.name === "AbortError") return
      }
    }

    try {
      await navigator.clipboard.writeText(url)
      this.showCopiedFeedback()
    } catch {
      window.prompt("Copiá el enlace:", url)
    }
  }

  showCopiedFeedback() {
    const el = this.element
    const label = el.querySelector("[data-share-label]")
    const previous = label ? label.textContent : ""
    if (label) label.textContent = "Copiado"
    el.setAttribute("title", "Enlace copiado")
    window.setTimeout(() => {
      if (label) label.textContent = previous
      el.setAttribute("title", "Compartir")
    }, 2000)
  }
}
