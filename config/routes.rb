Rails.application.routes.draw do

  root 'glasses#index' #to make it main page(default)

  get '/glasses', to: 'glasses#index'

  get '/glasses/:id', to: 'glasses#show'

  post '/glasses', to: 'glasses#create'

  delete '/glasses/:id', to: 'glasses#delete'

  put '/glasses/:id', to: 'glasses#update'

end
