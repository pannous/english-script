require_relative "TreeBuilder"
require_relative "exceptions"
require_relative "extensions"

module EnglishParserTokens #< MethodInterception
  include TreeBuilder
  include Exceptions

##################/
# Lexemes = simple words
##################

  def numbers
    %w[1 2 3 4 5 6 7 8 9 0
      1st 2nd 3rd 4th 5th 6th 7th 8th 9th 0th 10th
      tenth ninth eighth seventh sixth fifth fourth third second first
      ten nine eight seven six five four three two one zero]
  end

  def operators
    ["+", "*", "-", "/", "plus", "minus", "times"] # DANGER! ambivalent!!   ,"and" 4 and 5 == TROUBLE!!!
  end

  def initialize
    super
    #pronouns +  TODO!!! keywords-pronouns has "I" (for I in [1..2])!?
    @NEWLINE="NEWLINE"
    @keywords=prepositions+modifiers+be_words+comparison_words+fillers+nill_words+done_words+auxiliary_verbs+
        conjunctions+type_keywords+otherKeywords+numbers+operators
  end

  def keywords
    @keywords # precalculated
  end


  def articles
    ['a', 'an', 'the', 'these', 'those', 'any', 'all', 'some', 'teh', 'that', 'every', 'each', 'this'] # 'that' * 2 !!!
  end

  def no_quantifiers
    ["nothing", "neither", "none", "no"]
  end

  def all_quantifiers
    ["all", "every", "everything", "the whole"]
  end

  def any_quantifiers
    ["any", "one", "some", "most", "many", "exists", "exist", "there is", "there are", "at least one", "at most two"]
  end

# "either", VS either of VS either or !!!!!
  def quantifiers #articles+
    ["any", "all", "every", "one", "each", "some", "most", "many", "nothing", "neither", "none", "no",
     "everything", "the whole"] #+number
  end

  def result_words
    ['it', 'they', 'result', 'its']
  end

  def type_keywords
    ["class", "interface", "module", "type", "kind"]
  end


  def type_names
    ["string", "int", "integer", "bool", "boolean", "list", "array", "hash"]
  end

  def constants
    ["true", "false", "yes", "no", "1", "0", "pi"]
  end

  def question_words
    ["when", "why", "where", "what", "who", "which", "whose", "whom", "how"] #,"what's","how's","why's", "when's","who's",
  end

  def prepositions
    ["of", 'above', 'with or without', 'after', 'against', 'apart from', 'around', 'as', 'aside from', 'at', 'before', 'behind',
     'below',
     'beneath', 'beside', 'between', 'beyond', 'by', 'considering', 'down', 'during', 'for', 'from', 'in',
     'instead of', 'inside of', 'inside', 'into', 'like', 'near', 'on', 'onto', 'out of', 'over', 'outside',
     'since', 'through', 'thru', 'to', 'till', 'with', 'up', 'upon', 'under', 'underneath', 'versus', 'via', 'with',
     'within', 'without', 'toward', 'towards', 'with_or_without'] #wow
  end


