require 'gainer/port'

module Gainer
  class Basic
    AIN, DIN, AOUT, DOUT = 0, 1, 2, 3
    CONFIG = [
      nil,
      [4,  4,  4, 4],
      [8,  0,  4, 4],
      [4,  4,  8, 0],
      [8,  0,  8, 0],
      [0, 16,  0, 0],
      [0,  0, 16, 0],
      [],
    ]
    MATRIX_LED_CONFIGURATION = 7

    def initialize(config)
      @led = false
      @on_pressed = proc do end
      @on_released = proc do end

      @analog_input  = []
      @digital_input = []

      @digital_output = Port.new(self, nil, :digital_output_set)
      @analog_output  = Port.new(self, nil, :analog_output_set)

      @configuration = nil

      reboot
      self.configuration = config || 1
    end
    attr_reader :led, :analog_input, :digital_input, :analog_output, :digital_output
    attr_accessor :on_pressed, :on_released

    def configuration=(number)
      if 1 <= number and number <= 7
        @configuration = number
        command("KONFIGURATION_#{number}", { :wait => 1 })
      end
    end

    def matrix=(ary)
      raise if @configuration != MATRIX_LED_CONFIGURATION

      s = (0...8).to_a.map do |i|
        'a%X%08X' % [i, ary[i]]
      end.join('*')

      command(s, :reply => 'a')
    end

    def led=(flag)
      command(flag ? 'h' : 'l')
    end

    def peek_digital_input
      command('R')
    end

    def peek_analog_input
      command('I')
    end

    def digital_output=(n)
      s = '%02d' % CONFIG[@configuration][DOUT]
      command("D%#{s}X" % n)
    end

    def digital_output_set(index, flag)
      raise if index > CONFIG[@configuration][DOUT]
      command((if flag then 'H' else 'L' end) + ('%X' % index))
    end

    def analog_output=(n)
      s = '%02d' % (CONFIG[@configuration][AOUT] * 2)
      command("A%#{s}X" % n)
    end

    def analog_output_set(index, value)
      raise if index > CONFIG[@configuration][AOUT]
      value = [[0, value].max, 0xff].min
      command('a%1X%02X' % [index, value])
    end

    def reboot
      command('Q', :wait => 1)
    end

    def process_next_event(wait = nil)
      reply = next_event
      sleep(wait) if wait
      process_event(reply)
    end

    private
    def command(cmd, args = {})
      command_send(cmd + '*')
      process_next_event(args[:wait])
    end

    def process_event(event)
      case event
      when '!*'
        raise
      when 'h*'
        @led = true
      when 'l*'
        @led = false
      when 'N*'
        @on_pressed.call
      when 'F*'
        @on_released.call
      when /^I([0-9A-F]+)\*$/
        s = $1
        s.scan(/../).each_with_index do |s, i|
          @analog_input[i] = s.to_i(16)
        end
      when /^R([0-9A-F]+)\*$/
        s = $1
        s.reverse.scan(/./).each_with_index do |s, i|
          @digital_input[i] = s.to_i(16)
        end
      end
    end
  end

  require 'termios'
  class Serial < Basic
    def initialize(path, config = nil)
      @file = File.open(path, 'w+')
      @file.sync = true
      setup_port

      super(config)
    end

    private

    def setup_port
      setting = Termios::getattr(@file)
      setting.ispeed = setting.ospeed = 38400
      setting.cflag |= Termios::CS8
      Termios::setattr(@file, Termios::TCSANOW, setting)
    end

    def command_send(c)
      @file.write(c)
    end

    def next_event
      loop do
        ary = select([@file], [], [], 1)
        if ary and ary[0].include?(@file)
          result = @file.gets('*')
          return result
        end
      end
    end
  end

  class Proxy < Basic
    def initialize(host = '', port = 2000)
      @socket = TCPSocket.new(host, port)
      @socket.sync = true
    end

    private
    def command_send(c)
      @socket.write("#{c}\0")
    end

    def next_event
      @socket.gets("\0")[0...-1]
    end
  end
end

if $0 == __FILE__
  g = Gainer::Serial.new(ARGV.shift)

  done = false
  g.on_press = proc do
    done = true
  end

  until done
    g.led = ! g.led

    print 'press button to quit. led = ', (g.led ? 'on ' : 'off'), ".\r"
    sleep(0.5)
  end
  g.led = false
end
