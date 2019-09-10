require "rails_helper"

RSpec.describe ArticleSearchForm, type: :model do
  describe "#title" do
    let(:form) { ArticleSearchForm.new(attributes) }

    context "問題ない場合" do
      let(:attributes) { { title: "valid title" } }
      it { expect(form).to be_valid }
    end

    context "問題ある場合" do
      let(:attributes) { { title: "invalid title" * 5 } }
      it { expect(form).to be_invalid }
    end
  end

  describe "#articles" do
    let(:form) { ArticleSearchForm.new(attributes) }

    context "検索条件がvalidの場合" do
      let(:attributes) { { title: "selected article" } }
      let(:query) { instance_double(ArticleSearchQuery, articles: []) }

      before do
        allow(ArticleSearchQuery).to receive(:new) { query }
        form.articles
      end

      it { expect(query).to have_received(:articles).once }
    end

    context "検索条件がinvalidの場合" do
      let(:attributes) { { title: "article" * 10 } }

      before do
        allow(Article).to receive(:all)
        form.articles
      end

      it { expect(Article).to have_received(:all).once }
    end
  end

  describe "#from_date" do
    let(:form) { ArticleSearchForm.new(attributes) }

    context "@form_dateがある場合" do
      let(:attributes) { { from_date: "2020-10-09" } }
      it { expect(form.from_date).to eq "2020-10-09".to_datetime }
    end

    context "@form_dateがない場合" do
      let(:attributes) { {} }
      it { expect(form.from_date).to be_nil }
    end

    context "@form_dateが日時として評価できない場合" do
      let(:attributes) { { from_date: "now" } }
      it { expect(form.from_date).to be_nil }
    end
  end

  describe "#to_date" do
    let(:form) { ArticleSearchForm.new(attributes) }

    context "@to_dateがある場合" do
      let(:attributes) { { to_date: "2020-10-09" } }
      it { expect(form.to_date).to eq "2020-10-09".to_datetime }
    end

    context "@to_dateがない場合" do
      let(:attributes) { {} }
      it { expect(form.to_date).to be_nil }
    end

    context "@to_dateが日時として評価できない場合" do
      let(:attributes) { { to_date: "now" } }
      it { expect(form.to_date).to be_nil }
    end
  end
end
