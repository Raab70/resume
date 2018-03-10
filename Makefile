# Makefile to build PDF and Markdown cv from YAML.
#
# Brandon Amos <http://bamos.github.io> and
# Ellis Michael <http://ellismichael.com>

WEBSITE_DIR=$(HOME)/Code/Raab70/Raab70.github.io
WEBSITE_PDF=$(WEBSITE_DIR)/_data/cv.pdf
WEBSITE_MD=$(WEBSITE_DIR)/_includes/cv.md
WEBSITE_DATE=$(WEBSITE_DIR)/_includes/last-updated.txt

TEMPLATES=$(shell find templates -type f)

BUILD_DIR=build
TEX=$(BUILD_DIR)/cv.tex
PDF=$(BUILD_DIR)/cv.pdf
MD=$(BUILD_DIR)/cv.md
RESUME_TEX=$(BUILD_DIR)/resume.tex
RESUME_PDF=$(BUILD_DIR)/resume.pdf
RESUME_MD=$(BUILD_DIR)/resume.md

ifneq ("$(wildcard cv.hidden.yaml)","")
	YAML_FILES = cv.yaml cv.hidden.yaml
else
	YAML_FILES = cv.yaml
endif

.PHONY: all public viewpdf stage jekyll push clean

all: $(PDF) $(MD) $(RESUME_PDF) $(RESUME_MD)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

public: $(BUILD_DIR) $(TEMPLATES) $(YAML_FILES) generate.py
	./generate.py cv.yaml

$(TEX) $(MD) $(RESUME_TEX) $(RESUME_MD): $(TEMPLATES) $(YAML_FILES) generate.py
	./generate.py $(YAML_FILES)

$(PDF) : $(TEX) publications/*.bib
	# TODO: Hack for biber on OSX.
	rm -rf /var/folders/8p/lzk2wkqj47g5wf8g8lfpsk4w0000gn/T/par-62616d6f73

	latexmk -f -pdf -cd- -jobname=$(BUILD_DIR)/cv $(BUILD_DIR)/cv
	latexmk -c -cd $(BUILD_DIR)/cv

$(RESUME_PDF) : $(RESUME_TEX)
	rm -rf /var/folders/8p/lzk2wkqj47g5wf8g8lfpsk4w0000gn/T/par-62616d6f73
	latexmk -f -pdf -cd- -jobname=$(BUILD_DIR)/resume $(BUILD_DIR)/resume.tex
	latexmk -c -cd $(BUILD_DIR)/resume

resume: $(RESUME_TEX)
	rm -rf /var/folders/8p/lzk2wkqj47g5wf8g8lfpsk4w0000gn/T/par-62616d6f73
	latexmk -f -pdf -cd- -jobname=$(BUILD_DIR)/resume $(BUILD_DIR)/resume.tex
	latexmk -c -cd $(BUILD_DIR)/resume

viewpdf: $(PDF)
	gnome-open $(PDF)

stage: $(PDF) $(MD)
	# cp $(PDF) $(WEBSITE_PDF)
	cp $(MD) $(WEBSITE_MD)
	date +%Y-%m-%d > $(WEBSITE_DATE)

jekyll: stage
	cd $(WEBSITE_DIR) && bundle exec jekyll server

push: stage
	git -C $(WEBSITE_DIR) add $(WEBSITE_PDF) $(WEBSITE_MD) $(WEBSITE_DATE)
	git -C $(WEBSITE_DIR) commit -m "Update cv."
	git -C $(WEBSITE_DIR) push

clean:
	rm -rf $(BUILD_DIR)/*