#'but',
  def all_prepositions
    ['aboard', 'about', 'above', 'across', 'after', 'against', 'along', 'amid', 'among', 'anti', 'around', 'as',
     'at', 'before', 'behind', 'below', 'beneath', 'beside', 'besides', 'between', 'beyond', 'by',
     'concerning', 'considering', 'despite', 'down', 'during', 'except', 'excepting', 'excluding', 'following',
     'for', 'from', 'in', 'inside', 'into', 'like', 'minus', 'near', 'of', 'off', 'on', 'onto', 'opposite',
     'outside', 'over', 'past', 'per', 'pro', 'plus', 're', 'regarding', 'round', 'save', 'sans', 'since', 'than',
     'through', 'thru', 'thruout', 'throughout', 'to', 'till',
     'toward', 'towards', 'under', 'underneath', 'unlike', 'until', 'up', 'upon', 'versus', 'via', 'with',
     'within', 'without']
  end

  def long_prepositions
    ['by means of', 'for the sake of', 'in accordance with', 'in addition to', 'in case of',
     'in front of',
     'in lieu of', 'in order to', 'in place of', 'in point of', 'in spite of', 'on account of',
     'on behalf of', 'on top of', 'with regard to', 'with respect to', 'with a view to', 'as far as',
     'as long as', 'as opposed to', 'as soon as', 'as well as', 'by virtue of']
  end

  def pair_prepositions
    ['according to', 'ahead of', 'apart from', 'as for', 'as of', 'as per', 'as regards', 'aside from',
     'back to', 'because of', 'close to', 'due to', 'except for', 'far from',
     'in to', '(contracted as into)', 'inside of', '(note that inside out is an adverb and not a preposition)',
     'instead of', 'left of', 'near to', 'next to', 'on to', '(contracted as onto)', 'out from', 'out of', 'outside of',
     'owing to', 'prior to', 'pursuant to', 'regardless of', 'right of', 'subsequent to', 'thanks to', 'that of', 'up to',
     'where as'] #,'whereas'
  end

  def postpositions
    ['ago', 'apart', 'aside', 'away', 'hence', 'notwithstanding', 'on', 'through', 'withal', 'again']
  end

  def conjunctions
    ['and', 'or', 'but', 'yet', 'xor', 'nand'] # so for nor
  end

  def correlative_conjunctions
    ['either...or', 'not only...but (also)', 'neither...nor', 'neither...or',
     'both...and', 'whether...or', 'just as...so']
  end

  def auxiliary_verbs
    #['isnt','isn\'t','is not','wasn\'t','was not',]
    ['is', 'be', 'was', 'cannot', 'can not', 'can', 'could', 'has', 'have', 'had', 'may', 'might', 'must', 'shall', 'should',
     'will', 'would', 'do']
  end

  def possessive_pronouns
    ['my', 'your', 'their', 'his', 'her', 'hers', 'theirs']
  end

  def pronouns
    ['I', 'i', 'me', 'my', 'mine', 'myself', 'we', 'us', 'our', 'ours', 'ourselves', 'you', 'your', 'yours', 'yourself', 'you',
     'your', 'yours', 'yourselves', 'he', 'him', 'his', 'himself', 'they', 'them', 'their', 'theirs', 'themselves', 'she',
     'her', 'hers', 'herself', 'it', 'its', 'itself', 'ye', 'thou', 'thee', 'thy', 'thine', 'thyself']
  end

  def interjections
    ['ah', 'aah', 'aha', 'ahem', 'ahh', 'argh', 'aw', 'bah', 'boo', 'brr', 'eek', 'eep', 'eh', 'eww',
     'gah', 'grr', 'hmm', 'huh', 'hurrah', 'meh', 'mhm', 'mm', 'muahaha', 'nah', 'nuh-uh', 'oh', 'ooh',
     'ooh-la-la', 'oomph', 'oops', 'ow', 'oy', 'oy', 'pff', 'phew', 'psst', 'sheesh', 'shh', 'tsk-tsk', 'uh-hu',
     'uh-uh', 'uh-oh', 'uhh', 'wee', 'whoa', 'wow', 'yeah', 'yahoo', 'yoo-hoo', 'yuh-uh', 'yuk', 'zing']
  end


  def fillers
    ["like", "y'know", "so", "actually", "literally", "basically", "right", "I'm tellin' ya",
     "you know what I mean?", "ehm", "uh", "er"]
  end

# danger: so,like,right!!

