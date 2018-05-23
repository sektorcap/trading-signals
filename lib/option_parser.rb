require 'optparse'
require 'ostruct'

class OptionParser

  def self.parse(args)
    options = OpenStruct.new
    options.mail_to = ['ettore.caprella@gmail.com']
    options.stocks_files = ['ftse_mib.yml']

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: ccts [options]"

      opts.separator ""
      opts.separator "Specific options:"

      opts.on("-s","--stocks_files x,y,z", Array, 'Stocks files') do |list|
        options.stocks_files.concat list
      end
      opts.on("--mail_to x,y,z", Array, 'Email destinations') do |list|
        options.mail_to.concat list
      end

      opts.separator ""
      opts.separator "Common options:"

      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
      end
    end

    opt_parser.parse!(args)
    options.stocks_files.uniq!
    options.mail_to.uniq!
    options
  end

end
