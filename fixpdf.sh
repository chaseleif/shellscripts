#! /usr/bin/env bash

echo "
convert svg to pdf:
rsvg-convert -f pdf -o output.pdf input.svg

select page from pdf:
pdfjam input.pdf 2 -o output.pdf

crop pdf, removing whitespace
pdfcrop input.pdf
"
