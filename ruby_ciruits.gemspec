
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ruby_ciruits/version"

Gem::Specification.new do |spec|
  spec.name          = "ruby_ciruits"
  spec.version       = RubyCiruits::VERSION
  spec.authors       = ["Amandeep Singh"]
  spec.email         = ["amandeep511997@gmail.com"]

  spec.summary       = %q{Design digital circuits in Ruby}
  spec.description   = %q{Using RailsCircuits you can design a digital ciruit and simulate its working in practice}
  spec.homepage      = "https://github.com/amandeep511997/ruby_circuits"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  #if spec.respond_to?(:metadata)
  #  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  #else
  #  raise "RubyGems 2.0 or newer is required to protect against " \
  #    "public gem pushes."
  #end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version     = '>= 2.0.0'

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "celluloid", "~> 0.17"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "rspec", "~> 3.0"
end
