# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DnsRecords', type: :request do
  context '#index' do
    let(:lorem_hostname) { create(:hostname, name: 'lorem.com') }
    let(:ipsum_hostname) { create(:hostname, name: 'ipsum.com') }
    let(:dolor_hostname) { create(:hostname, name: 'dolor.com') }
    let(:amet_hostname) { create(:hostname, name: 'amet.com') }
    let(:sit_hostname) { create(:hostname, name: 'sit.com') }
    before do
      create(:dns_record, ip: '1.1.1.1', hostnames: [lorem_hostname, ipsum_hostname, dolor_hostname, amet_hostname])
      create(:dns_record, ip: '2.2.2.2', hostnames: [ipsum_hostname])
      create(:dns_record, ip: '3.3.3.3', hostnames: [ipsum_hostname, dolor_hostname, amet_hostname])
      create(:dns_record, ip: '4.4.4.4', hostnames: [ipsum_hostname, dolor_hostname, amet_hostname, sit_hostname])
      create(:dns_record, ip: '5.5.5.5', hostnames: [dolor_hostname, sit_hostname])
    end

    it 'returns status ok and params work correctly' do
      get '/dns-records', params: { page: 1, included: ['ipsum.com', 'dolor.com'], excluded: ['sit.com'] }

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body['total_records']).to eq(2)
      expect(response.parsed_body['records'].size).to eq(2)
      expect(response.parsed_body['records'][0]['ip_address']).to eq('1.1.1.1')
      expect(response.parsed_body['records'][1]['ip_address']).to eq('3.3.3.3')
      expect(response.parsed_body['related_hostnames'].size).to eq(2)
      expect(response.parsed_body['related_hostnames'][0]['count']).to eq(1)
      expect(response.parsed_body['related_hostnames'][0]['hostname']).to eq('lorem.com')
      expect(response.parsed_body['related_hostnames'][1]['count']).to eq(2)
      expect(response.parsed_body['related_hostnames'][1]['hostname']).to eq('amet.com')
    end

    it 'paginates correctly' do
      get '/dns-records', params: { page: 1, included: ['ipsum.com', 'dolor.com'] }
      expect(response.parsed_body['total_records']).to eq(2)
      get '/dns-records', params: { page: 2, included: ['ipsum.com', 'dolor.com'] }
      expect(response.parsed_body['total_records']).to eq(1)
    end

    it 'returns status bad request when missing the page param' do
      get '/dns-records', params: {}

      expect(response).to have_http_status(:bad_request)
    end
  end

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
