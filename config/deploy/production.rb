server '160.251.6.78', user: 'newuser', roles: %w{app db web}, port: 55569 

set :ssh_options, keys: '~/.ssh/cocomelo/id_rsa'