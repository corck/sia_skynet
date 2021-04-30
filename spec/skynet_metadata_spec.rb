# frozen_string_literal: true

RSpec.describe Skynet::Client do
  let(:subject) { described_class.new }

  describe 'metadata' do
    let(:skylink) { 'KAA54bKo-YqFRjDxRxGXdo9h15k84K8zl7ykrKw8kQyksQ' }

    context 'when requesting metadata' do
      it 'returns the metadata containing the file name' do
        expect(subject.get_metadata(skylink)).to include({ 'filename' => 'foo.pdf' })
      end
    end
  end
end
