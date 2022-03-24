require_relative "lib/react_particles/version"

Gem::Specification.new do |spec|
  spec.name        = "react_particles"
  spec.version     = ReactParticles::VERSION
  spec.authors     = ["Jonathan Norton"]
  spec.email       = ["jmichaeln5@gmail.com"]
  spec.homepage    = "https://github.com/jmichaeln5/react_particles"
  spec.summary     = "A flexible Rails engine to integrate page specific React applications with esbuild"
  spec.description = "Inspired by react-rails gem, this engine provides a React Application bundled with esbuild for separation of concerns."
    spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "http://localhost:3000"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/jmichaeln5/react_particles"
  spec.metadata["changelog_uri"] = "https://github.com/jmichaeln5/react_particles/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.required_ruby_version = '>= 2.7.0'
  spec.add_dependency "rails", ">= 7.0"
  spec.add_dependency "colorize"

end
