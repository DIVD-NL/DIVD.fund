#!/bin/bash
set -e
#set -x
TIDY_OUT=/tmp/tidy_out.$$

echo "*** Internal link check ***"
htmlproofer \
	--disable_external \
	--allow-hash-href  \
	--ignore-urls="/#menu/" \
	--no-enforce-https \
	_site
echo "*** External link check ***"
#(set +e ; htmlproofer \
#	--allow-hash-href \
#	--url-ignore="/www.linkedin.com/","/twitter.com/","/#menu/" _site || exit 0 )
(
	html5validator _site/*.html _site/*/*.html _site/*/*/*.html _site/*/*/*/*.html _site/*/*/*/*.html 
) | tee $TIDY_OUT
ERRORS=$( grep 'error:' $TIDY_OUT | wc -l )
if [[ $ERRORS -gt 0 ]] ; then
	echo "------------------------------------------------------------------------------------"
	echo "There are $ERRORS errors in html files, not good enough!"
	grep 'Error:' $TIDY_OUT
	exit 1
else
	echo "------------------------------------------------------------------------------------"
	echo " HTML checked and found flawles, \0/ \0/ \0/ \0/ \0/ \0/ "
	echo "------------------------------------------------------------------------------------"
fi
