FactoryBot.define do
  factory(:session, class: 'RpScripts::Session') do
    identifier { SecureRandom.uuid }
    success { true }
    output { "foo\nbar" }
  end
end
