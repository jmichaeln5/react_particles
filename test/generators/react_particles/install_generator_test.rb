# frozen_string_literal: true

require "test_helper"

class ReactParticlesInstallGeneratorTest < Rails::Generators::TestCase
  tests ReactParticles::Generators::InstallGenerator
  destination HOST_ROOT

  # https://rossta.net/blog/testing-rails-generators.html
  test "creates a file" do
    # run_generator
    # make some assertions about file and its contents
  end


  # def test_initializer_file_is_created
  #   run_generator [react_particles:install]
  #   assert_file "config/initializers/react_particles.rb"
  # end
end
