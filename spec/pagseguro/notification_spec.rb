require "spec_helper"

describe PagSeguro::Notification do
  it_assigns_attribute :code
  it_assigns_attribute :type

  it "detects notification as transaction" do
    expect(PagSeguro::Notification.new(type: "transaction")).to be_transaction
  end

  it "fetches transaction by its notificationCode" do
    PagSeguro::Transaction
      .should_receive(:find_by_notification_code)
      .with("CODE")

    PagSeguro::Notification.new(code: "CODE").transaction
  end
end
