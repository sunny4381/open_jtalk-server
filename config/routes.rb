Rails.application.routes.draw do
  root 'open_jtalk#index'
  get 'index' => 'open_jtalk#index'
  get 'synthesis' => 'open_jtalk#synthesis'
  post 'synthesis' => 'open_jtalk#synthesis'
end
