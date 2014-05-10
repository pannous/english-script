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
      tenth ninth eighth seventh sixth fifth fourth third second first
      ten nine eight seven six five four three two one zero]
  end

  def operators
    ["+", "*", "-", "/","and","plus","minus","times"] # DANGER! ambivalent!!
  end

  def initialize
    super
    #pronouns +  TODO!!! keywords-pronouns has "I" (for I in [1..2])!?
    @NEWLINE="NEWLINE"
    @keywords=prepositions+modifiers+be_words+true_comparitons+fillers+nill_words+done_words+auxiliary_verbs+
        conjunctions+type_keywords+otherKeywords+numbers
  end

  def keywords
    @keywords # precalculated
  end


  def articles
    ['a','an','the','these','those','any','all','some','teh','that','every','each','this']# 'that' * 2 !!!
  end

  def quantifiers
    articles+ ["any","all","no","every"]#+number
  end

  def type_keywords
    ["class","interface","module","type","kind"]
  end

  def type_names
    ["string","int","integer","bool","boolean","list","array","hash"]
  end

  def constants
    ["true","false","yes","no","1","0","pi"]
  end

  def question_words
    ["when","why","where", "what", "who","which", "whose", "whom", "how"]#,"what's","how's","why's", "when's","who's",
  end

  def prepositions
    ['above','after','against','apart from','around','as','aside from','at','before','behind','below',
                 'beneath','beside','between','beyond','by','considering','down','during','for','from','in',
                 'instead of','inside of','inside','into','like','near','on','onto','out of','over', 'outside',
                 'since','through','thru','to','till','with','up','upon','under','underneath','versus', 'via','with',
                 'within','without','toward','towards']
  end


#'but',
  def all_prepositions
    ['aboard','about','above','across','after','against','along','amid','among','anti','around','as',
                     'at','before','behind','below','beneath','beside','besides','between','beyond','by',
                     'concerning' ,'considering','despite','down','during','except','excepting','excluding','following',
                     'for','from','in','inside','into','like','minus','near','of','off','on','onto','opposite',
                     'outside', 'over','past','per','pro','plus','re','regarding','round','save','sans','since','than',
                     'through','thru','thruout','throughout','to','till',
                     'toward','towards','under','underneath','unlike','until','up','upon','versus', 'via','with',
                     'within','without']
  end

  def long_prepositions
    ['by means of','for the sake of','in accordance with','in addition to','in case of',
                       'in front of',
                      'in lieu of','in order to','in place of','in point of','in spite of','on account of',
                      'on behalf of','on top of','with regard to','with respect to','with a view to','as far as',
                      'as long as','as opposed to','as soon as','as well as','by virtue of']
  end

  def pair_prepositions
  ['according to','ahead of','apart from','as for','as of','as per','as regards','aside from',
                      'back to','because of','close to','due to','except for','far from',
                      'in to','(contracted as into)','inside of','(note that inside out is an adverb and not a preposition)',
                      'instead of','left of','near to','next to','on to','(contracted as onto)','out from','out of','outside of',
                      'owing to','prior to','pursuant to','regardless of','right of','subsequent to','thanks to','that of','up to',
                      'where as']#,'whereas'
  end

  def postpositions
    ['ago','apart','aside','away','hence','notwithstanding','on','through','withal','again']
  end

  def conjunctions
    ['and','or','but','yet','xor','nand']# so for nor
  end

  def correlative_conjunctions
    ['either...or','not only...but (also)','neither...nor','neither...or',
                             'both...and', 'whether...or','just as...so']
  end

  def auxiliary_verbs
    #['isnt','isn\'t','is not','wasn\'t','was not',]
      ['is','be','was','cannot','can not','can','could','has', 'have','had','may','might','must','shall','should',
      'will','would']
  end

  def pronouns
    ['I','i','me','my','mine','myself','we','us','our','ours','ourselves','you','your','yours','yourself','you',
             'your','yours','yourselves','he','him','his','himself','they','them','their','theirs','themselves','she',
             'her','hers','herself','it','its','itself','ye','thou','thee','thy','thine','thyself']
  end

  def interjections
    ['ah','aah','aha','ahem','ahh','argh','aw','bah','boo','brr','eek','eep','eh','eww',
                  'gah','grr','hmm','huh','hurrah','meh','mhm','mm','muahaha','nah','nuh-uh','oh','ooh',
                  'ooh-la-la','oomph','oops','ow','oy','oy','pff','phew','psst','sheesh','shh','tsk-tsk','uh-hu',
                  'uh-uh','uh-oh','uhh','wee','whoa','wow','yeah','yahoo','yoo-hoo','yuh-uh','yuk','zing']
  end


  def fillers
    ["like", "y'know", "so", "actually", "literally", "basically", "right", "I'm tellin' ya",
            "you know what I mean?","ehm","uh","er" ]
  end
  # danger: so,like,right!!

