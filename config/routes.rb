Rails.application.routes.draw do

  # GLASSES ROUTES
  root 'glasses#index' #to make it main page(default)

  get '/glasses', to: 'glasses#index'

  get '/glasses/:id', to: 'glasses#show'

  post '/glasses', to: 'glasses#create'

  delete '/glasses/:id', to: 'glasses#delete'

  put '/glasses/:id', to: 'glasses#update'

  put '/bought', to: 'glasses#bought'

  # LOCATIONS ROUTES
  get '/locations', to: 'locations#index'

  get '/locations/:id', to: 'locations#show'

  post '/locations', to: 'locations#create'

  delete '/locations/:id', to: 'locations#delete'

  put '/locations/:id', to: 'locations#update'

end
