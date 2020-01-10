require 'active_support'

module DateParams
  module ControllerAdditions
    extend ActiveSupport::Concern

    module ClassMethods
      # Converts a text field with a date, in a specified format, into a Date object
      def date_params(*args)
        options = args.extract_options!
        before_filter options do |controller|
          args.each { |param| DateParams::Parser.new(param, options, controller.params).parse_date_param! }
        end
      end

      # Similar to #date_params, but parses a date input field and a time input field
      # and combines them into a new timezone-aware datetime field.
      def datetime_params(*args)
        options = args.extract_options!
        before_filter options do |controller|
          args.each { |param| DateParams::Parser.new(param, options, controller.params).parse_datetime_param! }
        end
      end

      def before_filter(*args, &block)
        return super(*args, &block) unless respond_to?(:before_action)
        before_action(*args, &block)
      end
    end
  end
end

if defined?(ActionController::Base)
  ActionController::Base.class_eval do
    include DateParams::ControllerAdditions
  end
end
