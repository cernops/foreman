desc <<-END_DESC
Updates host parameter @hwdbkopts based on the output of @hwdbbin
END_DESC

require "open3"

@hwdbkopts = "hwdbkopts"
@hwdbbin = "/usr/bin/get-hardware-params"

namespace :hwdb do
  def get_kopts_from_hwdb(hostname, operatingsystem)
    stdout, stderr, status = Open3.capture3("#{@hwdbbin} -H #{hostname} -o \"#{operatingsystem}\" -b")
    if status == 0 && !stdout.blank?
      stdout.strip()
    else
      "none"
    end
  end

  task :refresh_kopts => :environment do
    puts " ================================================================ "
    puts "Import starts: #{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}"

    changes = 0
    if not File.exists?(@hwdbbin)
      puts "Can't import hardware parameters because CERN-CC-hardwareparams is not installed"
    else
      Host.find_all_by_managed(true).select { |host| host.params[@hwdbkopts].nil? }.each do |host|
        begin
          if host.operatingsystem.nil?
            puts "Host - #{host.name} does not have an operating system set -- can't request kopts"
          else
            kopts = get_kopts_from_hwdb(host.name, host.operatingsystem.fullname)
            param = HostParameter.find_or_initialize_by_reference_id_and_name(host.id, @hwdbkopts)
            if param.update_attribute("value", kopts)
              changes += 1
              puts "Host - #{host.name} - '#{@hwdbkopts}' set to \"#{kopts}\""
            else
              puts "Host - #{host.name} - failed to save: \"#{host.errors.full_messages}\""
            end
            puts '----------------------------------'
          end
        rescue
          next
        end
      end
    end

    puts "Changes ---------  #{changes}"
    puts "Import ends: #{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}"
    puts " ================================================================ "
  end
end
