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
      if both_values_are_hashes?
        recursively_add_changes_for_nested_hashes
      else
        add_removal_for_key
        add_addition_for_key
      end
    end

    def both_values_are_hashes?
      old_value.is_a?(Hash) and new_value.is_a?(Hash)
    end

    def recursively_add_changes_for_nested_hashes
      nested_hash_differences.each do |nested_difference|
        add_nested_difference(nested_difference)
      end
    end

    def nested_hash_differences
      nested_diff = NestedHashDiff.new(old_value, new_value)
      nested_diff.send(:differences)
    end

    def add_nested_difference(nested_difference)
      add_difference(nested_difference.class.new(@key, nested_difference.to_s))
    end

    def old_value
      @old[@key]
    end

    def new_value
      @new[@key]
    end

    def add_difference(difference)
      set_sign_display_in_difference(difference)
      @differences << difference
    end

    def set_sign_display_in_difference(difference)
      difference.include_sign_in_display = include_sign_in_display_at_this_level
    end

    def include_sign_in_display_at_this_level
      true
    end

    class NestedHashDiff < self

      def include_sign_in_display_at_this_level
        false
      end

    end

  end

end
