#!/usr/bin/env ruby
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'bundler/setup'

require 'option_parser'
require 'logging'
require 'signal_catching'
require 'mail'
require 'stocks_analyzer'
require 'send_mail'
require 'mailer'

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
    STDOUT.flush
    Mailer.daily_email(ret.select{|x| x[:is_signaled]}).deliver_now
    #SendMail.send_mail SendMail.build_signals_body(ret)
  end
rescue Exception => e
   logger.error e.inspect
   body  = "Exception\n"
   body += e.inspect
   SendMail.send_mail body
end

logger.info 'Finish'
