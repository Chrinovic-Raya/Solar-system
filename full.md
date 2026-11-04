```
sudo apt update
curl -fsSL https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/anydesk.gpg
echo "deb http://deb.anydesk.com/ rpi main" | sudo tee /etc/apt/sources.list.d/anydesk.list
sudo apt update
sudo apt install anydesk -y
```

