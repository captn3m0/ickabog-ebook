# ickabog-ebook

Generates ebooks for The Ickabog by J.K Rowling. Original text from https://www.theickabog.com/home/

## Dependencies:

- `wget`
- [`pup`](https://github.com/ericchiang/pup)
- [`pandoc`](https://pandoc.org/)

## How to run

`./generate.sh`

You should have `ickabog.epub`, and `ickabog.pdf` in your directory after the script finishes. If you have [ConTeXt](https://wiki.contextgarden.net/Main_Page) installed, you will also get a `ickabog-large.pdf` file with large fonts to be kid-friendly.

## Known Issues

1. Currently no cover is available. If you'd like to submit a cover for this book, please let me know. I think a kid-drawn illustration would be perfect, keeping with the theme of the contest.
2. The PDF is optimized for few pages of printing, so has a small font size by default. If you'd like a kid-friendly version, install context to get `ickabog-large.pdf` file.

## Extra

A list of my other EBook generation projects: https://captnemo.in/ebooks/, includes a link to other related projects as well

## License

Licensed under the [MIT License](https://nemo.mit-license.org/). See LICENSE file for details.
