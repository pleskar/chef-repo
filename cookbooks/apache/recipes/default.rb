#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

package "httpd" do
  action :install
end

#Disable the default virtula host
execute "mv /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/welcome.conf.disabled" do
  only_if { File.exists?("/etc/httpd/confd/welcome.conf") }
  notifies :restart, "service[httpd]"
end

=begin
node.default["apache"]["indexfile"] = "index2.html"
cookbook_file "/var/www/html/index.html" do
  source node["apache"]["indexfile"]
  mode "0644"
end
=end

#Iterate over the sites

node["apache"]["sites"].each do |site_name, site_data|
#Set the document root variable
document_root = "/srv/apache/#{site_name}"
 
  #Create the virtual hosts definition
  template "/etc/httpd/conf.d/#{site_name}.conf" do
    source "custom.erb"
    mode "0644"
    variables(
      :document_root => document_root,
      :port => site_data["port"]
     )
   notifies :restart, "service[httpd]"
  end

  #Create the appropriate apache directories
  directory "/srv/apache" do
    owner "apache"
    group "apache"
    mode "0755"
  end

  directory document_root do
    owner "apache"
    group "apache"
    mode "0755"
    recursive true
  end

  #Create each index.html page
  template "#{document_root}/index.html" do
    source "index.html.erb"
    owner "apache"
    group "apache"
    mode "0644"
    variables(
     :site_name => site_name,
     :port => site_data["port"]
    )
  end
end

service "httpd" do
  action [ :enable, :start ]
end

