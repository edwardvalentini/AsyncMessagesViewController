Pod::Spec.new do |s|
  s.name             = "AsyncMessagesViewController"
  s.version          = "0.5.3"
  s.summary          = "A smooth, responsive and flexible messages UI library for iOS."
  s.description      = <<-DESC
A smooth, responsive and flexible messages UI library for iOS. Built on top of the awesome AsyncDisplayKit framework, it takes full advantage of asynchronous sizing, (non-auto) layout and text rendering to deliver a 5x fps (subject to increase) scrolling experience.
                       DESC
  s.homepage         = "https://github.com/nguyenhuy/AsyncMessagesViewController"
  s.screenshots      = "https://raw.githubusercontent.com/nguyenhuy/AsyncMessagesViewController/master/Screenshots/screenshot1.png", "https://raw.githubusercontent.com/nguyenhuy/AsyncMessagesViewController/master/Screenshots/screenshot2.png"
  s.license          = 'MIT'
  s.author           = { "Huy Nguyen" => "no_email_for_huy@please_fill_this_in", "Edward Valentini" => "edward@interlook.com" }
  s.source           = { :git => "https://github.com/edwardvalentini/AsyncMessagesViewController.git", :tag => s.version.to_s }

  s.platform     = :ios, '9.0'
  s.ios.deployment_target = '9.0'

  s.pod_target_xcconfig = {
                 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
                 'DEFINES_MODULE ' => 'YES',
               }

  s.requires_arc = true

  s.source_files = ['AsyncMessagesViewController/**/*.{h,m,swift}']

  s.resource_bundles = {
                          'AsyncMessagesViewController' => ['AsyncMessagesViewController/Assets/AsyncMessagesViewController.bundle/*']
                        }

  s.dependency 'AsyncDisplayKit', '>= 2.0-rc.1'
  s.dependency 'SlackTextViewController', '~> 1.9.5'

end
