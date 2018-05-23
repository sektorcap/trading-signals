require 'logging'

# Signal catching
module Signal
  def shut_down
    puts "\nShutting down gracefully..."
  end

  # Trap ^C
  def trap_ctrl_c
    Signal.trap("INT") {
      shut_down
      exit!
    }
  end

  # Trap `Kill `
  def trap_kill
    Signal.trap("TERM") {
      shut_down
      exit!
    }
  end
end
