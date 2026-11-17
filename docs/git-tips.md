# Git tips

Written 2026-11-06 for git 2.50.1. Editor is Neovim (`core.editor=nvim`), so
commit messages and the interactive-rebase list open in Neovim. The "advanced"
recipes were tested in a throwaway repo on this git version.
In-editor git (CodeDiff, gitsigns): see the Git section in `vim-tips.md`.

`<sha>` = a commit hash (or any ref: `HEAD~2`, `master`, a tag). `HEAD~3` = 3
commits before the current one.

## Everyday

### Look around

| Command | What |
| --- | --- |
| `git status -sb` | Short status + branch / ahead / behind |
| `git diff` | Unstaged changes |
| `git diff --staged` | What the next commit will contain |
| `git diff master...HEAD` | Everything my branch changed since it split from master |
| `git log --oneline --graph -20` | Recent history as a graph (`gl`, `gla` = all branches) |
| `git show <sha>` | One commit: message + diff |
| `git show <sha>:path/to/file` | A file as it was in that commit |
| `git branch --sort=-committerdate` | Branches, most recently used first |

### Stage and commit

| Command | What |
| --- | --- |
| `git add -p` | Stage piece by piece: `y` yes, `n` no, `s` split, `e` edit, `q` quit |
| `git restore --staged <file>` | Unstage (keeps the changes) |
| `git commit -m "msg"` | Commit (`gm "msg"`) |
| `git commit -v` | Commit with the diff shown in the editor |
| `git commit --amend --no-edit` | Add staged changes to the last commit, same message |
| `git commit --amend` | Change the last commit's message (`gma`) |

### Branches

| Command | What |
| --- | --- |
| `git switch -c feat/x` | New branch from here (`gb feat/x` does the same with checkout) |
| `git switch master` / `git switch -` | Go to master / back to the previous branch |
| `git branch -m new-name` | Rename the current branch |
| `git branch -d feat/x` | Delete a merged branch (`-D` forces; needed after a squash merge) |
| `git push origin --delete feat/x` | Delete the remote branch |

### Sync

| Command | What |
| --- | --- |
| `git fetch --prune` | Get remote changes, forget deleted remote branches |
| `git pull --rebase` | Pull, replaying my commits on top (`gp`) |
| `git push` | Push (`gu`) |
| `git push -u origin HEAD` | First push of a new branch, and track it |
| `git push --force-with-lease` | Push after rewriting history; refuses if someone else pushed meanwhile |

My global `pull.rebase` is `off`, so plain `git pull` merges; `gp` rebases.

### Merge or rebase onto master

| Command | What |
| --- | --- |
| `git rebase master` | Replay my branch on top of master (`grm`) |
| `git merge master` | Merge master into my branch (`gmm`) |
| `git merge --squash feat/x` | Bring a branch in as one staged change, then commit (`gmms` for master) |

### Conflicts

1. `git status` lists the conflicted files.
2. Fix each file. In Neovim, `<leader>gm` opens CodeDiff's 3-way merge.
3. `git add <file>` marks it resolved.
4. `git rebase --continue` (`grc`), or `git merge --continue` /
   `git cherry-pick --continue`.

- Give up: `git rebase --abort` / `git merge --abort`.
- Take one side for a whole file: `git checkout --ours <file>` or `--theirs`.
  **During a rebase they're swapped:** "ours" is the branch you're rebasing
  onto (e.g. master), "theirs" is your commit being replayed.
- Skip the commit that conflicts (during a rebase): `git rebase --skip`.

### Stash

| Command | What |
| --- | --- |
| `git stash push -m "wip: login"` | Stash tracked changes with a name |
| `git stash -u` | Also stash untracked files |
| `git stash push -p` | Stash only some hunks |
| `git stash list` / `git stash show -p stash@{1}` | List / look inside |
| `git stash pop` / `git stash apply stash@{1}` | Restore and drop / restore and keep |
| `git stash drop stash@{1}` | Delete one |

### Undo

