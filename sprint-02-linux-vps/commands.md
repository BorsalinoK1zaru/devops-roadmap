## День 21

whoami
hostname
pwd
uname -a
cat /etc/os-release
id
groups
sudo -v

which ssh
ssh -V
ls -la ~/.ssh

ssh-keygen -lf ~/.ssh/devops_vps_ed25519.pub

ssh-keygen -t ed25519 -C "<your-email> devops-roadmap" -f ~/.ssh/devops_vps_ed25519


## День 22

chmod 600 config.txt
ls -l config.txt

chmod 644 config.txt
ls -l config.txt

chmod 755 config.txt
ls -l config.txt

cat > hello.sh <<'EOF'
#!/usr/bin/env bash
echo "Hello from Linux script"
EOF

./hello.sh

chmod +x hello.sh
ls -l hello.sh
./hello.sh

sleep 300 &
echo $! > sleep.pid

cat sleep.pid
ps -p $(cat sleep.pid) -o pid,ppid,user,stat,cmd

kill $(cat sleep.pid)
ps -p $(cat sleep.pid) -o pid,ppid,user,stat,cmd

mkdir -p web
echo "Hello from day22 server" > web/index.html

cd web
python3 -m http.server 9000 --bind 127.0.0.1 > ../server.log 2>&1 &
echo $! > ../server.pid
cd ..

curl http://127.0.0.1:9000

ss -tulpn | grep :9000

cat server.log
tail -f server.log

cat server.pid
kill $(cat server.pid)