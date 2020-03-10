export EDITOR=vim
[ -z $TMUX ] && export TERM=xterm-256color

APP=/workspaces/template_ts_node_app
SESSION=app

alias a='tmux attach-session -t $SESSION'
alias src='source ~/.bashrc'