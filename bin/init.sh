#! /bin/bash

rake db:create
rake db:create RACK_ENV=test

rake db:schema:load
rake db:schema:load RACK_ENV=test
