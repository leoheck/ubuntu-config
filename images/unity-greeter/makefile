

SVG = logo.svg
PNG = logo.png

all: $(PNG)

%.png: %.svg
	inkscape --without-gui --export-png=$@ $^ > /dev/null
