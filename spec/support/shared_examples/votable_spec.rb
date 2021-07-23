shared_examples "votable" do
  it { is_expected.to have_many(:votes).dependent(:destroy) }

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:votable) { create(described_class.to_s.underscore.to_sym) }
  let!(:vote) { create(:vote, user: user, votable: votable) }
  let!(:vote2) { create(:vote, user: another_user, votable: votable) }

  describe '#rating' do
    it { expect(votable.rating).to eq(2) }
  end

  describe '#revote' do
    before { votable.revote(user) }
    it { expect(votable.rating).to eq(1) }
  end
end
