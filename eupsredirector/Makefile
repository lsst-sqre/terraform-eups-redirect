all:
	bundle install
	bundle exec librarian-puppet install
	docker build -t docker.io/lsstsqre/eupsredirector .
