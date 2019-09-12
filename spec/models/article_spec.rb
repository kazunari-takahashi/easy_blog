require 'rails_helper'

RSpec.describe Article, type: :model do
  describe "#valid?" do
    context "件名と本文で10文字未満の場合はエラーになること" do
      let(:article) { build(:article, attributes) }

      context "invalid?" do
        let(:attributes) { { title: "件名", body: "本文"} }
        it { expect(article).to be_invalid }
      end

      context "valid?" do
        let(:attributes) { { title: "件名" * 5, body: "本文" * 5 } }
        it { expect(article).to be_valid }
      end
    end
  end
end
