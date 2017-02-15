
Pod::Spec.new do |s|
s.name         = "SRInfiniteCarouselView"
s.version      = "2.0.0"
s.summary      = "Creating infinite carousel view with local images or the urls of images.(图片轮播器)"
s.description  = "Only use two UIImageView to achieve infinite carousel; Do not rely on any third-party libraries, use the native API to download and cache images; Support for manually deleting cached carousel images in the sandbox; UIPageControl will be displayed on the right If there are descriptions of the contents of the images or displayed on the center."
s.homepage     = "https://github.com/guowilling/SRInfiniteCarouselView"
s.license      = "MIT"
s.author       = { "guowilling" => "guowilling90@gmail.com" }
s.platform     = :ios, "7.0"
s.source       = { :git => "https://github.com/guowilling/SRInfiniteCarouselView.git", :tag => "#{s.version}" }
s.source_files = "SRInfiniteCarouselView/*.{h,m}"
s.requires_arc = true
end
