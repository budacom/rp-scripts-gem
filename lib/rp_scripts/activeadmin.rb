ActiveAdmin.setup do |config|
  config.register RpScripts::Session do
    menu label: 'Custom Scripts', priority: 1000

    actions :index, :show, :perform_reuse

    index do
      column(:identifier)
      column(:created_at)
      column(:description)
      column(:output) { |s| truncate(s.output, length: 25) }
      column(:reusable, &:reusable?)
      actions
    end

    show do |session|
      attributes_table do
        row(:identifier)
        row(:created_at)
        row(:reusable) { session.reusable? }
        row(:description)
        row(:script) { simple_format(session.script) }
        row(:output) { simple_format(session.output) }
      end
    end

    action_item :reuse, only: :show do
      if resource.reusable?
        link_to(
          "Reuse",
          perform_reuse_admin_rp_scripts_session_path(resource),
          "data-confirm": "Run script again?"
        )
      end
    end

    member_action :perform_reuse do
      if resource.reusable?
        executor = RpScripts::Executor.new(
          "#{resource.identifier}-#{Time.now.to_i}",
          resource.script,
          resource.description,
          false
        )

        session = executor.run
        redirect_to admin_rp_scripts_session_path(session)
      else
        redirect_to admin_rp_scripts_session_path(resource)
      end
    end
  end
end
