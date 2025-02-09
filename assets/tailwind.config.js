// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin")
const fs = require("fs")
const path = require("path")

module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/landing_page_web.ex",
    "../lib/landing_page_web/**/*.*ex"
  ],
  theme: {
    // ajouter des variables supplementaires / customisées de tailwind
    extend: {
      fontFamily: {
        display: ['Satoshi', 'sans-serif'],
      },
      screens: {
        '3xl': '1920px',
      },
      colors: {
        avocado: {
          100: 'oklch(0.99 0 0)',
          200: 'oklch(0.98 0.04 113.22)',
          300: 'oklch(0.94 0.11 115.03)',
          400: 'oklch(0.92 0.19 114.08)',
          500: 'oklch(0.84 0.18 117.33)',
          600: 'oklch(0.53 0.12 118.34)',
        },
        green_primary: '#8DE2B0',
        green_secondary: '#57EF96',
        green_logo: '#1AAC57',
        grey_light: '#F5F5F5',
        grey_primary: '#D9D9D9',
      },
      transitionTimingFunction: {
        fluid: 'cubic-bezier(0.3, 0, 0, 1)',
        snappy: 'cubic-bezier(0.2, 0, 0, 1)',
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    // Allows prefixing tailwind classes with LiveView classes to add rules
    // only when LiveView classes are applied, for example:
    //
    //     <div class="phx-click-loading:animate-ping">
    //
    plugin(({addVariant}) => addVariant("phx-click-loading", [".phx-click-loading&", ".phx-click-loading &"])),
    plugin(({addVariant}) => addVariant("phx-submit-loading", [".phx-submit-loading&", ".phx-submit-loading &"])),
    plugin(({addVariant}) => addVariant("phx-change-loading", [".phx-change-loading&", ".phx-change-loading &"])),

    // Embeds Heroicons (https://heroicons.com) into your app.css bundle
    // See your `CoreComponents.icon/1` for more information.
    //
    plugin(function({matchComponents, theme}) {
      let iconsDir = path.join(__dirname, "../deps/heroicons/optimized")
      let values = {}
      let icons = [
        ["", "/24/outline"],
        ["-solid", "/24/solid"],
        ["-mini", "/20/solid"],
        ["-micro", "/16/solid"]
      ]
      icons.forEach(([suffix, dir]) => {
        fs.readdirSync(path.join(iconsDir, dir)).forEach(file => {
          let name = path.basename(file, ".svg") + suffix
          values[name] = {name, fullPath: path.join(iconsDir, dir, file)}
        })
      })
      matchComponents({
        "hero": ({name, fullPath}) => {
          let content = fs.readFileSync(fullPath).toString().replace(/\r?\n|\r/g, "")
          let size = theme("spacing.6")
          if (name.endsWith("-mini")) {
            size = theme("spacing.5")
          } else if (name.endsWith("-micro")) {
            size = theme("spacing.4")
          }
          return {
            [`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
            "-webkit-mask": `var(--hero-${name})`,
            "mask": `var(--hero-${name})`,
            "mask-repeat": "no-repeat",
            "background-color": "currentColor",
            "vertical-align": "middle",
            "display": "inline-block",
            "width": size,
            "height": size
          }
        }
      }, {values})
    })
  ]
}
