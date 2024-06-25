module RpScripts
  class Executor
    class ExecutorDsl
      def initialize(_buffer)
        @buffer = _buffer
      end

      def puts(_object)
        @buffer << _object.to_s
        @buffer << "\n"
      end
    end

    def initialize(identifier, script)
      @identifier = identifier
      @script = script
    end

    def run
      return if already_run?

      prepare_output_buffer
      eval_script
      save_success
    rescue StandardError => e
      save_failure(e)
    end

    def safe_run
      ::ActiveRecord::Base.connection_handler.clear_all_connections!

      fork do
        ::ActiveRecord::Base.establish_connection
        run
      end

      Process.wait
    end

    private

    def already_run?
      RpScripts::Session.where(identifier: @identifier).exists?
    end

    def prepare_output_buffer
      @buffer = []
    end

    def eval_script
      dsl = ExecutorDsl.new(@buffer)
      dsl.instance_eval(@script)
    end

    def save_success
      RpScripts::Session.create!(identifier: @identifier, output: @buffer.join, success: true)
    end

    def save_failure(_error)
      @buffer << _error.message
      @buffer << _error.backtrace
      RpScripts::Session.create!(identifier: @identifier, output: @buffer.join, success: false)
    end
  end
end
