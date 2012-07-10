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
          @differences << Removal.new(change.old_position, change.old_element.inspect)
          @differences << Addition.new(change.new_position, change.new_element.inspect)
        end
      end
    end

  end

end
