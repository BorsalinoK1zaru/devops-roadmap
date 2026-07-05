## День 21

mkdir -p ~/server-practice/day21
cd ~/server-practice/day21

echo "test config" > config.txt

ls -l config.txt

chmod 600 config.txt
ls -l config.txt

chmod 644 config.txt
ls -l config.txt

mkdir -p ~/.ssh
chmod 700 ~/.ssh

ssh-keygen -t ed25519 -C "моя почта devops-roadmap" -f ~/.ssh/devops_vps_ed25519

