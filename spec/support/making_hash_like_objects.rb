module MakingHashLikeObjects

  def hash_like(hash)
    HashLike.new(hash)
  end

  class HashLike

    extend Forwardable
    def_delegators :@real_hash, :keys, :include?, :fetch

    def initialize(real_hash)
      @real_hash = real_hash
    end

  end

end
