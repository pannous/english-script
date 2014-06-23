# encoding: utf-8

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
          maybe { looped_action_until }||
          maybe { repeat_while} ||
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
    _ 'repeat' #,'do'
    raise NotMatching if @string.match /\s*while/
    b=action_or_block
    _ 'while'
    c=condition
    while evaluate_condition c
      @result=do_execute_block b
    end if @interpret
    return parent_node if $use_tree
    return @result
  end


  def while_loop
    _? 'repeat'
    __ 'while','as long as'
    dont_interpret!
    no_rollback! #no_rollback! 13 # arbitrary value ! :{
    c=condition
    _? 'repeat' # keep gerunding
    b=action_or_block #Danger when interpreting it might contain conditions and breaks
    r=do_execute_block b while (check_condition c) if check_interpret
    r
  end


  def until_loop
    _? 'repeat'
    __ 'until','as long as'
    dont_interpret!
    no_rollback! #no_rollback! 13 # arbitrary value ! :{
    c=condition
    _? 'repeat'
    b=action_or_block #Danger when interpreting it might contain conditions and breaks
    r=do_execute_block b until (check_condition c) if check_interpret
    r
  end

  def looped_action
    must_contain 'as long as', 'while'
    dont_interpret!
    _? 'do'
    _? 'repeat'
    a=action # or semi-block
    __ 'as long as', 'while'
    c=condition
    return a if !check_interpret
    @result=do_execute_block a while (check_condition c) if check_interpret
    @result
  end

  def looped_action_until
    must_contain 'until'
    dont_interpret!
    _? 'do'
    _? 'repeat'
    a=action # or semi-block
    _'until'
    c=condition
    return a if !check_interpret
    @result=do_execute_block a until (check_condition c) if check_interpret
    @result
  end

  def is_number n
    n.to_s.replace_numerals!.to_i != 0 #hum
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
    ws=a.join(' ').split(' ')

    if is_number ws[-1] # greedy action hack "say hello 6" times
      a=ws[0..-2]
      n=ws[-1]
    end
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
    must_contain 'times'
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
