all: $(patsubst %.Dockerfile,build-stamp_%,$(wildcard *.Dockerfile))

build-stamp_%: %.Dockerfile
	docker build -t tfplenum/moloch:$(*) -f $< . 
	touch $@

push-stamp_%: build-stamp_%
	docker push tfplenum/moloch:$(*)
	touch $@

push_all: $(patsubst %.Dockerfile,push-stamp_%,$(wildcard *.Dockerfile))
