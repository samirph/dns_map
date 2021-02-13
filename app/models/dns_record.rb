# frozen_string_literal: true

class DnsRecord < ApplicationRecord
  has_many :dns_records_hostnames, dependent: :destroy
  has_many :hostnames, through: :dns_records_hostnames
end
