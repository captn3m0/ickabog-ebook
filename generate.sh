#!/bin/bash

mkdir -p html

HTML_FILE=ickabog.html
echo "<html><head><title>The Ickabog</title></head><body>" > "$HTML_FILE"

function download_chapter() {
    [ -s "html/$2.html" ] || wget --quiet "https://www.theickabog.com/$1" -O "html/$2.html"
}

download_chapter "king-fred-the-fearless/" "ch1"
download_chapter "the-ickabog/" "ch2"
download_chapter "death-of-a-seamstress/" "ch3"
download_chapter "the-quiet-house/" "ch4"
download_chapter "daisy-dovetail/" "ch5"
download_chapter "the-fight-in-the-courtyard/" "ch6"
download_chapter "lord-spittleworth-tells-tales/" "ch7"
download_chapter "the-day-of-petition/" "ch8"
download_chapter "the-shepherds-story/" "ch9"
download_chapter "king-freds-quest/" "ch10"
download_chapter "the-journey-north/" "ch11"
download_chapter "the-kings-lost-sword/" "ch12"
download_chapter "the-accident/" "ch13"
download_chapter "lord-spittleworths-plan/" "ch14"
download_chapter "the-king-returns/" "ch15"

for i in $(seq 1 15); do
  CHAPTER_TITLE=$(cat "html/ch$i.html" | pup 'h1.entry-title:nth-child(2) text{}')
  echo "<h2>$CHAPTER_TITLE</h2>" >> "$HTML_FILE"
  cat "html/ch$i.html" | pup 'article div.row:nth-child(2) div.entry-content' >> "$HTML_FILE"
done

echo "</body></html>" >> "$HTML_FILE"

pandoc --from=html --to=pdf \
    --output=ickabog1.pdf \
    --metadata title="The Ickabog" \
    --metadata author="J.K Rowling" \
    --pdf-engine=xelatex \
    --dpi=300 \
    -V book \
    -V lang=en-US \
    -V geometry=margin=1.5cm \
    "$HTML_FILE"

pdftk cover.pdf ickabog1.pdf cat output ickabog.pdf

pandoc --from=html --to=epub \
    --output=ickabog.epub \
    --epub-metadata=metadata.xml \
    --epub-cover-image=cover.jpg \
    --metadata title="The Ickabog" \
    "$HTML_FILE"

pandoc --from=html --to=pdf \
    -V fontsize=18pt \
    --output=ickabog2.pdf \
    --metadata title="The Ickabog" \
    --metadata author="J.K Rowling" \
    --pdf-engine=context \
    -V margin-left=0cm \
    -V margin-right=0cm \
    -V margin-top=0cm \
    -V margin-bottom=0cm \
    -V geometry=margin=0cm \
    -V lang=en-US \
    "$HTML_FILE"

pdftk cover.pdf ickabog2.pdf cat output ickabog-large.pdf
