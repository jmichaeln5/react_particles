module ReactParticles
  module GeneratorHelpers
    def call_generator(generator, *args)
      Rails::Generators.invoke(generator, args, generator_options)
    end

    # def call_template(template, *args)
    #   # code
    # end

    # def template(source, *args, &block)
    # # ~/rails/railties/lib/rails/generators/named_base.rb:23
    # end

    # def react_app_js_path
    #   "app/javascript/#{namespace}"
    # end

    # def mkdir_unless_exists(dir_path)
    #   if (Dir.exists? dir_path)
    #     return dir_path
    #   end
    #   system `mkdir #{dir_path}`
    # end



    def indent_str(strang)
      return " "*7 + strang + " "
    end

    private

    def generator_options
      { behavior: behavior }
    end
  end
end
