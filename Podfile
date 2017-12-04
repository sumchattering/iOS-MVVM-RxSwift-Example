platform :ios, '10.0'
use_frameworks!

project 'CoolClothes.xcodeproj'

def core_pods
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'RxDataSources'
    pod 'APIKit'
    pod 'OHHTTPStubs/Swift'
    pod 'SDWebImage'
    pod 'RangeSeekSlider'
end

target 'CoolClothes' do
    core_pods
    # Enable DEBUG flag in Swift for SwiftTweaks
end

target 'CoolClothesTests' do
    core_pods
end

target 'CoolClothesIntegrationTests' do
    core_pods
    pod 'RxBlocking'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == 'RangeSeekSlider'
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.2'
            end
        end
    end
end
