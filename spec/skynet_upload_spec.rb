# frozen_string_literal: true

RSpec.describe Skynet::Client do
  let(:subject) { described_class.new }

  describe 'portal url' do
    it 'defaults the portal to siasky' do
      expect(subject.portal).to eq 'https://siasky.net'
    end

    context 'allows to set a custom_portal' do
      let(:subject) { described_class.new(custom_portal: 'https://foo.bar.com') }

      it 'and sets the portal to the custom portal' do
        expect(subject.portal).to eq 'https://foo.bar.com'
      end
    end
  end

  describe 'portal path' do
    context 'with custom dirname' do
      let(:subject) { described_class.new(custom_dirname: 'my_dir') }

      it 'appends a custom dirname' do
        expect(subject.send(:portal_path)).to eq '/skynet/skyfile/my_dir'
      end
    end

    context 'with no custom dirname' do
      it 'returns the base path' do
        expect(subject.send(:portal_path)).to eq '/skynet/skyfile/'
      end
    end
  end
end
