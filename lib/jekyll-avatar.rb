module Jekyll
  class Avatar < Liquid::Tag
    SERVERS = 4
    DEFAULT_SIZE = 40
    VERSION = 3

    def initialize(_tag_name, text, _tokens)
      super
      @text = text
    end

    def render(context)
      @context = context
      @text    = Liquid::Template.parse(@text).render(@context)
      tag =  "<img class=\"#{classes}\" "
      tag << "src=\"#{url}\" alt=\"#{username}\" "
      tag << "srcset=\"#{srcset}\" "
      tag << "width=\"#{size}\" height=\"#{size}\" />"
    end

    private

    def username
      matches = @text.match(/\buser=(\w+)\b/)
      if matches && @context.has_key?(matches[1])
        @context[matches[1]]
      else
        @text.split(' ').first.sub('@', '')
      end
    end

    def size
      matches = @text.match(/\bsize=(\d+)\b/i)
      matches ? matches[1].to_i : DEFAULT_SIZE
    end

    def path(scale = 1)
      "#{username}?v=#{VERSION}&s=#{size * scale}"
    end

    def server_number
      Zlib.crc32(path) % SERVERS
    end

    def host
      "avatars#{server_number}.githubusercontent.com"
    end

    def url(scale = 1)
      "https://#{host}/#{path(scale)}"
    end

    def srcset
      (1..4).map { |scale| "#{url(scale)} #{scale}x" }.join(', ')
    end

    # See http://primercss.io/avatars/#small-avatars
    def classes
      size < 48 ? 'avatar avatar-small' : 'avatar'
    end
  end
end

Liquid::Template.register_tag('avatar', Jekyll::Avatar)
