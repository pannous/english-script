# encoding: utf-8
from tokenize import tokenize, untokenize, NUMBER, STRING, NAME, OP
from io import BytesIO
import os
# import TreeBuilder
import angle
from exceptions import *
import extensions
# encoding: utf-8
# include TreeBuilder
#   include Exceptions
# module EnglishParserTokens:
# class EnglishParserTokens:
# < MethodInterception

##################/
# Lexemes = simple words
##################
    # def __init__(self):
from nodes import Quote
from power_parser import * #app_path, verbose
bash_commands=['ls','cd']
main_verbs=['be', 'have', 'do', 'get', 'make', 'want', 'try', 'buy', 'take', 'apply', 'make', 'get', 'eat', 'drink',
               'go', 'know', 'take', 'see', 'come', 'think', 'look', 'give', 'use', 'find', 'tell', 'ask', 'work', 'seem', 'feel',
               'leave', 'call', 'integrate', 'print', 'eat', 'test','say']


method_tokens=  ['how to', 'function', 'definition for', 'definition of', 'define', 'method for', 'method',
                 'func','fn', 'def', 'in order to', 'to','^to'] # <<< TO == DANGER!! to be or not to be
# ,'impl','implementation','algorithm','routine'
import_keywords=[ 'dependencies', 'dependency', 'depends on', 'depends', 'requirement', 'requirements', 'require', 'required', 'include', 'using', 'uses', 'needs', 'requires', 'import']
require_types = "javascript script js gcc ruby gem header c cocoa native".split()  # todo c++ c# not tokenized!

numbers= "1 2 3 4 5 6 7 8 9 0\
      -1 -2 -3 -4 -5 -6 -7 -8 -9 -0\
      1st 2nd 3rd 4th 5th 6th 7th 8th 9th 0th 10th\
      tenth ninth eighth seventh sixth fifth fourth third second first\
      ten nine eight seven six five four three two one zero".split()

operators= ["+", "*", "-", "/","//","%","|","||","&","&&","^","^^","**", "mod","modulo" "plus", "minus", "times","and","or","xor","power","to the"]
 # DANGER! ambivalent!!   ,"and" 4 and 5 == TROUBLE!!! really? 4 and 5 == 9 ~= True OK lol
 # just make sure that 4 and False = False  4 and True == True

special_chars=list("!@#$%^*()+_}{\":?><,./';][=-`'|\\")

NEWLINE="NEWLINE"

articles= ['a', 'an', 'the', 'these', 'those', 'any', 'all', 'some', 'teh', 'that', 'every', 'each', 'this'] # 'that' * 2 !!!

no_quantifiers= ["nothing", "neither", "none", "no"]

all_quantifiers= ["all", "every", "everything", "the whole"]

any_quantifiers= ["any", "one", "some", "most", "many", "exists", "exist", "there is", "there are", "at least one", "at most two"]

# "either", VS either of VS either or !!!!!
quantifiers=["any", "all", "every", "one", "each", "some", "most", "many", "nothing", "neither", "none", "no","everything", "the whole"] #+number
#articles+):

result_words= ['it', 'they', 'result', 'its','that']

type_keywords= ["class", "interface", "module", "type", "kind"]

type_names=["auto","string", "int", "integer", "bool", "boolean", "list", "array", "hash","float","real","double","number","set","type","str"]
##danger(self): object,class ,class  "char","character",,"word"):

constants= ["True", "false", "yes", "no", "1", "0", "pi"]

question_words= ["when", "why", "where", "what", "who", "which", "whose", "whom", "how"] #,"what's","how's","why's", "when's","who's",

prepositions= ["of", 'above', 'with or without', 'after', 'against', 'apart from', 'around', 'as', 'aside from', 'at', 'before', 'behind',\
     'below',\
     'beneath', 'beside', 'between', 'beyond', 'by', 'considering', 'down', 'during', 'for', 'from', 'in',\
     'instead of', 'inside of', 'inside', 'into', 'like', 'near', 'on', 'onto', 'out of', 'over', 'outside',\
     'since', 'through', 'thru', 'to', 'till', 'with', 'up', 'upon', 'under', 'underneath', 'versus', 'via', 'with',\
     'within', 'without', 'toward', 'towards', 'with_or_without'] #wow

#'but',
all_prepositions= ['aboard', 'about', 'above', 'across', 'after', 'against', 'along', 'amid', 'among', 'anti', 'around', 'as',\
    'at', 'before', 'behind', 'below', 'beneath', 'beside', 'besides', 'between', 'beyond', 'by',\
    'concerning', 'considering', 'despite', 'down', 'during', 'except', 'excepting', 'excluding', 'following',\
    'for', 'from', 'in', 'inside', 'into', 'like', 'minus', 'near', 'of', 'off', 'on', 'onto', 'opposite',\
    'outside', 'over', 'past', 'per', 'pro', 'plus', 're', 'regarding', 'round', 'save', 'sans', 'since', 'than',\
    'through', 'thru', 'thruout', 'throughout', 'to', 'till',\
    'toward', 'towards', 'under', 'underneath', 'unlike', 'until', 'up', 'upon', 'versus', 'via', 'with',\
    'within', 'without']

