#!/bin/bash
#
# Run all updates.
#

bundle exec rake saf:parse_sqw
bundle exec rake saf:analyse_sqw
bundle exec rake saf:update_elo

