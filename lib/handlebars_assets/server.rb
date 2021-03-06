require 'handlebars_assets'

%w(responder controller handlers/handlebars extensions).each do |lib|
  require File.join('handlebars_assets', 'server', lib)
end

module HandlebarsAssets
  module Server
    extend self
    HANDLER = HandlebarsAssets::Server::Handlers::Handlebars

    def self.register_template_handlers
      Config.handlebars_extensions.each do |ext|
        ActionView::Template.register_template_handler(ext, HANDLER)
      end
      if Config.haml_enabled? && Config.haml_available?
        Config.hamlbars_extensions.each do |ext|
          ActionView::Template.register_template_handler(ext, HANDLER)
        end
      end
      if Config.slim_enabled? && Config.slim_available?
        Config.slimbars_extensions.each do |ext|
          ActionView::Template.register_template_handler(ext, HANDLER)
        end
      end
    end

    def self.register_mime_types
      Config.handlebars_extensions.each do |ext|
        Mime::Type.register_alias 'text/html', ext.to_sym
      end
      if Config.haml_enabled? && Config.haml_available?
        Config.hamlbars_extensions.each do |ext|
          Mime::Type.register_alias 'text/html', ext.to_sym
        end
      end
      if Config.slim_enabled? && Config.slim_available?
        Config.slimbars_extensions.each do |ext|
          Mime::Type.register_alias 'text/html', ext.to_sym
        end
      end
    end
  end
end

if defined?(Rails)
  ::HandlebarsAssets::Server.register_template_handlers
  ::HandlebarsAssets::Server.register_mime_types
end