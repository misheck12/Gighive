//= require popper
//= require bootstrap

import "@hotwired/turbo-rails"
import "./controllers"
import * as Bootstrap from "bootstrap"
import Rails from "@rails/ujs"
// Import the tasks form script
import "./tasks_form"

Rails.start()
