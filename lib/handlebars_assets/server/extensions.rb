module HandlebarsAssets
  module Server
    module Extensions
      def context_for(template, extra = '')
        tmpl = "var template = Handlebars.template(#{precompile(template)})"
        context = [runtime, extra, tmpl].join('; ')

        ExecJS.compile(context)
      end

      def render(template, *args)
        locals = args.last.is_a?(Hash) ? args.pop : {}
        extra = args.first.to_s
        context_for(template, extra).call('template', locals)
      end

      def render_by_js(template_key, *args)
        locals = args.last.is_a?(Hash) ? args.pop : {}
        context_with_templates.call("JST['#{template_key}']", locals)
      end

      def context_with_templates
        @context_with_templates ||= ExecJS.compile([apply_patches_to_source, templates_file].join('; '))
      end

      def templates_file
        sprockets[HandlebarsAssets::Config.templates_file].to_s
      end

      protected

      def runtime
        @runtime ||= runtime_path.read
      end

      def runtime_path
        @runtime_path ||= assets_path.join(HandlebarsAssets::Config.compiler_runtime)
      end
    end
  end
end

::HandlebarsAssets::Handlebars.send(:extend, HandlebarsAssets::Server::Extensions)
