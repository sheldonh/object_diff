module ObjectDiff

  class Difference

    attr_accessor :include_sign_in_display

    def initialize(key, value)
      @key = key
      @value = value
      @include_sign_in_display = true
    end

    def to_s
      if @include_sign_in_display
        as_string_with_sign
      else
        as_string_without_sign
      end
    end

    def as_string_with_sign
      "#{self.class::SIGN} #{@key.inspect}: #{@value}"
    end

    def as_string_without_sign
      "#{@key.inspect}: #{@value}"
    end

    def ==(other)
      self.class == other.class and
      @key == other.instance_variable_get('@key') and
      @value == other.instance_variable_get('@value')
    end

  end

  class Removal < Difference
    
    SIGN = '-'
  
  end

  class Addition < Difference

    SIGN = '+'

  end

end
