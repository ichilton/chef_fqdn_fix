name             'fqdn-fix'
maintainer       'Ian Chilton'
maintainer_email 'ian@ichilton.co.uk'
license          ''
description      'Fix the fqdn on boxes with invalid hostname / hosts files'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

supports "debian"
supports "ubuntu"

depends "hostsfile"

