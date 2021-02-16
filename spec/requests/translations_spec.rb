# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Translations', type: :request do
  describe 'POST /translations' do
    let!(:glossary) { create(:glossary, source_language_code: 'en', target_language_code: 'nl') }
    let(:endpoint) { '/translations' }

    it 'success' do
      post endpoint, params: {
        source_language_code: 'en',
        target_language_code: 'nl',
        source_text: 'aaa',
        glossary_id: glossary.id
      }
      expect(response).to have_http_status(200)
      expect(json_body.keys).to match_array(%w[id source_language_code target_language_code source_text])
      expect(json_body).to include('source_language_code' => 'en', 'target_language_code' => 'nl', 'source_text' => 'aaa')
    end

    it 'create without glossary' do
      post endpoint, params: {
        source_language_code: 'en',
        target_language_code: 'nl',
        source_text: 'aaa'
      }
      expect(response).to have_http_status(200)
      expect(json_body.keys).to match_array(%w[id source_language_code target_language_code source_text])
      expect(json_body).to include('source_language_code' => 'en', 'target_language_code' => 'nl', 'source_text' => 'aaa')
    end

    context 'fail' do
      it 'must have source_text' do
        post endpoint, params: {
          source_language_code: 'en',
          target_language_code: 'nl'
        }
        expect(response).to have_http_status(422)
        expect(json_body['errors'][0]).to include('must present')
      end

      it 'check glossary exist' do
        post endpoint, params: {
          source_language_code: 'en',
          target_language_code: 'fr',
          source_text: 'aaa',
          glossary_id: glossary.id
        }
        expect(response).to have_http_status(422)
        expect(json_body['errors']).to eq(['Glossary not found'])
      end

      it 'must have max length of source_text' do
        post endpoint, params: {
          source_language_code: 'en',
          target_language_code: 'fr',
          source_text: SecureRandom.hex * 200
        }
        expect(response).to have_http_status(422)
        expect(json_body['errors'][0]).to include('max length')
      end
    end
  end
end
