Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self, :https
    policy.font_src    :self, :https, :data, 'stackpath.bootstrapcdn.com', 'cdn.scite.ai'
    policy.img_src     :self, :https, :data, 'gighive.tech', '102.37.33.129'
    policy.object_src  :none
    policy.script_src  :self, :https, 'code.jquery.com', 'stackpath.bootstrapcdn.com', :unsafe_inline
    policy.style_src   :self, :https, 'stackpath.bootstrapcdn.com', 'cdn.scite.ai', :unsafe_inline
  end

  config.content_security_policy_nonce_generator = ->(request) { SecureRandom.base64(16) }
  config.content_security_policy_nonce_directives = %w(script-src)
end
