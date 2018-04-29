
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "readspeed/version"

Gem::Specification.new do |spec|
  spec.name          = "readspeed"
  spec.version       = Readspeed::VERSION
  spec.authors       = ["Madis Nõmme"]
  spec.email         = ["me@mad.is"]

  spec.summary       = %q{Records your reading speed and provides summary}
  spec.description   = %q{Small cli to track your reading speed to push yourself read more and faster}
  spec.homepage      = "https://github.com/madis/readspeed"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
end
