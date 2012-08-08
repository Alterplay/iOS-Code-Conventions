compile:
	markdown "Code Conventions.md" > ./Publish/index.html

publish: compile
	rsync -r --progress "./Publish/" "alterplay.com:~/http/ios-code-conventions"