long_prepositions= ['by means of', 'for the sake of', 'in accordance with', 'in addition to', 'in case of',\
    'in front of',\
    'in lieu of', 'in order to', 'in place of', 'in point of', 'in spite of', 'on account of',\
    'on behalf of', 'on top of', 'with regard to', 'with respect to', 'with a view to', 'as far as',\
    'as long as', 'as opposed to', 'as soon as', 'as well as', 'by virtue of']

pair_prepositions= ['according to', 'ahead of', 'apart from', 'as for', 'as of', 'as per', 'as regards', 'aside from',\
    'back to', 'because of', 'close to', 'due to', 'except for', 'far from',\
    'in to', '(contracted as into)', 'inside of', '(note that inside out is an adverb and not a preposition)',\
    'instead of', 'left of', 'near to', 'next to', 'on to', '(contracted as onto)', 'out from', 'out of', 'outside of',\
    'owing to', 'prior to', 'pursuant to', 'regardless of', 'right of', 'subsequent to', 'thanks to', 'that of', 'up to',\
    'where as'] #,'whereas'

postpositions= ['ago', 'apart', 'aside', 'away', 'hence', 'notwithstanding', 'on', 'through', 'withal', 'again']

conjunctions= ['and', 'or', 'but', 'yet', 'xor', 'nand'] # so for nor

correlative_conjunctions= ['either...or', 'not only...but (also)', 'neither...nor', 'neither...or',\
    'both...and', 'whether...or', 'just as...so']

#['isnt','isn\'t','is not','wasn\'t','was not',]
auxiliary_verbs=['is', 'be', 'was', 'cannot', 'can not', 'can', 'could', 'has', 'have', 'had', 'may', 'might', 'must', 'shall', 'should',\
    'will', 'would', 'do']

possessive_pronouns=['my', 'your', 'their', 'his', 'her', 'hers', 'theirs']

pronouns=['I', 'i', 'me', 'my', 'mine', 'myself', 'we', 'us', 'our', 'ours', 'ourselves', 'you', 'your', 'yours', 'yourself', 'you',\
    'your', 'yours', 'yourselves', 'he', 'him', 'his', 'himself', 'they', 'them', 'their', 'theirs', 'themselves', 'she',\
    'her', 'hers', 'herself', 'it', 'its', 'itself', 'ye', 'thou', 'thee', 'thy', 'thine', 'thyself']

interjections=['ah', 'aah', 'aha', 'ahem', 'ahh', 'argh', 'aw', 'bah', 'boo', 'brr', 'eek', 'eep', 'eh', 'eww',\
    'gah', 'grr', 'hmm', 'huh', 'hurrah', 'meh', 'mhm', 'mm', 'muahaha', 'nah', 'nuh-uh', 'oh', 'ooh',\
    'ooh-la-la', 'oomph', 'oops', 'ow', 'oy', 'oy', 'pff', 'phew', 'psst', 'sheesh', 'shh', 'tsk-tsk', 'uh-hu',\
    'uh-uh', 'uh-oh', 'uhh', 'wee', 'whoa', 'wow', 'yeah', 'yahoo', 'yoo-hoo', 'yuh-uh', 'yuk', 'zing']

fillers=["like", "y'know", "so", "actually", "literally", "basically", "right", "I'm tellin' ya",\
    "you know what I mean?", "ehm", "uh", "er"]

# danger: so,like,right!!

#Classifiers==#measure word="litre","cups","kernels","ears","bushels",

class_words=['is an', 'is a', 'has type', 'is of type'] # ...

be_words=['is an', 'is a', 'is', 'be', 'was', 'are', 'will be', 'were', 'have been', 'shall be', 'should be', ':=', '=', '==', 'equals', 'equal',\
    'is equal to', "consist of", "consists of", "is made up of", 'equal to','same','the same as','same as','the same']

  # nicer, sweeter, ....
  #  '=>' '<=', DANGER
  # OR class_words
comparison_words=['be','is of','is in','is a', 'is','element of','subset of','in', 'are', 'were',  '>=', '==', '<=',  '=<','=', '>', '<','gt', 'lt', 'eq',\
    'identical to', 'smaller or equal','greater or equal', 'equal to', 'bigger', 'greater', 'equals','smaller', 'less','more',  'the same as',\
    'same as', 'similar', 'comes after',\
    'comes before', 'exact', 'exactly', '~>', 'at least', 'at most']

