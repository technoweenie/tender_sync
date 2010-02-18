module TenderSync
  autoload :Config, 'tender_sync/config'
  autoload :Dir,    'tender_sync/dir'

  module Sources
    autoload :Filesystem, 'tender_sync/sources/filesystem'
    autoload :Api,        'tender_sync/sources/api'
  end
end