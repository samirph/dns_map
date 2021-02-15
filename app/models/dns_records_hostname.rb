# frozen_string_literal: true

class DnsRecordsHostname < ApplicationRecord
  belongs_to :dns_record
  belongs_to :hostname
  scope :excluded_by_hostname, lambda { |excluded_list|
    joins(:hostname)
      .where(hostname: { name: excluded_list })
  }
end
