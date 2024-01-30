// Entry point for the build script in your package.json
import "@hotwired/turbo-rails";
import "./controllers";
import Rails from "@rails/ujs";

Rails.start(); // Add a semicolon here
import * as Bootstrap from "bootstrap"; // Use the pinned name here
