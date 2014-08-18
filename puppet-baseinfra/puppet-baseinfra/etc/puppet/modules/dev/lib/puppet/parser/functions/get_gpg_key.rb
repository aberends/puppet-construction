#
# get_gpg_key.rb
#


module Puppet::Parser::Functions
  newfunction(:get_gpg_key,
              :type => :rvalue,
              :doc => <<-EOS
Returns a string with the name of the GPG key and the comment between parentheses. The provided string is the base64 encode GPG key.
EOS
  ) do |arguments|
    #require 'rubygems'
    require 'gpgme'
    require 'tmpdir'

    if (arguments.size != 1) then
      raise(Puppet::ParseError, "get_gpg_key(): Wrong number of arguments "+
        "given #{arguments.size} for 1")
    end

    g = ''
    Dir.mktmpdir {|dir|
      GPGME::Engine.home_dir = dir
      GPGME::Key.import(arguments[0])
      ctx = GPGME::Ctx.new
      ctx.each_key() do |key|
	g = "#{key.name()} (#{key.comment()})"
	break
      end
    }
    return g
  end
end

# vim: set ts=2 sw=2 et :
