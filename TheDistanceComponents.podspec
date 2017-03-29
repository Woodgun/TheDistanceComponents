Pod::Spec.new do |s|

  s.name         = "TheDistanceComponents"
  s.version      = "0.7"
  s.summary      = "Building Blocks for Great iOS Apps from The Distance."
  s.homepage     = "https://github.com/thedistance"
  s.license      = "MIT"
  s.author       = { "The Distance" => "dev@thedistance.co.uk" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/thedistance/TheDistanceComponents.git", :tag => "#{s.version}" }

  s.ios.deployment_target = "8.0"

  s.requires_arc = true
  
  s.module_name = "TDCAppDependencies"
    
  s.default_subspec = "TDCAppDependencies"
  
  s.subspec 'TDCContentLoading' do |cont|
    cont.source_files = 'TDCContentLoading/**/*.swift'
    cont.dependency 'ReactiveSwift'
  end  
  
  s.subspec 'TDCAppDependencies' do |app|
    app.source_files = 'TDCAppDependencies/**/*.{h,m,swift}'
    app.dependency 'ReactiveSwift'
  end  

end
