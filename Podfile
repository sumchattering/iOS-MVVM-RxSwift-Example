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
end

target 'CoolClothes' do
    core_pods
end

target 'CoolClothesTests' do
    core_pods
end

target 'CoolClothesIntegrationTests' do
    core_pods
    pod 'RxBlocking'
end
