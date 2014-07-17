module HandlebarsAssets
  # NOTE: must be an engine because we are including assets in the gem
  class Engine < ::Rails::Engine
    initializer "handlebars_assets.assets.register" do |app|
      ::HandlebarsAssets::register_extensions(app.assets)
    end

    initializer 'jader.prepend_views_path', :after => :add_view_paths do |app|
      next if Config.templates_path.nil?
      app.config.paths['app/views'].unshift(Config.templates_path)
      ActionController::Base.class_eval do
        before_filter do |controller|
          prepend_view_path Config.templates_path
        end
      end
    end

  end
end