// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin")
const fs = require("fs")
const path = require("path")

module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/pokequiz_web.ex",
    "../lib/pokequiz_web/**/*.*ex"
  ],
    darkMode: 'class',
  theme: {
    extend: {
      colors: {
          brand: "#e16bf8",
          'indian_red': { DEFAULT: '#db5461', 100: '#320b0e', 200: '#63151d', 300: '#95202b', 400: '#c72a3a', 500: '#db5461', 600: '#e27580', 700: '#e997a0', 800: '#f0babf', 900: '#f8dcdf' },
          'asparagus': { DEFAULT: '#679436', 100: '#151e0b', 200: '#293c16', 300: '#3e5a20', 400: '#53782b', 500: '#679436', 600: '#87be4b', 700: '#a5ce78', 800: '#c3dfa5', 900: '#e1efd2' },
          'mauve': { DEFAULT: '#f2befc', 100: '#470455', 200: '#8f08a9', 300: '#cf16f4', 400: '#e16bf8', 500: '#f2befc', 600: '#f5ccfd', 700: '#f7d9fd', 800: '#fae6fe', 900: '#fcf2fe' },
          'gunmetal': { DEFAULT: '#30343f', 100: '#0a0a0d', 200: '#13151a', 300: '#1d1f26', 400: '#272a33', 500: '#30343f', 600: '#525a6d', 700: '#778098', 800: '#a4aabb', 900: '#d2d5dd' },
          'eerie_black': { DEFAULT: '#1b2021', 100: '#060707', 200: '#0b0d0d', 300: '#111414', 400: '#161a1b', 500: '#1b2021', 600: '#445153', 700: '#6c8084', 800: '#9cabae', 900: '#ced5d7' } 
      },
      animation: {
        'infinite-scroll': 'infinite-scroll 25s linear infinite',
      },
      keyframes: {
        'infinite-scroll': {
          from: { transform: 'translateY(0)' },
          to: { transform: 'translateY(-100%)' },
        },
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
    // plugin(function({matchComponents, theme}) {
    //   let iconsDir = path.join(__dirname, "../deps/heroicons/optimized")
    //   let values = {}
    //   let icons = [
    //     ["", "/24/outline"],
    //     ["-solid", "/24/solid"],
    //     ["-mini", "/20/solid"],
    //     ["-micro", "/16/solid"]
    //   ]
    //   icons.forEach(([suffix, dir]) => {
    //     fs.readdirSync(path.join(iconsDir, dir)).forEach(file => {
    //       let name = path.basename(file, ".svg") + suffix
    //       values[name] = {name, fullPath: path.join(iconsDir, dir, file)}
    //     })
    //   })
    //   matchComponents({
    //     "hero": ({name, fullPath}) => {
    //       let content = fs.readFileSync(fullPath).toString().replace(/\r?\n|\r/g, "")
    //       let size = theme("spacing.6")
    //       if (name.endsWith("-mini")) {
    //         size = theme("spacing.5")
    //       } else if (name.endsWith("-micro")) {
    //         size = theme("spacing.4")
    //       }
    //       return {
    //         [`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
    //         "-webkit-mask": `var(--hero-${name})`,
    //         "mask": `var(--hero-${name})`,
    //         "mask-repeat": "no-repeat",
    //         "background-color": "currentColor",
    //         "vertical-align": "middle",
    //         "display": "inline-block",
    //         "width": size,
    //         "height": size
    //       }
    //     }
    //   }, {values})
    // })
  ]
}
