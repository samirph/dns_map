# frozen_string_literal: true

FactoryBot.define do
  factory :hostname do
    name { Faker::Internet.unique.domain_name }
  end
end
