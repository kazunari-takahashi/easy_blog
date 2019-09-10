require "rails_helper"

RSpec.describe CreateArticleWithNotify, type: :model do
  describe "#save" do
    let(:article) { build(:article, attributes) }
    let(:notify) { CreateArticleWithNotify.new(article) }
    let(:message_delivery) { instance_spy(ActionMailer::MessageDelivery, deliver_now: true) }

    before do
      allow(ArticleMailer).to receive(:new_article).with(article) { message_delivery }
    end

    context "保存が成功した場合" do
      let(:attributes) { { title: "TITLE" } }

      it :aggregate_failures do
        expect(notify.save).to eq true
        expect(message_delivery).to have_received(:deliver_now).once
      end
    end

    context "保存が失敗した場合" do
      let(:attributes) { { title: nil } }

      it :aggregate_failures do
        expect(notify.save).to eq false
        expect(message_delivery).to have_received(:deliver_now).exactly(0).times
      end
    end
  end
end
