compile:
	markdown "Code Conventions.md" > ./web/index.html

publish: compile
	rsync -r --progress "./web/" "alterplay.com:~/http/cc"

