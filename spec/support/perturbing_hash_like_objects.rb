module PerturbingHashLikeObjects

  def self.perturb(hash_like)
    HashLikePerturbation.new(hash_like).perturb
  end

  class HashLikePerturbation

    def initialize(hash_like)
      @hash_like = hash_like
    end

    def perturb
      @key = :perturbation
      make_value_numeric
      increment_value
    end

    private

    def make_value_numeric
      unless current_value.is_a?(Numeric)
        set_value(0)
      end
    end

    def increment_value
      set_value(current_value + 1)
    end

    def current_value
      actual_hash.fetch(@key, 0)
    end

    def set_value(value)
      actual_hash.store(@key, value)
    end

    def actual_hash
      if hash_has_a_delegee
        delegee_of_hash
      else
        @hash_like
      end
    end

    def hash_has_a_delegee
      @hash_like.private_methods.include? :delegee
    end

    def delegee_of_hash
      @hash_like.send :delegee
    end

  end

end
