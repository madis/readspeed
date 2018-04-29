require 'yaml'

module Readspeed
  class Tracker
    attr_accessor :file_name

    def initialize(title, input: $stdin, output: $stdout)
      @input = input
      @output = output
      @pages = 0
      @times = []
      @title = title
    end

    def start
      output.puts "#{help_info}\n Starting recording. Press [ENTER] when you finish reading page."
      while true do
        start_time = Time.now
        case read_command
        when :quit
          write_summary_to_file
          break
        when :pause
          @paused = true
        when :resume
          @paused = false
        when :help
          print_help
        else
          record_next_page(start_time, Time.now)
        end
      end
    end

    private

    attr_reader :input, :output

    COMMANDS = {
      quit: %w(q quit),
      pause: %w(p pause),
      resume: %w(r resume),
      help: %w(h help)
    }

    def expanded_commands
      COMMANDS.reduce({}) do |sum, (command, inputs)|
        inputs.each { |i| sum[i] = command }
        sum
      end
    end

    def read_command
      status = @paused ? "(paused)" : "#{@pages}"
      output.print "#{status}> "
      user_input = input.gets.chomp
      if @paused && user_input == ''
        @paused = false
        selected_command = :resume
      else
        selected_command = expanded_commands[user_input]
      end
      selected_command
    end

    def record_next_page(start_time, end_time)
      @pages += 1
      @times << end_time - start_time
      output.puts summary
    end

    def help_info
      <<~EOS
        Press [ENTER] without typing anything to start next page or one of the
        following commands:

        q, quit   - quit the application, write summary to file
        p, pause  - record current page, pause
        r, resume - resume from pause
        h, help   - show help (this)
      EOS
    end

    def write_summary_to_file
      output.puts "Writing summary to #{file_name}"
      if File.exist?(file_name)
        reading_summary = YAML.load(File.read(file_name))
      else
        reading_summary = {
          title: @title,
          started_at: Time.now,
          readings: []
        }
      end

      reading = {
        session_finished_at: Time.now,
        pages: @pages,
        times: @times,
        summary: summary
      }

      reading_summary[:readings] << reading
      File.open(file_name, 'w') { |f| f.write(reading_summary.to_yaml) }
    end

    def summary
      "Finished page #{@pages}. Last: #{last} Average: #{average} Total: #{total}"
    end

    def last
      @times.last.round(1)
    end

    def average
      (total / @pages).round(1)
    end

    def total
      @times.reduce(&:+).round(1)
    end

    def file_name
      @file_name || @title.gsub(/( )/, '_').downcase + ".yaml"
    end
  end
end
