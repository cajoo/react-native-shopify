require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-shopify-buy"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  react-native-shopify-buy
                   DESC
  s.homepage     = "https://github.com/magrinj/react-native-shopify-buy"
  s.license      = "MIT"
  s.authors      = { "Jérémy Magrin" => "contact@magrin.fr" }
  s.platforms    = { :ios => "12.0" }
  s.source       = { :git => "https://github.com/magrinj/react-native-shopify-buy.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,c,m,swift}"
  s.requires_arc = true

  s.dependency "React"
  s.dependency "Mobile-Buy-SDK", "~> 5.3.0"
end
