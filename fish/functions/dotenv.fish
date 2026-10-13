function dotenv --description 'Export KEY=value lines from env file(s) into this fish session'
    # llm: fish's `source` and `bass source` don't export plain KEY=value files; this does.
    if test (count $argv) -eq 0
        echo 'usage: dotenv FILE...' >&2
        return 2
    end

    for file in $argv
        if not test -r "$file"
            echo "dotenv: cannot read $file" >&2
            return 1
        end
        # llm: Skip blanks/comments, allow a leading `export `, strip one pair of surrounding quotes.
        for line in (string trim < "$file" | string match -rv '^(#|$)')
            set line (string replace -r '^export\s+' '' -- $line)
            set -l kv (string split -m1 = -- $line)
            if test (count $kv) -ne 2; or not string match -qr '^[A-Za-z_][A-Za-z0-9_]*$' -- $kv[1]
                echo "dotenv: skipping malformed line in $file: $line" >&2
                continue
            end
            set -gx $kv[1] (string replace -r '^([\'"])(.*)\1$' '$2' -- $kv[2])
        end
    end
    # llm: `string replace` returns 1 when there were no quotes; success means all files were read.
    return 0
end
