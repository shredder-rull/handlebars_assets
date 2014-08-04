module HandlebarsAssets
  module Server
    module Handlers
      class Handlebars
        def self.call(template)
          new.call(template)
        end

        def call(template)

          if HandlebarsAssets::Config.templates_file.present?
            view_key = template.identifier.match('templates\/(?<key>[^\.]+)')[:key]
            <<-HBS
            variables = assigns.merge local_assigns
            HandlebarsAssets::Handlebars.render_by_js(#{view_key.inspect}, variables).html_safe
            HBS

          else
            template_path = HandlebarsAssets::HandlebarsTemplate::TemplatePath.new(template.identifier)

            tmpl = template.source

            if template_path.is_haml?
              tmpl = Haml::Engine.new(tmpl, HandlebarsAssets::Config.haml_options).render
            elsif template_path.is_slim?
              tmpl = Slim::Template.new(HandlebarsAssets::Config.slim_options) { tmpl }.render
            end

            <<-HBS
            variables = assigns.merge local_assigns
            HandlebarsAssets::Handlebars.render(#{tmpl.inspect}, variables).html_safe
            HBS
          end

        end

      end
    end
  end
end