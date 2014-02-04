module Bwoken
  class Device
    class << self

      def plist_buddy;
        '/usr/libexec/PlistBuddy';
      end

      def plist_file;
        "#{Bwoken::Build.app_dir(false)}/Info.plist";
      end

      # deprecated. Remove when Rakefile support removed
      def should_use_simulator?
        want_simulator? || !connected?
      end

      # deprecated. Remove when Rakefile support removed
      def want_simulator?
        ENV['SIMULATOR'] && ENV['SIMULATOR'].downcase == 'true'
      end

      def connected?
        self.uuid ? true : false
      end

      def uuid
        ioreg[/"USB Serial Number" = "([0-9a-z]+)"/] && $1
      end

      def device_type
        ioreg[/"USB Product Name" = "(.*)"/] && $1.downcase
      end

      def ioreg
        @ioreg ||= `ioreg -w 0 -rc IOUSBDevice -k SupportsIPhoneOS`
      end

      def update_bundle_id bundle_id
        puts plist_file
        puts bundle_id
        system_cmd = lambda { |command| Kernel.system "#{plist_buddy} -c '#{command}' \"#{plist_file}\"" }
        system_cmd["Delete :CFBundleIdentifier"]
        system_cmd["Add :CFBundleIdentifier string #{bundle_id}"]

      end


    end

  end
end
