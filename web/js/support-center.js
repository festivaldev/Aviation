/*
    support-center.js
    FESTIVAL Aviation

    Provides methods and events for the support center

    @author Fabian Krahtz (f.krahtz@ostfalia.de)
    @version 1.0
*/

// Get all parameters (..?key=value&key2=value2...) from the URL
const ps = window.location.search.slice(1).split("&");

// Map parameters (key=value) to key/value pair objects
const params = ps.map(p => {
    if (!p.includes("=")) {
        return { k: p, v: "" };
    }

    return { k: p.split("=")[0], v: p.split("=")[1] };
});

// Remove all parameters where the key is empty
while (params.findIndex(p => p.k === "") > -1) {
    params.splice(params.findIndex(p => p.k === ""), 1);
}


// If params contains a "q" param (so the user wants to display a specific question)
if (params.some(p => p.k === "q")) {
    // Get the question id from the param, find the card and the link for this question
    const q = params.find(p => p.k === "q").v;
    const card = document.querySelector(`[data-q="${q}"]`);
    const link = document.querySelector(`[data-q-link="${q}"]`);

    // If the card exists, expand it
    if (card) {
        card.classList.add("expanded");
    }

    // If the link exists, select it
    if (link) {
        link.classList.add("selected");
    }
}

// Add a permalink to each question's answer
if (document.querySelectorAll(".faq-card[data-q]")) {
    document.querySelectorAll(".faq-card[data-q]").forEach(el => {
        const q = el.getAttribute("data-q");

        document.querySelector(`.faq-card[data-q="${q}"] .faq-card-content`).innerHTML += `<a href="${getURLForQuery(el.getAttribute("data-q"))}" class="permalink">Permalink zu dieser Frage</a>`;
    });
}

if (document.querySelector(".sc-menu.contents .heading")) {
    document.querySelector(".sc-menu.contents .heading").addEventListener("click", ev => {
        // Toggle the expand class (effectively open/close the menu when the header is clicked)
        ev.target.parentElement.classList.toggle("expanded");
    });
}

if (document.querySelectorAll(".sc-menu.contents a:not(.selected)")) {
    document.querySelectorAll(".sc-menu.contents a:not(.selected)").forEach(el => {
        el.addEventListener("click", ev => {
            ev.preventDefault();
            ev.stopPropagation();

            if (el.hasAttribute("data-q-link") && el.getAttribute("data-q-link")) {
                const q = el.getAttribute("data-q-link");

                // Navigate to the permalink effectively opening the question's card
                window.location.assign(getURLForQuery(q));
            }
        });
    });
}

if (document.querySelectorAll(".faq-card-header")) {
    document.querySelectorAll(".faq-card-header").forEach(el => {
        el.addEventListener("click", ev => {
            // Toggle the expand class (effectively open/close the card when the header is clicked)
            ev.target.parentElement.classList.toggle("expanded");

            if (document.querySelector(".sc-menu.contents a.selected")) {
                // Unselect the currently selected link in the sidebar
                document.querySelector(".sc-menu.contents a.selected").classList.remove("selected");
            }

            if (ev.target.parentElement.classList.contains("expanded")) {
                // If the card has been opened, add the selected class to link for this card
                document.querySelector(`[data-q-link="${ev.target.parentElement.getAttribute("data-q")}"]`).classList.add("selected");
            }
        });
    });
}

if (document.querySelectorAll(".editor .update")) {
    document.querySelectorAll(".editor .update").forEach(el => {
        el.addEventListener("click", ev => {
            // Get question data from the clicked element
            const id = el.getAttribute("data-q-id");
            const question = document.querySelector(`[data-q-question="${id}"]`).value;
            const answer = document.querySelector(`[data-q-answer="${id}"]`).value;

            // Prepare post request to update a question
            preparePost("sc-admin.jsp", { method: "update", id: id, question: question, answer: answer });
        });
    });
}

if (document.querySelectorAll(".editor .delete")) {
    document.querySelectorAll(".editor .delete").forEach(el => {
        el.addEventListener("click", ev => {
            // Get question data from the clicked element
            const id = el.getAttribute("data-q-id");

            // Prepare post request to delete a question
            preparePost("sc-admin.jsp", { method: "delete", id: id });
        });
    });
}

if (document.querySelectorAll(".editor .insert")) {
    document.querySelectorAll(".editor .insert").forEach(el => {
        el.addEventListener("click", ev => {
            // Get question data from the clicked element
            const id = document.getElementById("new-question-id").value;
            const question = document.getElementById("new-question-question").value;
            const answer = document.getElementById("new-question-answer").value;

            // Prepare post request to insert a question
            preparePost("sc-admin.jsp", { method: "insert", id: id, question: question, answer: answer });
        });
    });
}

// Returns the URL for the given question id
function getURLForQuery(query) {

    // Replace the value if already a "q" param is given in params otherwise insert a new one
    if (params.some(p => p.k === "q")) {
        params.find(p => p.k === "q").v = query;
    } else {
        params.push({ k: "q", v: query });
    }

    // Join all params to one param string
    const paramString = "?" + params.map(p => {
        if (p.v === "") {
            return p.k;
        }
        return `${p.k}=${p.v}`;
    }).join("&");

    if (window.location.search === "") {
        return window.location.href + paramString;
    } else {
        return window.location.href.replace(window.location.search, paramString);
    }
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
