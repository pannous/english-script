#!/usr/bin/ruby

require 'wordnet' unless defined?( WordNet )
require 'wordnet/constants'
require 'wordnet/model'


# WordNet synonym-set object class
#
# Instances of this class encapsulate the data for a synonym set ('synset') in a
# WordNet lexical database. A synonym set is a set of words that are
# interchangeable in some context.
#
# We can either fetch the synset from a connected Lexicon:
#
#    lexicon = WordNet::Lexicon.new( 'postgres://localhost/wordnet30' )
#    ss = lexicon[ :first, 'time' ]
#    # => #<WordNet::Synset:0x7ffbf2643bb0 {115265518} 'commencement, first,
#    #       get-go, offset, outset, start, starting time, beginning, kickoff,
#    #       showtime' (noun): [noun.time] the time at which something is
#    #       supposed to begin>
#
# or if you've already created a Lexicon, use its connection indirectly to
# look up a Synset by its ID:
#
#    ss = WordNet::Synset[ 115265518 ]
#    # => #<WordNet::Synset:0x7ffbf257e928 {115265518} 'commencement, first,
#    #       get-go, offset, outset, start, starting time, beginning, kickoff,
#    #       showtime' (noun): [noun.time] the time at which something is
#    #       supposed to begin>
#
# You can fetch a list of the lemmas (base forms) of the words included in the
# synset:
#
#    ss.words.map( &:lemma )
#    # => ["commencement", "first", "get-go", "offset", "outset", "start",
#    #     "starting time", "beginning", "kickoff", "showtime"]
#
# But the primary reason for a synset is its lexical and semantic links to
# other words and synsets. For instance, its *hypernym* is the equivalent
# of its superclass: it's the class of things of which the receiving
# synset is a member.
#
#    ss.hypernyms
#    # => [#<WordNet::Synset:0x7ffbf25c76c8 {115180528} 'point, point in
#    #        time' (noun): [noun.time] an instant of time>]
#
# The synset's *hypernyms*, on the other hand, are kind of like its
# subclasses:
#
#    ss.hyponyms
#    # => [#<WordNet::Synset:0x7ffbf25d83b0 {115142167} 'birth' (noun):
#    #       [noun.time] the time when something begins (especially life)>,
#    #     #<WordNet::Synset:0x7ffbf25d8298 {115268993} 'threshold' (noun):
#    #       [noun.time] the starting point for a new state or experience>,
#    #     #<WordNet::Synset:0x7ffbf25d8180 {115143012} 'incipiency,
#    #       incipience' (noun): [noun.time] beginning to exist or to be
#    #       apparent>,
#    #     #<WordNet::Synset:0x7ffbf25d8068 {115266164} 'starting point,
#    #       terminus a quo' (noun): [noun.time] earliest limiting point>]
#
# == Traversal
#
# Synset also provides a few 'traversal' methods which provide recursive searching
# of a Synset's semantic links:
#
#    # Recursively search for more-general terms for the synset, and print out
#    # each one with indentation according to how distantly it's related.
#    lexicon[ :fencing, 'sword' ].
#        traverse(:hypernyms).with_depth.
#        each {|ss, depth| puts "%s%s [%d]" % ['  ' * (depth-1), ss.words.first, ss.synsetid] }
#    # (outputs:)
#    play [100041468]
#      action [100037396]
#        act [100030358]
#          event [100029378]
#            psychological feature [100023100]
#              abstract entity [100002137]
#                entity [100001740]
#    combat [101170962]
#      battle [100958896]
#        group action [101080366]
#          event [100029378]
#            psychological feature [100023100]
#              abstract entity [100002137]
#                entity [100001740]
#          act [100030358]
#            event [100029378]
#              psychological feature [100023100]
#                abstract entity [100002137]
#                  entity [100001740]
#
# See the <b>Traversal Methods</b> section for more details.
#
# == Low-Level API
#
# This library is implemented using Sequel::Model, an ORM layer on top of the
# excellent Sequel database toolkit. This means that in addition to the
# high-level methods above, you can also make use of a database-oriented
# API if you need to do something not provided by a high-level method.
#
# In order to make use of this API, you'll need to be familiar with
# {Sequel}[http://sequel.rubyforge.org/], especially
# {Datasets}[http://sequel.rubyforge.org/rdoc/files/doc/dataset_basics_rdoc.html] and 
# {Model Associations}[http://sequel.rubyforge.org/rdoc/files/doc/association_basics_rdoc.html].
# Most of Ruby-WordNet's functionality is implemented in terms of one or both
# of these.
#
# === Datasets
#
# The main dataset is available from WordNet::Synset.dataset:
#
#   WordNet::Synset.dataset
#   # => #<Sequel::SQLite::Dataset: "SELECT * FROM `synsets`">
#
# In addition to this, Synset also defines a few other canned datasets. To facilitate
# searching by part of speech on the Synset class:
#
# * WordNet::Synset.nouns
# * WordNet::Synset.verbs
# * WordNet::Synset.adjectives
# * WordNet::Synset.adverbs
# * WordNet::Synset.adjective_satellites
#
# or by the semantic links for a particular Synset:
#
# * WordNet::Synset#also_see_dataset
# * WordNet::Synset#attributes_dataset
# * WordNet::Synset#antonyms_dataset
# * WordNet::Synset#causes_dataset
# * WordNet::Synset#domain_categories_dataset
# * WordNet::Synset#domain_member_categories_dataset
# * WordNet::Synset#domain_member_regions_dataset
# * WordNet::Synset#domain_member_usages_dataset
# * WordNet::Synset#domain_regions_dataset
# * WordNet::Synset#domain_usages_dataset
# * WordNet::Synset#entailments_dataset
# * WordNet::Synset#hypernyms_dataset
# * WordNet::Synset#hyponyms_dataset
# * WordNet::Synset#instance_hypernyms_dataset
# * WordNet::Synset#instance_hyponyms_dataset
# * WordNet::Synset#member_holonyms_dataset
# * WordNet::Synset#member_meronyms_dataset
# * WordNet::Synset#part_holonyms_dataset
# * WordNet::Synset#part_meronyms_dataset
# * WordNet::Synset#semlinks_dataset
# * WordNet::Synset#semlinks_to_dataset
# * WordNet::Synset#senses_dataset
# * WordNet::Synset#similar_words_dataset
# * WordNet::Synset#substance_holonyms_dataset
# * WordNet::Synset#substance_meronyms_dataset
# * WordNet::Synset#sumo_terms_dataset
# * WordNet::Synset#verb_groups_dataset
# * WordNet::Synset#words_dataset
#
class WordNet::Synset < WordNet::Model( :synsets )
	include WordNet::Constants

	require 'wordnet/lexicallink'
	require 'wordnet/semanticlink'

	# Semantic link type keys; maps what the API calls them to what
	# they are in the DB.
	SEMANTIC_TYPEKEYS = Hash.new {|h,type| h[type] = type.to_s.chomp('s').to_sym }

	# Now set the ones that aren't just the API name with
	# the 's' at the end removed.
	SEMANTIC_TYPEKEYS.merge!(
		also_see:                 :also,
		domain_categories:        :domain_category,
		domain_member_categories: :domain_member_category,
		entailments:              :entail,
		similar_words:            :similar,
		antonyms: :antonyms
	)


	set_primary_key :synsetid

	##
	# :singleton-method:
	# The WordNet::Words associated with the receiver
	many_to_many :words,
		:join_table  => :senses,
		:left_key    => :synsetid,
		:right_key   => :wordid


	##
	# :singleton-method:
	# The WordNet::Senses associated with the receiver
	one_to_many :senses,
		:key         => :synsetid,
		:primary_key => :synsetid


	##
	# :singleton-method:
	# The WordNet::SemanticLinks indicating a relationship with other
	# WordNet::Synsets
	one_to_many :semlinks,
		:class       => :"WordNet::SemanticLink",
		:key         => :synset1id,
		:primary_key => :synsetid,
		:eager       => :target


	##
	# :singleton-method:
	# The WordNet::SemanticLinks pointing *to* this Synset
	many_to_one :semlinks_to,
		:class       => :"WordNet::SemanticLink",
		:key         => :synsetid,
		:primary_key => :synset2id


	##
	# :singleton-method:
	# Terms from the Suggested Upper Merged Ontology
	many_to_many :sumo_terms,
		:join_table  => :sumomaps,
		:left_key    => :synsetid,
		:right_key   => :sumoid


	#################################################################
	###	C L A S S   M E T H O D S
	#################################################################

	# Cached lookup tables (lazy-loaded)
	@lexdomain_table = nil
	@lexdomains      = nil
	@linktype_table  = nil
	@linktypes       = nil
	@postype_table   = nil
	@postypes        = nil


	#
	# :section: Dataset Methods
	# This is a set of methods that return a Sequel::Dataset for Synsets pre-filtered
	# by a certain criteria. They can be used to do low-level queries against the
	# WordNetSQL database; stuff like:
	#
	#   lexicon = WordNet::Lexicon.new # connect to the DB
	#   WordNet::Synset.nouns.filter { :definition.like('%vocal%') }.limit( 5 ).all
	#   # => [#<WordNet::Synset:0x7fdf04e33f88 {100545344} 'vocal music' (noun): [noun.act] music
	#   #        that is vocalized (as contrasted with instrumental music)>,
	#   #     #<WordNet::Synset:0x7fdf04e33e70 {100545501} 'singing, vocalizing' (noun): [noun.act]
	#   #        the act of singing vocal music>,
	#   #     #<WordNet::Synset:0x7fdf04e33d58 {101525720} 'oscine, oscine bird' (noun):
	#   #        [noun.animal] passerine bird having specialized vocal apparatus>,
	#   #     #<WordNet::Synset:0x7fdf04e33c18 {101547143} 'clamatores, suborder clamatores'
	#   #        (noun): [noun.animal] used in some classification systems; a suborder or
	#   #        superfamily nearly coextensive with suborder Tyranni; Passeriformes having
	#   #        relatively simple vocal organs and little power of song; clamatorial birds>,
	#   #     #<WordNet::Synset:0x7fdf04e33ab0 {102511633} 'syrinx' (noun): [noun.animal] the vocal
	#   #        organ of a bird>]
	#

	##
	# :singleton-method: nouns
	# Dataset method: filtered by part of speech: nouns.
	def_dataset_method( :nouns ) { filter(pos: 'n') }

	##
	# :singleton-method: verbs
	# Dataset method: filtered by part of speech: verbs.
	def_dataset_method( :verbs ) { filter(pos: 'v') }

	##
	# :singleton-method: adjectives
	# Dataset method: filtered by part of speech: adjectives.
	def_dataset_method( :adjectives ) { filter(pos: 'a') }

	##
	# :singleton-method: adverbs
	# Dataset method: filtered by part of speech: adverbs.
	def_dataset_method( :adverbs ) { filter(pos: 'r') }

	##
	# :singleton-method: adjective_satellites
	# Dataset method: filtered by part of speech: adjective satellites.
	def_dataset_method( :adjective_satellites ) { filter(pos: 's') }


	# :section:

	### Overridden to reset any lookup tables that may have been loaded from the previous
	### database.
	def self::db=( newdb )
		self.reset_lookup_tables
		super
	end


	### Unload all of the cached lookup tables that have been loaded.
	def self::reset_lookup_tables
		@lexdomain_table = nil
		@lexdomains      = nil
		@linktype_table  = nil
		@linktypes       = nil
		@postype_table   = nil
		@postypes        = nil
	end


	### Return the table of lexical domains, keyed by id.
	def self::lexdomain_table
		@lexdomain_table ||= self.db[:lexdomains].to_hash( :lexdomainid )
	end


	### Lexical domains, keyed by name as a String (e.g., "verb.cognition")
	def self::lexdomains
		@lexdomains ||= self.lexdomain_table.inject({}) do |hash,(id,domain)|
			hash[ domain[:lexdomainname] ] = domain
			hash
		end
	end


	### Return the table of link types, keyed by linkid
	def self::linktype_table
		@linktype_table ||= self.db[:linktypes].inject({}) do |hash,row|
			hash[ row[:linkid] ] = {
				:id       => row[:linkid],
				:typename => row[:link],
				:type     => row[:link].gsub( /\s+/, '_' ).to_sym,
				:recurses => row[:recurses] && row[:recurses] != 0,
			}
			hash
		end
	end


	### Return the table of link types, keyed by name.
	def self::linktypes
		@linktypes ||= self.linktype_table.inject({}) do |hash,(id,link)|
			hash[ link[:type] ] = link
			hash
		end
	end


	### Return the table of part-of-speech types, keyed by letter identifier.
	def self::postype_table
		@postype_table ||= self.db[:postypes].inject({}) do |hash, row|
			hash[ row[:pos].untaint.to_sym ] = row[:posname]
			hash
		end
	end


	### Return the table of part-of-speech names to letter identifiers (both Symbols).
	def self::postypes
		@postypes ||= self.postype_table.invert
	end


	##
	# :singleton-method: semantic_link_methods
	# An Array of semantic link methods
	class << self; attr_reader :semantic_link_methods ; end
	@semantic_link_methods = []


	### Generate methods that will return Synsets related by the given semantic pointer
	### +type+.
	def self::semantic_link( type )
		self.log.debug "Generating a %p method" % [ type ]

		ds_method_body = Proc.new do
			self.semanticlink_dataset( type )
		end
		define_method( "#{type}_dataset", &ds_method_body )

		ss_method_body = Proc.new do
			self.semanticlink_dataset( type ).all
		end
		define_method( type, &ss_method_body )

		self.semantic_link_methods << type.to_sym
	end


	######
	public
	######

	### Return a Sequel::Dataset for synsets related to the receiver via the semantic
	### link of the specified +type+.
	def semanticlink_dataset( type )
		typekey  = SEMANTIC_TYPEKEYS[ type ]
		linkinfo = self.class.linktypes[ typekey ] or
			raise ArgumentError, "no such link type %p" % [ typekey ]
		ssids    = self.semlinks_dataset.filter( :linkid => linkinfo[:id] ).select( :synset2id )

		return self.class.filter( :synsetid => ssids )
	end


	### Return an Enumerator that will iterate over the Synsets related to the receiver
	### via the semantic links of the specified +linktype+.
	def semanticlink_enum( linktype )
		return self.semanticlink_dataset( linktype ).to_enum
	end


	### Return the name of the Synset's part of speech (#pos).
	def part_of_speech
		return self.class.postype_table[ self.pos.to_sym ]
	end


	### Stringify the synset.
	def to_s

		# Make a sorted list of the semantic link types from this synset
		semlink_list = self.semlinks_dataset.
			group_and_count( :linkid ).
			to_hash( :linkid, :count ).
			collect do |linkid, count|
				'%s: %d' % [ self.class.linktype_table[linkid][:typename], count ]
			end.
			sort.
			join( ', ' )

		return "%s (%s): [%s] %s (%s)" % [
			self.words.map( &:to_s ).join(', '),
			self.part_of_speech,
			self.lexical_domain,
			self.definition,
			semlink_list
		]
	end


	### Return the name of the lexical domain the synset belongs to; this also
	### corresponds to the lexicographer's file the synset was originally loaded from.
	def lexical_domain
		return self.class.lexdomain_table[ self.lexdomainid ][ :lexdomainname ]
	end


	### Return any sample sentences.
	def samples
		return self.db[:samples].
			filter( synsetid: self.synsetid ).
			order( :sampleid ).
			map( :sample )
	end


	#
	# :section: Semantic Links
	#

	##
	# "See Also" synsets
	semantic_link :also_see

	##
	# Attribute synsets
	semantic_link :antonyms

	##
	# Attribute synsets
	semantic_link :attributes

	##
	# Cause synsets
	semantic_link :causes

	##
	# Domain category synsets
	semantic_link :domain_categories

	##
	# Domain member category synsets
	semantic_link :domain_member_categories

	##
	# Domain member region synsets
	semantic_link :domain_member_regions

	##
	# Domain member usage synsets
	semantic_link :domain_member_usages

	##
	# Domain region synsets
	semantic_link :domain_regions

	##
	# Domain usage synsets
	semantic_link :domain_usages

	##
	# Verb entailment synsets
	semantic_link :entailments

	##
	# Hypernym sunsets
	semantic_link :hypernyms

	##
	# Hyponym synsets
	semantic_link :hyponyms

	##
	# Instance hypernym synsets
	semantic_link :instance_hypernyms

	##
	# Instance hyponym synsets
	semantic_link :instance_hyponyms

	##
	# Member holonym synsets
	semantic_link :member_holonyms

	##
	# Member meronym synsets
	semantic_link :member_meronyms

	##
	# Part holonym synsets
	semantic_link :part_holonyms

	##
	# Part meronym synsets
	semantic_link :part_meronyms

	##
	# Similar word synsets
	semantic_link :similar_words

	##
	# Substance holonym synsets
	semantic_link :substance_holonyms

	##
	# Substance meronym synsets
	semantic_link :substance_meronyms

	##
	# Verb group synsets
	semantic_link :verb_groups


	#
	# :section: Traversal Methods
	# These are methods for doing recursive iteration over a particular lexical
	# link. For example, if you're interested in not only the hypernyms of the
	# receiving synset, but its hypernyms' hypernyms as well, and so on up the
	# tree, you can make a traversal enumerator for it:
	#
	#   ss = $lex[:fencing]
	#   # => #<WordNet::Synset:0x7fb582c24400 {101171644} 'fencing' (noun): [noun.act] the art or 
	#      sport of fighting with swords (especially the use of foils or epees or sabres to score
	#      points under a set of rules)>
	#
	#   e = ss.traverse( :hypernyms )
	#   # => #<Enumerator: ...>
	#
	#   e.to_a
	#   # => [#<WordNet::Synset:0x7fb582cd2848 {100041468} 'play, swordplay' (noun): [noun.act] the
	#           act using a sword (or other weapon) vigorously and skillfully>,
	#         #<WordNet::Synset:0x7fb582ccf738 {100037396} 'action' (noun): [noun.act] something
	#           done (usually as opposed to something said)>,
	#         ... ]
	#
	#   e.with_index.each {|ss,i| puts "%02d: %s" % [i, ss] }
	#   # etc.
	#

	### Union: Return the least general synset that the receiver and
	### +othersyn+ have in common as a hypernym, or nil if it doesn't share
	### any.
	def |( othersyn )

		# Find all of this syn's hypernyms
		hypersyns = self.traverse( :hypernyms ).to_a
		commonsyn = nil

		# Now traverse the other synset's hypernyms looking for one of our
		# own hypernyms.
		othersyn.traverse( :hypernyms ) do |syn|
			if hypersyns.include?( syn )
				commonsyn = syn
				throw :stop_traversal
			end
		end

		return commonsyn
	end


	### With a block, yield a WordNet::Synset related to the receiver via a link of
	### the specified +type+, recursing depth first into each of its links if the link
	### type is recursive. To exit from the traversal at any depth, throw :stop_traversal.
	###
	### If no block is given, return an Enumerator that will do the same thing instead.
	###
	###   # Print all the parts of a boot
	###   puts lexicon[:boot].traverse( :member_meronyms ).to_a
	###
	### You can also traverse with an addiitional argument that indicates the depth of
	### recursion by calling #with_depth on the Enumerator:
	###
	###   $lex[:fencing].traverse( :hypernyms ).with_depth.each {|ss,d| puts "%02d: %s" % [d,ss] }
	###   # (outputs:)
	###
	###   01: play, swordplay (noun): [noun.act] the act using a sword (or other weapon) vigorously
	###     and skillfully (hypernym: 1, hyponym: 1)
	###   02: action (noun): [noun.act] something done (usually as opposed to something said)
	###     (hypernym: 1, hyponym: 33)
	###   03: act, deed, human action, human activity (noun): [noun.tops] something that people do
	###     or cause to happen (hypernym: 1, hyponym: 40)
	###   ...
	###
	def traverse( type, &block )
		enum = Enumerator.new do |yielder|
			traversals = [ self.semanticlink_enum(type) ]
			syn        = nil
			typekey    = SEMANTIC_TYPEKEYS[ type ]
			recurses   = self.class.linktypes[ typekey ][:recurses]

			self.log.debug "Traversing %s semlinks%s" % [ type, recurses ? " (recursive)" : ''  ]

			catch( :stop_traversal ) do
				until traversals.empty?
					begin
						self.log.debug "  %d traversal/s left" % [ traversals.length ]
						syn = traversals.last.next

						if enum.with_depth?
							yielder.yield( syn, traversals.length )
						else
							yielder.yield( syn )
						end

						traversals << syn.semanticlink_enum( type ) if recurses
					rescue StopIteration
						traversals.pop
					end
				end
			end
		end

		def enum.with_depth?
			@with_depth = false if !defined?( @with_depth )
			return @with_depth
		end

		def enum.with_depth
			@with_depth = true
			self
		end

		return enum.each( &block ) if block
		return enum
	end


	### Search for the specified +synset+ in the semantic links of the given +type+ of
	### the receiver, returning the depth it was found at if it's found, or nil if it
	### wasn't found.
	def search( type, synset )
		found, depth = self.traverse( type ).with_depth.find {|ss,depth| synset == ss }
		return depth
	end


	#
	# :section:
	#

	### Return a human-readable representation of the objects, suitable for debugging.
	def inspect
		return "#<%p:%0#x {%d} '%s' (%s): [%s] %s>" % [
			self.class,
			self.object_id * 2,
			self.synsetid,
			self.words.map(&:to_s).join(', '),
			self.part_of_speech,
			self.lexical_domain,
			self.definition,
		]
	end

end # class WordNet::Synset

