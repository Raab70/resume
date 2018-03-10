# About
This repo contains the source I use to automatically generate
my curriculum vitae as a
webpage (TODO)
and
PDF
from YAML and BibTeX input.

[generate.py](generate.py) reads from [cv.yaml](cv.yaml) and
[publications](publications) and outputs LaTeX and Markdown
by using Jinja templates.

# Building and running
This requires a Python 3.6+ installation,
and the hashbang of `generate.py` assumes an executable named
`python3` is available on the path.
Dependencies are included in `requirements.txt` and can be installed
using `pip` with `pip3 install -r requirements.txt`.
On Mac or Linux, `make` will call [generate.py](generate.py) and
build the LaTeX documents with `latexmk` and `biber`. To install latex
requirements from OSX basicTex 2017 I had to do:
`sudo tlmgr install latexmk moderncv fontawesome biblatex logreq xstring ieee biblatex biber ieee biblatex-ieee ieee lastpage`

The Makefile will also:

1. Stage to my website with `make stage`,
2. Start a local jekyll server of my website with updated
  documents with `make jekyll`
3. Push updated documents to my website with `make push`.
4. Make just the resume with `make resume`

# What to modify
1. Change the content in `cv.yaml`.
1. Update your publications (see below section)
1. Update your phone number in [`generate.py`](https://github.com/Raab70/resume/blob/master/generate.py#L443)
1. You should also look through the template files to make sure there isn't any
special-case code that needs to be modified.
1. The `Makefile` can also start a Jekyll server and push the
new documents to another repository.
1. To use the Jekyll integration,
review the `BLOG_DIR` variable and the `jekyll` and `push` targets.

## Warnings
1. Strings in `cv.yaml` should be LaTeX (though, the actual LaTeX formatting
   should be in the left in the templates as much as possible).
2. If you do include any new LaTeX commands, make sure that one of the
   `REPLACEMENTS` in `generate.py` converts them properly.
3. The LaTeX templates use modified Jinja delimiters to avoid overlaps with
   normal LaTeX. See `generate.py` for details.
4. Occasionally the PDF for the cv will generate but not the resume, I'm not
really sure why. Running another `make resume` typically resolves the issue

## Publications
All publications are stored as BibTeX in [publications](publications).
The entries can be obtained from Google Scholar.
The order in the BibTeX file will be the order in
the output files.

Be sure to add an `_venue={}` field to all entries. Also, selected publications
in `selected.bib` are expected to have an associated image in the markdown.
For this make sure you have an asset titled as the bibtex key for each
selected publication in your site's `assets/images/` folder.

BibTeX is built for integration with LaTeX, but producing
Markdown is not traditionally done from BibTeX files.
This repository uses [BibtexParser][bibtexparser] to load the
bibliography into a map.
The data is manually formatted to mimic the LaTeX
IEEE bibliography style.

[bibtexparser]: https://bibtexparser.readthedocs.org/en/latest/index.html

## Modifications from bamos/cv
1. Add phone number obfuscation to avoid publishing plain text phone number see
[here](https://github.com/Raab70/resume/blob/master/generate.py#L443)
1. Add resume capabilities, allowing to render a shorter version with only a
subset of sections found in `resume_order` in `cv.yaml`
1. Added projects section templates, this section was supported at one time by
`bamos` but had been deprecated so I implemented to match the new format

# Licensing
This work is distributed under the MIT license, The original repository from [bamos](https://github.com/bamos/cv)
is also distributed under the MIT license (`LICENSE-bamos.mit`)
other portions copyright Ellis Michael from
[emichael/resume](https://github.com/emichael/resume).
Ellis' portions are also distributed under the MIT license
(`LICENSE-emichael.mit`) and include
a re-write of `generate.py` and template restructuring.

# Credit:
This repository started with code from [bamos/cv](https://github.com/bamos/cv) and I have made many changes to meet my own needs as a (now) industry data scientist, his work also credits [emichael/resume](https://github.com/emichael/resume) for portions.
