Rails.application.routes.draw do
  resources :dns_records, only: [:create], path: 'dns-records'
end
