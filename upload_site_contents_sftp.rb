require 'net/sftp'

def checkout_dir(x, sftp)
  currentLocation = Dir.pwd

  if !Dir.exists?(x)
    puts "Putting file: #{x}"
    srcHomePath = "/home/ubuntu/physio_website_2/_site"

    src_path = "#{currentLocation}/#{x}"
    dst_path = "#{currentLocation.gsub(srcHomePath, "")}/#{x}"
    puts src_path
    puts dst_path
    puts 

    # sftp.upload!("/path/to/local", "/path/to/remote")
    return
  else
    Dir.chdir(x)

    puts "Currently at: #{currentLocation}"

    # We don't want to create the _site folder on the host
    unless x == "_site"
      puts"Creating/Navigating to: #{x}"

      # begin
      #   sftp.mkdir(x)
      # rescue
      #   puts "WARNING: Could not create directory '#{x}', presumably it already exists"
      # end

      # sftp.chdir(x)
    end

    Dir.entries(Dir.pwd).reject { |z| z == "." || z == ".." }.each do |y|
      checkout_dir(y, sftp)
    end

    Dir.chdir('..')
    # sftp.chdir('..')
  end
end

def transfer_files_sftp
  Net::SFTP.start(ENV["HOST"], ENV["USER"], :password => ENV["PASSWD"]) do |sftp|
    # sftp.upload!("/path/to/local", "/path/to/remote")

    checkout_dir("_site", sftp)
  end
end

transfer_files_sftp
