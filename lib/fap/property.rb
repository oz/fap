module FAP
  class Property
    attr_reader :name, :type, :xpath, :attribute

    def initialize name, opt={}
      @name      = name
      @type      = opt[:type]  || 'String'
      @xpath     = opt[:xpath] || name.to_s
      @attribute = opt[:get]   || nil
    end

    ##
    # Cast a Nokogiri node value to @type
    # @param [Nokogiri::XML::Element] a node
    # @return value of type @type
    def cast node
      raise "Invalid XML node" if node.nil?
      what = @attribute ? node[@attribute.to_s] : node.text
      case @type
      when 'Fixnum'
        what.to_i 10
      when 'DateTime'
        DateTime.parse what
      when 'URI'
        URI.parse what
      when 'String'
        what.to_s
      else
        ::FAP.constantize(@type).new(what)
      end
    end
  end
end
