echo get ruby https://www.ruby-lang.org/en/installation/
# get ruby gems
wget http://production.cf.rubygems.org/rubygems/rubygems-2.2.2.zip
unzip rubygems-2.2.2.zip
cd rubygems-2.2.2
./ruby setup.rb
cd ..

gem install wordnet-defaultdb
cd bin
bundle install #english script
cd ..
bundle install #rails app
