project = 'Demo Documentation'
copyright = '2025, Author'
author = 'Author'

extensions = [
    'myst_parser',
    'sphinxcontrib.bibtex',
]

myst_enable_extensions = [
    "dollarmath",
    "amsmath",
    "colon_fence",
]

bibtex_bibfiles = ['refs.bib']
bibtex_reference_style = 'author_year'

templates_path = ['_templates']
exclude_patterns = []

# Book output (LaTeX/PDF)
latex_engine = 'pdflatex'
latex_elements = {
    'papersize': 'letterpaper',
    'pointsize': '10pt',
}

# Wiki output (HTML)
html_theme = 'furo'
html_static_path = []

import re

def replace_cite_on_wiki_tag(app, docname, source):
    if app.tags.has("wiki"):
        source[0] = re.sub(r"\{cite(:?[a-zA-Z0-9_-]*?)\}(?=[`])", r"{footcite\1}", source[0])

def setup(app):
    app.connect("source-read", replace_cite_on_wiki_tag)