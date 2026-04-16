import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel"]

  connect() {
    this._onResize = () => {
      if (!this.panelTarget.classList.contains("hidden")) this.positionPanel()
    }
    window.addEventListener("resize", this._onResize)
  }

  disconnect() {
    window.removeEventListener("resize", this._onResize)
  }

  toggle(event) {
    event.stopPropagation()
    const hidden = this.panelTarget.classList.contains("hidden")
    if (hidden) {
      this.positionPanel()
      this.panelTarget.classList.remove("hidden")
      this.panelTarget.setAttribute("aria-hidden", "false")
    } else {
      this.close()
    }
  }

  positionPanel() {
    const btn = this.element.querySelector("button")
    if (!btn) return

    const rect = btn.getBoundingClientRect()
    const panel = this.panelTarget
    const gap = 6
    const vw = window.innerWidth
    const margin = 8
    const panelW = Math.min(18 * 16, vw - margin * 2)
    const alignRight = vw - rect.right
    const maxRight = vw - panelW - margin
    const right = Math.min(alignRight, Math.max(margin, maxRight))

    panel.style.position = "fixed"
    panel.style.top = `${Math.round(rect.bottom + gap)}px`
    panel.style.right = `${Math.round(right)}px`
    panel.style.left = "auto"
    panel.style.maxWidth = `${panelW}px`
    panel.style.zIndex = "10050"
  }

  closeOnClickOutside(event) {
    if (this.element.contains(event.target)) return

    this.close()
  }

  closeOnEscape(event) {
    if (event.key !== "Escape") return
    if (this.panelTarget.classList.contains("hidden")) return

    this.close()
  }

  close() {
    const panel = this.panelTarget
    panel.classList.add("hidden")
    panel.setAttribute("aria-hidden", "true")
    panel.style.top = ""
    panel.style.right = ""
    panel.style.left = ""
    panel.style.maxWidth = ""
    panel.style.zIndex = ""
  }
}
