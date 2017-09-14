Pod::Spec.new do |s|
	s.name			= 'MagixViewer'
	s.version		= '0.1.1'
	s.summary		= '360 viewer'
	s.homepage		= 'https://github.com/HsuYee/MagixViewer'
	s.license		= { :type => 'MIT', :file => 'LICENSE' }
	s.author		= { 'Arloo' => 'hsu.yee.htike@gmail.com' }
	s.source		= { :git => 'https://github.com/HsuYee/MagixViewer.git', :tag => s.version.to_s }
	s.ios.deployment_target = '8.3'
	s.source_files	= 'MagixViewer/*'
	end 