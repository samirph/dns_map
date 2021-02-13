# frozen_string_literal: true

class DnsRecordsController < ApplicationController
  def create
    dns_record = DnsRecord.new(dns_record_params)

    if dns_record.save
      render json: { id: dns_record.id }, status: :created
    else
      render json: { message: dns_record.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  private

  def dns_record_params
    params.permit(:ip, hostnames_attributes: [:hostname])
  end
end
