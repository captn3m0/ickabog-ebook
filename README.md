# ickabog-ebook ![](https://img.shields.io/badge/Chapters%20Published%2042-brightgreen)

Generates ebooks for The Ickabog by J.K Rowling. Original text from https://www.theickabog.com/. Since the book is still being published, please consider this "in-progress". Supports all 9 languages. Note that not all languages have the complete book yet.

## Dependencies:

- `wget`
- [`pup`](https://github.com/ericchiang/pup) and `jq` to parse input files
- [`pandoc`](https://pandoc.org/) to generate EPUB and PDF files
- `qpdf` to add cover to PDF files. (optional)
- `kindlegen` or `calibre` installed to generate MOBI files. (optional)

## How to run

### Using Docker

```
mkdir out
docker run --volume `pwd`/out:/src/out captn3m0/ickabog-ebook
```

If you'd like to generate for a different language, use the following:

```bash
mkdir out

# Italiano
docker run --env LC="it" --volume `pwd`/out:/src/out captn3m0/ickabog-ebook

# English (US)
docker run --env LC="en-us" --volume `pwd`/out:/src/out captn3m0/ickabog-ebook

# España
docker run --env LC="es" --volume `pwd`/out:/src/out captn3m0/ickabog-ebook

# Français
docker run --env LC="fr" --volume `pwd`/out:/src/out captn3m0/ickabog-ebook

# Deutsch
docker run --env LC="de" --volume `pwd`/out:/src/out captn3m0/ickabog-ebook

# Português brasileiro
docker run --env LC="pt" --volume `pwd`/out:/src/out captn3m0/ickabog-ebook

# 中文
docker run --env LC="ch" --volume `pwd`/out:/src/out captn3m0/ickabog-ebook

# Русский
docker run --env LC="ru" --volume `pwd`/out:/src/out captn3m0/ickabog-ebook
```

### Directly

`./generate.sh`

For generating ebooks for a different language, run the script with a LC parameter

`LC=it ./generate.sh`

Various values for LC are: `it, en-us, es, fr, de, pt, ch, ru`. If you don't pass a value, the default (en-GB) is used.

You should have `ickabog.epub`, and `ickabog.pdf` in the `out` directory after the script finishes.

- If you have [ConTeXt][context] installed, you will also get a `out/ickabog-large.pdf` file with large fonts to be kid-friendly.
- If you have `qpdf` installed, the PDF files will have cover pages
- If you have `calibre` or `kindlegen` installed, a `out/ickabog.mobi` file will also be generated. Preference is given to `kindlegen`.

## Known Issues

The PDF is optimized for few pages of printing, so has a small font size by default. If you'd like a kid-friendly version, [install context][context] to get `ickabog-large.pdf` file. ~ConTeXt comes preinstalled in the Docker image, so that's the easiest way to get the same.~

## Credits

The cover art is [Avanyu](http://edan.si.edu/saam/id/object/1979.144.85) by Julian Martinez. Used under Creative Commons license.

> Julian Martinez, Avanyu, ca. 1923, watercolor, ink, and pencil on paper, Smithsonian American Art Museum, Corbin-Henderson Collection, gift of Alice H. Rossin, 1979.144.85

Code for internationalization and automatic chapter updates via [@lesensei](https://github.com/lesensei/ickabog-ebook/commits/master)'s fork.

## Extra

A list of my other EBook generation projects: https://captnemo.in/ebooks/, includes a link to other related projects as well.

## License

The little code in this repository is licensed under the [MIT License](https://nemo.mit-license.org/). See LICENSE file for details.

[context]: https://wiki.contextgarden.net/Main_Page
