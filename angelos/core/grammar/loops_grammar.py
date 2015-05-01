# encoding: utf-8

class LoopsGrammar:
  def loops(self):
    any {#loops }
      maybe( repeat_every_times ) or
          maybe( repeat_n_times ) or
          maybe( n_times_action ) or
          maybe( action_n_times ) or
          maybe( for_i_in_collection ) or
          maybe( while_loop ) or
          maybe( looped_action ) or
          maybe( looped_action_until ) or
          maybe( repeat_action_while) or
          maybe( as_long_condition_block ) or
          maybe( forever }
    )
# beep every 4 seconds
# every 4 seconds beep
# at 5pm send message to john
# send message to john at 5pm
  def repeat_every_times(self):
    must_contain time_words
    dont_interpret11 #'cause later
    ___ 'repeat'
    b=maybe( action }
    interval=datetime
    no_rollback11
    if not b:
      start_block
      dont_interpret11
      b=maybe( action ) or  block
      end_block

    # event=Event(interval:interval,event:b)
    event=Event(interval, b)
    event
    #if angel.use_tree: parent_node

  def repeat_action_while(self):
    _ 'repeat' #,'do'
    if self.string.match /\s*while/: raise_not_matching "repeat_action_while != repeat_while_action"
    b=action_or_block
    _ 'while'
    c=condition
    while evaluate_condition c
      self.result=do_execute_block b
    if self.interpret: end
    if angel.use_tree: return parent_node
    return self.result

  def while_loop(self):
    ___ 'repeat'
    __ 'while','as long as'
    dont_interpret11
    no_rollback11 #no_rollback11 13 # arbitrary value ! :{
    c=condition
    no_rollback11
    ___ 'repeat' # keep gerunding
    ___ 'then'
    b=action_or_block #Danger when interpreting it might contain conditions and breaks
    try:
    if interpreting(): r=do_execute_block b while (check_condition c)
    except
      print $!

    end_block?
    r or self.OK

  def until_loop(self):
    ___ 'repeat'
    __ 'until','as long as'
    dont_interpret11
    no_rollback11 #no_rollback11 13 # arbitrary value ! :{
    c=condition
    ___ 'repeat'
    b=action_or_block #Danger when interpreting it might contain conditions and breaks
    if interpreting(): r=do_execute_block b until (check_condition c)
    r

  def looped_action(self):
    must_contain 'as long as', 'while'
    dont_interpret11
    ___ 'do'
    ___ 'repeat'
    a=action # or semi-block
    __ 'as long as', 'while'
    c=condition
    if !interpreting(): return a
    if interpreting(): self.result=do_execute_block a while (check_condition c)
    self.result

  def looped_action_until(self):
    must_contain 'until'
    dont_interpret11
    ___ 'do'
    ___ 'repeat'
    a=action # or semi-block
    _'until'
    c=condition
    if !interpreting(): return a
    if interpreting(): self.result=do_execute_block a until (check_condition c)
    self.result

  def is_number(n):
    str(n).replace_numerals!.to_i != 0 #hum

    # notodo: LTR parser just here!
  # say hello 6 times   #=> (say hello 6) times ? give up for now
  # say hello 6 times 5 #=> hello 30 ??? SyntaxError! say hello (6 times 5)
  def action_n_times(self):
    must_contain 'times'
    dont_interpret11
    ___ 'do'
    #___ "repeat"
    a=action
    ws=a.join(' ').split(' ') except [a]

    if is_number ws[-1] # greedy action hack "say hello 6" times:
      a=ws[0..-2]
      n=ws[-1]

    if not n: n=number
    _ 'times'
    end_block
    if interpreting(): int(n).times { self.result=do_evaluate a }

  def n_times_action(self):
    must_contain 'times'
    n=number #or int_variable
    _ 'times'
    no_rollback11
    ___ 'do'
    ___ 'repeat'
    dont_interpret11
    a=action_or_block
    if interpreting(): int(n).times { self.result=do_evaluate a }

  def repeat_n_times(self):
    must_contain 'times'
    _ 'repeat'
    n=number
    _ 'times'
    no_rollback11
    dont_interpret11
    b=action_or_block
    if interpreting(): n.times { do_execute_block b }
    b
    #if angel.use_tree: parent_node

# if action was (not) parsed before: todo: node cache: skip action(X) -> _'forever' 
  def forever(self):
    must_contain 'forever'
    dont_interpret11
    allow_rollback
    a= action
    _ 'forever'
    self.forever=True
    if interpreting(): do_execute_block a while (self.forever)

  def as_long_condition_block(self):
    _ 'as long as'
    c=condition
    start_block
    a=block #  danger, block might contain condition
    end_block
    if interpreting(): do_execute_block a while (check_condition c)
