module ReactParticles
  module GeneratorHelpers
    def call_generator(generator, *args)
      Rails::Generators.invoke(generator, args, generator_options)
    end

    # def call_template(template, *args)
    #   # code
    # end

    def indent_str(strang)
      return " "*7 + strang + " "
    end

    # def file_empty?(file_path)
    #   !(File.file?(file_path) && !File.zero?(file_path))
    # end

    private

    def generator_options
      { behavior: behavior }
    end
  end
end
