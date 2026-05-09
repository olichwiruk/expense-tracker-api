# frozen_string_literal: true

require 'vcr'
require 'webmock/rspec'

ENV['OPENAI_API_KEY'] ||= 'fake-api-key'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'

  config.hook_into :webmock

  config.configure_rspec_metadata!

  config.filter_sensitive_data('<OPENAI_API_KEY>') { ENV['OPENAI_API_KEY'] }
end
