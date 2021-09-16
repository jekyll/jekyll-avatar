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
  spec.required_ruby_version = ">= 2.5"

  spec.add_dependency "jekyll", ">= 3.0", "< 5.0"
  spec.add_development_dependency "bundler", "> 1.0", "< 3.0"
  spec.add_development_dependency "kramdown-parser-gfm", "~> 1.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-html-matchers", "~> 0.9"
  spec.add_development_dependency "rubocop-jekyll", "~> 0.10"
  spec.add_development_dependency "rubocop-performance", "~> 1.5"
  spec.add_development_dependency "rubocop-rspec", "~> 2.0"
end
