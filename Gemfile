source 'https://rubygems.org'

gem 'nokogiri'
# gem 'xml'

gem 'bundler'
gem 'wordnet'#,'~> 1.0.0'
gem 'wordnet-defaultdb'
gem 'rufus-scheduler'

# gem 'libxslt-ruby'

#gem 'linguistics' #needs ruby 2.0!!
# gem 'linkparser','~> 1.1.3'
# gem 'ruby-stemmer'#,'~> 0.9.3'
# gem 'whenever', :require => false

# gem 'ffi'
# gem 'ruby-llvm' #, :git => "git@github.com:jvoorhis/ruby-llvm"
# gem 'hoe-deveiate','~> 0.1.1'
# gem 'simplecov'#,'~> 0.6.4'

gem 'rake'
gem 'test-unit'
gem "minitest" , "~> 5.3.3"
gem 'minitest-reporters', '>= 0.5.0'
# gem "minitest", "4.7.5" #if $RUBYMINE



$RUBYMINE=ENV['RUBYMINE']||true

group :development do
  gem 'debase', :groups => [:development]  if $RUBYMINE
  gem 'ruby-debug-ide' , :groups => [:development] if $RUBYMINE
  # gem 'quiet_assets'
  # Disable below two line if you using rubymine
  #gem 'pry-rails' if not $RUBYMINE
  #gem 'pry-debugger' if not $RUBYMINE
end
# gem 'did_you_mean', group: [:development, :test]
