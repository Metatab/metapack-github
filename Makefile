


THIS_REV=$(shell python setup.py --version)
NEXT_REV=$(shell python -c "import sys; import semantic_version; \
print( semantic_version.Version('.'.join(sys.argv[1].split('.')[:3])).next_patch()  )\
" $(THIS_REV) )

# Create a new revision
rev:
	git tag $(NEXT_REV)

showrev:
	@echo this=$(THIS_REV) next=$(NEXT_REV)

publish:
	$(MAKE) clean
	python setup.py sdist && \
	twine check dist/* && \
	git push --tags origin && \
	twine upload dist/*
	$(MAKE) clean

clean:
	@rm -Rf *.egg .cache .coverage .tox build dist docs/build htmlcov
	@find . -depth -type d -name __pycache__ -exec rm -Rf {} \;
	@find . -type f -name '*.pyc' -delete


develop:
	python setup.py develop

test:
	cd tests &&  python -m pytest
