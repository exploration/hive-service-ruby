# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hive_service/version'

# rubocop:disable Metrics/BlockLength
Gem::Specification.new do |spec|
  spec.name = 'hive_service'
  spec.version = HiveService::VERSION
  spec.authors = ['Donald Merand']
  spec.email = ['dmerand@explo.org']

  spec.summary = 'Use HIVE in your Ruby app'
  spec.homepage = 'https://bitbucket.org/explo/hive-service-ruby'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the
  # 'allowed_push_host' to allow pushing to a single host or delete this
  # section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] =
      'https://bitbucket.org/explo/hive-service-ruby'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'pry', '~> 0.11'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'rantly', '~> 1.1.0'
  spec.add_development_dependency 'yard', '~> 0.9.12'

  spec.add_runtime_dependency 'httparty', '~>0.18.1'
end
# rubocop:enable Metrics/BlockLength
