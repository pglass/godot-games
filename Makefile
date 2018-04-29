GODOT := /Applications/Godot.app/Contents/MacOS/Godot

DIRS = asteroids

.PHONY: $(DIRS)

all: $(DIRS)

$(DIRS):
	python build-project.py $@
	./sync-project.sh $@
