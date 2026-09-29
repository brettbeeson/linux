function jc --description 'journalctl shortcut'
    journalctl -n 10 -f -u $argv  | \
        string replace -r '^(.{15}) \S+ ([^[]+)\[\d+\]:' '$1 $2:'

end
~         
