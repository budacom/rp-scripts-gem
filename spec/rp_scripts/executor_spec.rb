require 'spec_helper'

RSpec.describe RpScripts::Executor do
  let(:identifier) { '1' }
  let(:script) { "puts 'hello world'; puts 'foo bar'" }
  let(:description) { "prints hello world" }
  let(:reusable) { false }
  let(:executor) { described_class.new(identifier, script, description, reusable) }

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
      expect(RpScripts::Session.last.output).to eq "hello world\nfoo bar"
    end

    it 'stores description in session' do
      executor.run
      expect(RpScripts::Session.last.description).to eq "prints hello world"
    end

    context 'when execution fails' do
      let(:script) { "raise StandardError, 'foo'" }

      it 'creates a failed RpScriptsSession' do
        expect { executor.run }.to change { RpScripts::Session.count }.by 1
        expect(RpScripts::Session.last.success).to eq false
      end

      it 'stores exception message and backtrace in session' do
        executor.run
        lines = RpScripts::Session.last.output.split("\n")
        expect(lines.count).to be > 10
        expect(lines.first).to eq 'foo'
        expect(lines.second).to eq "(eval):1:in `eval_script'"
      end
    end
  end
end
