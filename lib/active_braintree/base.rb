module ActiveBraintree
  class Base
    include MagicAttributes

    def valid?
      @errors.empty?
    end

    def self.human_attribute_name attribute
      attribute.capitalize.gsub("_", " ")
    end

    protected
    def add_errors errors, opts = {}
      errors.each do |error|
        if opts[:on_base]
          @errors.add_to_base("#{error.message}")
        else
          @errors.add(error.attribute, "^#{error.message}")
        end
      end
    end
  end
end
