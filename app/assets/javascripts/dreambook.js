"use strict";

const Dreambook = {
    initialized: false,
    components: {},
    autoInitComponents: true
};

Dreambook.components.pendingPatternEnqueue = {
    initialized: false,
    selector: ".js-pattern-queue-container",
    container: undefined,
    textarea: undefined,
    button: undefined,
    init: function () {
        this.container = document.querySelector(this.selector);
        if (this.container) {
            this.initialized = true;
            this.textarea = this.container.querySelector("textarea");
            this.button = this.container.querySelector("button");
            const component = this;
            this.button.addEventListener("click", component.handler);
        }
    },
    handler: function () {
        const component = Dreambook.components.pendingPatternEnqueue;
        const url = component.container.getAttribute("data-url");
        const request = Biovision.jsonAjaxRequest("post", url, function () {
            component.textarea.value = "";
            component.button.disabled = false;
        });
        component.button.disabled = true;
        request.send(JSON.stringify({list: component.textarea.value}));
    }
};

Dreambook.components.pendingPatternSummary = {
    initialized: false,
    selector: ".js-pending-pattern-summary",
    items: [],
    init: function () {
        document.querySelectorAll(this.selector).forEach(this.apply);
        this.initialized = true;
    },
    apply: (element) => {
        const component = Dreambook.components.pendingPatternSummary;
        component.items.push(element);
        element.addEventListener("change", component.handler);
    },
    handler: function (event) {
        const input = event.target;
        if (input.value.length > 0) {
            const state = input.parentNode.querySelector(".state");
            const url = input.getAttribute("data-url");
            const request = Biovision.jsonAjaxRequest("post", url, function () {
                const response = JSON.parse(this.responseText);
                if (response.hasOwnProperty("meta")) {
                    if (response.meta["processed"]) {
                        const container = input.closest(".info");
                        if (container) {
                            container.innerHTML = input.value;
                        }
                    }
                }
            }, function () {
                state.classList.remove("processing");
                state.classList.add("failed");
            });
            input.readonly = true;

            if (!state.classList.contains("processing")) {
                request.send(JSON.stringify({summary: input.value}));
            }
        }
    }
};

/**
 * Quickly add links between words and patterns
 *
 * @type {Object}
 */
Dreambook.components.wordPatternString = {
    initialized: false,
    selector: ".js-word-pattern-string",
    elements: [],
    init: function () {
        document.querySelectorAll(this.selector).forEach(this.apply);
        this.initialized = true;
    },
    apply: (element) => {
        const component = Dreambook.components.wordPatternString;
        component.elements.push(element);
        element.addEventListener("change", component.handler);
        if (!element.hasAttribute("autocomplete")) {
            element.setAttribute("autocomplete", "off");
        }
    },
    handler: function (event) {
        const input = event.target;
        const url = input.getAttribute("data-url");
        const state = input.parentNode.querySelector(".state");
        const request = Biovision.jsonAjaxRequest("put", url, function () {
            state.classList.remove("processing");
            state.classList.remove("failed");
            state.classList.add("processed");
        }, function () {
            state.classList.remove("processing");
            state.classList.add("failed");
        });

        if (!state.classList.contains("processing")) {
            const data = {"string": input.value};

            state.classList.add("processing");
            request.send(JSON.stringify(data));
        }
    }
};

Biovision.components.dreambook = Dreambook;
