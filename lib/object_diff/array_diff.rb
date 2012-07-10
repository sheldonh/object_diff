require 'object_diff/base_diff'
require 'object_diff/difference'

require 'rubygems'
require 'diff/lcs'

module ObjectDiff

  class ArrayDiff < BaseDiff

    private

    ADDITION = '+'
    REMOVAL = '-'
    CHANGE = '!'

    def calculate_differences
      Diff::LCS.sdiff(@old, @new).flatten.each do |change|
        case change.action
        when REMOVAL
          @differences << Removal.new(change.old_position, change.old_element.inspect)
        when ADDITION
          @differences << Addition.new(change.new_position, change.new_element.inspect)
        when CHANGE
          if change.old_element.is_a?(Array) and change.new_element.is_a?(Array)
            @lcs_change = change
            add_differences_between_array_values
          else
            @differences << Removal.new(change.old_position, change.old_element.inspect)
            @differences << Addition.new(change.new_position, change.new_element.inspect)
          end
        end
      end
    end

    # Cut'n'pasted'n'renamed (and renamed differences_between_hash_like_values to *_array_values)
    def add_differences_between_array_values
      differences_between_array_values.each do |difference|
        nest_difference(difference)
      end
    end

    # Cut'n'pasted'n'renamed
    def differences_between_array_values
      diff = self.class.new(old_value, new_value)
      diff.differences
    end

    # Cut'n'pasted
    def nest_difference(difference)
      index_to_nest_under = difference.is_a?(Removal) ? old_index : new_index
      nested_difference = difference.nested_under_key(index_to_nest_under)
      add_difference(nested_difference)
    end

    # Cut'n'pasted
    def add_difference(difference)
      @differences << difference
    end

    def old_index
      @lcs_change.old_position
    end

    def new_index
      @lcs_change.new_position
    end

    def old_value
      @lcs_change.old_element
    end

    def new_value
      @lcs_change.new_element
    end

  end

end
