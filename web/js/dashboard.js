/*
    dashboard.js
    FESTIVAL Aviation
    
    Provides methods to prepare cancellation requests on the dashboard
    
    @author Fabian Krahtz (f.krahtz@ostfalia.de)
    @version 1.0
*/

if (document.querySelectorAll(".cancel")) {
    document.querySelectorAll(".cancel").forEach(el => {
        el.addEventListener("click", ev => {
            // Get booking data from the clicked element
            const bookingId = el.getAttribute("data-b-id");
            const holder = el.getAttribute("data-b-holder");
            const svid = el.getAttribute("data-b-svid");
            const email = el.getAttribute("data-b-email");

            // Prepare post request to cancel a booking
            preparePost("sc-cancellations.jsp", { bookingId: bookingId, holder: holder, svid: svid, email: email, message: "Storniert durch Dashboard" });
        });
    });
}

// Used to create a hidden form which could then be triggered by a modal primary action
function preparePost(path, params) {
    let form;

    // Reset existing or create new hidden form
    if (document.getElementById("hidden-form")) {
        form = document.getElementById("hidden-form");
        form.innerHTML = "";
    } else {
        form = document.createElement("form");
        form.setAttribute("id", "hidden-form");
        document.body.appendChild(form);
    }

    form.setAttribute("method", "POST");
    form.setAttribute("action", path);

    // Create an input field for each key/value pair in the params add it to the hidden form
    for(var key in params) {
        if(params.hasOwnProperty(key)) {
            var hiddenField = document.createElement("input");
            hiddenField.setAttribute("type", "hidden");
            hiddenField.setAttribute("name", key);
            hiddenField.setAttribute("value", params[key]);

            form.appendChild(hiddenField);
        }
    }
}
