module FAP
  class Relation
    attr_reader :name, :type, :xpath, :klass
    attr_accessor :from

    def initialize name, opt={}
      @name  = name
      @type  = opt[:type]
      @xpath = opt[:xpath] || name
      @klass = opt[:class] || nil
      @from  = opt[:from]  || nil
    end

  end
end
