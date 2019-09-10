require "rails_helper"

RSpec.describe ArticleSearchQuery, type: :model do
  describe "#title" do
    let(:query) { ArticleSearchQuery.new(attributes) }

    context "@titleがある場合" do
      let(:attributes) { { title: "query" } }
      it { expect(query.title).to eq "%#{attributes[:title]}%" }
    end

    context "@titleがない場合" do
      let(:attributes) { {} }
      it { expect(query.title).to be_nil }
    end
  end

  describe "#articles" do
    let(:query) { ArticleSearchQuery.new(attributes) }
    let!(:articles) { create_list(:article, 3, title: "article") }

    before do
      travel_to Time.zone.local(2019, 1, 1) do
        create(:article, title: "article")
      end

      travel_to Time.zone.local(2019, 9, 5)
    end

    after do
      travel_back
    end

    context "検索条件がある場合" do
      let(:attributes) { { title: "article", from_date: "2019-09-01", to_date: "2019-10-01" } }
      it { expect(query.articles).to match_array(articles) }
    end

    context "検索条件がない場合" do
      let(:attributes) { {} }
      it { expect(query.articles).to match_array(Article.all) }
    end
  end
end
