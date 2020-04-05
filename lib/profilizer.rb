# frozen_string_literal: true

# require 'pry'
require 'ruby2_keywords'

require 'profilizer/profiler'
require 'profilizer/version'

module Profilizer
  class ArgumentError < StandardError; end

  OUR_BLOCK = lambda do
    extend(ClassMethods)
    extend ModuleMethods if instance_of?(Module)
  end

  private_constant :OUR_BLOCK

  module ModuleMethods
    def included(base = nil, &block)
      if base.nil? && block
        super do
          instance_exec(&block)
          instance_exec(&OUR_BLOCK)
        end
      else
        base.instance_exec(&OUR_BLOCK)
      end
    end
  end

  extend ModuleMethods

  module ClassMethods
    def profilize(method_name, time: true, gc: true, memory: true)
      prepend_profilizer_module!
      define_profilized_method!(method_name, time: time, gc: gc, memory: memory)
      method_name
    end

    private

    def prepend_profilizer_module!
      return if defined?(@_prifilizer_module)

      @_prifilizer_module = Module.new { extend ProfilizerModule }
      prepend @_prifilizer_module
    end

    def define_profilized_method!(*args, **kwargs)
      @_prifilizer_module.public_send __method__, self, *args, **kwargs
    end

    module ProfilizerModule
      def define_profilized_method!(klass, method_name, time: nil, gc: nil, memory: nil)
        original_visibility = method_visibility(klass, method_name)

        define_method method_name do |*args, &block|
          result = nil
          Profiler.new.profile_method(time: time, gc: gc, memory: memory) do
            result = super(*args, &block)
          end
          result
        end

        ruby2_keywords method_name

        send original_visibility, method_name
      end

      private

      def method_visibility(klass, method_name)
        if klass.private_method_defined?(method_name)
          :private
        elsif klass.protected_method_defined?(method_name)
          :protected
        elsif klass.public_method_defined?(method_name)
          :public
        else
          raise ArgumentError, "Method #{method_name} is not defined on #{klass}"
        end
      end
    end
  end

  # private_constant ProfilizerModule
end
