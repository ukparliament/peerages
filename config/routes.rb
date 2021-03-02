Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index', as: :home
  
  get 'people/a-z' => 'person_atoz#index', as: :person_atoz_list
  get 'people/a-z/:letter' => 'person_atoz#show', as: :person_atoz_show
  
  get 'people' => 'person#index', as: :person_list
  get 'people/:person' => 'person#show', as: :person_show
  
  get 'administrations' => 'administration#index', as: :administration_list
  get 'administrations/:administration' => 'administration#show', as: :administration_show
  
  get 'special-remainders' => 'special_remainder#index', as: :special_remainder_list
  get 'special-remainders/:special_remainder' => 'special_remainder#show', as: :special_remainder_show
  
  get 'ranks' => 'rank#index', as: :rank_list
  get 'ranks/:rank' => 'rank#show', as: :rank_show
  
  get 'peerage-types' => 'peerage_type#index', as: :peerage_type_list
  get 'peerage-types/:peerage_type' => 'peerage_type#show', as: :peerage_type_show
  
  get 'peerage-types/:peerage_type/a-z' => 'peerage_type_atoz#index', as: :peerage_type_atoz_list
  get 'peerage-types/:peerage_type/a-z/:letter' => 'peerage_type_atoz#show', as: :peerage_type_atoz_show
  
  get 'jurisdictions' => 'jurisdiction#index', as: :jurisdiction_list
  get 'jurisdictions/:jurisdiction' => 'jurisdiction#show', as: :jurisdiction_show
  
  get 'announcement-types' => 'announcement_type#index', as: :announcement_type_list
  get 'announcement-types/:announcement_type' => 'announcement_type#show', as: :announcement_type_show
  
  get 'announcements' => 'announcement#index', as: :announcement_list
  get 'announcements/:announcement' => 'announcement#show', as: :announcement_show
  
  get 'peerages/a-z' => 'peerage_atoz#index', as: :peerage_atoz_list
  get 'peerages/a-z/:letter' => 'peerage_atoz#show', as: :peerage_atoz_show
  
  get 'peerages' => 'peerage#index', as: :peerage_list
  get 'peerages/:peerage' => 'peerage#show', as: :peerage_show
  
  get 'letters-patent' => 'letters_patent#index', as: :letters_patent_list
  get 'letters-patent/:letters_patent' => 'letters_patent#show', as: :letters_patent_show
  
  get 'law-lords' => 'law_lord#index', as: :law_lord_list
  get 'law-lords/:law_lord' => 'law_lord#show', as: :law_lord_show
  
  get 'meta' => 'meta#index', as: :meta_list
  get 'meta/about' => 'meta#about', as: :meta_about
  get 'meta/iaq' => 'meta#iaq', as: :meta_iaq
  get 'meta/schema' => 'meta#schema', as: :meta_schema

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
