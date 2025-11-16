project = 'The logic book'
copyright = '2025, Emil J. Tywoniak'
author = 'Emil J. Tywoniak (widlarizer) and friends'

extensions = [
    'myst_parser',
    'sphinxcontrib.bibtex',
]

myst_enable_extensions = [
    "dollarmath",
    "amsmath",
    "colon_fence",
]

bibtex_bibfiles = [
    'chapters/pda/pda.bib',
    'chapters/synth/synth.bib',
]
bibtex_reference_style = 'author_year'

templates_path = ['../_templates']

exclude_patterns = ['**refs.*'] if 'wiki' in tags else []
suppress_warnings = [
    'toc.not_readable',
    'toc.excluded',
]

# Book output (LaTeX/PDF)
latex_engine = 'pdflatex'
latex_elements = {
    'papersize': 'A4',
    'pointsize': '12pt',
    'preamble': r'''
\usepackage[sectionbib]{chapterbib}
''',
}
latex_theme_path = ['../_templates']
latex_theme = 'book'

# Wiki output (HTML)
html_theme = 'furo' if 'wiki' in tags else "sphinx_book_theme"
html_static_path = []

import sphinx.builders.latex.transforms

class DummyTransform(sphinx.builders.latex.transforms.BibliographyTransform):
    def run(self, **kwargs):
        pass

sphinx.builders.latex.transforms.BibliographyTransform = DummyTransform

import re

def replace_cite_on_wiki_tag(app, docname, source):
    if app.tags.has("wiki"):
        source[0] = re.sub(r"\{cite(:?[a-zA-Z0-9_-]*?)\}(?=[`])", r"{footcite\1}", source[0])

def setup(app):
    app.connect("source-read", replace_cite_on_wiki_tag)