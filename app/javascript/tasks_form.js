document.addEventListener('turbo:load', () => {
    const COST_PER_PAGE = 30; // Cost per page in ZMK
  
    const pagesInput = document.getElementById("pages");
    const priceInput = document.getElementById("price");
  
    function calculatePrice() {
      const pages = parseInt(pagesInput.value, 10) || 1;
      const price = pages * COST_PER_PAGE;
      priceInput.value = price.toFixed(2);
  
      // Optionally update the budget field if it's necessary
      // const budgetInput = document.querySelector('input[name="task[budget]"]');
      // if (budgetInput) {
      //   budgetInput.value = price.toFixed(2);
      // }
    }
  
    if (pagesInput) {
      pagesInput.addEventListener("input", calculatePrice);
    }
  
    calculatePrice();
  });