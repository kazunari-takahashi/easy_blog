require 'rails_helper'

RSpec.describe ArticleSearchQuery, type: :model do
  describe "#articles" do
    subject { query.articles }

    before do
      travel_to Time.zone.local(2019, 8, 10)
      create(:article)
    end

    after do
      travel_back
    end

    let!(:articles) { create_list(:article, 3, title: "検索対象") }
    let(:query) { ArticleSearchQuery.new(attributes) }

    context "検索条件がある場合" do
      let(:attributes) { { title: "検索対象", from_date: "2019-08-01", to_date:  "2019-08-31"} }
      it { is_expected.to match_array(articles) }
    end

    context "検索条件がない場合" do
      let(:attributes) { {} }
      it { is_expected.to match_array(Article.all) }
    end
  end

  describe "#title" do
    subject { query.title }
    let(:query) { ArticleSearchQuery.new(title: title) }

    context "キーワードがある場合" do
      let(:title) { "検索対象" }
      it { is_expected.to eq "%#{Article.sanitize_sql_like(title)}%" }
    end

    context "キーワードがない場合" do
      let(:title) { nil }
      it { is_expected.to be_nil }
    end
  end
end
