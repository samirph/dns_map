# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DnsRecords', type: :request do
  it 'returns status created with correct params' do
    post '/dns-records', params: { ip: '1.1.1.1', hostnames_attributes: [{ hostname: 'domain.com' }] }

    expect(response).to have_http_status(:created)
  end

  it 'returns status unprocessible entity when missing the required params' do
    post '/dns-records', params: {}

    expect(response).to have_http_status(:unprocessable_entity)
  end
end
