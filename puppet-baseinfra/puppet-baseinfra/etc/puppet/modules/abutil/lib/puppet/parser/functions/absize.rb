#
# absize.rb
#

# AB: removed the Float(item) from the original size
# function in stdlib. Reason, we want to be able to check on
# strings from YAML files, like '2.1'. With the stdlib
# version of size it fail because it tries to covert it to a
# float. This is an unwanted side effect for our use cases.

module Puppet::Parser::Functions
  newfunction(:absize, :type => :rvalue, :doc => <<-EOS
Returns the number of elements in a string or array.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "absize(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    item = arguments[0]

    if item.is_a?(String)

      begin
        result = item.size
      end

    elsif item.is_a?(Array)
      result = item.size
    else
      raise(Puppet::ParseError, 'absize(): Unknown type given')
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
