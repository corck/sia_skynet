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

  describe 'upload a file' do
    let(:file) { File.path(__FILE__) }

    context 'uploading the file to sia' do
      it 'returns a sia link in the reponse' do
        expect(subject.upload_file(file, { full_response: true })).to include(
          'sialink' => 'sia://KAA54bKo-YqFRj345xGXdo9h15k84K8zl7ykrKw8kQyksQ',
          'merkleroot' => '39e1b2a8f98a854630f1471345768f61d7993ce0af3397bca4acac3c910ca4b1',
          'bitfield' => 40,
          'skylink' => 'KAA54bKo-YqFRj345xGXdo9h15k84K8zl7ykrKw8kQyksQ'
        )
      end

      it 'returns sia link as string by default' do
        expect(subject.upload_file(file)).to eq 'sia://KAA54bKo-YqFRj345xGXdo9h15k84K8zl7ykrKw8kQyksQ'
      end
    end
  end
end
