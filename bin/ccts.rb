#!/usr/bin/env ruby
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'bundler/setup'

require 'option_parser'
require 'logging'
require 'signal_catching'
require 'mail'
require 'stocks_analyzer'
require 'send_mail'

include Logging
include StocksAnalizer
include Signal
include SendMail

logger.info 'Start'

trap_ctrl_c
trap_kill

options = OptionParser.parse(ARGV)

begin
  options.stocks_files.each do |f|
    logger.info "Analyzing #{f}..."
    ret = analyze f
    puts ret.inspect
    STDOUT.flush
    SendMail.send_mail SendMail.build_signals_body(ret), options[:mail_to]
  end
rescue Exception => e
   logger.error e.inspect
   body  = "Exception\n"
   body += e.inspect
   SendMail.send_mail body, options[:mail_to]
end

# SendMail.send_mail ret, options[:mail_to]

logger.info 'Finish'

#https://devcenter.heroku.com/articles/getting-started-with-ruby#introduction
