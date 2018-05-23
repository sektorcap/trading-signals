require 'yaml'
require 'logger'


module Logging
  def logger
    Logging.logger
  end

  def self.logger
    return @logger if @logger

    config = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'config', 'settings.yml'))

    file  = config['log']['file']  rescue STDOUT
    level = Logger.const_get config['log']['level'].upcase rescue Logger::INFO

    @logger = Logger.new(file)
    @logger.level = level
    @logger
  end
end
