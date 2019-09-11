require 'rails_helper'

RSpec.describe ArticleSearchForm, type: :model do
  describe "#articles" do
    let(:form) { ArticleSearchForm.new(attributes) }
    let(:query) { instance_spy(ArticleSearchQuery, articles: []) }

    before do
      allow(ArticleSearchQuery).to receive(:new).with(args) { query }
      form.articles
    end

    context "valid?" do
      let(:from_date) { "2019-08-01" }
      let(:to_date) { "2019-08-31" }
      let(:attributes) { { title: "検索対象", from_date: from_date, to_date: to_date} }
      let(:args) { attributes.merge({from_date: from_date.to_time, to_date: to_date.to_time}) }

      it { expect(query).to have_received(:articles).once }
    end

    context "invalid?" do
      let(:attributes) { { title: "検索対象" * 10 } }
      let(:args) { {} }

      it { expect(query).to have_received(:articles).once }
    end
  end

  describe "#from_date" do
    let(:form) { ArticleSearchForm.new(attributes) }

    context "例外が発生しない場合" do
      let(:attributes) { { from_date: "2019-09-09" } }
      it { expect(form.from_date).to eq "2019-09-09".to_time }
    end

    context "例外が発生する場合" do
      let(:attributes) { { from_date: "invalid" } }
      it { expect(form.from_date).to be_nil }
    end
  end

  describe "#to_date" do
    let(:form) { ArticleSearchForm.new(attributes) }

    context "例外が発生しない場合" do
      let(:attributes) { { to_date: "2019-09-09" } }
      it { expect(form.to_date).to eq "2019-09-09".to_time }
    end

    context "例外が発生する場合" do
      let(:attributes) { {to_date: "invalid"} }
      it { expect(form.to_date).to be_nil }
    end
  end
end
