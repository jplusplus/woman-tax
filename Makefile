
WEBAPP = $(wildcard webapp.py)
PYC    = $(wildcard *.pyc */*.pyc sources/*/*.pyc sources/*/*/*.pyc sources/*/*/*/*.pyc sources/*/*/*/*/*.pyc)
CACHE  = $(wildcard static/.webassets-cache static/gen)
RM     = rm -fr

run: clean
	. `pwd`/.env ; python $(WEBAPP)

install:
	virtualenv venv --no-site-packages --distribute --prompt=womantax
	. `pwd`/.env ; pip install -r requirements.txt
	. `pwd`/.env ; npm install

clean:
	$(RM) $(PYC)
	$(RM) $(CACHE)

freeze:
	-rm build -r
	. `pwd`/.env ; python -c "from webapp import app; from flask_frozen import Freezer; freezer = Freezer(app); freezer.freeze()"
	-rm build/static/.webassets-cache/ -r
	sed -i 's/href="\//href="/g' build/*.html
	sed -i 's/src="\//src="/g' build/*.html

update_i18n:
	pybabel extract -F babel.cfg -o translations/messages.pot .
	pybabel update -i translations/messages.pot -d translations

compile_i18n:
	pybabel compile -d translations

# EOF
