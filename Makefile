all: check-compile build-html transfer open

check-compile:
	./ci.bfast.sh	

build-html:
	(cd html ;./gen_html.js > index.html)

transfer:
	ssh is04607.com mkdir -p public_html/ci.bfast
	scp html/index.html is04607.com:public_html/ci.bfast
	scp html/style.css is04607.com:public_html/ci.bfast
	scp -r logs is04607.com:public_html/ci.bfast

open:
	open http://is04607.com/~drio/ci.bfast/

.PHONY: check-check build-build transfer open
