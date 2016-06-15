Pod::Spec.new do |s|
  s.name             = "AsyncMessagesViewController"
  s.version          = "0.0.1"
  s.summary          = "A smooth, responsive and flexible messages UI library for iOS."
  s.description      = <<-DESC
A smooth, responsive and flexible messages UI library for iOS. Built on top of the awesome AsyncDisplayKit framework, it takes full advantage of asynchronous sizing, (non-auto) layout and text rendering to deliver a 5x fps (subject to increase) scrolling experience.
                       DESC
  s.homepage         = "https://github.com/nguyenhuy/AsyncMessagesViewController"
  s.screenshots     = "https://raw.githubusercontent.com/nguyenhuy/AsyncMessagesViewController/master/Screenshots/screenshot1.png", "https://raw.githubusercontent.com/nguyenhuy/AsyncMessagesViewController/master/Screenshots/screenshot2.png"
  s.license          = 'MIT'
  s.author           = { "Huy Nguyen" => "no_email_for_huy@please_fill_this_in", "Edward Valentini" => "edward@interlook.com" }
  s.source           = { :git => "git@github.com:edwardvalentini/AsyncMessagesViewController.git", :tag => s.version.to_s }

  s.platform     = :ios, '9.0'
  s.ios.deployment_target = '9.0'

  s.requires_arc = true


  s.source_files = ['Source/**/*.{h,m,swift}']

  s.resources = ['Source/Assets/**/*']

  s.dependency 'AsyncDisplayKit', '~> 1.9'
  s.dependency 'SlackTextViewController', '~> 1.7'
  s.development_dependency 'LoremIpsum', '~> 1.0'

end
