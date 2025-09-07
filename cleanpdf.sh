#! /usr/bin/env bash

echo "
# View metadata in a pdf
exiftool the.pdf

# Strip metadata, make a new file
mat2 the.pdf && sync the.cleaned.pdf && mv the.cleaned.pdf the.pdf
# or inplace
mat2 --inplace the.pdf

# Add/change some metadata, may retain history (?)
exiftool -Title=\"The title\" the.pdf
"
