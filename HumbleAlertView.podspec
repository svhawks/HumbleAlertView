Pod::Spec.new do |s|
  s.name         = "HumbleAlertView"
  s.version      = "1.0.1"
  s.summary      = "Temporary and unobtrusive translucent alert view for iOS."
  s.description  = <<-DESC
  HumbleAlertView is a humble view to display automagically disappearing information to your users.
                   DESC
  s.homepage     = "https://github.com/svtek/HumbleAlertView"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author             = { "okaris" => "ok@okaris.com" }
  s.social_media_url   = "http://twitter.com/okarisman"
  s.source       = { :git => "https://github.com/svtek/HumbleAlertView.git", :tag => "#{s.version}" }
  s.source_files = 'Classes/*.swift'
  s.ios.deployment_target = '9.0'
  s.framework    =  'QuartzCore'
end
