require 'alphavantagerb'
require 'yaml'

module Alphavantage
  def alphavantage
    Alphavantage.alphavantage
  end

  def self.alphavantage
    return @alphavantage if @alphavantage

    config = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'config', 'settings.yml'))

    key  = config['alphavantage']['key']  rescue "demo"
    verbose = config['alphavantage']['verbose'] == 'true'? true : false rescue false

    @alphavantage = Alphavantage::Client.new key: key, verbose: verbose
    @alphavantage
  end
end