#Classifiers==#measure word="litre","cups","kernels","ears","bushels",


  def class_words
    ['is an','is a','has type','is of type'] # ...
  end

  def be_words
    ['is an','is a','is','be','was','are','will be','were','have been','shall be','should be', ':=','=','==','equals','equal',
     'is equal to',"consist of","consists of","is made up of"]
  end

  # nicer, sweeter, ....
  #  '=>' '<=', DANGER
  # OR class_words
  def true_comparitons
    ['be','is','are','were','=','>','>=','==','<=','<','=<','gt','lt','eq','bigger','greater','equals',
     'identical to','smaller','less','equal to','more','less','the same as','same as','similar']
  end


  def once_words
    ['on the occasion that', 'whenever', 'wherever',"as soon as","once"]
  end

  def if_words
    ['if','in case that','provided that','assuming that', 'conceding that', 'granted that',
'on the assumption that', 'supposing that', 'with the condition that']
  end

  def nill_words
    ['0','0.0','0,nix','zero','naught','nought','aught','oh','nil','nill','nul','nothing','not a thing','null',
         'zilch','nada','nuttin','nutting','zip','nix','cypher','cipher','leer','empty','nirvana','void']  #'love',
  end

  def done_words
    ['}','done','ende','end','okay','ok','OK','O.K.','alright','alrighty','that\'s it','thats it',"I'm done","i'm done",
        'fine','fi',
        'fini','all set','finished','finish','fin','the end','over and out','over','q.e.d.','qed',"<end>"]# NL+ # NL verbium?]
  end


  def otherKeywords
    ['and','as','back','beginning','but','by','contain','contains','copy','def','div','does','eighth','else',
                  'end','equal','equals','error','every','false','fifth','first','for','fourth','even','front','get',
                  'given','global','if','ignoring' ,'is','it','its','last','local','me','middle','mod','my',
                  'ninth', 'not','sixth','some','tell','tenth','then','third','timeout','times',
                  'transaction','true','try','where','whose','until','while','prop','property','put','ref','reference',
                  'repeat','returning','script','second','set','seventh']
  end


  @verbs=nil #remove:
  @verbs2=[ 'be', 'have', 'do', 'get', 'make', 'want', 'try', 'buy','take','apply','make','get','eat','drink',
            'say',
            'go','know','take','see','come','think','look','give','use','find','tell','ask','work','seem','feel',
            'leave','call','integrate','print','eat','test']

  def modifiers
    ['initial','public','static','void','default','protected','private','constant','const']
  end

  def modifier
    tokens modifiers
  end

  def pronoun
    __ pronouns
  end

  def nill
    tokens nill_words
  end

  def preposition
    tokens prepositions
  end

  def attribute
    tokens 'sucks','default'
  end

  def be
    tokens be_words
  end


  def adverb
    tokens 'often','never','joyfully', 'often','never','joyfully','quite','nearly','almost','definitely','by any means','without a doubt'
  end



  def done
    #if(@string[0]=='}')
    #  @string=@string[1]
    #  pop '}'
    #end
    #return true if checkEndOfLine
    return "OK" if checkNewline
    tokens done_words
    #rescue EndOfLine =>x
    #  puts x
    #end
    #return true
    #ignore_rest_of_line
  end

  def let?
    _? 'let' , 'set'
  end

  def let
    tokens 'let' , 'set'
  end



  def question
    tokens question_words
  end


  def method
    tokens 'how to','function','definition for','definition of','define','method for','method',
           'in order to','^to' # <<< TO == DANGER!! to be or not to be
    # is defined as
    #
  end

  def bla
    tokens 'hey'#,'here is'
  end

  def the
    tokens articles
  end

  def the?
    maybe{the}
  end

  def number # complex ||
    real? || integer? || __(numbers).parse_integer
  end

  def integer
    match=@string.match(/^\s*\d+/)
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
    match=@string.match(/^\d*\\.\d+/)
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
    match=@string.match(/^\s*\d*\.\d+i/)  if not match # 3.3i
    match=@string.match(/^\s*\d+\s*\+\s*\d+i/)  if not match # 3+3i
    match=@string.match(/^\s*\d*\.\d+\s*\+\s*\d*\.\d+i/)  if not match # 3+3i
    if match
      @current_value=match[0].strip
      @string=match.post_match.strip
      return @current_value
    end
    return false
  end

  def fileName
    raiseEnd
    match=is_file(@string,false)
    if match
      path=match[0]
      path=path.gsub(/^\/home/,"/Users")
      path=File.new path rescue path
      @string=match.post_match.strip
      return @current_value=path
    end
    return false
  end


  def match_path string
    string.to_s.match /^(\/[\w\/\.]+)/
  end

  def is_file string, must_exist=true
    m=string.to_s.match /^([\w\/\.]+\.\w+)/ || match_path(string)
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
      path=path.gsub(/^\/home/,"/Users")
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
      verbose "rubyThing: "+thing
      @current_value=eval(thing) if @interpret
      @string=match.post_match.strip
      return @current_value
    end
    return false
  end



  def variables_list
    return ['x','y','z','a','i']
  end

  def true_variable
    v=tokens @variables.keys
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
    no_keyword_except include
    #return true if true_variable
    @current_value=wordnet_is_noun
    #@current_value=call_is_noun
  end

  def special_verbs
    ['evaluate','eval']
  end

  def adjective
    @current_value=wordnet_is_adjective
    #tokens 'funny','big','small','good','bad'
  end

  def wordnet_is_noun
    the_noun=@string.match(/^\s*(\w+)/)[1] rescue nil
    #return false if not the_noun
    raise NotMatching.new "no noun word" if not the_noun
    raise NotMatching.new "no noun" if not the_noun.is_noun
    @string=@string.strip[the_noun.length..-1]
    the_noun
  end

  def wordnet_is_adjective
    the_adjective=@string.match(/^\s*(\w+)/)[1] rescue nil
    #return false if not the_adjective
    raise NotMatching.new "no adjective word" if not the_adjective
    raise NotMatching.new "no adjective" if not the_adjective.is_adjective
    @string=@string.strip[the_adjective.length..-1]
    the_adjective
  end


  def wordnet_is_verb
    the_verb=@string.match(/^\s*(\w+)/)[1] rescue nil
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

  def verb
    system_verbs=['contains','contain']+special_verbs+auxiliary_verbs
    no_keyword_except system_verbs-be_words
    found_verb= tokens? system_verbs-be_words #@verbs,
    @current_value=found_verb||wordnet_is_verb # call_is_verb
  end

end
