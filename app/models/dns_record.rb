# frozen_string_literal: true

class DnsRecord < ApplicationRecord
  has_many :dns_records_hostnames, dependent: :destroy
  has_many :hostnames, through: :dns_records_hostnames
  validate
  alias_attribute :ip, :ipv4

  validates :ipv4, presence: true

  accepts_nested_attributes_for :hostnames
end
