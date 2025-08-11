echo "Welcome to obscat!"

mkdir -p ~/.local

cd ~/.local

echo "Downloading obscat@latest version..."
wget https://github.com/xlients-dev/test/releases/download/test/obscat.tar.gz

clear

echo "extracting file..."
tar -xzf obscat.tar.gz
sleep 2
rm -rf obscat.tar.gz
cd obscat
echo "done."

echo "chmod binary..."
cd bin
chmod +x obscat obscatd
cd ..
echo "done"

sleep 1
echo "moving folder bin to /usr/local/obscat"
mkdir -p /usr/local/obscat
mv bin /usr/local/obscat

sleep 1
echo "exporting bin to PATH"
export PATH=$PATH:/usr/local/obscat/bin
obscat version

echo "Installing dependencies..."
sudo apt update && sudo apt install nginx postgresql -y
export PATH=$PATH:/usr/lib/postgresql/17/bin
postgres
echo "done."

echo "Setting up database"
sleep 3
cd ~/.local/obscat/
bash setupdb.sh
