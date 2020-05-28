#!/bin/bash

HTML_FILE=ickabog.html
echo "<html><head><title>The Ickabog</title></head><body>" > "$HTML_FILE"
wget https://www.theickabog.com/king-fred-the-fearless/ -O ch1.html
wget https://www.theickabog.com/the-ickabog/ -O ch2.html
wget https://www.theickabog.com/death-of-a-seamstress/ -O ch3.html
wget https://www.theickabog.com/the-quiet-house/ -O ch4.html
wget https://www.theickabog.com/daisy-dovetail/ -O ch5.html
wget https://www.theickabog.com/the-fight-in-the-courtyard/ -O ch6.html
wget https://www.theickabog.com/lord-spittleworth-tells-tales/ -O ch7.html
wget https://www.theickabog.com/the-day-of-petition/ -O ch8.html

for i in $(seq 1 8); do
  CHAPTER_TITLE=$(cat "ch$i.html" | pup 'h1.entry-title:nth-child(2) text{}')
  echo "<h2>$CHAPTER_TITLE</h2>" >> "$HTML_FILE"
  cat "ch$i.html" | pup 'article div.row:nth-child(2) div.entry-content' >> "$HTML_FILE"
done

echo "</body></html>" >> "$HTML_FILE"

pandoc --from=html --to=pdf \
    --output=ickabog.pdf \
    --metadata title="The Ickabog" \
    --metadata author="J.K Rowling" \
    --pdf-engine=xelatex \
    --dpi=300 \
    -V book \
    -V lang=en-US \
    -V geometry=margin=1cm \
    "$HTML_FILE"

pandoc --from=html --to=epub \
    --output=ickabog.epub \
    --epub-metadata=metadata.xml \
    --metadata title="The Ickabog" \
    "$HTML_FILE"

pandoc --from=html --to=pdf \
    -V fontsize=18pt \
    --output=ickabog-large.pdf \
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


