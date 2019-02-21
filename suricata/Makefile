all: $(patsubst %.Dockerfile,build-stamp_%,$(wildcard *.Dockerfile))

build-stamp_%: %.Dockerfile
	docker build -t tfplenum/suricata:$(*) -f $< . 
	touch $@

push-stamp_%: build-stamp_%
	docker push tfplenum/suricata:$(*)
	touch $@

push_all: $(patsubst %.Dockerfile,push-stamp_%,$(wildcard *.Dockerfile))
