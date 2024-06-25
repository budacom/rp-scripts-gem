module RpScripts
  class Session < ::ActiveRecord::Base
    self.table_name = "rp_scripts_sessions"

    validates :identifier, presence: true
  end
end
