# frozen_string_literal: true

RSpec.describe Skynet::Client do
  let(:subject) { described_class.new }

  describe 'portal url' do
    it 'defaults the portal to siasky' do
      expect(subject.config[:portal]).to eq 'https://siasky.net'
    end

    context 'allows to set a custom portal' do
      let(:subject) { described_class.new(portal: 'https://foo.bar.com') }

      it 'and sets the portal to the custom portal' do
        expect(subject.config[:portal]).to eq 'https://foo.bar.com'
      end
    end
  end

  describe 'portal path' do
    context 'with custom dirname' do
      let(:subject) { described_class.new(dirname: 'my_dir') }

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

    context 'setting a custom filename on initilize' do
      let(:subject) { described_class.new(filename: "bar.html")}
      it 'sends a param filename with the provided filename' do
        request = double()
        expect(Typhoeus).to receive(:post).with(
          "https://siasky.net/skynet/skyfile/",
          hash_including(
            params: hash_including(filename: 'bar.html')
          ),
          any_args
        ).and_return(double(body: "{}"))
        subject.upload_file(file)
      end
    end


    context 'setting a custom filename' do
      let(:subject) { described_class.new(filename: "bar.html")}
      it 'sends a param filename with the provided filename' do
        request = double()
        expect(Typhoeus).to receive(:post).with(
          "https://siasky.net/skynet/skyfile/",
          hash_including(
            params: hash_including(filename: 'foo.html')
          ),
          any_args
        ).and_return(double(body: "{}"))
        subject.upload_file(file, { filename: "foo.html" })
      end
    end
  end


  context 'uploading a directory' do
    let(:directory) { File.join(File.dirname(__FILE__), 'uploads/html') }

    it 'sends all files' do
      expect(subject.upload_directory(directory)).to eq({})


    end
  end
end
