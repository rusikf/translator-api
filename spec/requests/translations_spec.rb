# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Translations', type: :request do
  describe 'GET /translations/:id' do
    context 'with glossary' do
      let!(:glossary) { create(:glossary, :en_nl) }
      let!(:term) { create(:term, glossary: glossary, source_term: 'recruitment') }
      let!(:translation) { create(:translation, glossary: glossary, source_text: 'This is a recruitment task') }

      it 'have highlighted_source_text' do
        get "/translations/#{translation.id}"
        expect(response).to have_http_status(200)
        expect(json_body.keys).to match_array(%w[source_text glossary_terms highlighted_source_text])
        expect(json_body).to include(
          'source_text' => 'This is a recruitment task',
          'glossary_terms' => ['recruitment'],
          'highlighted_source_text' => 'This is a <HIGHLIGHT>recruitment</HIGHLIGHT> task'
        )
      end
    end

    context 'without glossary' do
      let!(:translation) { create(:translation, source_text: 'This is a recruitment task') }
      it 'success' do
        get "/translations/#{translation.id}"
        expect(response).to have_http_status(200)
        expect(json_body.keys).to match_array(%w[source_text glossary_terms highlighted_source_text])
        expect(json_body).to include(
          'source_text' => 'This is a recruitment task',
          'glossary_terms' => []
        )
      end
    end
  end

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
