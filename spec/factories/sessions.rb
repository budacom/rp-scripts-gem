FactoryBot.define do
  factory(:session, class: 'RpScripts::Session') do
    identifier { SecureRandom.uuid }
    success { false }
    output { "foo\nbar" }
  end
end
