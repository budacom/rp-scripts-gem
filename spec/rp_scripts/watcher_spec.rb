require 'spec_helper'

RSpec.describe RpScripts::Watcher do
  let(:kubernetes_client) { instance_double('Kubeclient::Client') }
  let(:executor) { instance_double('RpScripts::Executor') }
  let(:watcher) { described_class.new }
  let(:type) { "ADDED" }
  let(:notice) do
    Kubeclient::Resource.new(
      type: type,
      object: {
        kind: "ConfigMap",
        apiVersion: "v1",
        metadata: {
          name: "kube-root-ca.crt",
          namespace: "rails-operator",
          uid: "5c74110d-d271-471c-bcc4-8723b80c8928",
          resourceVersion: "757",
          creationTimestamp: "2024-06-24T19:01:14Z",
          annotations: {
            "rp-scripts.buda.com/pull-request": "2032",
            "rp-scripts.buda.com/respository": "github.com/budacom/rp-scripts",
            "kubernetes.io/description": "description"
          },
          labels: {
            "buda.com/rp-scripts": "1.0"
          }
        },
        data: {
          script: "puts 'hello world'"
        }
      }
    )
  end

  describe '#watch' do
    before do
      allow(RpScripts::Executor).to receive(:new).and_return(executor)
      allow(executor).to receive(:safe_run).and_return(true)
      allow(File).to receive(:read).with('/var/run/secrets/kubernetes.io/serviceaccount/namespace')
                                   .and_return('test-namespace')
      allow(Kubeclient::Client).to receive(:new).and_return(kubernetes_client)
      allow(kubernetes_client)
        .to receive(:watch_entities)
        .and_return([notice])
    end

    it 'creates an Executor with the correct params' do
      watcher.watch
      expect(RpScripts::Executor).to have_received(:new).with("2032", "puts 'hello world'")
    end

    it 'executes the script for added entities' do
      watcher.watch
      expect(executor).to have_received(:safe_run)
    end

    context 'when there are no added entities' do
      let(:type) { "DELETED" }

      it 'does not executes the script' do
        watcher.watch
        expect(executor).not_to have_received(:safe_run)
      end
    end
  end
end
