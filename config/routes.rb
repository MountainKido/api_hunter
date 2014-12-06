Rails.application.routes.draw do

  devise_for :users

  resources :game , :only => [:index] do
    collection do
      get  'about'
      get  'callback_success'
      
      get  'twitter_trends_place'
      post 'twitter_trends_place_check'

      get  'twitter_draw_kitten'
      post 'twitter_draw_kitten_check'

      get  'twitter_50_obama'
      post 'twitter_50_obama_check'

      get  'google_map_london'
      post 'google_map_london_check'

      get  'google_map_timezone'
      post 'google_map_timezone_check'
      
      get  'google_chart_qrcode'
      post 'google_chart_qrcode_check'

    end
  end

  root 'game#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