| Situation | Command |
| --- | --- |
| Unstage a file | `git restore --staged <file>` |
| Throw away local changes to a file | `git restore <file>` (**gone for good**) |
| Undo the last commit, keep its changes staged | `git reset --soft HEAD~1` |
| Undo the last commit, keep changes unstaged | `git reset HEAD~1` |
| Undo a commit that's already pushed | `git revert <sha>` (new commit that reverses it) |
| Get one file back from a commit | `git restore --source=<sha> -- <file>` |
| Bring back a deleted branch or a commit "lost" by reset/rebase | see [Reflog](#safety-net-reflog) |

## Advanced: edit the last N commits (interactive rebase)

```sh
git rebase -i HEAD~5        # last 5 commits
git rebase -i master        # every commit on my branch since master
git rebase -i --root        # all commits in the repo
```

Neovim opens a list, **oldest at the top**:

```
pick 1a2b3c4 Add login form
pick 5d6e7f8 Fix typo
pick 9a0b1c2 Add validation
```

Change the word at the start of a line, reorder lines, then `:wq`. Git replays
the list top to bottom.

| Command | Short | Effect |
| --- | --- | --- |
| `pick` | `p` | Keep the commit as is |
| `reword` | `r` | Keep it, edit its message |
| `edit` | `e` | Stop after it so I can amend or split it |
| `squash` | `s` | Merge into the commit above, combine both messages |
| `fixup` | `f` | Merge into the commit above, keep only the above message |
| `fixup -C` | | Merge into the commit above, keep **this** commit's message |
| `drop` | `d` | Delete the commit (deleting the line does the same) |
| `exec <cmd>` | `x` | Run a shell command at that point; stops if it fails |
| `break` | `b` | Pause here (`git rebase --continue` to go on) |
| *(move a line)* | | Reorder commits |

- **Abort before it starts:** quit Neovim with `:cq` (exit with an error), or delete every line.
- **Abort midway:** `git rebase --abort` returns everything to how it was.
- **After it stops** (for `edit`, `break`, or a conflict): do the work, then `git rebase --continue`.

### Recipes

**Fix something in an older commit** (the most useful one)
```sh
# stage the fix, then:
git commit --fixup=<sha>                 # creates "fixup! <its message>"
git rebase -i --autosquash <sha>~1       # the fixup is already moved under <sha>; just :wq
```
Add `GIT_SEQUENCE_EDITOR=:` in front of the rebase to skip the editor
entirely. To make `--autosquash` the default:
`git config --global rebase.autoSquash true`.

**Change an older commit's message**
```sh
git commit --fixup=reword:<sha>          # opens the editor for the new message ("amend!" commit)
git rebase -i --autosquash <sha>~1
```
Or simply `git rebase -i <sha>~1` and change `pick` to `reword`.

**Squash the last 3 commits into one**
- `git rebase -i HEAD~3`: keep the first line `pick`, set the other two to `fixup`
  (or `squash` to edit the combined message).
- Quicker: `git reset --soft HEAD~3 && git commit -m "One commit"`.

**Split one commit into two**
```sh
git rebase -i <sha>~1        # mark <sha> as edit, :wq
git reset HEAD^              # undo that commit, keep its changes unstaged
git add -p                   # stage the first part
git commit -m "First part"
git add -A
git commit -m "Second part"
git rebase --continue
```

**Remove or reorder commits:** `git rebase -i HEAD~N`, then delete lines or
move them.

**Check every commit still builds / passes tests**
```sh
git rebase -i --exec "npm test" master   # stops at the first commit that fails
```

**Rebase a branch without moving its base** (only clean up my own commits):
`git rebase -i --keep-base master`

**Stacked branches** (feat/b built on feat/a): `git rebase -i --update-refs master`
while on feat/b also moves feat/a's pointer. Default it with
`git config --global rebase.updateRefs true`.

**After rewriting commits that are already pushed:**
`git push --force-with-lease`. Only on my own branches, never on shared ones
like master.

**What changed between before and after the rebase:**
`git range-diff ORIG_HEAD...HEAD` (right after the rebase).

### Safety net: reflog

Every position `HEAD` has been at is recorded for ~90 days, including before
a bad reset, rebase or amend.

```sh
git reflog -15                     # HEAD@{0} now, HEAD@{1} one step back, …
git reset --hard HEAD@{1}          # go back to where I was one step ago
git reset --hard ORIG_HEAD         # undo the last rebase / reset / merge
git branch rescue <sha-from-reflog>  # or keep the lost state on a new branch
git reflog show feat/x             # history of one branch's pointer
```

Uncommitted changes are **not** in the reflog. Commit or stash before risky
operations.

## More advanced tools

### Find things in history

| Command | What |
| --- | --- |
| `git log -S "useHooksProvider"` | Commits that added or removed that text |
| `git log -G "regex"` | Commits whose diff matches a regex |
| `git log -L 40,60:src/app.tsx` | History of just those lines |
| `git log --follow -- <file>` | File history, across renames |
| `git log --author=Tomasz --since="2 weeks ago"` | Filter by author / date |
| `git blame -w -C -C -C <file>` | Blame, ignoring whitespace and following moved code |
| `git grep "text" <sha>` | Search the files of any commit |
| `git shortlog -sn` | Commits per author |

### Find the commit that broke something (bisect)

```sh
git bisect start
git bisect bad                 # current commit is broken
git bisect good v1.4.0         # this one was fine
# git checks out the middle; test it, then: git bisect good / git bisect bad
git bisect run npm test        # or let a command decide automatically
git bisect reset               # back to where I started
```

### Copy commits between branches

- `git cherry-pick <sha>`: apply one commit here. Add `-x` to note the source in
  the message.
- `git cherry-pick A^..B`: a range, A to B inclusive.

### Several checkouts at once (worktree)

Useful for reviewing or hotfixing without stashing current work:
```sh
git worktree add ../ep-native-review master     # second working folder on master
git worktree list
git worktree remove ../ep-native-review
```

### Clean untracked files

`git clean -n` shows what would go; `git clean -fd` removes untracked files and
folders (**permanent**); add `-x` to also remove ignored files (e.g.
`node_modules`).

### Remember conflict resolutions (rerere)

`git config --global rerere.enabled true`: git records how I resolved a
conflict and reapplies it the next time the same conflict appears, which helps
with repeated rebases.

## Config worth considering (not applied)

```sh
git config --global rebase.autoSquash true        # --autosquash by default
git config --global rebase.autoStash true         # stash/unstash around rebase automatically
git config --global rebase.updateRefs true        # move stacked branches along
git config --global push.autoSetupRemote true     # plain `git push` works on a new branch
git config --global fetch.prune true              # drop deleted remote branches on fetch
git config --global merge.conflictStyle zdiff3    # conflicts also show the original (base) text
git config --global diff.algorithm histogram      # usually more readable diffs
git config --global rerere.enabled true           # reuse conflict resolutions
git config --global branch.sort -committerdate    # `git branch` lists recent first
git config --global commit.verbose true           # show the diff while writing the message
git config --global help.autocorrect prompt       # offer to run the right command on typos
```

## My aliases (~/.config/.aliases)

| Alias | Runs |
| --- | --- |
| `gp` / `gu` | `git pull --rebase` / `git push` |
| `gm "msg"` / `gma` / `gsm "msg"` | commit / amend / signed commit (needs signing set up first) |
| `gmn` | `npm run commit` (the project's commit helper) |
| `gb name` / `gcm` | `checkout -b name` / `checkout master` |
| `grm` / `grd` / `grc` | rebase master / rebase develop / rebase --continue |
| `gmm` / `gmms` / `gmd` | merge master / merge master --squash / merge develop |
| `gl` / `gla` / `gln N` | log --graph / all branches / last N |
| `gls` / `glsn N` | date + subject per commit / last N |
| `gcl` | clone |

Watch out:
- **`gd` is not diff.** It runs `git reset --hard HEAD` and throws away all
  uncommitted changes.
- **`gpb` force-deletes every local branch except the current one**
  (`git branch -D`), merged or not.
- **`gmc` doesn't work:** `git commit --continue` isn't a git command
  (`unknown option 'continue'`). Use `git merge --continue`,
  `git rebase --continue` (`grc`) or `git cherry-pick --continue`.
