#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

package "httpd" do
  action :install
end

cookbook_file "/var/www/html/index.html" do
  source node ["apache"]["indexfile"]
  mode "0644"
end

service "httpd" do
  action [ :enable, :start ]
end
