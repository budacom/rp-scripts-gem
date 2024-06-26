require 'kubeclient'

module RpScripts
  class Watcher
    def initialize
      @stopped = false
    end

    def watch
      return if @stopped

      @watcher = client.watch_entities('configmaps', namespace: fetch_namespace)
      @watcher.each do |notice|
        next unless script_notice? notice
        next if notice[:type] != 'ADDED'

        executor = build_executor(notice)
        executor.safe_run
      end
    end

    def stop_watching
      @stopped = true
      @watcher.try(:finish)
    end

    private

    def script_notice?(_notice)
      _notice[:object][:metadata][:labels][:"buda.com/rp-scripts"].present? rescue false
    end

    def build_executor(_notice)
      RpScripts::Executor.new(
        _notice[:object][:metadata][:annotations]["rp-scripts.buda.com/pull-request"],
        _notice[:object][:data][:script],
        _notice[:object][:metadata][:annotations]["rp-scripts.buda.com/description"],
        _notice[:object][:metadata][:annotations]["rp-scripts.buda.com/reusable"].to_s == 'true'
      )
    end

    def client
      @client ||= Kubeclient::Client.new(
        'https://kubernetes.default.svc',
        'v1',
        auth_options: auth_options,
        ssl_options: ssl_options
      )
    end

    def auth_options
      {
        bearer_token_file: '/var/run/secrets/kubernetes.io/serviceaccount/token'
      }
    end

    def ssl_options
      {
        ca_file: '/var/run/secrets/kubernetes.io/serviceaccount/ca.crt'
      }
    end

    def fetch_namespace
      File.read('/var/run/secrets/kubernetes.io/serviceaccount/namespace')
    end
  end
end
