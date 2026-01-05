if [[ "$(uname)" == "Darwin" ]]; then
    typeset -U path PATH

    path=("/opt/homebrew/bin" "$HOME/.cargo/bin" "$HOME/go/bin" $path)

    if [[ -x /usr/libexec/java_home ]]; then
        export JAVA_HOME=$(/usr/libexec/java_home)
        path=("$JAVA_HOME/bin" $path)
    fi

    ulimit -Sn 65535
fi
