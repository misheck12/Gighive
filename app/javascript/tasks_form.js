// app/javascript/tasks_form.js

document.addEventListener('turbo:load', () => {
    const COST_PER_PAGE = 30; // Cost per page in ZMK
  
    // Get references to elements
    const pagesInput = document.getElementById("pages");
    const priceInput = document.getElementById("price");
  
    // Function to calculate and update price
    function calculatePrice() {
      const pages = parseInt(pagesInput.value, 10) || 1; // Default to 1 if invalid
      const price = pages * COST_PER_PAGE;
  
      // Update price field with calculated price
      priceInput.value = price.toFixed(2);
    }
  
    // Attach event listener to the pages input
    if (pagesInput) {
      pagesInput.addEventListener("input", calculatePrice);
    }
  
    // Initialize price on page load
    calculatePrice();
  });