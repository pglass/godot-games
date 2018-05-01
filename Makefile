GODOT := /Applications/Godot.app/Contents/MacOS/Godot

DIRS = asteroids lightsout

.PHONY: $(DIRS) index.html

all: $(DIRS)

$(DIRS):
	python build-project.py $@
	./sync-project.sh $@

index.html:
	rsync -r -v index.html games.pglbutt.com:/var/www/html/index.html
