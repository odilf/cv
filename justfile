both:
  just en && just es

en:
  typst compile cv.typ build/cv-en.pdf --input lang=en

es:
  typst compile cv.typ build/cv-es.pdf --input lang=es
