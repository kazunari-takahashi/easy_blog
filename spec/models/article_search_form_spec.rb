require 'rails_helper'

RSpec.describe ArticleSearchForm, type: :model do
  describe "#article" do
    let(:form) { ArticleSearchForm.new(attributes) }
    let(:articles) { create_list(:article, 3, title: "検索対象") }

    before do
      travel_to Time.zone.local(2019, 8, 10)
      create(:article)
    end

    after do
      travel_back
    end

    context "#valid?" do
      let(:attributes) { { title: "検索対象", from_date: "2019-08-01", to_date:  "2019-08-31"} }
      it {  expect(form.articles).to match_array(articles) }
    end

    context "#invalid?" do
      let(:attributes) { { title: "検索対象" * 10 } }
      it {  expect(form.articles).to match_array(Article.all) }
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