once_words=['on the occasion that', 'whenever', 'wherever', "as soon as", "once"]

if_words=['if', 'in case that', 'provided that', 'assuming that', 'conceding that', 'granted that',\
    'on the assumption that', 'supposing that', 'with the condition that']

  #  NOT: '0','0.0','0,nix','zero',
nill_words=['naught', 'nought', 'aught', 'oh', 'None', 'nill', 'nul', 'nothing', 'not a thing', 'null', 'undefined',\
    'zilch', 'nada', 'nuttin', 'nutting', 'zip', 'nix', 'cypher', 'cipher', 'leer', 'empty', 'nirvana', 'void'] #'love',

done_words=['}', 'done', 'ende', 'end', 'okay', 'ok', 'OK', 'O.K.', 'alright', 'alrighty', 'that\'s it', 'thats it', "I'm done", "i'm done",\
    'fine', 'fi', 'fini', 'all set', 'finished', 'finish', 'fin', 'the end', 'over and out', 'over', 'q.e.d.', 'qed', "<end>"] # NL+ # NL verbium?]

false_words=['false', 'FALSE', 'False', 'falsch', 'wrong', 'no', 'nein'] #'negative',

true_words=['True', 'yes', 'ja', 'positive']

boolean_words=false_words+true_words

otherKeywords= ['and', 'as', 'back', 'beginning', 'but', 'by', 'contain', 'contains', 'copy', 'def', 'div', 'does', 'eighth', 'else:',\
    'end', 'equal', 'equals', 'error', 'every', 'false', 'fifth', 'first', 'for', 'fourth', 'even', 'front', 'get',\
    'given', 'global', 'if', 'ignoring', 'is', 'it', 'its', 'last', 'local', 'me', 'middle', 'mod', 'my',\
    'ninth', 'not', 'sixth', 'some', 'tell', 'tenth', 'then', 'third', 'timeout', 'times',\
    'transaction', 'True', 'try', 'where', 'whose', 'until', 'while', 'prop', 'property', 'put', 'ref', 'reference',\
    'repeat', 'returning', 'script', 'second', 'set', 'seventh', 'otherwise']

const=['constant', 'const','final','immutable','unchangeable'] #not: static

modifiers= const + ['protected', 'private','public', 'static', 'void', 'default', 'initial', 'mutable','variable']

adverbs=['often', 'never', 'joyfully', 'often', 'never', 'joyfully', 'quite', 'nearly', 'almost', 'definitely', 'by any means', 'without a doubt']

let=['let', 'set']

time_words=['seconds', 'second', 'minutes', 'minute', 'a.m.', 'p.m.', 'pm', "o'clock", 'hours', 'hour'] #etc... !

event_kinds=['in', 'at', 'every', 'from', 'between', 'after', 'before', 'until', 'till']

bla_words=['tell me', 'hey', 'could you', 'give me',\
    'i would like to', 'can you', 'please', 'let us', "let's", 'can i',\
    'can you', 'would you', 'i would', 'i ask you to', "i'd",\
    'love to', 'like to', 'i asked you to', 'would you', 'could i',\
    'i tell you to', 'i told you to', 'would you', 'come on',\
    'i wanna', 'i want to', 'i want', 'tell me', 'i need to',\
    'i need']

attributes=['sucks', 'default']

keywords=prepositions+modifiers+be_words+comparison_words+fillers+nill_words+done_words+auxiliary_verbs+conjunctions+type_keywords+otherKeywords+numbers+operators

true=True
false=False
TRUE="True"
FALSE="False"
NILL="None"
Nil="None"
# Nill="None"
ZERO='0'

start_block_words=[';',':', 'do', '{','begin','start', 'first you ', 'second you ', 'then you ', 'finally you ']

flow_keywords=['next', 'continue', 'break', 'stop']
eval_keywords=['eval','what is', 'evaluate', 'how much', 'what are', 'calculate']
nonzero_keywords=['nonzero', 'not null', 'defined', 'existing', 'existant','existent', 'available']
other_verbs=['increase','decrease','square','invert','test']
special_verbs=['evaluate', 'eval']
system_verbs=['contains', 'contain']+special_verbs+auxiliary_verbs
invoke_keywords=['call', 'execute', 'run', 'start', 'evaluate', 'eval', 'invoke'] # not: go!
context_keywords=['context','module','package']
self_modifying_operators=['|=', '&=', '&&=', '||=', '+=', '-=', '/=', '^=', '%=', '#=', '*=', '**=', '<<', '>>']

newline_tokens=["\.\n", "\. ", "\n", "\r\n", ';']
