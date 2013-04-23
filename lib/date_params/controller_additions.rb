require 'date'
require 'active_support/concern'
require 'active_support/core_ext/object/try'
require 'active_support/core_ext/object/blank'

module DateParams
  module ControllerAdditions
    extend ActiveSupport::Concern

    module ClassMethods
      # Usage:
      #
      # To convert only on specific actions use:
      # date_params :param_name, [:namespaced, :param_name], only: :action_name
      # If all variables are in a common namespace, use the namespace option:
      # date_params :param_name1, :param_name2, namespace: :namespaced
      # @see #parse_date_param!
      def date_params(*args)
        options = args.extract_options!
        before_filter options do |controller|
          controller.parse_date_params(args, options)
        end
      end
    end

    # Usage:
    #
    # To convert params[:my_date]
    # date_params :my_date
    #
    # To convert params[:my_model][:my_date1] use one of the following:
    # parse_date_param!([:my_model, :my_date1])
    # parse_date_param!(:my_date1, namespace: :my_model)
    #
    # if the format of the data is not '%m/%d/%Y'
    # parse_date_param!(:my_date1, date_format: '%m/%Y')
    def parse_date_param!(param, options)
      param_path = Array(param).dup
      param_path.unshift options[:namespace] if options[:namespace] && param_path.length == 1
      date_format =  options.fetch(:date_format, '%m/%d/%Y')
      traversed_params = params

      if param_path.length > 1
        param_key = param_path.pop
        param_path.each { |k| traversed_params = traversed_params.try :[], k }
      else
        param_key = param_path.first
      end

      value = traversed_params.try(:[], param_key)
      return nil if value.blank?
      date_format = value =~ /\d{4}-\d{2}-\d{2}/ ? '%Y-%m-%d' : date_format
      date = Date.strptime(value, date_format)
      traversed_params[param_key] = date if date
    end

    def parse_date_params(the_params, options)
      the_params.each{ |param| parse_date_param! param, options }
    end
  end
end
