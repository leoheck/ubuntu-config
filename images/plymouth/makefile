

SVG = ubuntu-logo.svg
PNG = ubuntu-logo.png

all: $(PNG)

%.png: %.svg
	inkscape --without-gui --export-png=$@ $^ > /dev/null
