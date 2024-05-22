#!/bin/bash

git remote set-url origin https://White-Seeker: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@github.com/White-Seeker/HacktoberFest2021-1.git

for branch in `git branch -r | grep -Ev 'HEAD|main|develop|recipe|tindog'`;do echo -e `git show --format="%ci %cr" $branch | head -n 1` \\t$branch; done | sort -r
cnt=0

echo ""
echo "Deleting branches older than 6 months in GitHub. Key branches will be excluded."
echo ""

# Creating sample branch to switch before deleting
git branch new

for branch in `git branch -r | grep -Ev 'HEAD|main|develop|recipe|tindog' | cut -c 10-`; do

	if [[ "$(git log origin/$branch --since "6 months ago" | head -n 1 | wc -l)" -eq 0 ]]; then
		echo "Deleting $branch"
        echo "Last commit to the branch: `git log -1 origin/$branch | head -n 5 | grep Date`"
		git checkout $branch
        git checkout new
		git branch -d $branch
		git push origin --delete $branch
		((cnt++))
        echo ""
	else
		echo "Branch $branch updated less than 6 months ago"
		echo ""
	fi

done

git checkout develop
git branch -d new

echo ""
echo "Deleted $cnt branches"
echo ""
