// Entry point for the build script in your package.json
import "@hotwired/turbo-rails";
import "./controllers";
import Rails from "@rails/ujs";

<<<<<<< HEAD
import "@hotwired/turbo-rails"
import "./controllers"
import * as Bootstrap from "bootstrap"
import Rails from "@rails/ujs"

Rails.start()import * as bootstrap from "bootstrap"
=======
Rails.start(); // Add a semicolon here
import * as Bootstrap from "bootstrap"; // Use the pinned name here
>>>>>>> extra_costs
