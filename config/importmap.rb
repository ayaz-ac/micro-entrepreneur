# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'application', preload: true
pin '@hotwired/turbo-rails', to: 'turbo.min.js', preload: true
pin '@hotwired/stimulus', to: 'stimulus.min.js' # @3.2.2
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: true
pin_all_from 'app/javascript/controllers', under: 'controllers'
pin '@stimulus-components/chartjs', to: '@stimulus-components--chartjs.js' # @6.0.1
pin 'chart.js', to: 'https://cdn.jsdelivr.net/npm/chart.js@4.5.1/dist/chart.js' # @4.5.1
pin '@kurkle/color', to: 'https://cdn.jsdelivr.net/npm/@kurkle/color@0.3.4/dist/color.esm.js' # @0.3.4
