#!/usr/bin/env zsh
cat > ./global/scripts/$1 << EOF
#!/usr/bin/env zsh

EOF

$EDITOR ./global/scripts/$1 || $VISUAL ./global/scripts/$1

