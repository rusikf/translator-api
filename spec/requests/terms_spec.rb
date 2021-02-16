# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Terms', type: :request do
  describe 'POST /terms' do
    let(:glossary) { create(:glossary, :en_nl) }
    let(:endpoint) { "/glossaries/#{glossary.id}/terms" }

    it 'create term' do
      post endpoint, params: { source_term: 'hello world', target_term: 'hallo wereld' }
      expect(response).to have_http_status(200)
      expect(json_body.keys).to match_array(%w[id source_term target_term])
      expect(json_body).to include('source_term' => 'hello world', 'target_term' => 'hallo wereld')
    end

    context 'fail' do
      let!(:term) { create(:term, source_term: 'aaa', target_term: 'bbb', glossary: glossary) }

      it 'must be unique' do
        post endpoint, params: { source_term: 'aaa', target_term: 'bbb' }
        expect(response).to have_http_status(422)
        expect(json_body['errors']).to eq(['Term is already exists'])
      end

      it 'terms must present' do
        post endpoint, params: { source_term: '', target_term: '' }
        expect(response).to have_http_status(422)
        expect(json_body['errors']).to eq(['Source term and Target term must present'])
      end
    end
  end
end
