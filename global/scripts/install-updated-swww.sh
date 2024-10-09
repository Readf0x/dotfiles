#!/usr/bin/env zsh

yay -R swww
git clone -b fix-transition-frame-timings https://github.com/Horus645/swww.git /tmp/swww-tmp
cd /tmp/swww-tmp
git merge --no-commit origin/main
cargo build --release
sudo cp ./target/release/swww /usr/bin/local/swww
sudo cp ./target/release/swww-daemon /usr/bin/local/swww-daemon
sudo cp ./completions/_swww /usr/share/zsh/site-functions/_swww
sudo cp ./completions/swww.bash /usr/share/bash-completion/completions/swww
