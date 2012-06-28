module ObjectDiff

  class Difference

    attr_accessor :key, :value

    def initialize(key, value)
      @key, @value = key, value
    end

    def to_s
      raise NotImplementedError
    end

    def ==(other)
      self.class == other.class and key == other.key and value == other.value
    end

  end

  class Removal < Difference

    def to_s
      "- #{@key.inspect}: #{@value.inspect}"
    end

  end

  class Addition < Difference

    def to_s
      "+ #{@key.inspect}: #{@value.inspect}"
    end

  end

end
