


# Development

```bash
# ---- ----------- ---- #
# ----  GIT CONFIG ---- #
# ----  ---------- ---- #

git config --global commit.gpgsign true
git config --global user.name "Jean-Baptiste-Lasselle"
git config --global user.email jean.baptiste.lasselle.pegasus@gmail.com
git config --global user.signingkey 7B19A8E1574C2883
# Now, to sign Git commits, for example inside an SSH session (where TTY is a bit different ...)
export GPG_TTY=$(tty)

git config --global --list

# will re-define the default identity in use
# https://docstore.mik.ua/orelly/networking_2ndEd/ssh/ch06_04.htm
ssh-add ~/.ssh.perso.backed/id_rsa

export GIT_SSH_COMMAND='ssh -i ~/.ssh.perso.backed/id_rsa'
ssh -Ti ~/.ssh.perso.backed/id_rsa git@github.com

# if [ -d ~/hugofied-gravitee-doc ]; then
  # rm -fr ~/hugofied-gravitee-doc
# fi;

git clone git@github.com:gravitee-lab/hugofied-gravitee-docs.git
cd ~/hugofied-gravitee-doc
# git flow init --defaults && git push -u origin --all
export FEATURE_ALIAS='first-try'
# git flow feature start ${FEATURE_ALIAS} && git push -u origin --all
git checkout "feature/${FEATURE_ALIAS}"
export COMMIT_MESSAGE="feat.(${FEATURE_ALIAS}): trying to build a hugo project from the rawx website in the [raw-website-to-convert/] folder "
# git add --all && git commit -m "${COMMIT_MESSAGE}" && git push -u origin HEAD

```

* And then start upthe dev server in watch mode :

```bash

hugo serve --watch

```
