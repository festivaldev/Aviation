/*
    modal.js
    FESTIVAL Aviation

    Provides methods and events for modals

    @author Fabian Krahtz (f.krahtz@ostfalia.de)
    @version 1.0
*/

const triggers = document.querySelectorAll(".modal-trigger");
const modal = document.querySelector(".modal");
const modalTitleBar = document.getElementById("modal-title-bar");
const modalTitle = document.getElementById("modal-title");
const modalText = document.getElementById("modal-text");
const modalPrimary = document.getElementById("modal-primary");
const modalClose = document.getElementById("modal-close");

// Triggers are all elements marked with "modal-trigger" that should trigger a modal
if (triggers) {
    triggers.forEach(el => {
        el.addEventListener("click", ev => {
            ev.preventDefault();

            if (document.querySelector(".modal")) {
                // Make sure no styles from the last opening remain
                modal.classList.remove("error", "info", "question", "success", "warning");
                
                if (el.hasAttribute("data-modal-type")) {
                    // Set type if given
                    modal.classList.add(el.getAttribute("data-modal-type"));
                }

                if (el.hasAttribute("data-modal-title")) {
                    // Set title if given
                    modalTitle.style.visibility = "visible";
                    modalTitle.innerText = el.getAttribute("data-modal-title");
                } else {
                    // Hide title if not
                    modalTitle.style.visibility = "hidden";
                }
            
                // Hide title bar if neither type nor title given
                modalTitleBar.hidden = !el.hasAttribute("data-modal-type") && !el.hasAttribute("data-modal-title");
            
                if (el.hasAttribute("data-modal-primary") && el.hasAttribute("data-modal-primary-action")) {
                    // If text for the primary button is given and an action is set show the button and set the text
                    
                    modalPrimary.style.visibility = "visible";
                    modalPrimary.innerText = el.getAttribute("data-modal-primary");

                    // Store the action on the modal for future reference
                    modal.setAttribute("data-primary-action", el.getAttribute("data-modal-primary-action"));
                    
                    if (el.hasAttribute("data-modal-primary-action-target")) {
                        // If a target is set, store the target on the modal as well for future reference
                        modal.setAttribute("data-primary-action-target", el.getAttribute("data-modal-primary-action-target"));
                    }

                    if (el.hasAttribute("data-modal-primary-action-timeout")) {
                        // If a timeout is set, store it also on the modal for future reference
                        modal.setAttribute("data-primary-action-timeout", el.getAttribute("data-modal-primary-action-timeout"));
                    }
                } else {
                    // If no text or action is set for the primary button, hide it
                    modalPrimary.style.visibility = "hidden";
                }

                if (el.hasAttribute("data-modal-secondary")) {
                    // If an alternative secondary text is set, set it
                    modalClose.innerText = el.getAttribute("data-modal-secondary");
                } else {
                    // Otherwise keep the default
                    modalClose.innerText = "Schließen";
                }

                if (el.hasAttribute("data-modal-text")) {
                    // Set modal text if given
                    modalText.innerText = el.getAttribute("data-modal-text");
                }
                
                // Finally open the modal
                document.body.classList.add("modal-open");
            } else {
                if (el.hasAttribute("data-modal-text")) {
                    // If text for the modal is set but the DOM doesn't contain a modal, fallback to an alert()
                    
                    alert(el.getAttribute("data-modal-text"));
                }
            }
        });
    });
}

// This is the primary button of the modal
if (modalPrimary) {
    modalPrimary.addEventListener("click", ev => {
        ev.preventDefault();
        
        // Close the modal
        document.body.classList.remove("modal-open");

        let timeout = 0;
        if (modal.hasAttribute("data-primary-action-timeout")) {
            // If there is a timeout stored on the modal, set it here
            timeout = modal.getAttribute("data-primary-action-timeout");
        }

        setTimeout(() => {
            switch (modal.getAttribute("data-primary-action")) {
                case "submit": {
                    // If the primary action is "submit"
                    
                    if (!modal.hasAttribute("data-primary-action-target")) {
                        // If no target is set, we just submit the first form we can find
                        document.querySelector("form").submit();
                    } else {
                        // Otherwise we submit the form specified by the target attribute
                        document.querySelector(modal.getAttribute("data-primary-action-target")).submit();
                    }
                    break;
                }
            }
        }, timeout);
    });
}

// This is the secondary button
if (modalClose) {
    modalClose.addEventListener("click", ev => {
        ev.preventDefault();
        
        // Close the modal
        document.body.classList.remove("modal-open");
    });
}
