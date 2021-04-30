# frozen_string_literal: true

RSpec.describe Skynet::Client do
  let(:subject) { described_class.new }

  describe 'download' do
    let(:path) { '/tmp/file.txt' }
    let(:skylink) { 'KAA54bKo-YqFRjDxRxGXdo9h15k84K8zl7ykrKw8kQyksQ' }

    context 'when downloading a file from skynet' do
      it 'saves a file to the provided path' do
        subject.download_file(path, skylink)
        expect(File.read(path)).to eq('foo-bar') # file content returned from request stub
      end
    end
  end
end
