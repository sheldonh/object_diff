require 'object_diff/difference'
require 'object_diff/base_diff'

module ObjectDiff

  class HashDiff < BaseDiff

    private

    def calculate_differences
      keys_from_both_hashes.each do |key|
        @key = key
        handle_differences_for_key
      end
    end

    def keys_from_both_hashes
      @old.keys.concat(@new.keys).sort.uniq
    end

    def handle_differences_for_key
      handle_removal_for_key or handle_addition_for_key or handle_change_for_key
    end

    def handle_removal_for_key
      if key_removed?
        add_removal_for_key
      end
    end

    def handle_addition_for_key
      if key_added?
        add_addition_for_key
      end
    end

    def handle_change_for_key
      if key_value_changed?
        add_change_for_key
      end
    end

    def key_removed?
      @old.include?(@key) and not @new.include?(@key)
    end

    def key_added?
      @new.include?(@key) and not @old.include?(@key)
    end

    def key_value_changed?
      old_value != new_value
    end

    def add_removal_for_key
      add_difference Removal.new(@key, old_value.inspect)
    end

    def add_addition_for_key
      add_difference Addition.new(@key, new_value.inspect)
    end

    def add_change_for_key
      if both_values_are_hash_like?
        add_differences_between_hash_like_values
      else
        add_removal_for_key
        add_addition_for_key
      end
    end

    def both_values_are_hash_like?
      hash_like?(old_value) and hash_like?(new_value)
    end

    def add_differences_between_hash_like_values
      differences_between_hash_like_values.each do |difference|
        nest_difference(difference)
      end
    end

    def differences_between_hash_like_values
      diff = self.class.new(old_value, new_value)
      diff.differences
    end

    def nest_difference(difference)
      nested_difference = difference.nested_under_key(@key)
      add_difference(nested_difference)
    end

    def hash_like?(object)
      object.respond_to?(:keys) and
      object.respond_to?(:include?) and
      object.respond_to?(:fetch)
    end

    def old_value
      @old.fetch(@key)
    end

    def new_value
      @new.fetch(@key)
    end

    def add_difference(difference)
      @differences << difference
    end

  end

end
