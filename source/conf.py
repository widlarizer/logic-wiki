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
html_theme = 'sphinx_rtd_theme'
html_static_path = []

tags_has_book = 'book' in tags
tags_has_wiki = 'wiki' in tags
