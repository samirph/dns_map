# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DnsRecord, type: :model do
  describe 'associations' do
    it { should have_many(:hostnames).through(:dns_records_hostnames) }
  end

  describe 'validations' do
    it { should validate_presence_of(:ipv4) }
  end
end
