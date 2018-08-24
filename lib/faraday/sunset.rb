require 'faraday'

module Faraday
  class Sunset < Faraday::Middleware
    class NoOutputForWarning < StandardError; end

    # Initialize the middleware
    #
    # @param [Type] app describe app
    # @param [Hash] options = {}
    # @return void
    def initialize(app, active_support: nil, logger: nil, rollbar: nil)
      super(app)
      @active_support = active_support
      @logger = logger
      @rollbar = rollbar
    end

    # @param [Faraday::Env] no idea what this does
    # @return [Faraday::Response] response from the middleware
    def call(env)
      @app.call(env).on_complete do |response_env|
        datetime = sunset_header(response_env.response_headers)
        report_deprecated_usage(env, datetime) unless datetime.nil?
      end
    end

    protected

    # Check to see if there is a Sunset header, which contains deprecation date
    #
    # @param [Faraday::Response] response object with headers and whatnot
    # @return [DateTime|nil] date time object of the expected deprecation date
    def sunset_header(headers)
      return if headers[:sunset].nil?
      DateTime.parse(headers[:sunset])
    end

    def report_deprecated_usage(env, datetime)
      if datetime > DateTime.now
        warning = "Endpoint #{env.url} is deprecated for removal on #{datetime.iso8601}"
      else
        warning = "Endpoint #{env.url} was deprecated for removal on #{datetime.iso8601} and could be removed AT ANY TIME"
      end
      send_warning!(warning)
    end

    def send_warning!(warning)
      warned = false

      if @active_support == :auto
        warned = report_active_support(warned, warning)
      elsif @active_support == true
        warned = report_active_support!(warning)
      end

      if @logger && @logger.respond_to?(:warn)
        @logger.warn(warning)
        warned = true
      end

      if @rollbar == :auto
        warned = report_rollbar(warned, warning)
      elsif @rollbar == true
        warned = report_rollbar!(warning)
      end

      unless warned
        raise NoOutputForWarning, "Pass active_support: (true|false|:auto), rollbar: (true|false|:auto), or logger: ::Logger.new when registering middleware"
      end
    end

    private

    def report_rollbar!(warning)
      Rollbar.warning(warning)
      # return true to set :warned
      true
    end

    def report_active_support!(warning)
      ActiveSupport::Deprecation.warn(warning)
      # return true to set :warned
      true
    end

    # :auto methods
    # do not raise errors if gems are missing
    def report_rollbar(warned, warning)
      report_rollbar!(warning)

    rescue NameError 
      # rollbar is not present!
      # do not modify warned if an error is raised
      warned
    end

    def report_active_support(warned, warning)
      report_active_support!(warning)

    rescue NameError 
      # active_support is not present!
      # do not modify warned if an error is raised - return warned instead
      warned
    end

  end
end

Faraday::Response.register_middleware sunset: Faraday::Sunset
