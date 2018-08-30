/*
    checkout.js
    FESTIVAL Aviation
    
    Provides events to update the credit card when the user inputs data
    
    @author Fabian Krahtz (f.krahtz@ostfalia.de)
    @version 1.0
*/

let lastExpirationLength = 0;

document.querySelectorAll("form input").forEach(el => {
    el.addEventListener("input", ev => {
        if (el.hasAttribute("data-corresponds")) {
            const c = el.getAttribute("data-corresponds");

            switch (c) {
                case "holder":
                    // Set holder on card to input from the holder field
                    
                    document.getElementById("card-holder").innerText = el.value;
                    break;
                case "number":
                    // Set number on card to input from the number field
                    
                    // Add a space " " after each block of 4 numbers
                    el.value = el.value.replace(/[^\d]/g, "").replace(/(.{4})/g, "$1 ").trim();
                    
                    const numbers = el.value.split(" ");
                    for (let i = 0; i < 4; i++) {
                        if (numbers[i]) {
                            // Fill remaining digits in block with •
                            document.querySelectorAll(".card .number span")[i].innerText = numbers[i].substr(0, 4) + "•".repeat(4 - numbers[i].substr(0, 4).length);
                        } else {
                            // Fill whole block with 4 •
                            document.querySelectorAll(".card .number span")[i].innerText = "••••";
                        }
                    }
                    
                    break;
                case "expiration":
                    // Set expiration on card to input from the expiration field
                    
                    document.getElementById("card-expiration").innerText = el.value;
                    
                    // Add "/" after 2 characters, but only if the length is longer than before (so the user isn't deleting)
                    // Otherwise the user would not be able to delete the "/"
                    if (el.value.length > lastExpirationLength && el.value.length == 2) {
                        el.value += "/";
                    }
                    
                    lastExpirationLength = el.value.length;
                    break;
            }
        }
    });
});

// Hide button and show loading indicator after pay button is clicked
document.getElementById("modal-primary").addEventListener("click", ev => {
    document.querySelector("form button").classList.add("hidden");
    document.querySelector(".sk-folding-cube").classList.add("shown");
});
