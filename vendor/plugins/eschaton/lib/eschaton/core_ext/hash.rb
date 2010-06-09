class Hash # :nodoc:
  alias extract delete

  alias has_option? has_key?

  # Defaults key values in a hash that are not present. Works like #merge but does not overwrite
  # existing keys. This is useful when using options arguments.
  def default!(defaults = {})
    replace(defaults.merge(self))
  end

  # Prepares a Hash as MethodOptions. See MethodOptions for details
  def prepare_options
    method_options = Eschaton::PreparedOptions.new(self)

    yield method_options if block_given?

    method_options
  end

end
