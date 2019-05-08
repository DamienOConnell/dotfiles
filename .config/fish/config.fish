fish_vi_key_bindings

# set fish_key_bindings fish_user_key_bindings

if status --is-login
    set -x PATH /usr/local/Cellar/ruby/2.6.1/bin /usr/local/opt/ruby/bin /usr/local/lib/ruby/gems/2.6.0/bin /Users/damien/.gem/ruby/2.6.0/bin /Users/damien/Library/Python/3.7/bin $PATH
end

set -g fish_key_bindings hybrid_bindings

# automatically install fisherman:

    if not functions -q fisher
        set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
        curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
        fish -c fisher
    end


# set fisher_path to /Users/damien/.config/fish/fisher_path
# keep fisher-installed items separate from mine

set -g fisher_path /Users/damien/.config/fish/fisher_path

set fish_function_path $fish_function_path[1] $fisher_path/functions $fish_function_path[2..-1]
set fish_complete_path $fish_complete_path[1] $fisher_path/completions $fish_complete_path[2..-1]

for file in $fisher_path/conf.d/*.fish
    builtin source $file 2> /dev/null
end

# the fuck 
thefuck --alias | source 
