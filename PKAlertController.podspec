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
  s.version          = "0.2.4"
  s.summary          = "PKAlertController is a highly customizable alert view controller."
  s.description      = <<-DESC
                      PKAlertController is a flexible, highly customizable, many view transitional animation popup view controller.

                      * `PKAlertController` has the title and description label, and you can set a text alignment.
                      * Made with UIViewController-based, so that you can call it as the modal view controller, or add it to some view controller.
                      * There are many cutom view controller transitions.
                      * There are some layout styles, and it is the style of the size about the same as a UIAlertview, the flexible size and the fullscreen size.
                      * To customize UI Color theme, use the class that inherited `PKAlertDefaultTheme`.
                      * The view content is customizable to set a custom view same as a titleView of UINavigationItem.

  DESC
  s.homepage         = "https://github.com/goodpatch/PKAlertController"

  screenshot_url_prefix = "https://raw.githubusercontent.com/goodpatch/PKAlertController/master/"
  s.screenshots     = "#{screenshot_url_prefix}screenshotdefault.gif", "#{screenshot_url_prefix}screenshotwhiteblue.gif", "#{screenshot_url_prefix}screenshottransitions.gif"
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
