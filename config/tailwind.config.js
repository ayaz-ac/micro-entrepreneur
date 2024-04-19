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
        logo: ['Lilita One', 'sans-serif'],
        display: ['Protest Strike', 'sans-serif'],
        body: ['Nunito Sans', 'sans-serif']
      },
      colors: {
        primary: '#006D77',
        secondary: '#3bbdc6',
        'brand-200': '#C3E0FA',
        'brand-950': '#14213D',
        gray: '#F3F4F6'
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
