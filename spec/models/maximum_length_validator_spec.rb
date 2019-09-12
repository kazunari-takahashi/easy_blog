require 'rails_helper'

RSpec.describe MaximumLengthValidator, type: :model do
  describe "#validate_each" do
    let(:record) { build(:article) }
    let(:attribute) { :body }
    let(:value) { "本文" }
    let(:maximum) { 10 }
    let(:validator) { MaximumLengthValidator.new({ attributes: [attribute] }.merge({ maximum: maximum, culomn: :title })) }
    let(:args) { [value, record.title, maximum] }
    let(:inner_validator) { instance_spy(MaximumLengthValidator::Validator, invalid?: invalid) }

    before do
      allow(MaximumLengthValidator::Validator).to receive(:new).with(*args) { inner_validator }
      validator.validate_each(record, attribute, value)
    end

    context "valid?" do
      let(:invalid) { false }

      it :aggregate_failures do
        expect(inner_validator).to have_received(:invalid?).once
        expect(record.errors.count).to eq 0
      end
    end

    context "#invalid?" do
      let(:invalid) { true }

      it :aggregate_failures do
        expect(inner_validator).to have_received(:invalid?).once
        expect(record.errors.count).to eq 1
      end
    end
  end

  context "culomn がないの場合" do
    let(:klass) do
      Class.new do
        include ActiveModel::Model
        attr_accessor :title, :body
        validates :body, maximum_length: { maximum: 10 }
      end
    end

    let(:model) { klass.new(title: "a" * 10) }

    it { expect(model).to be_invalid }
  end

  context "maximum がないの場合" do
    let(:klass) do
      Class.new do
        include ActiveModel::Model
        attr_accessor :title, :body
        validates :body, maximum_length: true
      end
    end

    let(:model) { klass.new(title: "a" * 10) }

    it { expect(model).to be_invalid }
  end

  context "maximum がないの場合" do
    let(:klass) do
      Class.new do
        include ActiveModel::Model
        attr_accessor :title, :body
        validates :body, maximum_length: { foo: nil }
      end
    end

    let(:model) { klass.new(title: "a" * 10) }

    it { expect(model).to be_invalid }
  end
end

RSpec.describe MaximumLengthValidator::Validator, type: :model do
  describe "#value1" do
    subject { validator.value1 }
    let(:validator) { MaximumLengthValidator::Validator.new(nil, value,{}) }

    context "文字列の場合" do
      let(:value) { "a" * 3 }
      it { is_expected.to eq value }
    end

    context "数字の場合" do
      let(:value) { 1 }
      it { is_expected.to eq "1" }
    end

    context "nilの場合" do
      let(:value) { nil }
      it { is_expected.to eq "" }
    end
  end

  describe "#value2" do
    subject { validator.value2 }

    let(:article) { build(:article, title: value) }
    let(:validator) { MaximumLengthValidator::Validator.new(article, nil, { column: :title }) }

    context "文字列の場合" do
      let(:value) { "a" * 3 }
      it { is_expected.to eq value }
    end

    context "数字の場合" do
      let(:value) { 1 }
      it { is_expected.to eq "1" }
    end

    context "nilの場合" do
      let(:value) { nil }
      it { is_expected.to eq "" }
    end
  end

  describe "#maximum" do
    subject { validator.maximum }
    let(:validator) { MaximumLengthValidator::Validator.new(nil, nil, { maximum: maximum } ) }

    context "指定がある場合" do
      let(:maximum) { 3 }
      it { is_expected.to eq maximum }
    end

    context "空文字を指定した場合" do
      let(:maximum) { "" }
      it { is_expected.to eq 10 }
    end

    context "指定があって数字じゃない場合" do
      let(:maximum) { "A" }
      it { is_expected.to eq 0 }
    end

    context "nilの場合" do
      let(:maximum) { nil }
      it { is_expected.to eq 10 }
    end
  end

  describe "#valid?" do
    let(:article) { build(:article, title: value1, body: value2) }
    let(:validator) { MaximumLengthValidator::Validator.new(article, value1, { maximum: 1 }) }

    context "invalidの時" do
      let(:value1) { "" }
      let(:value2) { "" }

      it { expect(validator).to be_invalid }
    end

    context "validの時" do
      let(:value1) { "a" * 1 }
      let(:value2) { "b" * 2 }

      it { expect(validator).to be_valid }
    end
  end
end