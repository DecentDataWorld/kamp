export default class Iconpicker
{
    constructor(el, options) {
        this.el = el
        this.options = options

        const {
            hideOnSelect = true,
            selectedClass = 'selected',
            defaultValue = '',
            icons = [
              "bi-123",
              "bi-activity",
              "bi-airplane",
              "bi-alarm",
              "bi-alt",
              "bi-app",
              "bi-app-indicator",
              "bi-archive",
              "bi-arrow-clockwise",
              "bi-arrow-counterclockwise",
              "bi-arrow-down",
              "bi-arrow-down-up",
              "bi-arrow-left",
              "bi-arrow-left-right",
              "bi-arrow-repeat",
              "bi-arrow-return-left",
              "bi-arrow-return-right",
              "bi-arrow-right",
              "bi-arrows-angle-contract",
              "bi-arrows-angle-expand",
              "bi-arrows-collapse",
              "bi-arrows-expand",
              "bi-arrows-fullscreen",
              "bi-arrows-move",
              "bi-aspect-ratio",
              "bi-back",
              "bi-backspace",
              "bi-bag",
              "bi-balloon",
              "bi-bandaid",
              "bi-bank",
              "bi-bar-chart",
              "bi-basket",
              "bi-battery",
              "bi-battery-charging",
              "bi-bell",
              "bi-bell-slash",
              "bi-bezier",
              "bi-bicycle",
              "bi-binoculars",
              "bi-body-text",
              "bi-book",
              "bi-bookmark",
              "bi-bookshelf",
              "bi-boombox",
              "bi-border",
              "bi-box",
              "bi-boxes",
              "bi-braces",
              "bi-bricks",
              "bi-briefcase",
              "bi-brightness-high",
              "bi-brightness-low",
              "bi-broadcast",
              "bi-broadcast-pin",
              "bi-brush",
              "bi-bucket",
              "bi-bug",
              "bi-building",
              "bi-buildings",
              "bi-bullseye",
              "bi-bus-front",
              "bi-calculator",
              "bi-calendar",
              "bi-calendar-event",
              "bi-calendar3",
              "bi-camera",
              "bi-camera-reels",
              "bi-capslock",
              "bi-capsule",
              "bi-car-front",
              "bi-card-checklist",
              "bi-card-image",
              "bi-card-text",
              "bi-cart",
              "bi-cash",
              "bi-cash-coin",
              "bi-cassette",
              "bi-chat",
              "bi-check",
              "bi-check-circle",
              "bi-check-all",
              "bi-check2-square",
              "bi-circle",
              "bi-clipboard",
              "bi-clock",
              "bi-cloud",
              "bi-cloud-download",
              "bi-cloud-drizzle",
              "bi-cloud-lightning",
              "bi-cloud-sun",
              "bi-cloud-upload",
              "bi-clouds",
              "bi-code",
              "bi-collection",
              "bi-compass",
              "bi-cone",
              "bi-credit-card",
              "bi-crop",
              "bi-cup",
              "bi-cursor",
              "bi-dash-circle",
              "bi-database",
              "bi-diagram-3",
              "bi-diamond",
              "bi-dice-5",
              "bi-disc",
              "bi-display",
              "bi-door-closed",
              "bi-door-open",
              "bi-download",
              "bi-droplet",
              "bi-ear",
              "bi-egg",
              "bi-egg-fried",
              "bi-eject",
              "bi-envelope",
              "bi-envelope-open",
              "bi-envelope-paper",
              "bi-eraser",
              "bi-ev-front",
              "bi-ethernet",
              "bi-exclamation-circle",
              "bi-exclamation-triangle",
              "bi-eye",
              "bi-eye-slash",
              "bi-eyedropper",
              "bi-eyeglasses",
              "bi-fast-forward",
              "bi-file",
              "bi-file-bar-graph",
              "bi-file-earmark",
              "bi-files",
              "bi-film",
              "bi-filter",
              "bi-fingerprint",
              "bi-fire",
              "bi-flag",
              "bi-flower1",
              "bi-folder",
              "bi-folder2-open",
              "bi-forward",
              "bi-front",
              "bi-fuel-pump",
              "bi-funnel",
              "bi-gear",
              "bi-gem",
              "bi-gender-ambiguous",
              "bi-gender-female",
              "bi-gender-male",
              "bi-geo",
              "bi-geo-alt",
              "bi-gift",
              "bi-globe",
              "bi-graph-down",
              "bi-graph-up",
              "bi-grid",
              "bi-hammer",
              "bi-hand-index",
              "bi-hand-thumbs-down",
              "bi-hand-thumbs-up",
              "bi-handbag",
              "bi-headphones",
              "bi-heart",
              "bi-heart-pulse",
              "bi-hospital",
              "bi-hourglass",
              "bi-house",
              "bi-houses",
              "bi-hurricane",
              "bi-image",
              "bi-images",
              "bi-inbox",
              "bi-incognito",
              "bi-infinity",
              "bi-info-circle",
              "bi-intersect",
              "bi-joystick",
              "bi-key",
              "bi-keyboard",
              "bi-lamp",
              "bi-laptop",
              "bi-layers",
              "bi-life-preserver",
              "bi-lightbulb",
              "bi-lightning",
              "bi-link",
              "bi-list",
              "bi-list-check",
              "bi-lock",
              "bi-lungs",
              "bi-magic",
              "bi-magnet",
              "bi-mailbox",
              "bi-map",
              "bi-megaphone",
              "bi-mic",
              "bi-mic-mute",
              "bi-minecart",
              "bi-moisture",
              "bi-moon",
              "bi-moon-stars",
              "bi-mortarboard",
              "bi-mouse",
              "bi-music-note",
              "bi-newspaper",
              "bi-nut",
              "bi-option",
              "bi-outlet",
              "bi-p-circle",
              "bi-paint-bucket",
              "bi-palette",
              "bi-paperclip",
              "bi-pass",
              "bi-pause-circle",
              "bi-pc-display",
              "bi-peace",
              "bi-pen",
              "bi-pencil",
              "bi-people",
              "bi-person",
              "bi-person-add",
              "bi-phone",
              "bi-pie-chart",
              "bi-piggy-bank",
              "bi-pin",
              "bi-pin-map",
              "bi-play-circle",
              "bi-plug",
              "bi-postage",
              "bi-postcard",
              "bi-power",
              "bi-prescription",
              "bi-printer",
              "bi-puzzle",
              "bi-question-circle",
              "bi-quote",
              "bi-radioactive",
              "bi-rainbow",
              "bi-reception-4",
              "bi-record-circle",
              "bi-recycle",
              "bi-repeat",
              "bi-reply",
              "bi-reply-all",
              "bi-rewind",
              "bi-robot",
              "bi-rocket",
              "bi-router",
              "bi-rulers",
              "bi-safe",
              "bi-save",
              "bi-scissors",
              "bi-scooter",
              "bi-screwdriver",
              "bi-search",
              "bi-send",
              "bi-server",
              "bi-share",
              "bi-shield",
              "bi-shift",
              "bi-shop",
              "bi-shuffle",
              "bi-sign-stop",
              "bi-signpost",
              "bi-signpost-2",
              "bi-sliders",
              "bi-smartwatch",
              "bi-snow",
              "bi-speaker",
              "bi-speedometer",
              "bi-stack",
              "bi-star",
              "bi-stars",
              "bi-stickies",
              "bi-stop-circle",
              "bi-stoplights",
              "bi-stopwatch",
              "bi-sun",
              "bi-sunglasses",
              "bi-sunrise",
              "bi-sunset",
              "bi-table",
              "bi-tablet",
              "bi-tag",
              "bi-tags",
              "bi-taxi-front",
              "bi-telephone",
              "bi-terminal",
              "bi-thermometer",
              "bi-ticket",
              "bi-toggle-off",
              "bi-toggle-on",
              "bi-toggles",
              "bi-tools",
              "bi-tornado",
              "bi-train-front",
              "bi-translate",
              "bi-trash",
              "bi-tree",
              "bi-trophy",
              "bi-tropical-storm",
              "bi-truck",
              "bi-truck-front",
              "bi-tsunami",
              "bi-tv",
              "bi-type",
              "bi-umbrella",
              "bi-unity",
              "bi-universal-access",
              "bi-unlock",
              "bi-upload",
              "bi-usb-drive",
              "bi-voicemail",
              "bi-volume-down",
              "bi-volume-mute",
              "bi-volume-up",
              "bi-wallet",
              "bi-watch",
              "bi-water",
              "bi-wifi",
              "bi-wind",
              "bi-wrench",
              "bi-yin-yang",
              "bi-zoom-in",
              "bi-zoom-out"
            ],
            searchable = true,
            containerClass = '',
            showSelectedIn = null
        } = options
        this.valueFormat = val => val

        this.el.insertAdjacentHTML('afterend', `
            <div class="iconpicker-dropdown ${containerClass}">
                <ul>
                    ${icons.map(icon => `<li value="${this.valueFormat(icon)}" class="${defaultValue === icon ? selectedClass : ''}"><i class="${this.valueFormat(icon)}"></i></li>`).join('')}
                </ul>
            </div>
        `)

        this.el.nextElementSibling.querySelectorAll('li').forEach(item => item.addEventListener('click', e => {
            this.el.nextElementSibling.querySelector('li.selected')?.classList.remove(selectedClass)
            item.classList.add(selectedClass)
            const value = item.getAttribute('value')
            this.el.value = value

            if(hideOnSelect){
                this.el.nextElementSibling.classList.remove('show')
            }

            if (showSelectedIn){
                this.options.showSelectedIn.innerHTML = `<i class="${value}"></i>`
            }
        }))

        if (searchable){
            this.el.addEventListener('keyup', this.search)
        }

        this.el.addEventListener('focusin', this.focusIn)
        this.el.addEventListener('change', this.setIconOnChange)

        this.el.value = this.valueFormat(defaultValue)
        this.el.dispatchEvent(new Event('change'))
    }

    /**
     * Use input as a search box
     */
    search() {
        const items = this.nextElementSibling.getElementsByTagName('li')
        const pattern = new RegExp(this.value, 'i');

        for (let i=0; i < items.length; i++) {
            const item = items[i];
            if (pattern.test(item.getAttribute('value'))) {
                item.classList.remove("hidden");
            } else {
                item.classList.add("hidden");
            }
        }
    }

    /**
     * if showSelectedIn argument passed show icon in that element
     */
    setIconOnChange = () => {
        if (this.options?.showSelectedIn){
            this.options.showSelectedIn.innerHTML = `<i class="${this.el.value}"></i>`
        }
    }

    /**
     * Focus event for given input element
     */
    focusIn = () => {
        if(this.el.nextElementSibling?.classList?.contains('iconpicker-dropdown')){
            this.el.nextElementSibling.querySelector('ul').style.top = this.el.offsetHeight + 'px'
            this.el.nextElementSibling.style.transition = '0.25s ease-in-out';
            this.el.nextElementSibling.classList.add('show')
        }
    }
    
    set = (setValue = '') => this.el.value = this.valueFormat(setValue)
}

window.Iconpicker = Iconpicker

/**
 * Close iconpicker on click outside
 */
document.addEventListener('click', e => {
    document.querySelectorAll('.iconpicker-dropdown').forEach(dw => {
        const isClickInside = dw.contains(e.target) || dw.previousElementSibling.contains(e.target)

        if (!isClickInside) {
            dw.classList.remove('show')
        }
    })
});