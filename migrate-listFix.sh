#!/bin/bash

# Project name
PROJECT_NAME="listFix"

# SVN repository to be migrated
SVNREPO="https://svn.code.sf.net/p/listfix/code/"
GIT_URL="https://github.com/Borewit/listFix.git"
FOLDER_GIT="${PROJECT_NAME}.git"
FOLDER_SVN="${PROJECT_NAME}.svn"
PWD=$(pwd)

svnadmin create "${FOLDER_SVN}"
echo '#!/bin/sh' > "${FOLDER_SVN}/hooks/pre-revprop-change"
chmod 755 "${FOLDER_SVN}/hooks/pre-revprop-change"

svnsync init "file://${PWD}/${FOLDER_SVN}" "${SVNREPO}"

svnsync sync "file://${PWD}/${FOLDER_SVN}"

rm -rf "${FOLDER_GIT}"

reposurgeon "script listFix.lift"

cd "${FOLDER_GIT}" || exit

for crt_tag in $(git tag | grep "emptycommit"); do
  git tag --delete "${crt_tag}"
done

array=( 1.5.3 2.0.0 2.1.0 2.2.0)
for i in "${array[@]}"
do
	git checkout "${i}"
	git tag "v${i}"
done

git remote add origin "${GIT_URL}"
