import { Controller } from "@hotwired/stimulus"

// Vista previa local de archivos elegidos en <input type="file" multiple accept="image/*">
export default class extends Controller {
  static targets = ["input", "list"]

  preview() {
    const files = this.inputTarget.files
    this.listTarget.innerHTML = ""

    if (!files?.length) return

    const grid = document.createElement("div")
    grid.className = "mt-3 grid grid-cols-2 gap-3 sm:grid-cols-3 md:grid-cols-4"
    grid.setAttribute("role", "list")
    grid.setAttribute("aria-label", "Vista previa de imágenes seleccionadas")

    Array.from(files).forEach((file) => {
      const item = document.createElement("div")
      item.className =
        "overflow-hidden rounded-lg border border-arrecife/60 bg-white shadow-sm ring-1 ring-arrecife/40"
      item.setAttribute("role", "listitem")

      const caption = document.createElement("p")
      caption.className =
        "truncate border-b border-arrecife/40 bg-espuma/60 px-2 py-1.5 text-xs font-medium text-abismo"
      caption.textContent = file.name
      caption.title = file.name
      item.appendChild(caption)

      if (file.type.startsWith("image/")) {
        const img = document.createElement("img")
        img.className = "h-28 w-full object-cover"
        img.alt = ""
        const reader = new FileReader()
        reader.onload = (e) => {
          img.src = e.target.result
        }
        reader.readAsDataURL(file)
        item.appendChild(img)
      } else {
        const p = document.createElement("p")
        p.className = "px-2 py-8 text-center text-xs text-slate-500"
        p.textContent = "Sin vista previa"
        item.appendChild(p)
      }

      grid.appendChild(item)
    })

    this.listTarget.appendChild(grid)
  }
}
