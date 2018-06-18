terraform / kubernetes deployment for sw.lsstcorp.org
===

Kubernetes deployment of an nginx server that redirects `sw.lsstcorp.org` to
`eups.lsst.codes`.

tl;dr
---

    bundle install
    # requires access to the internal DM/SQRE eyaml keyring:
    # ~/Dropbox/lsst-sqre/git/lsst-certs.git.
    bundle exec rake creds
    . creds.sh
    bundle exec rake eyaml:sqre
    bundle exec rake eyaml:decrypt
    bundle exec rake terraform:install
    # production only
    bundle exec rake terraform:remote
    # /production only
    bundle exec rake khelper:create
    bundle exec rake khelper:ip
    bundle exec rake terraform:dns:apply
