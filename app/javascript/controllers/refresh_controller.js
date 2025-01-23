import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["table"];
  static values = {
    interval: Number,
  };

  connect() {
    this.startRefreshing();
  }

  disconnect() {
    this.stopRefreshing();
  }

  startRefreshing() {
    if (this.hasIntervalValue) {
      this.refreshTimer = setInterval(() => {
        this.refresh();
      }, this.intervalValue);
    }
  }

  stopRefreshing() {
    if (this.refreshTimer) {
      clearInterval(this.refreshTimer);
    }
  }

  refresh() {
    this.tableTargets.forEach(table => {
        fetch(table.dataset.url, {
            headers: { "Accept": "text/vnd.turbo-stream.html" }
        })
        .then(response => response.text())
        .then(html => {
            Turbo.renderStreamMessage(html);
        })
        .catch(error => console.error("Error refreshing table:", error));
    });
}
}