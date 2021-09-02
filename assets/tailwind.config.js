const defaultTheme = require('tailwindcss/defaultTheme')
const plugin = require('tailwindcss/plugin')
const colors = require('tailwindcss/colors')

module.exports = {
  mode: 'jit',
  purge: [
    "./tailwindcss.whitelist.txt",
    "../**/*.html.eex",
    "../**/*.html.leex",
    "../**/*.html.heex",
    "../**/components/**/*.ex",
    "../**/views/**/*.ex",
    "../**/live/**/*.ex",
    "./js/**/*.js"
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      backgroundSize: {
       'full-auto': '100% auto',
       'auto-full': 'auto 100%',
       '150': '150%',
      },
      boxShadow: {
        'bl': '-1px 0 var(--outline)',
        'bx:blue:1': '1px 0 var(--blue-1), -1px 0 var(--blue-1)',
        'purple': '0 2px 8px hsla(253, 79%, 37%, .35)',
        'sm-purple': '0 1px 4px hsla(253, 79%, 37%, .15)',
      },
      colors: {
        cyan: colors.cyan,
        gray: colors.blueGray,
        emerald: colors.emerald,
        fuchsia: colors.fuchsia,
        navy: '#24185B',
        orange: colors.orange,
        purple: {
          50: '#FAF5FF',
          100: '#F6E7FF',
          200: '#EDD4FE',
          300: '#DFB2FC',
          400: '#CA7FF8',
          500: '#B54FF3',
          600: '#A02BE4',
          700: '#8919C9',
          800: '#731CA5',
          900: '#5D1985',
        },
        teal: colors.teal,
        violet: colors.violet,
      },
      container: {
        screens: {
           sm: '640px',
           md: '768px',
           lg: '1024px',
           xl: '1280px',
           '2xl': '1400px',
        }
      },
      filter: {
        'none': 'none',
        'shadow-purple': 'drop-shadow(0 2px 8px hsla(253, 79%, 37%, .35))',
      },
      gradients: {
        'blue-violet': [
          'var(--blue-1)',
          'var(--violet--1)',
        ],
        'cyan-blue': [
          'var(--cyan-1)',
          'var(--blue)',
        ],
      },
      gridTemplateColumns: {
        'auto-span': 'auto 1fr',
        'span-auto': '1fr auto',
        'auto-span-auto': 'auto 1fr auto',
        'span-auto-span': '1fr auto 1fr',
        'fill-24': `repeat(auto-fill, minmax(${defaultTheme.spacing[24]}, 1fr))`,
        'fill-32': `repeat(auto-fill, minmax(${defaultTheme.spacing[32]}, 1fr))`,
        'fill-40': `repeat(auto-fill, minmax(${defaultTheme.spacing[40]}, 1fr))`,
        'fill-48': `repeat(auto-fill, minmax(${defaultTheme.spacing[48]}, 1fr))`,
        'fill-56': `repeat(auto-fill, minmax(${defaultTheme.spacing[56]}, 1fr))`,
        'fill-64': `repeat(auto-fill, minmax(${defaultTheme.spacing[64]}, 1fr))`,
        'fill-80': `repeat(auto-fill, minmax(${defaultTheme.spacing[80]}, 1fr))`,
        'fill-96': `repeat(auto-fill, minmax(${defaultTheme.spacing[96]}, 1fr))`,
        'fit-24': `repeat(auto-fit, minmax(${defaultTheme.spacing[24]}, 1fr))`,
        'fit-32': `repeat(auto-fit, minmax(${defaultTheme.spacing[32]}, 1fr))`,
        'fit-40': `repeat(auto-fit, minmax(${defaultTheme.spacing[40]}, 1fr))`,
        'fit-48': `repeat(auto-fit, minmax(${defaultTheme.spacing[48]}, 1fr))`,
        'fit-56': `repeat(auto-fit, minmax(${defaultTheme.spacing[56]}, 1fr))`,
        'fit-64': `repeat(auto-fit, minmax(${defaultTheme.spacing[64]}, 1fr))`,
        'fit-80': `repeat(auto-fit, minmax(${defaultTheme.spacing[80]}, 1fr))`,
        'fit-96': `repeat(auto-fit, minmax(${defaultTheme.spacing[96]}, 1fr))`,
      },
      gridTemplateRows: {
        'auto-span': 'auto 1fr',
        'span-auto': '1fr auto',
        'auto-span-auto': 'auto 1fr auto',
        'span-auto-span': '1fr auto 1fr',
      },
      fontFamily: {
        sans: [
          'Inter',
          ...defaultTheme.fontFamily.sans
        ],
        mono: [
          'Roboto Mono',
          ...defaultTheme.fontFamily.mono
        ],
        serif: [
          'Mackinac',
          ...defaultTheme.fontFamily.serif
        ],
      },
      fontSize: {
        '4.5xl': ['2.5rem', { lineHeight: '1.25' }],
        '5.5xl': ['3.35rem', { lineHeight: '1.25' }],
      },
      minHeight: {
        '20': defaultTheme.spacing[20],
        '24': defaultTheme.spacing[20],
        '32': defaultTheme.spacing[32],
      },
      textShadow: {
        'purple': '0 2px 8px hsla(253, 79%, 37%, .35)',
      },
      translate: {
        label: '-1.4rem',
      },
      underlineOffset: {
        'sm': '0.05em',
      },
      underlineThickness: {
        '1': '1px',
        '2': '2px',
      },
      zIndex: {
        "-1": "-1",
      },
    },
  },
  variants: {
    backgroundBlendMode: ['responsive'],
    backgroundColor: ['responsive', 'active', 'hover', 'focus', 'focus-within'],
    isolation: ['responsive'],
    mixBlendMode: ['responsive'],
    position: ['responsive', 'focus'],
    ringWidth: ['hover', 'active', 'focus-within'],
    scale: ['responsive', 'active', 'hover', 'focus', 'group-hover'],
    translate: ['responsive', 'hover', 'focus', 'group-hover'],
  },
  plugins: [
    require('tailwindcss-blend-mode')(),
    require('tailwindcss-filters'),
    require('@tailwindcss/forms'),
    require('@tailwindcss/line-clamp'),
    require('tailwindcss-textshadow'),
    require('tailwind-underline-utils'),
    plugin(function({ addComponents, theme }) {
      const cards = {
        '.card': {
          'border-radius': theme('borderRadius.default'),
          'background-color': '#FFF',
          'box-shadow': theme('boxShadow.default'),
        }
      }

      const wordSpacing = {
        '.word-spacing-wide': {
          'word-spacing': '0.025em',
        }
      }

      addComponents([ cards, wordSpacing ])
    }),
  ],
}