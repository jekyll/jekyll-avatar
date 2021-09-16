# frozen_string_literal: true

require_relative "lib/jekyll-avatar/version"

Gem::Specification.new do |spec|
  spec.name          = "jekyll-avatar"
  spec.version       = Jekyll::Avatar::VERSION
  spec.authors       = ["Ben Balter"]
  spec.email         = ["ben.balter@github.com"]

  spec.summary       = "A Jekyll plugin for rendering GitHub avatars"
  spec.homepage      = "https://github.com/benbalter/jekyll-avatar"
  spec.license       = "MIT"

  spec.files         = `git ls-files lib`.split("\n").concat(%w(LICENSE.txt README.md))

  spec.require_paths = ["lib"]

  spec.add_dependency "jekyll", ">= 3.0", "< 5.0"
  spec.add_development_dependency "bundler", "> 1.0", "< 3.0"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-html-matchers", "~> 0.9"
  spec.add_development_dependency "rubocop-jekyll", "~> 0.12.0"
end
