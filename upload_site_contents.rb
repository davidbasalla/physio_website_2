require 'net/ftp'

def checkout_dir(x, ftp)
  if !Dir.exists?(x)
    puts "Putting file: #{x}"
    ftp.put(x)
    return
  else
    Dir.chdir(x)

    puts "Currently at: #{ftp.pwd}"

    # We don't want to create the _site folder on the host
    unless x == "_site"
      puts"Creating/Navigating to: #{x}"

      begin
        ftp.mkdir(x)
      rescue
        puts "WARNING: Could not create directory '#{x}', presumably it already exists"
      end

      ftp.chdir(x)
    end

    Dir.entries(Dir.pwd).reject { |z| z == "." || z == ".." }.each do |y|
      checkout_dir(y, ftp)
    end

    Dir.chdir('..')
    ftp.chdir('..')
  end
end

def transfer_files
  Net::FTP.open(ENV["URL"]) do |ftp|
    ftp.login(ENV["USER"], ENV["PASSWD"])

    checkout_dir("_site", ftp)
  end
end

transfer_files
