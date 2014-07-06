class MySingleton
  include Singleton

  singleton_class.class_eval{attr_accessor :role_id}
end
