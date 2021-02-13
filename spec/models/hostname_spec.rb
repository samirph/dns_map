# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Hostname, type: :model do
  describe 'associations' do
    it { should have_many(:dns_records).through(:dns_records_hostnames) }
  end
end
