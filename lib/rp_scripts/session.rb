module RpScripts
  class Session < ::ActiveRecord::Base
    self.table_name = "rp_scripts_sessions"

    validates :identifier, presence: true

    def reusable?
      reusable_until.present? && reusable_until > Time.current
    end
  end
end
