search("node","platform:redhat").each do |server|
  log "The RedHat servers in your organization have the following FQDN/IP addresses:- #{server["fqdn"]}/#{server["ipaddress"]}"
end

log "hello from the ip-logger recipe"
