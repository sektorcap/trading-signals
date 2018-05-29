require 'mailgun'

module SendMail
  def send_mail body, dest
    mg_client = Mailgun::Client.new ENV['MAILGUN_KEY']


    message_params = {:from    => "sektor@#{ENV['MAILGUN_DOMAIN']}",
                      :to      => ENV['CCTS_MAIL_TO'],
                      :subject => 'Trading Signals from CCTS!',
                      :text    => body}

    # Send your message through the client
    mg_client.send_message ENV['MAILGUN_DOMAIN'], message_params
  end

  def build_signals_body signals
    msg = ""
    signals.select{|x| x[:is_signaled]}.each do |s|
      msg += "#{s[:name]} #{s[:symbol]}: #{s[:last_time]}, #{s[:last_close]}\n"
      s[:signals].each {|m| msg += "  - #{m[:message]}"}
    end
    msg
  end
end
