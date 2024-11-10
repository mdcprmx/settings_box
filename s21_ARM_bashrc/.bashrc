
###################################
#  List of all aliases: 
#	gacp %msg%   | git add -A, git commit %msg%, git push
#	gsetdev      | git push --set-upstream origin develop
#	gs           | git pull, git status
#	stylecheck   | clang-format -style=Google -n *.c *.h
#	stylefix     | clang-format -style=Google -i *.c *.h
#	c            | clear
#	valcheck %   | valgrind --tool=memcheck --leak-check=yes ./"$*"
#	openrepo     | open repository in firefox browser
#
#	[dol - dolphin] [spec - spectacle] [oracle - oracle VM manager]
###################################

## custom bash look, added in 2024 march
# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
		echo "[${BRANCH}${STAT}]"
	else
		echo ""
	fi
}

# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

export PS1="\[\e[37;45m\]@\[\e[m\]\u[\A] [\w]\[\e[30;47m\]\`parse_git_branch\`\[\e[m\]\[\e[37;45m\]@\[\e[m\] "


## aliases, added in 2024 june
alias dol='dolphin'
alias spec='spectacle'
alias oracle='virtualbox'

## git add, commit, push; added in 2024 july
git_add_commit_push() {
    git add -A
    git commit -m "$*"
    git push
}
alias gacp=git_add_commit_push
#gacp %commit message%

git_pull_and_status() {
	git status
	git pull
	git status
}
alias gs=git_pull_and_status
alias gsetdev="git push --set-upstream origin develop"


## clang-format aliases, added 19 july 2024 
clang_style_Google_check() {
echo "clang-format -style=Google -n *.c *.h" 
clang-format -style=Google -n *.c *.h 
}
alias stylecheck=clang_style_Google_check

clang_style_Google_fix() {
echo "clang-format -style=Google -i *.c *.h" 
clang-format -style=Google -i *.c *.h 
}
alias stylefix=clang_style_Google_fix

## valgrind memory leaks check, added 19 july 2024
memtest_valgrind() {
	echo "valgrind --tool=memcheck --leak-check=yes ./"$*""
	valgrind --tool=memcheck --leak-check=yes ./"$*"
}
alias valcheck="memtest_valgrind"

## clear alias, added 1 august 2024
alias c='clear'
alias gorl='clear'

## open git repo url, added 29 august 2024
git_open_repo_in_browser() {
	if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
		echo "Error: not in a git repo bruh."
		return 1
	fi
	check=$(git config --get remote.origin.url)


	# using sed we format gotten string. u can run this command without sed to understand how it works~
	URL=$(git config --get remote.origin.url | sed -e 's/ssh/https/g' -e 's/git@repos-https.21-school.ru:2289\//repos.21-school.ru\//' -e 's/.git//' | sed -e 's/hub.com/github.com/')
	open "$URL" &>/dev/null &
}
alias openrepo=git_open_repo_in_browser


