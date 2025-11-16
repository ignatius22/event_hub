import { Controller } from "@hotwired/stimulus"

// This controller can be extended to integrate with Mapbox or Google Maps
// For now, it displays coordinates as a placeholder
export default class extends Controller {
  static values = {
    latitude: Number,
    longitude: Number,
    title: String
  }

  connect() {
    this.renderMap()
  }

  renderMap() {
    // Placeholder for map integration
    // To integrate with Mapbox:
    // 1. Add mapbox-gl to importmap
    // 2. Include Mapbox CSS in layout
    // 3. Create map instance here

    this.element.innerHTML = `
      <div class="flex flex-col items-center justify-center h-full bg-gray-100 rounded-lg p-4">
        <svg class="h-12 w-12 text-gray-400 mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
        </svg>
        <p class="font-medium text-gray-700">${this.titleValue}</p>
        <p class="text-sm text-gray-500">Lat: ${this.latitudeValue.toFixed(4)}, Lng: ${this.longitudeValue.toFixed(4)}</p>
        <a href="https://www.google.com/maps?q=${this.latitudeValue},${this.longitudeValue}"
           target="_blank"
           class="mt-3 inline-flex items-center px-3 py-1 border border-gray-300 text-xs font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
          Open in Google Maps
        </a>
      </div>
    `
  }
}
