module ActiveBraintree
  module MagicAttributes
    require 'ostruct'

    def self.included(base)
      base.extend(ClassMethods)
    end

    protected

    def attributes
      self.class.attrs
    end

    def set_attributes(result, opts = { :except => [] })
      if result.is_a?(Hash)
        result = OpenStruct.new(result)
      end

      (attributes - opts[:except]).each do |attr|
        instance_variable_set("@#{attr}".to_sym, result.send(attr))
      end
    end

    module ClassMethods
      def attributes(*attrs)
        @attrs ||= []
        @attrs.concat attrs
        attr_reader(*attrs)
      end

      def attrs
        @attrs
      end
    end
  end
end
