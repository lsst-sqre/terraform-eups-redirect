all: build

build:
	bundle install
	bundle exec librarian-puppet install
	docker build -t docker.io/lsstsqre/eupsredirector .

push:
	docker push docker.io/lsstsqre/eupsredirector:latest
