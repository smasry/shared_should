module SharedShould::TestClassHelper
  def self.included(base_test_class)
    base_test_class.class_eval do
      attr_accessor :shared_value
      @@shared_proxies_executed = {}
      @@setup_blocks = {}

      def self.execute_class_shared_proxies

        if @@shared_proxies_executed[self].nil?
          shared_proxies.each do |shared_proxy|
            shared_proxy.share_execute(self)
          end
          @@shared_proxies_executed[self] = true
        end
      end

      def self.shared_context_block_owner(context_or_test_class)
        return context_or_test_class.kind_of?(Shoulda::Context) ? context_or_test_class : ActiveSupport::TestCase
      end

      def execute_class_shared_setups_if_not_executed
        if !@shared_setups_executed
          @shared_setups_executed = true
          (@@setup_blocks[self.class] || []).each do |setup_block|
            setup_block.bind(self).call
          end
        end
      end

      def self.setup(*args, &setup_block)
        if args
          set_callback(:setup, :before, *args, &setup_block)
        else
          @@setup_blocks[self] = [] unless @@setup_blocks[self]
          @@setup_blocks[self] << setup_block
        end
      end

      def setup_shared_value(initialization_block)
        self.shared_value = initialization_block.nil? ? nil : initialization_block.bind(self).call
      end

      def call_block_with_shared_value(test_block)
        return nil unless test_block
        execute_class_shared_setups_if_not_executed
        if test_block.arity == 1
          # check arity of 1 before checking if value is an array. If one parameter, never treat the shared_value as variable args
          test_block.bind(self).call(self.shared_value)
        elsif self.shared_value.class == Array && test_block.arity == self.shared_value.length
          test_block.bind(self).call(*self.shared_value)
        else
          test_block.bind(self).call()
        end
      end

      def call_block_config(block_config)
        ret_val = call_block_with_shared_value(block_config[:block])
        self.shared_value = ret_val if block_config[:action] == :given
      end
    end
  end
end
