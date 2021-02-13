# frozen_string_literal: true

class DnsRecordsHostname < ApplicationRecord
  belongs_to :dns_record
  belongs_to :hostname
end
