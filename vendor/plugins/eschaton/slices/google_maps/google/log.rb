module Google
  
  # Provides the ability to write debug and test information to a floating log window on the map.
  class Log

    # Writes the given +html+ to the log window. Interpolating both Ruby(by use of #{ruby_variable}) and 
    # Javascript(by use of #[javascript_variable]) variables are supported.
    #
    # ==== Examples
    #
    #  script << "var name = 'yawningman"
    #  Google::Log.write("Hello #[name], this is javascript interpolation.")
    #
    #  name = "yanwingman"
    #  Google::Log.write("Hello #{name}, this is ruby interpolation.")
    #
    def self.write(html)
      Eschaton.global_script << "GLog.writeHtml(#{html.interpolate_javascript_vars});"
    end

  end
  
end