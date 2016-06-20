#!/bin/bash -e

# Run everything in bootstrap/ that matches `dd-script_name` that is executable.
# Scripts can be commented out marking them as not executable.

# http://manpages.ubuntu.com/manpages/wily/man8/run-parts.8.html

run-parts --verbose --exit-on-error --regex='^[a-zA-Z0-9_-]+' \
  -- /vagrant/bootstrap
