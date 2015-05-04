# cd ${ENGLISH_SCRIPT_HOME}
if [ -z  "$ENGLISH_SCRIPT_HOME" ]; then
			DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
			ENGLISH_SCRIPT_HOME=$DIR/..
fi
ruby ${ENGLISH_SCRIPT_HOME}/src/core/english-parser.rb "$@"
