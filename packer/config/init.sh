#!/usr/bin/env bash

# Update everything
apt update

# Install Packages Needed for NPM scripts
apt install -y build-essential python make g++ zsh vim

# Install NodeJS 12.x
curl -sL https://deb.nodesource.com/setup_12.x -o nodesource_setup.sh
sudo bash nodesource_setup.sh
apt install -y nodejs
node -v
npm -v

# Add the new sudo user
useradd $USER && echo $USER:"$PASSWORD" | /usr/sbin/chpasswd
usermod -aG sudo $USER
echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/username

touch ~/.zshrc
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/agkozak/zsh-z ~/.oh-my-zsh/custom/plugins/zsh-z
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone git://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

sed -i -e '/^ZSH_THEME=/s/^.*$/ZSH_THEME="agnoster"/' ~/.zshrc
sed -i -e '/^plugins=/s/^.*$/plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-z)/' ~/.zshrc

source ~/.zshrc

chsh -s /bin/zsh root
chsh -s /bin/zsh $USER

# Add our SSH keys
mv /tmp/config/ssh/id_rsa ~/.ssh/github
chmod 0600 ~/.ssh/github

mv /tmp/config/ssh/id_rsa.pub ~/.ssh/github.pub
chmod 0600 ~/.ssh/github.pub

ssh-add ~/.ssh/github
printf 'IdentityFile ~/.ssh/github' >> ~/.ssh/config
ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts

# sed -i -e '/^Port/s/^.*$/Port 4444/' /etc/ssh/sshd_config
sed -i -e '/^PermitRootLogin/s/^.*$/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i -e "$aAllowUsers $USER" /etc/ssh/sshd_config
service ssh restart

rsync --archive --chown=$USER:$USER ~/.ssh /home/$USER
chown $USER:$USER /home/$USER

cp ~/.zshrc /home/$USER/.zshrc
cp -r ~/.oh-my-zsh /home/$USER/.oh-my-zsh

chown $USER:$USER /home/$USER/.zshrc
chown $USER:$USER /home/$USER/.oh-my-zsh

sed -i -e "/^export ZSH=/s/^.*$/export ZSH='\/home\/$USER\/.oh-my-zsh'/" /home/$USER/.zshrc
source /home/$USER/.zshrc

echo "$SSH_KEY" >> /home/$USER/.ssh/authorized_keys

# Install and build our apps
cd /var
mkdir www
mkdir www/jungle-hunt
cd www/jungle-hunt
mkdir pm2

mv /tmp/config/pm2/ecosystem.config.js ./pm2/ecosystem.config.js

git clone git@github.com:rdimascio/jungle-hunt-app.git ./app
git clone git@github.com:rdimascio/jungle-hunt-server.git ./api

cd ./app

mv /tmp/config/env/$NODE_ENV/.env.app ./.env

cd ./../api

mv /tmp/config/env/$NODE_ENV/.env.api ./.env

# Install & Colnfigure Nginx
apt install -y nginx
rm /etc/nginx/sites-enabled/default
cat /tmp/config/nginx.conf >> /etc/nginx/sites-available/junglehunt.io
sudo ln -s /etc/nginx/sites-available/junglehunt.io /etc/nginx/sites-enabled/
service nginx start

npm i -g pm2

# Configure Firewall
# ufw allow 4444/tcp
ufw allow OpenSSH
ufw allow 'Nginx Full'
ufw --force enable
