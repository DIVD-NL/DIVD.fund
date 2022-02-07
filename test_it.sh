#!/bin/bash

docker pull mrseccubus/github-pages:latest
docker run --volume="$PWD:/root/project:delegated" --entrypoint /bin/bash -ti mrseccubus/github-pages \
-c "
	cd /root/project/;
	rm -rf _site/* jekyll-build.log;
	jekyll build  --future 2>&1 | tee jekyll-build.log
	./proof_html.sh
"