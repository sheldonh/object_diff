module ObjectDiff

  class Difference

    def initialize(key, value)
      @key = key
      @value = value
    end

    def nested_under_key(key)
      self.class.new(key, to_string_without_sign)
    end

    def to_s
      to_string_with_sign
    end

    def to_string_with_sign
      "#{sign} #{to_string_without_sign}"
    end

    def to_string_without_sign
      "#{@key.inspect}: #{@value}"
    end

    def ==(other)
      self.class == other.class and
      @key == other.instance_variable_get('@key') and
      @value == other.instance_variable_get('@value')
    end

  end

  class Removal < Difference

    private

    SIGN = '-'

    def sign
      SIGN
    end
  
  end

  class Addition < Difference

    private

    SIGN = '+'

    def sign
      SIGN
    end

  end

end
