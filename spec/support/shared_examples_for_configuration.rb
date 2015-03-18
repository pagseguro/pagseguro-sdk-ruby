RSpec.shared_examples "a configuration" do
  it { is_expected.to respond_to(:email) }
  it { is_expected.to respond_to(:email=) }
  it { is_expected.to respond_to(:receiver_email) }
  it { is_expected.to respond_to(:receiver_email=) }
  it { is_expected.to respond_to(:token) }
  it { is_expected.to respond_to(:token=) }
  it { is_expected.to respond_to(:environment) }
  it { is_expected.to respond_to(:environment=) }
end
