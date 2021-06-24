require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it {should allow_value('netflix.com').for(:url)}
  it {should_not allow_value('netflixcom').for(:url)}

  describe '#gist?' do
    let(:question) { create(:question) }
    let(:gist) { create(:link, url: 'https://gist.github.com/qrkate/afcfad7af3004b6a9ae0fb3193e6afdc') }

    context 'when return true' do
      it { expect(gist).to be_gist }
    end

    context 'when return false' do
      it { expect(create(:link)).to_not be_gist }
    end
  end
end
