@echo off

set DSSSL=file:///D:/workspace/Document/Docbook/docbook-xsl-1.74.0/xhtml/chunk.xsl
cd tmp
rem C:\project\xsltproc-win32\
xsltproc --timing --nonet --stringparam html.stylesheet docbook.css %DSSSL% ..\book.xml
explorer index.html 
cd ..