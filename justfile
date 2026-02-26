both:
  just en && just es

en:
  mkdir -p build
  typst compile cv.typ build/cv-en.pdf --input lang=en

es:
  mkdir -p build
  typst compile cv.typ build/cv-es.pdf --input lang=es
