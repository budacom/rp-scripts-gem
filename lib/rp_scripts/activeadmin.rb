ActiveAdmin.setup do |config|
  config.register RpScripts::Session do
    menu label: 'Custom Scripts', priority: 1000
    actions :index, :show
  end
end
