# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Glossaries', type: :request do
  describe 'POST /glossaries' do
    it 'create glossary' do
      post '/glossaries', params: { source_language_code: 'en', target_language_code: 'nl' }
      expect(response).to have_http_status(200)
      expect(json_body.keys).to match_array(%w[id source_language_code target_language_code])
      expect(json_body).to include('source_language_code' => 'en', 'target_language_code' => 'nl')
    end

    context 'fail' do
      let!(:nl_en_glossary) { create(:glossary, :en_nl) }

      it 'check uniqueness' do
        post '/glossaries', params: { source_language_code: 'en', target_language_code: 'nl' }
        expect(response).to have_http_status(422)
        expect(json_body['errors']).to eq(['Glossary is not unique'])
      end

      it 'must have valid codes' do
        post '/glossaries', params: { source_language_code: 'en', target_language_code: 'invalid' }
        expect(response).to have_http_status(422)
        expect(json_body['errors']).to eq(['Source or Target code must be valid'])
      end
    end
  end

  describe 'GET /glossaries' do
    let!(:glossary) { create(:glossary) }
    let!(:glossary2) { create(:glossary) }

    it 'return list of glossaries' do
      get '/glossaries'
      expect(json_body.size).to eq(2)
      expect(json_body.map { |j| j['id'] }).to match_array([glossary.id, glossary2.id])
    end
  end

  describe 'GET /glossaries/:id' do
    let!(:glossary) { create(:glossary) }

    it 'return glossary' do
      get "/glossaries/#{glossary.id}"
      expect(json_body['id']).to eq(glossary.id)
    end
  end
end
