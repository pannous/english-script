module LoopsGrammar
  def loops
    any {#loops }
      maybe { repeat_every_times }||
          maybe { repeat_n_times }||
          maybe { n_times_action }||
          maybe { action_n_times }||
          maybe { for_i_in_collection }||
          maybe { while_loop }||
          maybe { looped_action }||
          maybe { as_long_condition_block }||
          maybe { forever }
    }
  end


# beep every 4 seconds
# every 4 seconds beep
# at 5pm send message to john
# send message to john at 5pm
  def repeat_every_times
    must_contain time_words
    dont_interpret! #'cause later
    _? 'repeat'
    b=maybe { action }
    interval=datetime
    no_rollback!
    if not b
      start_block
      dont_interpret!
      b=maybe { action } || block
      end_block
    end
    # event=Event.new interval:interval,event:b
    event=Event.new interval, b
    event
    #parent_node if $use_tree
  end

  def repeat_while
    _ 'repeat'
    _while =_? 'while'
    c=condition
    _ 'while' if not _while
    b=block
    while evaluate_condition c
      @result=do_execute_block b
    end if @interpret
    return parent_node if $use_tree
    return @result
  end


  def while_loop
    _ 'while'
    dont_interpret!
    no_rollback! #no_rollback! 13 # arbitrary value ! :{
    c=condition
    start_block
    b=block #Danger when interpreting it might contain conditions and breaks
    end_block
    r=do_execute_block b while (check_condition c) if check_interpret
    r
  end

#
#def until_condition
#  action
#  _'until'
#  condition
#end
#
#def while_condition
#  action
#  _'while'
#  condition
#end
#
#def as_long_condition
#  action
#  _'as long'
#  condition
#end
#

  def looped_action
    must_contain 'as long', 'while', 'until'
    dont_interpret!
    _? 'do'
    _? 'repeat'
    a=action
    __ 'as long', 'while', 'until'
    c=condition
    do_execute_block a while (check_condition c) if check_interpret
  end


  # notodo: LTR parser just here!
  # say hello 6 times
  # say hello 6 times 5 #=> hello 30 ??? SyntaxError! say hello (6 times 5)
  def action_n_times
    must_contain 'times'
    dont_interpret!
    _? 'do'
    #_? "repeat"
    a=action
    a, n=a.join(' ').split(/(\d)\s*$/) #if a.matches /\d\s*$/ # greedy action hack "say hello 6"
    n=number if not n
    _ 'times'
    end_block
    n.to_i.times { @result=do_evaluate a } if check_interpret
  end

  def n_times_action
    must_contain 'times'
    n=number #or int_variable
    _ 'times'
    no_rollback!
    _? 'do'
    _? 'repeat'
    dont_interpret!
    a=action_or_block
    n.to_i.times { @result=do_evaluate a } if check_interpret
  end

  def repeat_n_times
    _ 'repeat'
    n=number
    _ 'times'
    no_rollback!
    dont_interpret!
    b=action_or_block
    n.times { do_execute_block b } if check_interpret
    b
    #parent_node if $use_tree
  end


# todo: node cache: skip action(X) -> _'forever'  if action was (not) parsed before
  def forever
    must_contain 'forever'
    dont_interpret!
    allow_rollback
    a= action
    _ 'forever'
    @forever=true
    do_execute_block a while (@forever) if check_interpret
  end

  def as_long_condition_block
    _ 'as long as'
    c=condition
    start_block
    a=block #  danger, block might contain condition
    end_block
    do_execute_block a while (check_condition c) if check_interpret
  end


end
