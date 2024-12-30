// app/javascript/controllers/index.js

import { Application } from "@hotwired/stimulus"
import { definitionsFromContext } from "@hotwired/stimulus-loading"

// Create a Stimulus application instance
const application = Application.start()

// Load all controllers defined in the controllers directory
const context = require.context(".", true, /\.js$/)
application.load(definitionsFromContext(context))
