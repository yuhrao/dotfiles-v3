# Additional steps for gpg

```sh
# Set correct permissions for the gnupg directory structure
chmod 700 ~/.gnupg
find ~/.gnupg -type f -exec chmod 600 {} \;
find ~/.gnupg -type d -exec chmod 700 {} \;
```
