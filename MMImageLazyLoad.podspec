Pod::Spec.new do |s|
          #1.
          s.name               = "MMImageLazyLoad"
          #2.
          s.version            = "1.0.0"
          #3.  
          s.summary         = "Sort description of 'MMImageLazyLoad' framework"
          #4.
          s.homepage        = "http://www.MMImageLazyLoad.com"
          #5.
          s.license              = "MIT"
          #6.
          s.author               = "MMImageLazyLoad"
          #7.
          s.platform            = :ios, "10.0"
          #8.
          s.source              = { :git => "https://github.com/Murugan0491/MMImageLazyLoad.git", :tag => "1.0.0" }
          #9.
          s.source_files     = "MMImageLazyLoad", "MMImageLazyLoad/**/*.{h,m,swift,png}"
    end