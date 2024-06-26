module RpScripts
  class Executor
    SCRIPT_LIFESPAN_DAYS = 5

    class ExecutorDsl
      def initialize(_buffer)
        @buffer = _buffer
      end

      def puts(_object)
        @buffer << _object.to_s
        @buffer << "\n"
      end
    end

    def initialize(identifier, script, description, reusable)
      @identifier = identifier
      @script = script
      @description = description
      @reusable = reusable
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
      RpScripts::Session.create!(identifier: @identifier, script: @script, output: @buffer.join,
                                 success: true, reusable_until: reusable_until)
    end

    def save_failure(_error)
      @buffer << _error.message
      @buffer << _error.backtrace
      RpScripts::Session.create!(identifier: @identifier, script: @script, output: @buffer.join,
                                 success: false, reusable_until: reusable_until)
    end

    def reusable_until
      return nil unless @reusable

      Time.current + SCRIPT_LIFESPAN_DAYS.days
    end
  end
end
