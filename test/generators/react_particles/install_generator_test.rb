# frozen_string_literal: true

require "test_helper"

class ReactParticlesInstallGeneratorTest < Rails::Generators::TestCase
  def test_initializer_file_is_created
    run_generator [react_particles:install]
    assert_file "config/initializers/react_particles.rb"
  end
end
