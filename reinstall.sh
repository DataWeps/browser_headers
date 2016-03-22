#!/bin/bash
sudo gem uninstall browser_headers
gem build browser_headers.gemspec 
sudo gem install browser_headers-0.0.0.gem
