Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :admin do
    #resources :settings, only: [:index, :update]
    resources :settings, only: [:index, :update]
    resources :productclas do
      collection do
        get 'ckeck_keyword_unipue'
        get 'get_product_cla'
        post 'change_cla'
      end
    end
    resources :products do
      resources :showparams
      resources :productshares do
        collection do
          get 'getshare'
          post 'updateshare'
        end
      end
      resources :buyparams do
        resources :buyparamoptions
      end
      resources :productbanners do
        collection do
          post 'sort'
        end
      end
      resources :agentprices
      collection do
        get 'get_delivermode'
        get 'getseller'
      end
    end
    resources :resources
    resources :indepots do
      collection do
        get 'get_products'
      end
      member do
        post 'reviewer'
      end
    end
    resources :depots
    resources :buyfulls do
      resources :buyfullproducts do
        collection do
          get 'get_products'
        end
      end
      resources :buyfullgiveproducts do
        collection do
          get 'get_products'
        end
      end
      collection do
        get 'get_users'
      end
    end
    resources :addcashs do
      resources :addcashproducts do
        collection do
          get 'get_products'
        end
      end
      resources :addcashgis do
        collection do
          get 'get_products'
        end
      end
      collection do
        get 'get_users'
      end
    end
    resources :limitdiscounts do
      resources :limitdiscountproducts do
        collection do
          get 'get_products'
        end
      end
      collection do
        get 'get_users'
      end
    end
    resources :agents do
      collection do
        get 'check_unique'
        post 'sort'
      end
    end
    resources :orders do
      collection do
        post 'autonumber'
        post 'createdeliver'
        post 'createele'
        post 'set_elesheet'
      end
      member do
        delete 'deletedeliver'
      end
    end
    resources :users
    resources :orderprints do
      collection do
        post 'upload'
      end
    end
    resources :orderproducts
    resources :profits
    resources :sellers do
      resources :shophours
      collection do
        get 'get_delivermode'
        get 'ckeck_login_unipue'
      end
    end
    resources :delivermodes
    resources :todaydeals do
      collection do
        get 'get_product_list'
      end
      member do
        get 'get_product'
        post 'set_product'
      end
    end
  end

  namespace :api do
    resources :testapis
    resources :homes do
      collection do
      get 'getrecommendseller'
      get 'searchproduct'
      end
    end
    resources :getopenids
    resources :productlists
    resources :buycars do
      collection do
        post 'changenumber'
      end
    end
    resources :productdetails
    resources :addrs do
      collection do
        post 'getadcode'
      end
    end
    resources :productclas
    resources :orders do
      collection do
        post 'pay'
        post 'get_express'
        post 'confirmdeliver'
        post 'wx_pay'
        post 'wxpay_notify'
        get 'exchangerate'
        get 'getdelivertime'
      end
    end
    resources :users do
      collection do
        post 'charge'
        get 'getbalancedetail'
        get 'financering'
        get 'financestack'
        get 'financeline'
        get 'getstayincome'
        get 'team'
        get 'teamdetail'
        get 'mytask'
        get 'taskdetail'
        get 'mysales'
        get 'profit'
        get 'setlocation'
      end
    end
    resources :agents
    resources :evaluates
    resources :productshares
    resources :userlocation do
      collection do
        get 'getnear'
      end
    end
  end
end
