class MaximumLengthValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    validator = Validator.new(record, value, options)
    if validator.invalid?
      record.errors.add(attribute, "#{attribute}とと#{options[:culomn]}合わせて#{options[:maximum]}文字以上で入力してください")
    end
  end

  class Validator
    def initialize(record, value, options)
      @record = record
      @value = value
      @options = options
    end

    def value1
      @value.to_s
    end

    def value2
      return "" unless @options[:column]
      (@record.send(@options[:column])).to_s
    end

    def maximum
      @options[:maximum].blank? ? 10 : @options[:maximum].to_i
    end

    def length
      (value1 + value2).length
    end

    def valid?
      length >= maximum
    end

    def invalid?
      !valid?
    end
  end
end