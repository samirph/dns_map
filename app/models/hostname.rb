# frozen_string_literal: true

class Hostname < ApplicationRecord
  has_many :dns_records_hostnames, dependent: :destroy
  has_many :dns_records, through: :dns_records_hostnames
  alias_attribute :hostname, :name
  validates :name, presence: true
end
