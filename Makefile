CLONE = git clone --depth=1 https://github.com



default: $(PROJECT)

$(PROJECT):
	$(CLONE)/$@


$(DOMAIN)/$(project): tmp/$(project)/issues.txt $(DOMAIN)/$(project)/notes
	$(CLONE)/$(project) $@

/$(project)/issues.txt: tmp/$(project)
	ok.sh list_issues $(project) labels=$(labels) _filter='.[] | "\(.html_url)"' > $@

tmp/$(project):
	mkdir -p $@

clean:
	rm -rf github.com/$(project)
	rm -rf tmp/$(project)/issues.txt

$(DOMAIN)/$(project)/notes: tmp/$(project)/issues.txt
	mkdir -p $@
	for url in `cat $<`; do \
		curl $$url \
		| pup '.js-timeline-item' \
		| lynx -dump -stdin -unique_urls -list_inline > $@/`basename $$url`.txt; \
	done

tmp/%.json:

tmp/pull_requests.txt:
	for pull_request in $(shell ~/dotfiles-local/bin/ok.sh list_pulls $(USER) $(APPLICATION) _filter='.[] | "\(.url)"'); do \
		url=`curl $$pull_request | jq -r .review_comments_url`;\
		curl $$url | jq -cr '.[] | [.path, .url][]'; \
	done > $@

build:
	docker build -t backlog:latest .


run:
	docker run backlog:latest make -e PROJECT=$(PROJECT)
