require_relative "lib/immosquare-capistrano/version"

Gem::Specification.new do |spec|
  spec.license       = "MIT"
  spec.name          = "immosquare-capistrano"
  spec.version       = ImmosquareCapistrano::VERSION.dup
  spec.authors       = ["immosquare"]
  spec.email         = ["jules@immosquare.com"]
  spec.description   = "Puma, Sidekiq & SolidQueue services integrations for Capistrano"
  spec.summary       = "Puma, Sidekiq & SolidQueue services integrations for Capistrano"
  spec.homepage      = "https://github.com/IMMOSQUARE/immosquare-capistrano"

  spec.files         = Dir["lib/**/*"]
  spec.require_paths = ["lib"]

  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.2")

  spec.add_dependency("capistrano", "~> 3.0")
end
