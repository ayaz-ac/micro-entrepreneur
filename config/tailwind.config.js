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
        logo: ['Vina Sans', 'sans-serif'],
        display: ['Righteous', 'sans-serif'],
        body: ['Nunito Sans', 'sans-serif']
      },
      colors: {
        primary: '#7c3aed',
        secondary: '#7e22ce'
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
