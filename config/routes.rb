Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  
  get 'peerages' => 'peerage#index', as: :peerage_list
  get 'peerages/:peerage' => 'peerage#show', as: :peerage_show
  
  get 'administrations' => 'administration#index', as: :administration_list
  get 'administrations/:administration' => 'administration#show', as: :administration_show
  get 'administrations/:administration/peerages' => 'administration#peerages', as: :administration_peerages
  
  get 'peerage-types' => 'peerage_type#index', as: :peerage_type_list
  get 'peerage-types/:peerage_type' => 'peerage_type#show', as: :peerage_type_show
  get 'peerage-types/:peerage_type/peerages' => 'peerage_type#peerages', as: :peerage_type_peerages
  
  get 'ranks' => 'rank#index', as: :rank_list
  get 'ranks/:rank' => 'rank#show', as: :rank_show
  get 'ranks/:rank/peerages' => 'rank#peerages', as: :rank_peerages
  get 'ranks/:rank/subsidiary-titles' => 'rank#subsidiary_titles', as: :rank_subsidiary_titles
  
  get 'announcements' => 'announcement#index', as: :announcement_list
  get 'announcements/:announcement' => 'announcement#show', as: :announcement_show
  get 'announcements/:announcement/peerages' => 'announcement#peerages', as: :announcement_peerages
  
  get 'announcement-types' => 'announcement_type#index', as: :announcement_type_list
  get 'announcement-types/:announcement_type' => 'announcement_type#show', as: :announcement_type_show
  get 'announcement-types/:announcement_type/announcements' => 'announcement_type#announcements', as: :announcement_type_announcements

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
