XSLTPROC = /usr/bin/xsltproc
DSSSL = /home/neo/workspace/Document/Docbook/docbook-xsl/docbook.xsl
TMPDIR = $(shell mktemp -d --suffix=.tmp -p /tmp docbook.html.XXXXXX)
DOCBOOK='.'
PUBLIC_HTML=/home/neo/workspace/public_html

define reset
	@mkdir -p ${PUBLIC_HTML}/$(1)
	@find ${PUBLIC_HTML}/$(1) -type f -iname "*.html" -exec rm -rf {} \;
endef

define book
	@rsync -au ../common/docbook.css $(PUBLIC_HTML)/$(1)/
	@$(XSLTPROC) -o $(PUBLIC_HTML)/$(1)/ $(DSSSL) $(DOCBOOK)/book.xml
	@$(shell test -d $(PUBLIC_HTML)/$(1)/images && find $(PUBLIC_HTML)/$(1)/images/ -type f -exec rm -rf {} \;)
	@$(shell test -d $(1)/images && rsync -au --exclude=.svn $(DOCBOOK)/images $(PUBLIC_HTML)/$(1)/)
endef

define test
        @$(XSLTPROC) -o $(TMPDIR)/ $(DSSSL) $(DOCBOOK)/book.xml
endef


all: docbook

clean:
	@rm -rf $(PUBLIC_HTML)/$@

docbook:
	$(call reset,docbook)
	$(call book,docbook,docbook) 

test:
	$(call test)

