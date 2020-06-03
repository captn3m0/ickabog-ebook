#!/bin/bash

HTML_FILE=ickabog.html
echo "<html><head><title>The Ickabog</title></head><body>" > "$HTML_FILE"

function download_chapter() {
    if [ ! -f "$2" ]; then
        echo "Downloading $2"
        wget --quiet "https://www.theickabog.com/$1" -O "$2"
    fi
}

download_chapter "king-fred-the-fearless/" "ch1.html"
download_chapter "the-ickabog/" "ch2.html"
download_chapter "death-of-a-seamstress/" "ch3.html"
download_chapter "the-quiet-house/" "ch4.html"
download_chapter "daisy-dovetail/" "ch5.html"
download_chapter "the-fight-in-the-courtyard/" "ch6.html"
download_chapter "lord-spittleworth-tells-tales/" "ch7.html"
download_chapter "the-day-of-petition/" "ch8.html"
download_chapter "the-shepherds-story/" "ch9.html"
download_chapter "king-freds-quest/" "ch10.html"
download_chapter "the-journey-north/" "ch11.html"
download_chapter "the-kings-lost-sword/" "ch12.html"
download_chapter "the-accident/" "ch13.html"

for i in $(seq 1 13); do
  CHAPTER_TITLE=$(cat "ch$i.html" | pup 'h1.entry-title:nth-child(2) text{}')
  echo "<h2>$CHAPTER_TITLE</h2>" >> "$HTML_FILE"
  cat "ch$i.html" | pup 'article div.row:nth-child(2) div.entry-content' >> "$HTML_FILE"
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
