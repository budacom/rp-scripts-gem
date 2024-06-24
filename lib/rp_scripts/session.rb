module RpScripts
  class Session < ::ActiveRecord::Base
    self.table_name = "rp_scripts_sessions"

    validates :identifier, :success, :output, presence: true
  end
end
