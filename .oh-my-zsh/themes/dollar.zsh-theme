local path_string="%{$fg[cyan]%}%~"
local dollar="%(?:%{$fg[green]%}%B◊:%{$fg[magenta]%}%B◊)"
local dollar="%(?:%{$fg[green]%}%B$:%{$fg[magenta]%}%B$)"
local prompt="${dollar} %{$reset_color%}"
PROMPT="${path_string} ${prompt}"