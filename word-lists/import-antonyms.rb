#!/usr/bin/env ruby
# require 'sqlite'
require 'Wordnet'

  # db = SQLite::Database.open( "/Users/me/.rvm/gems/ruby-1.9.3-p125/gems/wordnet-defaultdb-1.0.1/data/wordnet-defaultdb/wordnet30.sqlite" )
  # WordNet::Synset[300003356].similar_words !!
    lex=WordNet::Lexicon.new
    WordNet::Synset.semantic_link :antonyms # if not ...
IO.foreach("antonyms.txt").each{|l|
    begin
    a,b=l.split("\t")
    b=b.gsub(/\/.*/,"")
    b=b.gsub(/,.*/,"")
    # puts a
    # puts b
    
    # wa=lex.lookup_synsets(a,"a")[0]
    # wb=lex.lookup_synsets(b.strip,"a")[0]
    # if not wa or not wb
      wa=lex.lookup_synsets(a,"r")[0]
      wb=lex.lookup_synsets(b.strip,"r")[0]
    # end
    # if not wa or not wb
    #   wa=lex.lookup_synsets(a,"v")[0]
    #   wb=lex.lookup_synsets(b.strip,"v")[0]
    # end
    # if not wa or not wb
    #   wa=lex.lookup_synsets(a,"n")[0]
    #   wb=lex.lookup_synsets(b.strip,"n")[0]
    # end
    
    puts wb if wb
    next if not wa or not wb
    # wa=lex[a]
    # wb=lex[b]
    s=WordNet::SemanticLink.new
    s.linkid=30 # antonym
    s.origin=wa
    # s.target=wb
    s.synset2id=wb.synsetid
    s.save
    # assert 
    puts wa.antonyms[0]==wb
  rescue
  end
}
    
