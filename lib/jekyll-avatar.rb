# frozen_string_literal: true

require "zlib"

module Jekyll
  class Avatar < Liquid::Tag
    include Jekyll::LiquidExtensions

    def self.generate_template_with(keys)
      attrs = (BASE_ATTRIBUTES + keys).map! { |key| %(#{key}="%<#{key}>s") }.join(" ")
      "<img #{attrs} />"
    end
    private_class_method :generate_template_with

    #

    SERVERS      = 4
    DEFAULT_SIZE = 40
    API_VERSION  = 3

    BASE_ATTRIBUTES = %w(
      class alt width height data-proofer-ignore src
    ).freeze

    BASE_TEMPLATE = generate_template_with %w(srcset)
    LAZY_TEMPLATE = generate_template_with %w(data-src data-srcset)

    private_constant :BASE_ATTRIBUTES, :BASE_TEMPLATE, :LAZY_TEMPLATE

    def initialize(_tag_name, text, _tokens)
      super
      @text = text
      @markup = Liquid::Template.parse(text)
    end

    def render(context)
      @context = context
      @text    = @markup.render(@context)
      template = lazy_load? ? LAZY_TEMPLATE : BASE_TEMPLATE
      format(template, attributes)
    end

    private

    def attributes
      result = {
        :class                 => classes,
        :alt                   => username,
        :width                 => size,
        :height                => size,
        :"data-proofer-ignore" => true
      }

      if lazy_load?
        result[:src] = ""
        result[:"data-src"] = url
        result[:"data-srcset"] = srcset
      else
        result[:src] = url
        result[:srcset] = srcset
      end

      result
    end

    def lazy_load?
      @text.include?("lazy=true")
    end

    def username
      matches = @text.match(%r!\buser=([\w\.]+)\b!)
      if matches
        lookup_variable(@context, matches[1])
      elsif @text.include?(" ")
        result = @text.split(" ")[0]
        result.sub!("@", "")
        result
      else
        @text
      end
    end

    def size
      matches = @text.match(%r!\bsize=(\d+)\b!i)
      matches ? matches[1].to_i : DEFAULT_SIZE
    end

    def path(scale = 1)
      "#{username}?v=#{API_VERSION}&s=#{size * scale}"
    end

    def server_number
      Zlib.crc32(path) % SERVERS
    end

    def host
      if ENV["PAGES_AVATARS_URL"].is_a?(String) && !ENV["PAGES_AVATARS_URL"].empty?
        ENV["PAGES_AVATARS_URL"]
      else
        "https://avatars#{server_number}.githubusercontent.com"
      end
    end

    def parsed_host
      @parsed_host ||= {}
      @parsed_host[host] ||= Addressable::URI.parse(host)
    end

    def url(scale = 1)
      uri = parsed_host
      uri.path << "/" unless uri.path.end_with?("/")
      uri = uri.join path(scale)
      uri.to_s
    end

    SCALES = %w(1 2 3 4).freeze
    private_constant :SCALES

    def srcset
      SCALES.map { |scale| "#{url(scale.to_i)} #{scale}x" }.join(", ")
    end

    # See http://primercss.io/avatars/#small-avatars
    def classes
      size < 48 ? "avatar avatar-small" : "avatar"
    end
  end
end

Liquid::Template.register_tag("avatar", Jekyll::Avatar)
