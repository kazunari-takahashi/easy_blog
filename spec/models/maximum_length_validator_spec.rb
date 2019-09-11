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
end

RSpec.describe MaximumLengthValidator::Validator, type: :model do
  describe "#value1" do
    let(:validator) { MaximumLengthValidator::Validator.new(value, nil, nil) }

    context "文字列の場合" do
      let(:value) { "a" * 3 }
      it { expect(validator.value1).to eq value }
    end

    context "数字の場合" do
      let(:value) { 1 }
      it { expect(validator.value1).to eq "1" }
    end

    context "nilの場合" do
      let(:value) { nil }
      it { expect(validator.value1).to eq "" }
    end
  end

  describe "#value2" do
    let(:validator) { MaximumLengthValidator::Validator.new(nil, value, nil) }

    context "文字列の場合" do
      let(:value) { "a" * 3 }
      it { expect(validator.value2).to eq value }
    end

    context "数字の場合" do
      let(:value) { 1 }
      it { expect(validator.value2).to eq "1" }
    end

    context "nilの場合" do
      let(:value) { nil }
      it { expect(validator.value2).to eq "" }
    end
  end

  describe "#maximum" do
    subject { validator.maximum }
    let(:validator) { MaximumLengthValidator::Validator.new(nil, nil, maximum) }

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
    let(:maximum) { 1 }
    let(:validator) { MaximumLengthValidator::Validator.new(value1, value2, maximum) }

    context "validの時" do
      let(:value1) { "" }
      let(:value2) { "" }

      it { expect(validator).to be_valid }
    end

    context "invalidの時" do
      let(:value1) { "a" * 1 }
      let(:value2) { "b" * 2 }

      it { expect(validator).to be_invalid }
    end
  end
end