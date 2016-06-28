VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock # or :fakeweb
  c.ignore_localhost = true
  c.ignore_hosts.add('fonts.googleapis.com')
  c.ignore_hosts.add('fonts.gstatic.com')
  c.ignore_hosts.add('fonts.useso.com')
end
