# frozen_string_literal: true

require "spec_helper"

describe Jekyll::Avatar do
  let(:doc) { doc_with_content(content) }
  let(:username) { "hubot" }
  let(:args) { "" }
  let(:text) { "#{username} #{args}".squeeze(" ") }
  let(:content) { "{% avatar #{text} %}" }
  let(:rendered) { subject.render(nil) }
  let(:tokenizer) { Liquid::Tokenizer.new("") }
  let(:parse_context) { Liquid::ParseContext.new }
  let(:output) do
    doc.content = content
    doc.output  = Jekyll::Renderer.new(doc.site, doc).run
  end

  let(:server_number) { 3 }
  let(:host) { "https://avatars#{server_number}.githubusercontent.com" }
  let(:uri) do
    uri = Addressable::URI.parse(host)
    uri.path = "#{uri.path}/#{username}"
    uri.query_values = { :v => 3, :s => width }.to_a
    uri
  end
  let(:height) { 40 }
  let(:width) { 40 }
  let(:scales) { (1..4) }
  let(:src) { src_hash["1x"] }
  let(:src_hash) do
    scales.map do |scale|
      uri.query_values = { "v" => 3, "s" => width * scale }.to_a
      ["#{scale}x", uri.to_s]
    end.to_h
  end
  let(:srcset) { src_hash.map { |scale, src| "#{src} #{scale}" }.join(", ") }

  subject { described_class.parse "avatar", text, tokenizer, parse_context }

  it "has a version number" do
    expect(Jekyll::Avatar::VERSION).not_to be nil
  end

  it "outputs the HTML" do
    expect(output).to have_tag("p") do
      with_tag "img", :with => {
        :alt                  => username,
        :class                => "avatar avatar-small",
        "data-proofer-ignore" => "true",
        :height               => height,
        :src                  => src,
        :srcset               => srcset,
        :width                => width,
      }
    end
  end

  it "parses the username" do
    expect(subject.send(:username)).to eql(username)
  end

  it "determines the server number" do
    expect(subject.send(:server_number)).to eql(server_number)
  end

  it "builds the host" do
    expect(subject.send(:host)).to eql(host)
  end

  context "with a custom host" do
    let(:host) { "http://avatars.example.com" }
    context "with subdomain isolation" do
      it "builds the host" do
        with_env("PAGES_AVATARS_URL", host) do
          expect(subject.send(:host)).to eql(host)
        end
      end

      it "builds the URL" do
        with_env("PAGES_AVATARS_URL", host) do
          expect(subject.send(:url)).to eql(src)
        end
      end
    end

    context "without subdomain isolation" do
      let(:host) { "http://github.example.com/avatars" }
      it "builds the URL" do
        with_env("PAGES_AVATARS_URL", host) do
          expect(subject.send(:url)).to eql(src)
        end
      end
    end
  end

  it "builds the path" do
    expect(subject.send(:path)).to eql("hubot?v=3&s=40")
  end

  it "defaults to the default size" do
    expect(subject.send(:size)).to eql(width)
  end

  it "builds the URL" do
    expect(subject.send(:url)).to eql(src)
  end

  it "builds the params" do
    attrs = subject.send(:attributes)
    expect(attrs).to eql({
      "data-proofer-ignore" => true,
      :class                => "avatar avatar-small",
      :alt                  => username,
      :src                  => src,
      :srcset               => srcset,
      :width                => width,
      :height               => height,
    })
  end

  it "includes data-proofer-ignore" do
    expect(output).to have_tag "img", :with => {
      "data-proofer-ignore" => "true",
    }
  end

  context "retina" do
    it "builds the path with a scale" do
      expect(subject.send(:path, 2)).to eql("hubot?v=3&s=80")
    end

    context "when given a scale" do
      let(:width) { 80 }

      it "builds the URL with a scale" do
        expect(subject.send(:url, 2)).to eql(src)
      end
    end

    it "builds the srcset" do
      srcset = subject.send(:srcset)
      src_hash.each do |scale, url|
        regex = Regexp.escape("#{url} #{scale}")
        expect(srcset).to match(regex)
      end
    end
  end

  context "when passed @hubot as a username" do
    let(:username) { "@hubot" }

    it "parses the username" do
      expect(subject.send(:username)).to eql("hubot")
    end
  end

  context "with a size is passed" do
    let(:width) { 45 }
    let(:args) { "size=#{width}" }

    it "parses the user's requested size" do
      expect(subject.send(:size)).to eql(width)
    end
  end

  context "with a size < 48" do
    it "includes the avatar-small class" do
      expect(rendered).to match(%r!avatar-small!)
    end

    it "calculates the classes" do
      expect(subject.send(:classes)).to eql("avatar avatar-small")
    end
  end

  context "with a size > 48" do
    let(:width) { 80 }
    let(:args) { "size=#{width}" }

    it "doesn't include the avatar-small class" do
      expect(rendered).to_not match(%r!avatar-small!)
    end

    it "calculates the classes" do
      expect(subject.send(:classes)).to eql("avatar")
    end
  end

  context "when passed the username as a rendered variable" do
    let(:username) { "hubot2" }
    let(:server_number) { 0 }
    let(:content) { "{% assign user='#{username}' %}{% avatar {{ user }} %}" }

    it "parses the variable" do
      expect(output).to have_tag "img", :with => { :src => src }
    end
  end

  context "when passed the username as a variable-argument" do
    let(:username) { "hubot2" }
    let(:server_number) { 0 }
    let(:content) { "{% assign user='hubot2' %}{% avatar user=user %}" }

    it "parses the variable" do
      expect(output).to have_tag "img", :with => { :src => src }
    end
  end

  context "when passed the username as a sub-variable-argument" do
    let(:username) { "hubot2" }
    let(:server_number) { 0 }
    let(:content) { "{% avatar user=page.author %}" }

    it "parses the variable" do
      expect(output).to have_tag "img", :with => { :src => src }
    end
  end

  context "loops" do
    let(:content) do
      <<-LIQUID
{% assign users = "a|b" | split:"|" %}
{% for user in users %}
  {% avatar user=user %}
{% endfor %}
      LIQUID
    end

    it "renders each avatar" do
      expect(output).to have_tag("p") do
        with_tag "img", :with => { :alt => "a" }
        with_tag "img", :with => { :alt => "b" }
      end
    end
  end

  context "lazy loading" do
    let(:args) { "lazy=true" }

    it "sets the image URL as the data-src" do
      expect(output).to have_tag "img", :with => {
        :src          => "",
        "data-src"    => src,
        "data-srcset" => srcset,
      }, :without => {
        :srcset => %r!.*!,
      }
    end
  end
end
