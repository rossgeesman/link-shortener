Rails.application.routes.draw do
  root to: 'short_links#new'

  resources :short_links, only: [:new, :create, :update]
  get 's/:short_code', to: 'short_links#show', as: 'shortened_link'
  get 'edit/:admin_secret', to: 'short_links#edit', as: 'short_link_admin'
end
