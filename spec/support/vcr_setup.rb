require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'vcr_cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.default_cassette_options = { record: :new_episodes }
  c.filter_sensitive_data('<AWS_ACCESS_KEY_ID>') { ENV['AWS_ACCESS_KEY_ID'] }
  c.filter_sensitive_data('<AWS_SECRET_ACCESS_KEY>') { ENV['AWS_SECRET_ACCESS_KEY'] }
  c.filter_sensitive_data('<PRODUCTION_S3_BUCKET>') { ENV['PRODUCTION_S3_BUCKET'] }
  c.filter_sensitive_data('<DEVELOPMENT_S3_BUCKET>') { ENV['DEVELOPMENT_S3_BUCKET'] }
  c.filter_sensitive_data('<WORDNIK_API_KEY>') { ENV['WORDNIK_API_KEY'] }
end
