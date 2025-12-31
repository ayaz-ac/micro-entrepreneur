const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
    './app/helpers/tailwind_builder.rb'
  ],
  theme: {
    extend: {
      fontFamily: {
        logo: ['Poppins', 'sans-serif'],
        display: ['Bricolage Grotesque', 'sans-serif'],
        body: ['Nunito Sans', 'sans-serif']
      },
      colors: {
        'brand-50': '#f3f5f9',
        'brand-100': '#e7ebf2',
        'brand-200': '#d1d8e4',
        'brand-300': '#a5b2c7',
        'brand-400': '#788aa8',
        'brand-500': '#556a8b',
        'brand-600': '#3e506f',
        'brand-700': '#2e3d57',
        'brand-800': '#263349',
        'brand-900': '#1c2739',
        'brand-950': '#121b29'
      },
      gridTemplateRows: {
        'fit-content': 'minmax(0, 1fr)'
      }
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ]
}
