#!/usr/bin/env fish


function updatedb -d "Updates 'locate' database"
  sudo /usr/libexec/locate.updatedb
end
