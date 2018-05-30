require 'alphavantagerb'
require 'yaml'
require 'logging'

include Logging

module Alphavantage
  DEFAULT_WAITING_TIME = 5
  DEFAULT_RETRY = 10

  def alphavantage
    Alphavantage.alphavantage
  end
  def alphavantage_config
    Alphavantage.alphavantage_config
  end

  def self.alphavantage_config
    return @alphavantage_config if @alphavantage_config
    config = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'config', 'settings.yml'))
    @alphavantage_config = {}
    @alphavantage_config[:verbose] = config['alphavantage']['verbose'] == 'true'? true : false rescue false
    @alphavantage_config[:waiting_time] = config['alphavantage']['waiting_time'] rescue DEFAULT_WAITING_TIME
    @alphavantage_config[:retry] = config['alphavantage']['retry'] rescue DEFAULT_RETRY
    @alphavantage_config
  end

  def self.alphavantage
    return @alphavantage if @alphavantage
    key  = ENV['ALPHAVANTAGE_KEY']  rescue "demo"
    @alphavantage = Alphavantage::Client.new key: key, verbose: alphavantage_config[:verbose]
    @alphavantage
  end

  def daily_stock symbol
    attempts = 0
    while true
      begin
        stock = alphavantage.stock symbol: symbol
        return stock.timeseries outputsize: "full"
      rescue Alphavantage::Error => ex
        attempts += 1
        logger.warn "Attempts #{attempts} failed for #{symbol}"
        raise ex if attempts == alphavantage_config[:retry]
        logger.info "Waiting #{alphavantage_config[:waiting_time]} seconds"
        sleep alphavantage_config[:waiting_time]
      end
    end


  end
end
