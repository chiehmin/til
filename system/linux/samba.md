# Samba settings

```bash
# creating a new user for windows samba login
$ adduser winAccount

# Editing /etc/samba/smb.conf
[myfolder]
comment = myfolder
path = /home/fatminmin/myfolder
valid users = root, winAccount
admin users = winAccount
public = no
writable = yes
printable = no

# Setting samba password
$ smbpasswd -a winAccount

# Restarting smbd and nmbd
$ systemctl restart smbd; systemctl restart nmbd 
```