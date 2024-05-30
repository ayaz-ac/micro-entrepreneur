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
        primary: '#006D77',
        secondary: '#3bbdc6',
        'brand-50': '#F0F7FE',
        'brand-100': '#DDEDFC',
        'brand-200': '#C3E0FA',
        'brand-300': '#99CDF7',
        'brand-400': '#69B2F1',
        'brand-500': '#4594EC',
        'brand-600': '#3076E0',
        'brand-700': '#2762CE',
        'brand-800': '#264FA7',
        'brand-900': '#244584',
        'brand-950': '#14213D',
        gray: '#F3F4F6',
        black: '#030712',
        'off-white': '#FAFAFA'
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
