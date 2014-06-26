begin
require "observer"
require 'rufus-scheduler' # When the process is gone the schedules are gone!!
# require "whenever" #cron ?? seriously?? yes: for days etc
# require 'clockwork' #same
rescue Exception => e
  puts "WARN scheduler NOT available"
end

class Event
  include Observable rescue nil
      @@id=0
  @@events=[]
  @@scheduler = Rufus::Scheduler.new rescue nil


  def initialize time, action
    @time=time #Interval
    @action=action
    @@events<<self
    @id=@@id
    if not $testing
      case time.kind
        when "in" then @@scheduler.in time.from.to_s+time.unit[0] do self.invoke end
        when "at" then @@scheduler.at time.from.to_s+time.unit[0] do self.invoke end
        when "every" then @@scheduler.every time.from.to_s+time.unit[0] do self.invoke end
      end
    end
    @@id=@@id+1
  end

  def invoke
    EnglishParser.new.parse @action
    # notify_observers(Time.now, "before "+@action)
    # notify_observers(Time.now, "after "+@action)
  end

end

class Observer
  def initialize condition, action
    @condition=condition
    @action=action
  end
end

class Interval

  attr_accessor :from
  attr_accessor :to
  attr_accessor :kind
  attr_accessor :unit

  def initialize kind,from,to,unit #, action
    @kind=kind # event_kinds
    @from=from
    @to=to
    @unit=unit #convert!
    # @action=action
  end
end

# NAH!!
# class Time
#   def initialize kind,time,unit
#   end
# end
