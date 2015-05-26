import sched, time
# >>> s = sched.scheduler(time.time, time.sleep)
# >>> def print_time(): print "From print_time", time.time()
# ...
# >>> def print_some_times():
# ...     print time.time()
# ...     s.enter(5, 1, print_time, ())
# ...     s.enter(10, 1, print_time, ())
# ...     s.run()
# ...     print time.time()
# ...
# >>> print_some_times()
# 930343690.257
# From print_time 930343695.274
# From print_time 930343700.273
# 930343700.276

import english_parser
# try:
# import observer
# import rufus-scheduler # When the process is gone the schedules are gone!!
# import whenever #cron ?? seriously?? yes: for days etc
# import clockwork #same
# except Exception as e:
#   print "WARN scheduler NOT available"

class Event:
    pass
  # import  except None
  #     self.self.id=0
  # self.self.events=[]
  # self.self.scheduler = Rufus::Scheduler() except None
  #
  #
  # def __init__(time, action):
  #   self.time=time #Interval
  #   self.action=action
  #   self.self.events.append(self)
  #   self.id=self.self.id
  #   if not $testing:
  #     case time.kind
  #       when "in" then self.self.scheduler.in time.str(from)+time.unit[0] do self.invoke
  #       when "at" then self.self.scheduler.at time.str(from)+time.unit[0] do self.invoke
  #       when "every" then self.self.scheduler.every time.str(from)+time.unit[0] do self.invoke
  #   self.self.id=self.self.id+1
  #
  # def invoke(self):
  #   EnglishParser().parse
    # notify_observers(Time.now, "before "+self.action)
    # notify_observers(Time.now, "after "+self.action)

class Observer:
  def __init__(self,condition, action):
    self.condition=condition
    self.action=action


class Interval:

  #attr_accessor :from
  #attr_accessor :to
  #attr_accessor :kind
  #attr_accessor :unit

  def __init__(self,kind,fromy,to,unit):# , action):
    self.kind=kind # event_kinds
    self.fromy=fromy
    self.to=to
    self.unit=unit #convert!
    # self.action=action


# NAH!!
# class Time
#   def __init__(kind,time,unit):
#
#