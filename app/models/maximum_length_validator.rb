class MaximumLengthValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    validator = Validator.new(value, record.send(options[:culomn]), options[:maximum])
    if validator.invalid?
      record.errors.add(attribute, "件名とと本文合わせて10文字以上で入力してください")
    end
  end

  class Validator
    attr_writer :value1, :value2, :maximum

    def initialize(value1, value2, maximum)
      @value1 = value1
      @value2 = value2
      @maximum = maximum
    end

    def value1
      @value1.to_s
    end

    def value2
      @value2.to_s
    end

    def maximum
      @maximum.blank? ? 10 : @maximum.to_i
    end

    def length
      (value1 + value2).length
    end

    def valid?
      length <= maximum
    end

    def invalid?
      !valid?
    end
  end
end