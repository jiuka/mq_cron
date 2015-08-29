module MqCron
  class RoutingKeyMatcher

    def initialize(key)
      @key = key.gsub('.', '\.')
      @key.gsub!('*','[a-zA-Z0-9]+')
      @key.gsub!(/(\\\.)?#(\\\.)?/, '(\1[a-zA-Z0-9\.]+\2|\.)?')
      @key = Regexp.new "^#{@key}$"
    end

    def match?(key)
      @key.match(key)
    end

  end
end
