#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

OUTPUT_DIR=out

mkdir -p html
mkdir -p "$OUTPUT_DIR"
MAIN_STORY_OUTPUT_FILE="$OUTPUT_DIR/read-the-story.html"
HTML_FILE=ickabog.html

LC=${LC:-""}
if [[ "$LC" != "" ]]; then
    LC="/$LC"
fi

if [[ "$LC" == "" || "$LC" == "en-US" ]]; then
    MAIN_STORY_URL="https://web.archive.org/web/20200713135650/https://www.theickabog.com/$LC/read-the-story/"
else
    # Non-english editions are still accessible on the original website.
    MAIN_STORY_URL="https://www.theickabog.com$LC/read-the-story/"
fi

echo "[+] Fetching $MAIN_STORY_URL"

wget --quiet --timeout=10 "$MAIN_STORY_URL" --output-document "$MAIN_STORY_OUTPUT_FILE"

LANG=$(cat "$MAIN_STORY_OUTPUT_FILE"| pup 'html attr{lang}')
echo "[+] Language set to $LANG"

MAIN_TITLE=$(cat "$MAIN_STORY_OUTPUT_FILE" | pup 'ul.chapters__list a json{}' | jq -r '[.[] | {url: .href, chapter: .children[0].children[0].children[0].children[0].text, title: .children[0].children[0].children[0].children[1].text}] | sort_by(.chapter) | .[]|[.chapter, .title, .url] | @tsv' | grep $' 2\t' | while IFS=$'\t' read -r chapter title url; do echo "$title"; done)

echo "[+] Title set to $MAIN_TITLE"

echo "<html lang=$LANG><head><meta charset=UTF-8><title>$MAIN_TITLE</title></head><body>" > "$HTML_FILE"

# args = "$url" "$chapter" "$title"
function download_chapter() {
    [[ $2 =~ 1$ ]] && MAIN_TITLE=$3
    # We have a direct link, so lets use that
    if [[ $1 =~ ^http ]]; then
        URL="$1"
    # For english, we need to make sure we are using the archive link
    elif [[ "$LANG" == "en-US" || "$LANG" == "en-GB" ]]; then
        URL="https://web.archive.org$1"
    # For others cases, let us make it a absolute URL
    else
        URL="https://www.theickabog.com$1"
    fi
    echo $URL
    [ -s "html/$2.html" ] || wget --timeout=10 --quiet "$URL" -O "html/$2.html"
    echo "<h1>$3</h1>" >> "$HTML_FILE"
    cat "html/$2.html" | pup -p --charset UTF-8 'article div.row:nth-child(2) div.entry-content' >> "$HTML_FILE"
}

cat "$MAIN_STORY_OUTPUT_FILE" |
pup -p --charset UTF-8 'ul.chapters__list a json{}' |
jq -r '[.[] | {url: .href, chapter: .children[0].children[0].children[0].children[0].text, title: .children[0].children[0].children[0].children[1].text}] | sort_by(.chapter | match("[0-9]+$")) | .[]|[.chapter, .title, .url] | @tsv' |
while IFS=$'\t' read -r chapter title url; do download_chapter "$url" "$chapter" "$title"; done

echo "</body></html>" >> "$HTML_FILE"

cat <<__METADATA__ > metadata.xml
<dc:creator opf:role="aut">J.K Rowling</dc:creator>
__METADATA__

pandoc --from=html \
    --output="$OUTPUT_DIR/ickabog.epub" \
    --epub-metadata=metadata.xml \
    --epub-cover-image=cover.jpg \
    --epub-chapter-level=1 \
    "$HTML_FILE"

echo "[+] Generated $OUTPUT_DIR/ickabog.epub"

if command -v kindlegen > /dev/null; then
    kindlegen "$OUTPUT_DIR/ickabog.epub" > /dev/null 2>&1
    echo "[+] Generated MOBI using kindlegen: $OUTPUT_DIR/ickabog.mobi"
elif command -v ebook-convert > /dev/null; then
    ebook-convert "$OUTPUT_DIR/ickabog.epub" \
        "$OUTPUT_DIR/ickabog.mobi" \
        --metadata title="$MAIN_TITLE" \
        > /dev/null 2>&1
    echo "[+] Generated MOBI using ebook-convert: $OUTPUT_DIR/ickabog.mobi"
else
    echo "[-] Could not generate MOBI, install kindlegen or calibre"
fi

if command -v xelatex >/dev/null; then
    pandoc --from=html \
        --pdf-engine=xelatex \
        --metadata title="$MAIN_TITLE" \
        --metadata author="J.K Rowling" \
        --toc \
        --output="$OUTPUT_DIR/ickabog-no-cover.pdf" \
        -V lang="$LANG" \
        -V geometry=margin=1.5cm \
        "$HTML_FILE"
else
    echo "[-] Missing xelatex, please install xelatex before trying again"
    exit
fi

if command -v qpdf > /dev/null; then
    qpdf --empty --pages cover.pdf "$OUTPUT_DIR/ickabog-no-cover.pdf" -- "$OUTPUT_DIR/ickabog.pdf"
else
    echo "[-] qpdf not installed, PDF won't have cover"
    mv "$OUTPUT_DIR/ickabog-no-cover.pdf" "$OUTPUT_DIR/ickabog.pdf"
fi

echo "[+] Generated PDF using xelatex: $OUTPUT_DIR/ickabog.pdf"

# Run only if context is available
if command -v context>/dev/null; then
    pandoc --from=html --to=pdf \
        -V fontsize=18pt \
        --output="$OUTPUT_DIR/ickabog-large-no-cover.pdf" \
        --metadata title="$MAIN_TITLE" \
        --metadata author="J.K Rowling" \
        --pdf-engine=context \
        -V margin-left=0cm \
        -V margin-right=0cm \
        -V margin-top=0cm \
        -V margin-bottom=0cm \
        -V geometry=margin=0cm \
        -V lang="$LANG" \
        "$HTML_FILE"

    if command -v qpdf > /dev/null; then
        qpdf --empty --pages cover.pdf "$OUTPUT_DIR/ickabog-large-no-cover.pdf" -- "$OUTPUT_DIR/ickabog-large.pdf"
    else
        mv "$OUTPUT_DIR/ickabog-no-cover.pdf" "$OUTPUT_DIR/ickabog-large.pdf"
    fi

    echo "[+] Generated PDF using context: $OUTPUT_DIR/ickabog-large.pdf"
else
    echo "[-] Can't find ConTeXt, not generating large-text PDF"
fi
