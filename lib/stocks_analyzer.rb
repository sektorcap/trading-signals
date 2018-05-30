require 'alphavantage'
require 'yaml'
require 'logging'

include Alphavantage
include Logging

module StocksAnalizer
  def analyze file
    stocks = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'config', file))
    ret = []
    stocks.each do |symbol, name|
      timeseries = daily_stock symbol

      s1, options1 = signal_5_down timeseries.close[0..4]
      s2, options2 = one_year_min timeseries.close
      s3, options3 = one_year_max timeseries.close

      logger.info "#{name} (#{symbol}): #{timeseries.close[0]}"
      logger.info "  - #{options1[:message]}" if s1
      logger.info "  - #{options2[:message]}" if s2
      logger.info "  - #{options3[:message]}" if s3

      ret << {
        symbol: symbol,
        name: name,
        last_time: timeseries.close[0][0],
        last_close: timeseries.close[0][1],
        is_signaled: s1 | s2 | s3,
        signals: [
          (options1 if s1),
          (options2 if s2),
          (options3 if s3)
        ].compact
      }
    end
    ret
  end

  def signal_5_down ts
    options = {}
    (0..3).each {|x| return false, options if ts[x][1] >= ts[x+1][1]}
    options[:message] = "Sceso 5 volte di fila (#{ts[0..4].map{|x| x[1]}.join(", ")})"
    return true, options
  end

  PERCENTAGE_MIN_THRESHOLD = 0.95
  def one_year_min ts
    options = {}
    min_entry = ts[0..280].min{|x,y| x[1].to_f <=> y[1].to_f}
    options[:min_entry] = min_entry
    if (ts[0][1].to_f*PERCENTAGE_MIN_THRESHOLD <= min_entry[1].to_f)
      options[:message] = "Nei pressi del minimo dell'ultimo anno (#{min_entry})"
      return true, options
    else
      return false, options
    end
  end

  PERCENTAGE_MAX_THRESHOLD = 0.95
  def one_year_max ts
    options = {}
    max_entry = ts[0..280].max{|x,y| x[1].to_f <=> y[1].to_f}
    options[:max_entry] = max_entry
    if (ts[0][1].to_f >= max_entry[1].to_f*PERCENTAGE_MAX_THRESHOLD)
      options[:message] = "Nei pressi del massimo dell'ultimo anno (#{max_entry})"
      return true, options
    else
      return false, options
    end
  end
end
