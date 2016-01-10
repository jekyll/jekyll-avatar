require 'jekyll/avatar/version'

module Jekyll
  class Avatar < Liquid::Tag
    SERVERS = 4
    DEFAULT_SIZE = 40
    VERSION = 3

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(_context)
      tag = '<img '

      # See http://primercss.io/avatars/#small-avatars
      if size < 48
        tag << 'class="avatar avatar-small" '
      else
        tag << 'class="avatar" '
      end

      tag << "src=\"#{url}\" alt=\"#{username}\" "
      tag << "width=\"#{size}\" height=\"#{size}\" "
      tag << '/>'
      tag
    end

    private

    def username
      @username ||= @text.split(' ').first.sub('@', '')
    end

    def size
      @size ||= begin
        matches = @text.match(/\bsize=(\d+)\b/i)
        matches ? matches[1].to_i : DEFAULT_SIZE
      end
    end

    def path
      @path ||= "#{username}?v=#{VERSION}&s=#{size}"
    end

    def server_number
      @server_number ||= Zlib.crc32(path) % SERVERS
    end

    def host
      @host ||= "avatars#{server_number}.githubusercontent.com"
    end

    def url
      @url ||= "https://#{host}/#{path}"
    end
  end
end

Liquid::Template.register_tag('avatar', Jekyll::Avatar)
