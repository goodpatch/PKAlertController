#
# Be sure to run `pod lib lint PKAlertController.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "PKAlertController"
  s.version          = "0.1.1"
  s.summary          = "A short description of PKAlertController."
  s.description      = <<-DESC
                       An optional longer description of PKAlertController

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/goodpatch/PKAlertController"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Satoshi Ohki" => "ohki@goodpatch.com" }
  s.source           = { :git => "https://github.com/goodpatch/PKAlertController.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'PKAlertController' => ['Pod/Assets/*.{png,storyboard,lproj}']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'QuartzCore'
end
