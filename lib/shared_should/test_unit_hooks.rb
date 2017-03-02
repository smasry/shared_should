
module SharedShould::Plugin
  def before_setup
    self.class.execute_class_shared_proxies
    super
  end
end
ActiveSupport::TestCase.send(:extend, SharedShould::SharedContext)
ActiveSupport::TestCase.send(:include, SharedShould::TestClassHelper)
ActiveSupport::TestCase.send(:include, SharedShould::Plugin)

if defined?(Shoulda::Context::Context)
  class Shoulda::Context::Context
    include SharedShould::SharedContext
  end
elsif defined?(Shoulda::Context)
  class Shoulda::Context
    include SharedShould::SharedContext
  end
end
