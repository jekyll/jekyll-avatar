# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "jekyll"
require "jekyll-avatar"
require "rspec-html-matchers"

TEST_DIR = File.dirname(__FILE__)
TMP_DIR  = File.expand_path("../tmp", TEST_DIR)

RSpec.configure do |config|
  config.include RSpecHtmlMatchers
end

def doc_with_content(_content, opts = {})
  my_site = site(opts)
  options = { :site => my_site, :collection => collection(my_site) }
  doc = Jekyll::Document.new(source_dir("_test/doc.md"), options)
  doc.merge_data!("author" => "hubot2")
  doc
end

def tmp_dir(*files)
  File.join(TMP_DIR, *files)
end

def source_dir(*files)
  tmp_dir("source", *files)
end

def dest_dir(*files)
  tmp_dir("dest", *files)
end

def collection(site, label = "test")
  Jekyll::Collection.new(site, label)
end

def site(opts = {})
  defaults = Jekyll::Configuration::DEFAULTS
  opts = opts.merge(
    "source"      => source_dir,
    "destination" => dest_dir
  )
  conf = Jekyll::Utils.deep_merge_hashes(defaults, opts)
  Jekyll::Site.new(conf)
end

def fixture(name)
  path = File.expand_path "./fixtures/#{name}.json", File.dirname(__FILE__)
  File.open(path).read
end

def with_env(key, value)
  old_value = ENV[key]
  ENV[key] = value
  yield
ensure
  ENV[key] = old_value
end
