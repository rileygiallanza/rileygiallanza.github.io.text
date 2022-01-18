#!/usr/bin/env bash
# This script does the required work to set up your personal GitHub Pages
# repository for deployment using Hugo. Run this script only once -- when the
# setup has been done, run the `deploy.sh` script to deploy changes and update
# your website. See
# https://hjdskes.github.io/blog/deploying-hugo-on-personal-github-pages/index.html
# for more information.
# GitHub username
USERNAME=rileygiallanza
# Name of the branch containing the Hugo source files.
SOURCE=sources
msg() {
    printf "\033[1;32m :: %s\n\033[0m" "$1"
}
msg "Adding a README.md file to \'sources\' branch"
touch README.md
msg "Deleting the \`main\` branch"
git branch -D main
git push origin --delete main
msg "Creating an empty, orphaned \`master\` branch"
git checkout --orphan master
git rm --cached $(git ls-files)
msg "Grabbing one file from the \`sources\` branch so that a commit can be made"
git checkout "sources" README.md
git commit -m "Initial commit on master branch"
git push origin master
msg "Returning to the \`sources\` branch"
git checkout -f "sources"
msg "Removing the \`public\` folder to make room for the \`master\` subtree"
rm -rf public
git add -u
git commit -m "Remove stale public folder"
msg "Adding the new \`master\` branch as a subtree"
git subtree add --prefix=public \
    git@github.com:rileygiallanza/rileygiallanza.github.io.git master --squash
msg "Pulling down the just committed file to help avoid merge conflicts"
git subtree pull --prefix=public \
    git@github.com:rileygiallanza/rileygiallanza.github.io.git master
