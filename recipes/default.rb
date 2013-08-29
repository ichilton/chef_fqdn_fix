#
# Cookbook Name:: fqdn-fix
# Recipe:: default
#

if !system('hostname -f >/dev/null 2>/dev/null') && system('hostname >/dev/null 2>/dev/null')

  hostname_cmd = `hostname`.strip

  if hostname_cmd.split('.').count >= 3
    fqdn = hostname_cmd
  elsif node.name.split('.').count >= 3
    fqdn = node.name
  end

  if fqdn
    fqdn =~ /^(.+?)\./

    if hostname = $1

      Chef::Log.info 'Fixing Hostname in /etc/hostname and /etc/hosts'

      file '/etc/hostname' do
        content "#{hostname}\n"
        mode "0644"
      end

      execute "hostname #{hostname}"

      hostsfile_entry "127.0.0.1" do
        ip_address "127.0.0.1"
        hostname "localhost"
        action :create
      end

      hostsfile_entry node[:ipaddress] do
        ip_address node[:ipaddress]
        hostname fqdn
        aliases [ hostname ]
        action :create
      end

      ohai "reload" do
        action :reload
      end

      # Temporary hack as the above ohai reload doesn't seem to work...:
      fqdn =~ /^.+?\.(.+)/
      node.override[:domain] = $1
      node.override[:fqdn] = fqdn
    end
  end

end
