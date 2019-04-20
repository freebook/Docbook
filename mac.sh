rm -rf ~/tmp/docbook/
mkdir -p ~/tmp/docbook/
xsltproc -o ~/tmp/docbook/ docbook-xsl/docbook.mac.xsl book.xml
