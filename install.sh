echo get ruby here https://www.ruby-lang.org/en/installation/

# get ruby gems
echo get rubygems here https://rubygems.org/pages/download
# wget http://production.cf.rubygems.org/rubygems/rubygems-2.2.2.zip
# unzip rubygems-2.2.2.zip
# cd rubygems-2.2.2
# ruby setup.rb
# cd ..

git clone git@github.com:pannous/EnglishScript.tmbundle.git ~/Library/Application\ Support/TextMate/Bundles/EnglishScript.tmbundle/ 2>/dev/null

echo INSTALLING DEPENDENCIES... This might take a minute or 10


git submodule init git@github.com:pannous/kast.git
git submodule init git@github.com:pannous/angle.git # the python branch of english script
git submodule init git@github.com:pannous/english-script-samples.git
git submodule init git@github.com:pickhardt/betty.git
git submodule foreach git pull origin master

# gem install wordnet-defaultdb
bundle install #--no-deployment --local

export ENGLISH_SCRIPT_HOME=$PWD
echo export ENGLISH_SCRIPT_HOME=$PWD
echo "export ENGLISH_SCRIPT_HOME=$PWD" >> ~/.bashrc

sudo ln -s $ENGLISH_SCRIPT_HOME/bin/angle /usr/bin/angle
