#!/usr/bin/env fish

# Kenneth Reitz script - cd to the current Finder directory

function cdf -d "cd to the current Finder directory"
  cd (pfd)
end
