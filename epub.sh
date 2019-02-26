#!/bin/bash
#export DSSSL=/usr/share/xml/docbook/stylesheet/docbook-xsl/epub/docbook.xsl
#export DSSSL=/usr/share/xml/docbook/stylesheet/docbook-xsl/epub3/chunk.xsl
export DSSSL=/usr/local/opt/docbook-xsl/docbook-xsl/epub3/chunkfast.xsl
#export XSLTPROC="xsltproc --stringparam epub.stylesheet docbook.css --stringparam use.id.as.filename 1 ${DSSSL}"
export XSLTPROC="xsltproc --stringparam epub.stylesheet docbook.css ${DSSSL}"
export PUBLIC_HTML="~/tmp/epub"

WORKSPACE=~/workspace


generator(){
	#echo $@
	PROJECT="Netkiller-"$(echo $1|sed "s/\//-/")
        DOCBOOK=$WORKSPACE/$1
	EPUB=$PUBLIC_HTML/$2
	echo $PROJECT
	echo $EPUB

	TMPDIR=$(mktemp -d --suffix=.tmp -p /tmp epub.$2.XXXXXX)
	echo $TMPDIR
	cd $TMPDIR
	
	${XSLTPROC} $DOCBOOK/book.xml

#	sed "s/{latest}/`date -u`/g" index.epub >index.epub.sed; mv index.epub.sed index.epub
#	if [ ! -d ${PUBLIC_HTML}/${epub} ]; then
#		mkdir ${PUBLIC_HTML}/${epub}
#	fi
	cp $WORKSPACE/common/docbook.css OEBPS
	if [ -d $DOCBOOK/images ]; then
		#cp -r $DOCBOOK/${xml}/images OEBPS
		rsync -a --exclude=.svn $DOCBOOK/images .
		rsync -a --exclude=.svn $WORKSPACE/Website/images/* images/
	fi
	find OEBPS -type d -iname ".svn" -exec rm -rf {} \; 

	echo "application/epub+zip" > mimetype
	zip -0Xq  ${PROJECT}.epub mimetype
	zip -Xr9D ${PROJECT}.epub *

	cp *.epub ${PUBLIC_HTML}/download/2019/epub/
	#cp ${PROJECT}.epub ${EPUB}/ibook.epub

	cd -
	
}


english(){
	xml=English
	html=english/notes
	generator
}


website(){
#HTDOCS=$PUBLIC_HTML
#WEBSITE=/usr/share/xml/docbook/stylesheet/nwalsh/website
#XML_CATALOG_FILES=/usr/share/xml/docbook/stylesheet/nwalsh/catalog.xml \
#xsltproc --output Docbook/Website/autolayout.xml ${WEBSITE}/autolayout.xsl Docbook/Website/layout.xml
##xsltproc --stringparam output-root $HTDOCS $WEBSITE/chunk-tabular.xsl autolayout.xml
#xsltproc --stringparam output-root $HTDOCS Docbook/Website/template.xsl Docbook/Website/autolayout.xml
##       --stringparam  collect.xref.targets yes
#cp -r Docbook/Website/graphics $HTDOCS
#rm -rf $HTDOCS/graphics/.svn
#cp Docbook/Website/stylesheet.css $HTDOCS
exit
}

case "$1" in
	architect)
		generator Architect architect
		;;
	freebsd)
		generator FreeBSD freebsd
		;;
	linux)
		generator Linux linux
		;;
	monitoring)
        	generator Linux/Monitoring monitoring
		;;
	www)
		generator Linux/Web www
		;;
	project)
		generator Linux/Project project
		;;
	storage)
		generator Linux/Storage storage
		;;
	shell)
		generator Linux/Shell shell
		;;
	security)
        	generator Linux/Security security
		;;
	developer)
		generator Developer developer
		;;
	testing)
		generator Developer/Testing testing
		;;
	cryptography)
		generator Linux/Cryptography cryptography
		;;

	database)
        	generator Database database
		;;
	mysql)
	        generator Database/MySQL mysql
		;;
	nosql)
        	generator Database/NoSQL nosql
		;;
        postgresql)
	        generator Database/PostgreSQL postgresql 
                ;;
	management)
		generator Management management
		;;
	openldap)
		generator Linux/OpenLDAP openldap
		;;
	cisco)
		generator Network/Cisco cisco
		;;
	h3c)
		generator Network/H3C h3c
		;;
	docbook)
		generator Docbook docbook
		;;

	version)
		generator Linux/Project version
		;;
	mail)
		generator Linux/Mail mail
		;;
	network)
		generator Network network
		;;
	multimedia)
		generator Linux/Multimedia multimedia
		;;
	english)
		english
		;;

	website)
		website
		;;
        sport)
                sport
                ;;
        java)
                java
		generator Java java
                ;;
	spring)
		generator Java/Spring spring
		;;
	blockchain)
		generator Blockchain blockchain
		;;
	radio)
		generator Radio radio
		;;
	android)
		generator Java/Android android
		;;
	all)	
		$0 freebsd &
                $0 linux &
		$0 www &
		$0 monitoring &
		$0 storage &
		$0 centos &
		$0 debian &
		$0 shell &
		$0 architect &
		$0 developer &
		$0 security & 
		$0 cryptography &
		$0 database &
		$0 mysql &
		$0 docbook &
		$0 openldap & 
		$0 cisco & 
		$0 version &
		$0 network &
		$0 multimedia &
		$0 mail &
		$0 solaris &
		$0 testing &
		$0 nosql &
                $0 postgresql &
		;;
	*)
                echo $"Usage: $0 {freebsd | linux | monitoring | www | centos | debian | storage | developer | website | security | docbook | architect | cisco | version | mail | intranet | multimedia | solaris | testing | all}"
                echo $"        $0 {database | mysql | nosql}"
                echo $"        $0 {cryptography}"
        	RETVAL=1
esac


exit $RETVAL
