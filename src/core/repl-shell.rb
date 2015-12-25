require_relative "english-parser"

def load_history_why? history_file
  histSize = 100
  begin
    history_file = File::expand_path(history_file)
    if File::exists?(history_file)
      lines = IO::readlines(history_file).collect { |line| line.chomp }
      Readline::HISTORY.push(*lines)
    end
    Kernel::at_exit do
      lines = Readline::HISTORY.to_a.reverse.uniq.reverse
      lines = lines[-histSize, histSize] if lines.count > histSize
      File::open(history_file, File::WRONLY|File::CREAT|File::TRUNC) { |io| io.puts lines.join("\n") }
    end
  rescue => e
    puts "Error when configuring history: #{e}"
  end
end

def start_shell
  $verbose=false
  puts 'English Script v1.2'
  puts 'usage:'
  puts "\t./angle 6 plus six"
  puts "\t./angle examples/test.e"
  puts "\t./angle (no args for shell)"
  @parser=EnglishParser.new
  require 'readline'
  load_history_why?('~/.english_history')
  # http://www.unicode.org/charts/PDF/U2980.pdf
  while input = Readline.readline('⦠ ', true)
    # while input = Readline.readline('angle-script⦠ ', true)
    # Readline.write_history_file("~/.english_history")
    # while true
    #   print "> "
    #   input = STDIN.gets.strip
    begin
      interpretation= @parser.parse input
      next if not interpretation
      puts interpretation.tree if $use_tree
      puts interpretation.result
    rescue NotMatching
      puts 'Syntax Error'
    rescue GivingUp
      puts 'Syntax Error'
    rescue
      puts $!
    end
  end
  puts ""
  exit
end


def startup
  return start_shell if ARGV.count==0 #and not ARGF
  @all=ARGV.join(' ')
  a   =ARGV[0].to_s
  # read from commandline argument or pipe!!
  @all=ARGF.read||File.read(a) rescue a
  # @all=File.read(`pwd`.strip+"/"+a) if @all.is_a?(String) and @all.end_with? ".e"
  @all=@all.split("\n") if @all.is_a?(String)

  # puts "parsing #{@all}"
  for line in @all
    next if line.blank?
    begin
      interpretation=EnglishParser.new.parse line.encode('utf-8')
      result        =interpretation.result
      puts interpretation.tree if $use_tree
      puts result if result and not result.empty? and not result==:nill
    rescue NotMatching
      puts $!
      puts 'Syntax Error'
    rescue GivingUp
      puts 'Syntax Error'
    rescue
      puts $!
      puts $!.backtrace.join("\n")
    end
  end
  puts ""
end

$testing||=false
startup if ARGV and not $testing and not $commands_server #and not $raking
