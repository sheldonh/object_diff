require 'forwardable'

module MakingHashLikeObjects

  def hash_like(real_hash)
    HashLike.new(real_hash)
  end

  class HashLike

    extend Forwardable
    def_delegators :@real_hash, :keys, :include?, :fetch

    def initialize(real_hash)
      @real_hash = real_hash
    end

    private

    def delegee
      @real_hash
    end

  end

end
