transmission:
  defaults:
    - directory_mode: "0644"
  instances:
    - instance:    public1
      daemonuser:  ptracker
      configdir:   /srv/ptracker_config
      watch:       /srv/ptracker_dropbox
      incomplete:  /srv/ptracker_working
      complete:    /srv/complete
      user:        ptracker
      password:    pass123
      requireencryption: True
      dht:         True
      upnp:        True
      port:        9091
      requireauth: True
      allowedNets:    
        - 192.168.1.* 
        - 10.244.0.*
    - instance: private1
      daemonuser:  myservice
      configdir:   /srv/myservice_config
      watch:       /srv/myservice_dropbox
      incomplete:  /srv/myservice_working
      complete:    /srv/complete
      user:        someuser
      password:    pass123
      preferencryption: True
      dht: False
      upnp: False
      requireauth: True
      allowedNets:    
        - 192.168.1.* 
