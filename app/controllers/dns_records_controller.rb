# frozen_string_literal: true

class DnsRecordsController < ApplicationController
  PAGINATION_SIZE = 2
  before_action :validate_pagination_params, only: [:index]
  def index
    excluded_dns_record_ids = DnsRecordsHostname
                              .excluded_by_hostname(index_params[:excluded])
                              .pluck(:dns_record_id)

    result_ids = DnsRecord
                 .includes(:hostnames)
                 .offset((params[:page].to_i - 1) * PAGINATION_SIZE)
                 .limit(PAGINATION_SIZE)
                 .where.not(id: excluded_dns_record_ids)
                 .where(hostnames: { name: index_params[:included] })
                 .group('id', 'dns_records_hostnames.dns_record_id')
                 .having('count(hostnames.id) >= %s', index_params[:included].size)
                 .pluck(:dns_record_id)

    result = DnsRecord
             .includes(hostnames: :dns_records)
             .where(id: result_ids)

    render json: {
      total_records: result.size,
      records: result.map { |dns_record| { id: dns_record.id, ip_address: dns_record.ip } },
      related_hostnames: format_result_related_hostnames(result, result_ids)
    }
  end

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

  def validate_pagination_params
    return head :bad_request if params[:page].blank?
  end

  def index_params
    params.permit(:page, included: [], excluded: [])
  end

  def format_result_related_hostnames(result, allowed_dns_record_ids)
    non_related_hostnames = index_params[:included] || [] + index_params[:excluded] || [] 
    hostnames = result.map(&:hostnames).flatten.uniq
    filtered_hostnames = hostnames.select{|hostname| !non_related_hostnames.include?(hostname.name) }
    filtered_hostnames.map do |hostname|
      {
        hostname: hostname.name,
        count: hostname.dns_records.select do |record|
                 allowed_dns_record_ids.include?(record.id)
               end.size
      }
    end
  end
end
