require 'rails/generators'

module Paysto
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../../templates', __FILE__)

    def add_paysto_routes
      paysto_route = <<-PAYSTO_ROUTES
namespace :paysto do
    post :success, :fail, :check, :callback
    get  :fail
  end
PAYSTO_ROUTES
      route paysto_route
    end

    def copy_config
      template 'config/paysto.rb', 'config/initializers/paysto.rb'
    end

    def copy_locale
      template 'config/paysto.en.yml', 'config/locales/paysto.en.yml'
      template 'config/paysto.ru.yml', 'config/locales/paysto.ru.yml'
    end

    def copy_controller
      template 'controllers/paysto_controller.rb', 'app/controllers/paysto_controller.rb'
    end

  end
end