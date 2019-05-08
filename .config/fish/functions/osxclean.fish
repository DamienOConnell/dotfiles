function osxclean -d "Recursively clean directory from .pyc and .pyo files and python3 __pycache__ folders"
  set -l path2CLEAN

  if set -q $argv
    set path2CLEAN .
  else
    set path2CLEAN $argv
  end

  find $path2CLEAN -type f -name ".DS_Store" -delete -or -type f -name "._.DS_Store" -delete
end
