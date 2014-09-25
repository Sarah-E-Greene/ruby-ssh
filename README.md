ruby-ssh
========

Wrapper around 'net/ssh' to make it easier to use - uses password for sudo automatically, and gives back an array of [stdout, stderr], each an array of lines.

Usage
=====

```
require 'ssh'

ssh = SSH.new(hostname, user, password)

stdout, stderr = ssh.run('sudo apt-get update')
raise "Error updating package lists: #{stderr}" unless stderr.empty?

stdout.select{ |x| x.match(/Reading package lists/) }
```
