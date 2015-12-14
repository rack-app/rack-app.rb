require 'spec_helper'

describe Rack::App::File::Streamer do

  let(:file_path) { '/file/path' }
  let(:instance) { described_class.new(file_path) }

  context 'given the file exist' do

    let(:file) { double('File/instance').as_null_object }
    before { allow(File).to receive(:open).with(file_path).and_return(file) }

    describe '#each' do

      it 'should yield the given block on the file object' do

        proc = Proc.new {}
        expect(file).to receive(:each) do |*args, &block|
          expect(proc).to be(block)
        end

        instance.each(&proc)

      end

      it 'should ensure to run file.close always' do
        expect(file).to receive(:close)

        instance.each(&(Proc.new {}))
      end

    end

    describe '#to_a' do
      subject { instance.to_a }
      context 'given the file has content' do
        before { allow(file).to receive(:to_a).and_return(["hello\n", "world\n"]) }

        it { is_expected.to eq ["hello", "world"] }
      end

    end

    describe '#render' do
      subject { instance.render(nil) }

      it { is_expected.to be instance }
    end

  end

end