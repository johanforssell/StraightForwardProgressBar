#
# Be sure to run `pod lib lint StraightForwardProgressBar.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "StraightForwardProgressBar"
  s.version          = "0.1"
  s.summary          = "Just a bar of color to indicate progress"
  s.description      = <<-DESC
                        View controller which is a progress bar.

                        Can use a NSProgress object or just a property.
                       DESC
  s.homepage         = "https://github.com/johanforssell/StraightForwardProgressBar"
  s.license          = 'MIT'
  s.author           = { "Johan Forssell" => "johan.forssell@dohi.se" }
  s.source           = { :git => "https://github.com/johanforssell/StraightForwardProgressBar.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/jforssell'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
end
