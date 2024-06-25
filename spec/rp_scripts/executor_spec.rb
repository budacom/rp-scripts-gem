require 'spec_helper'

RSpec.describe RpScripts::Executor do
  let(:identifier) { '1' }
  let(:script) { "puts 'hello world'" }
  let(:executor) { described_class.new(identifier, script) }

  describe '#run' do
    it 'creates a succeful RpScriptsSession' do
      expect { executor.run }.to change { RpScripts::Session.count }.by 1
      expect(RpScripts::Session.last.success).to eq true
    end

    it 'stores identifier in session' do
      executor.run
      expect(RpScripts::Session.last.identifier).to eq "1"
    end

    it 'stores output in session' do
      executor.run
      expect(RpScripts::Session.last.output).to eq "hello world\n"
    end

    context 'when execution fails' do
      let(:script) { "raise StandardError, 'foo'" }

      it 'creates a failed RpScriptsSession' do
        expect { executor.run }.to change { RpScripts::Session.count }.by 1
        expect(RpScripts::Session.last.success).to eq false
      end

      it 'stores exception in session' do
        executor.run
        expect(RpScripts::Session.last.output).to include "foo"
      end
    end
  end
end
