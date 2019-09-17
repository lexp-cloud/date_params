#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

rails_version="$(echo "$(basename $BUNDLE_GEMFILE .gemfile)" | sed 's/[^0-9.]*\([0-9.]*\).*/\1/')"

echo "Trying to compare rails ${rails_version} with 5.1"

if (( $(echo "${rails_version%.*} >= 5.1" |bc -l) )); then
   echo "Installing Bundler v2"
   gem uninstall -v '< 2.0' -i $(rvm gemdir)@global -ax bundler --force || true
   gem install bundler -v '2.0.1'
else
   echo "Installing Bundler v1"
   gem uninstall -v '>= 2' -i $(rvm gemdir)@global -ax bundler --force  || true
   gem install bundler -v '1.17.3'
fi

unset rails_version
