#!/usr/bin/env ruby
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'bundler/setup'

require 'option_parser'
require 'logging'
require 'signal_catching'
require 'mail'
require 'stocks_analyzer'

include Logging
include StocksAnalizer
include Signal

logger.info 'Start'
trap_ctrl_c
trap_kill

options = OptionParser.parse(ARGV)

while true
  begin
    options.stocks_files.each do |f|
      logger.info "Analyzing #{f}..."
      ret = analyze f
      puts ret.inspect
    end
  rescue Exception => e
     logger.error e.inspect
  end
  sleep(60*60)
end

logger.info 'Finish'

#https://devcenter.heroku.com/articles/getting-started-with-ruby#introduction
