#
#  Be sure to run `pod spec lint Welian_Coco_Demo.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

s.name         = "Welian_Coco_Demo"
s.version      = "0.0.3"
s.summary      = "welian, weliandemo, 微链的重用库 ,Welian_Coco_Demo."
s.homepage     = "https://github.com/liuwu/Welian_Coco_Demo"
s.license      = "MIT"
s.author       = { "liuwu" => "liuwugui@gmail.com" }
s.platform     = :ios, "7.0"
s.source       = { :git => "https://github.com/liuwu/Welian_Coco_Demo.git", :tag => "v0.0.3" }
s.source_files  = "Welian_Coco_Demo", "Welian_Coco_Demo/**/*.{h,m}"
s.frameworks = "CoreGraphics", "CoreFoundation" , "UIKit", "libz"

end
