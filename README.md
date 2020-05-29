# ickabog-ebook

Generates ebooks for The Ickabog by J.K Rowling. Original text from https://www.theickabog.com/

## Dependencies:

- `wget`
- [`pup`](https://github.com/ericchiang/pup)
- [`pandoc`](https://pandoc.org/)
- [`pdftk`]

## How to run

`./generate.sh`

You should have `ickabog.epub`, and `ickabog.pdf` in your directory after the script finishes. If you have [ConTeXt](https://wiki.contextgarden.net/Main_Page) installed, you will also get a `ickabog-large.pdf` file with large fonts to be kid-friendly.

## Known Issues

2. The PDF is optimized for few pages of printing, so has a small font size by default. If you'd like a kid-friendly version, install context to get `ickabog-large.pdf` file.

## Extra

A list of my other EBook generation projects: https://captnemo.in/ebooks/, includes a link to other related projects as well.

## Credits

The cover art is [Avanyu](http://edan.si.edu/saam/id/object/1979.144.85) by Julian Martinez. Used under Creative Commons license.

> Julian Martinez, Avanyu, ca. 1923, watercolor, ink, and pencil on paper, Smithsonian American Art Museum, Corbin-Henderson Collection, gift of Alice H. Rossin, 1979.144.85

## License

The little code in this repository is licensed under the [MIT License](https://nemo.mit-license.org/). See LICENSE file for details.
