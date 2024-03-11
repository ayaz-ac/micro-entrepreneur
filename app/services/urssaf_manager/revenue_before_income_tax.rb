# frozen_string_literal: true

require 'httparty'

module UrssafManager
  class RevenueBeforeIncomeTax < ApplicationService
    include HTTParty

    API_URL = 'https://mon-entreprise.urssaf.fr/api/v1'

    attr_reader :revenue

    def initialize(revenue) # rubocop:disable Lint/MissingSuper
      @revenue = revenue
    end

    def call
      endpoint = '/evaluate'
      headers = {
        'Content-Type' => 'application/json'
      }

      response = HTTParty.post(API_URL + endpoint, body: request_body(revenue:).to_json, headers:, verify: false)

      unless response.success?
        raise "Erreur lors de retrieve_revenue_before_tax: #{response.code} - #{response.message}"
      end

      json_response = JSON.parse(response.body)
      json_response.dig('evaluate', 0, 'nodeValue')
    end

    private

    def request_body(revenue:) # rubocop:disable Metrics/MethodLength
      {
        situation: {
          'établissement . commune . département': "'Paris'",
          'entreprise . date de création': '10/02/2021',
          'entreprise . activité . nature': "'libérale'",
          'entreprise . activité . nature . libérale . réglementée': 'non',
          "dirigeant . auto-entrepreneur . chiffre d'affaires": revenue,
          'entreprise . catégorie juridique': "'EI'",
          'entreprise . catégorie juridique . EI . auto-entrepreneur': 'oui',
          'entreprise . activités . revenus mixtes': 'non',
          'établissement . commune . département . outre-mer': 'non'
        },
        expressions: [
          'dirigeant . rémunération . net'
        ]
      }
    end
  end
end
