require 'time'
require 'date'
require 'tzinfo'
require 'active_support/core_ext/time/zones'
require 'active_support/core_ext/time/calculations'
require 'active_support/time_with_zone'
require 'active_support/core_ext/object/try'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/hash/keys'

class DateParams::Parser
  attr_reader :param, :options, :params, :date_format, :time_format
  def initialize(param, options, params)
    @param = param
    @options = options
    @params = params
    @date_format =  options.fetch :date_format, '%m/%d/%Y'
    @time_format =  options.fetch :time_format, '%I:%M %p'
  end

  def parse_date_param!(field = param)
    date_string = traversed_params.try(:[], field)
    return if date_string.blank?
    inferred_date_format = date_string =~ /\d{4}-\d{2}-\d{2}/ ? '%Y-%m-%d' : date_format
    date = Date.strptime(date_string, inferred_date_format)
    traversed_params[field] = date if date
  end

  def parse_datetime_param!
    if param.is_a? Hash
      fields = param
      fields.assert_valid_keys :date, :time, :field
    else
      field_root = param.to_s.gsub /_at\z/, ''
      fields = {
          date: "#{field_root}_on".to_sym,
          time: "#{field_root}_time".to_sym,
          field: "#{field_root}_at".to_sym
      }
    end

    date = parse_date_param! fields[:date]
    return if date.blank?
    time_string = traversed_params.try(:[], fields[:time])
    return if time_string.blank?
    datetime_format = "%Y-%m-%dT#{time_format}%z"
    datetime_string = "#{date.iso8601}T#{time_string}#{Time.zone.name}"
    datetime = Time.strptime(datetime_string, datetime_format).in_time_zone(Time.zone)
    traversed_params[fields[:field]] = datetime if datetime
  end

  private

  def traversed_params
    traversed_params = params
    if options[:namespace].present?
      traversed_params = traversed_params.try :[], options[:namespace]
    end
    traversed_params
  end
end
