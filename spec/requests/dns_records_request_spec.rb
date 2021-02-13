# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DnsRecords', type: :request do
  context '#create' do
    it 'returns status created with correct params' do
      expect do
        post '/dns-records', params: { ip: '1.1.1.1', hostnames_attributes: [{ hostname: 'domain.com' }] }
      end.to change { DnsRecord.count }.by(1).and change { Hostname.count }.by(1)

      expect(response).to have_http_status(:created)
      expect(response.parsed_body['id']).to be_present
    end

    it 'returns status unprocessible entity when missing the required params' do
      post '/dns-records', params: {}

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.parsed_body['id']).not_to be_present
    end
  end
end
