$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'nokogiri'

module FAP
  VERSION = '0.0.1'

  autoload :FAP,        'fap/fap'
  autoload :Property,   'fap/property'
  autoload :Relation,   'fap/relation'
  autoload :Mixins,     'fap/mixins'
  autoload :Collection, 'fap/collection'

  # extracted from Extlib
  #
  # Constantize tries to find a declared constant with the name specified
  # in the string. It raises a NameError when the name is not in CamelCase
  # or is not initialized.
  #
  # @example
  # "Module".constantize #=> Module
  # "Class".constantize #=> Class
  def self.constantize(camel_cased_word)
    unless /\A(?:::)?([A-Z]\w*(?:::[A-Z]\w*)*)\z/ =~ camel_cased_word
      raise NameError, "#{camel_cased_word.inspect} is not a valid constant name!"
    end
    Object.module_eval "::#{$1}", __FILE__, __LINE__
  end
end

# *fap* *fap* *fap*
