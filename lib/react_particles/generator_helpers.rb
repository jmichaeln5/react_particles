module ReactParticles
  module GeneratorHelpers
    def call_generator(generator, *args)
      Rails::Generators.invoke(generator, args, generator_options)
    end

    # def call_template(template, *args)
    #   # code
    # end

    private

    def generator_options
      { behavior: behavior }
    end
  end
end
