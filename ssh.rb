require 'net/ssh'

class SSH
  def initialize(hostname, username, password)
    begin
      @hostname = hostname
      @username = username
      @password = password
      @ssh = Net::SSH.start(@hostname, @username, :password => @password)
    rescue
      fail "Unable to connect to #{@hostname}"
    end
  end

  def run(command)
    stdout = []
    stderr = []

    @ssh.open_channel do |channel|
      channel.request_pty
      channel.exec(command) do |ch, success|
        fail "could not execute command" unless success

        # Handle stdout
        channel.on_data do |c_, data|
          if data =~ /\[sudo\]/ || data =~ /Password/i
            channel.send_data "#{@password}\n"
          else
            stdout.push(data)
          end
        end

        # Handle stderr
        channel.on_extended_data do |ch, type, data|
          stderr.push(data)
        end
      end
    end
    @ssh.loop
    [stdout, stderr]
  end

  def disconnect
    @ssh.close
  end
end