#Classifiers==#measure word="litre","cups","kernels","ears","bushels",


  def class_words
    ['is an', 'is a', 'has type', 'is of type'] # ...
  end

  def be_words
    ['is an', 'is a', 'is', 'be', 'was', 'are', 'will be', 'were', 'have been', 'shall be', 'should be', ':=', '=', '==', 'equals', 'equal',
     'is equal to', "consist of", "consists of", "is made up of", 'equal to']
  end

  # nicer, sweeter, ....
  #  '=>' '<=', DANGER
  # OR class_words
  def comparison_words
    ['be', 'is', 'are', 'were', '=', '>', '>=', '==', '<=', '<', '=<', 'gt', 'lt', 'eq', 'bigger', 'greater', 'equals',
     'identical to', 'smaller', 'less', 'equal to', 'more', 'less', 'the same as', 'same as', 'similar', 'comes after',
     'comes before', 'exact', 'exactly', '~>', 'at least', 'at most']
  end


  def once_words
    ['on the occasion that', 'whenever', 'wherever', "as soon as", "once"]
  end

  def if_words
    ['if', 'in case that', 'provided that', 'assuming that', 'conceding that', 'granted that',
     'on the assumption that', 'supposing that', 'with the condition that']
  end

  #  NOT: '0','0.0','0,nix','zero',
  def nill_words
    ['naught', 'nought', 'aught', 'oh', 'nil', 'nill', 'nul', 'nothing', 'not a thing', 'null', 'undefined',
     'zilch', 'nada', 'nuttin', 'nutting', 'zip', 'nix', 'cypher', 'cipher', 'leer', 'empty', 'nirvana', 'void'] #'love',
  end

  def done_words
    ['}', 'done', 'ende', 'end', 'okay', 'ok', 'OK', 'O.K.', 'alright', 'alrighty', 'that\'s it', 'thats it', "I'm done", "i'm done",
     'fine', 'fi',
     'fini', 'all set', 'finished', 'finish', 'fin', 'the end', 'over and out', 'over', 'q.e.d.', 'qed', "<end>"] # NL+ # NL verbium?]
  end

  def false_words
    ['false', 'FALSE', 'False', 'falsch', 'wrong', 'no', 'nein'] #'negative',
  end

  def true_words
    ['true', 'yes', 'ja', 'positive']
  end

  def boolean_words
    false_words+true_words
  end

  def otherKeywords
    ['and', 'as', 'back', 'beginning', 'but', 'by', 'contain', 'contains', 'copy', 'def', 'div', 'does', 'eighth', 'else',
     'end', 'equal', 'equals', 'error', 'every', 'false', 'fifth', 'first', 'for', 'fourth', 'even', 'front', 'get',
     'given', 'global', 'if', 'ignoring', 'is', 'it', 'its', 'last', 'local', 'me', 'middle', 'mod', 'my',
     'ninth', 'not', 'sixth', 'some', 'tell', 'tenth', 'then', 'third', 'timeout', 'times',
     'transaction', 'true', 'try', 'where', 'whose', 'until', 'while', 'prop', 'property', 'put', 'ref', 'reference',
     'repeat', 'returning', 'script', 'second', 'set', 'seventh', 'otherwise']
  end


  @verbs=nil #remove:
  @verbs2=['be', 'have', 'do', 'get', 'make', 'want', 'try', 'buy', 'take', 'apply', 'make', 'get', 'eat', 'drink',
           'say',
           'go', 'know', 'take', 'see', 'come', 'think', 'look', 'give', 'use', 'find', 'tell', 'ask', 'work', 'seem', 'feel',
           'leave', 'call', 'integrate', 'print', 'eat', 'test']

  def modifiers
    ['initial', 'public', 'static', 'void', 'default', 'protected', 'private', 'constant', 'const']
  end

  def modifier
    tokens modifiers
  end

  def pronoun
    __ pronouns
  end

  def nonzero
    tokens 'nonzero', 'not null', 'defined', 'existing', 'existant', 'available'
  end

  def nill
    t=tokens nill_words
    return :nill
  end

  def preposition
    tokens prepositions
  end

  def attribute
    tokens 'sucks', 'default'
  end

  def be
    tokens be_words
  end


  def adverb
    tokens 'often', 'never', 'joyfully', 'often', 'never', 'joyfully', 'quite', 'nearly', 'almost', 'definitely', 'by any means', 'without a doubt'
  end

  def let?
    _? 'let', 'set'
  end

  def let
    tokens 'let', 'set'
  end


  def time_words
    ['seconds', 'second', 'minutes', 'minute', 'a.m.', 'p.m.', 'pm', "o'clock", 'hours', 'hour'] #etc... !
  end

  def event_kinds
    ['in', 'at', 'every', 'from', 'between', 'after', 'before', 'until', 'till']
  end


  def bla_words
    ['tell me', 'hey', 'could you', 'give me',
     'i would like to', 'can you', 'please', 'let us', "let's", 'can i',
     'can you', 'would you', 'i would', 'i ask you to', "i'd",
     'love to', 'like to', 'i asked you to', 'would you', 'could i',
     'i tell you to', 'i told you to', 'would you', 'come on',
     'i wanna', 'i want to', 'i want', 'tell me', 'i need to',
     'i need']
  end


  def question
    tokens question_words
  end


  def method_tokens
    ['how to', 'function', 'definition for', 'definition of', 'define', 'method for', 'method', 'func', 'def',
     'in order to', '^to'] # <<< TO == DANGER!! to be or not to be
    # is defined as
    #
  end

  def bla
    tokens 'hey' #,'here is'
  end

  def the
    tokens articles
  end

  def the?
    maybe { the }
  end

  def number_word
    __(numbers).parse_integer
  end

  def number
  # complex? ||
    real? || integer? || number_word
  end

  def integer
    match=@string.match(/^\s*-?\d+/)
    if match
      @current_value=match[0].to_i
      @string=match.post_match.strip
      return @current_value
    end
    #return false
    raise NotMatching.new "no integer"
    #plus{tokens '1','2','3','4','5','6','7','8','9','0'}
  end

  def real
    raiseEnd
    match=@string.match(/^-?\d*\.\d+f?r?/)
    if match
      @current_value=match[0].to_f
      @string=match.post_match.strip
      return @current_value
    end
    #return false
    raise NotMatching.new "no real"
  end

  def complex
    match=@string.match(/^\s*\d+i/) # 3i
    match=@string.match(/^\s*\d*\.\d+i/) if not match # 3.3i
    match=@string.match(/^\s*\d+\s*\+\s*\d+i/) if not match # 3+3i
    match=@string.match(/^\s*\d*\.\d+\s*\+\s*\d*\.\d+i/) if not match # 3+3i
    if match
      @current_value=match[0].strip
      @string=match.post_match.strip
      return @current_value
    end
    return false
  end

  def fileName
    raiseEnd
    match=is_file(@string, false)
    if match
      path=match[0]
      path=path.gsub(/^\/home/, "/Users")
      path=File.new path rescue path
      @string=match.post_match.strip
      return @current_value=path
    end
    return false
  end


  def match_path string
    m=string.to_s.match /^(\/[\w\/\.]+)/
    return false if not m
    m
  end

  def is_file string, must_exist=true
    m=string.to_s.match /^([\w\/\.]+\.\w+)/ || match_path(string)
    return false if not m
    must_exist ? m && File.file?(m) : m
  end


  def is_dir string, must_exist=true
    #(@string+" ").match(/^(\/)?([^\/\\0]+(\/)?)+ /)
    m=match_path string
    must_exist ? m && File.directory?(m[0]) : m
  end

  def linuxPath
    raiseEnd
    match=match_path @string
    if match
      path=match[0]
      path=path.gsub(/^\/home/, "/Users")
      path=Dir.new path rescue path
      @string=match.post_match.strip
      return @current_value=path
    end
    return false
  end

  def rubyThing
    raiseEnd
    match=@string.match(/^[A-Z]\w+\.\w+/)
    if match
      thing=match[0]
      @string=match.post_match.strip
      args=@string.match(/^\(.*?\)/)
      @string=args.post_match.strip if args
      args=args||" #{value?||''}"
      thing=thing+"#{args}"
      verbose "rubyThing: "+thing
      # todo: better than eval!
      @current_value=eval(thing) if @interpret
      return @current_value
    end
    return false
  end


  def variables_list
    return ['x', 'y', 'z', 'a', 'i']
  end

  def true_variable
    vars=@variables.keys
    v=tokens vars
    return @variables[v] if @interpret
    #for v in @variables.keys
    #  if @string.start_with? v
    #    var=token v
    #    return var
    #  end
    #end
    #tokens variables_list # todo: remove (in endNodes, selectors,...)
  end


  def noun include=[]
    the?
    return word(include) unless $use_wordnet
    #return true if true_variable
    no_keyword_except include
    @current_value=wordnet_is_noun # expensive!!!
    #@current_value=call_is_noun # expensive!!!
  end

  def other_verbs
    ['increase','decrease']
  end

  def special_verbs
    ['evaluate', 'eval']
  end

  def verb
    system_verbs=['contains', 'contain']+special_verbs+auxiliary_verbs
    no_keyword_except system_verbs-be_words
    found_verb= tokens? other_verbs+system_verbs-be_words-['do'] #@verbs,
    return found_verb unless $use_wordnet
    @current_value=found_verb||wordnet_is_verb # call_is_verb
  end


  def adjective
    return @current_value=tokens('funny', 'big', 'small', 'good', 'bad') unless $use_wordnet
    @current_value=wordnet_is_adjective
  end

  def wordnet_is_noun # expensive!!!
    raise NotMatching.new "numbers are not nouns" if @string.match(/^\d/)
    the_noun=@string.match(/^\s*(\w+)/)[1] if @string.match(/^\s*(\w+)/) rescue nil
    #return false if not the_noun
    raise NotMatching.new "no noun word" if not the_noun
    raise NotMatching.new "no noun" if not the_noun.is_noun
    @string=@string.strip[the_noun.length..-1]
    the_noun
  end

  def wordnet_is_adjective # expensive!!!
    the_adjective=@string.match(/^\s*(\w+)/)[1] if @string.match(/^\s*(\w+)/) rescue nil
    raise NotMatching.new "no boolean adjectives" if boolean_words.has the_adjective
    #return false if not the_adjective
    raise NotMatching.new "no adjective word" if not the_adjective
    raise NotMatching.new "no adjective" if not the_adjective.is_adjective
    @string=@string.strip[the_adjective.length..-1]
    the_adjective
  end


  def wordnet_is_verb # expensive!!!
    the_verb=@string.match(/^\s*(\w+)/)[1] if @string.match(/^\s*(\w+)/) rescue nil
    return false if not the_verb
    raise NotMatching.new "no verb" if the_verb.synsets(:verb).empty?
    #raise NotMatching.new "no verb" if not the_verb.is_verb
    @string=@string.strip[the_verb.length..-1]
    the_verb
  end


  def call_is_verb
    # eats=>eat todo lifted => lift
    test=@string.match(/^\s*(\w+)s?/)[1] rescue nil
    return false if not test
    command=app_path+"/../word-lists/is_verb "+test
    #puts command
    found_verb=%x[#{command}]
    raise NotMatching.new "no verb" if found_verb.blank?
    @string=@string.strip[found_verb.length..-1] if found_verb
    verbose "found_verb "+found_verb.to_s
    found_verb
  end

  def call_is_noun
    test=@string.match(/^\s*(\w+)/)[1] rescue nil
    return false if not test
    command=app_path+"/../word-lists/is_noun "+test
    found_noun=%x[#{command}]
    raise NotMatching.new "no noun" if found_noun.blank?
    raise NotMatching.new "B.A.D. acronym noun" if found_noun==found_noun.upcase
    @string=@string.strip[found_noun.length..-1] if found_noun
    verbose "found_noun "+found_noun.to_s
    found_noun
  end

  def quote
    raiseEnd
    #return if checkEnd
    # todo :match ".*?"
    if @string.strip[0]=="'"
      @string.strip!
      to=@string[1..-1].index("'")
      @result=@current_value=@string[1..to];
      @string= @string[to+2..-1].strip
      return Quote.new @current_value
      #return "'"+@current_value+"'"
    end
    if @string.strip[0]=='"'
      @string.strip!
      to=@string[1..-1].index('"')
      @result=@current_value=@string[1..to];
      @string= @string[to+2..-1].strip
      return Quote.new @current_value
      #return '"'+@current_value+'"'
    end
    raise NotMatching.new("quote")
    #throw "no quote" if @throwing
    return false
  end

end
