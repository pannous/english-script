#!/usr/bin/env ruby

$use_tree=false
#$use_tree=true

require_relative '../parser_test_helper'

class ObserverTest  < ParserBaseTest

  include ParserTestHelper

  def _test_every_date1 # OK, trust me ;)
    parse 'every 1 seconds { say "Ja!" }'
    parse 'every 2 seconds do say "OK"'
    sleep 10000
  end

  def _test_every_date  # OK, trust me ;)
    parse 'every 1 seconds do say "OK"'
    parse 'beep every three seconds'
    parse 'every two seconds puts "YAY"'
    # parse 'every second puts "HURRAY"' # WAH! every second  VS  every second hour WTF ! lol
    parse 'every minute puts "HURRAY"' # WAH! every second  VS  every second hour WTF ! lol
    parse 'every five seconds do say "OK"'
    # parse 'every three seconds make a beep'
    sleep 10000
  end

  def test_whenever
    # verbose
    parse "beep whenever x is 5"
    parse "beep once x is 5"
    parse "once x is 5 do beep"
    parse "once x is 5 beep "
    parse "x is 5"
    # todo assert beeped
    # parse "beep whenever the clock shows five seconds"
  end

  def test_whenever_2
    skip "test this later"
    parse "whenever the clock shows five seconds do beep"
    #parse "whenever that clock shows five seconds beep"
    assert @result=="1/3"
  end

end
