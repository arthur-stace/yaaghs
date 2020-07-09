LABELS = "good first issue"

OKSH = /usr/local/bin/ok.sh


default: $(PROJECT)/todo
	mkdir -p $(DOMAIN)/$(PROJECT)
	mv $(PROJECT)/* $(DOMAIN)/$(PROJECT)/
	${MAKE} clean



run:
	docker run -v $(shell pwd):/work backpack make -e PROJECT=$(PROJECT) -e DOMAIN=$(DOMAIN)



$(PROJECT)/todo: $(PROJECT)/notes
	for file in $(wildcard $</*.html); do sh scripts/todo.sh $$file; done > $@



$(PROJECT)/notes: $(PROJECT)/issues.txt
	mkdir -p $@
	for url in `cat $<`; do curl $$url > $@/`basename $$url`.html; done



$(PROJECT)/issues.txt: $(PROJECT)
	$(OKSH) list_issues $(PROJECT) labels=$(LABELS) _filter='.[] | "\(.html_url)"'\
	> $@



$(PROJECT):
	mkdir -p $(PROJECT)



clean:
	find $(DOMAIN)/$(PROJECT) -name *.html | xargs rm
	find $(DOMAIN)/$(PROJECT) -name *.txt | xargs rm

