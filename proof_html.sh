#!/bin/bash
set -e # Need to fail on error
set -x
TIDY_OUT=/tmp/tidy_out.$$

gem install html-proofer
echo "*** Internal link check ***"
export LANG=en_US.UTF-8
htmlproofer \
	--disable_external \
	--allow-hash-href  \
	_site
echo "*** External link check ***"
( set +e ; htmlproofer --allow-hash-href _site || exit 0 )
(
	html5validator _site/*.html _site/*/*.html _site/*/*/*.html _site/*/*/*/*.html _site/*/*/*/*.html 
) | tee $TIDY_OUT
ERRORS=$( grep 'error:' $TIDY_OUT | wc -l )
if [[ $ERRORS -gt 0 ]] ; then
	echo "------------------------------------------------------------------------------------"
	echo "There are $ERRORS errors in html files, not good enough!"
	grep 'error:' $TIDY_OUT
	# TODO break here # exit 1
else
	echo "------------------------------------------------------------------------------------"
	echo " HTML checked and found flawles, \0/ \0/ \0/ \0/ \0/ \0/ "
	echo "------------------------------------------------------------------------------------"
fi
if [[ -e jekyll-build.log ]]; then
	ERRORS=$( grep ERROR jekyll-build.log | grep -v DIVD-3000-0000 | wc -l )
	WARNS=$( grep WARN jekyll-build.log | wc -l )
	if [[ $WARNS -gt 0 ]] ; then
		echo "There are $WARNS warnings in the Jekyll build log"
		grep 'WARN' jekyll-build.log
	fi
	if [[ $ERRORS -gt 0 ]] ; then
		echo "------------------------------------------------------------------------------------"
		echo "There are $ERRORS errors in the Jekyll build log, not good enough!"
		grep 'ERROR' jekyll-build.log
		exit 1
	fi
fi
