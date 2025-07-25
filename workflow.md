# Git and GitHub Workflow

The following diagram visualizes our branching model:

![Git Branching Model](git-branching-model.svg)

Our git workflow looks as follows:

- The `main` branch reflects the latest state of development, and should
  always compile.

- In case we need to release a hotfix, we use dedicated patch release branches.

- The `latest` branch always points to the latest release that is not a release
  candidate. It exists so support a streamlined workflow for some packaging
  tools (e.g., Nix).

- For new features or fixes, use _topic branches_ that branch off `main` with
  a naming convention of `topic/description`. After completing work in a topic
  branch, check the following steps to prepare for a merge back into `main`:
  - Squash your commits such that each commit reflects a self-contained change.
    You can interactively rebase all commits in your current pull request with
    `git rebase --interactive $(git merge-base origin/main HEAD)`.

  - Create a pull request to `main` on GitHub.

  - Wait for the results of continuous integration tools and fix any reported
    issues.

  - Ask a maintainer to review your work when your changes merge cleanly. If
    you don't want a specific maintainer's feedback, ask for a team review from
    [tenzir/engineering](https://github.com/orgs/tenzir/teams/engineering).

  - Address the feedback articulated during the review.

  - A maintainer will merge the topic branch into `main` after it passes the
    code review.

- Similarly, for features or fixes relating to a specific GitHub issue, use
  _topic branches_ that branch off `main` with a naming convention of
  `topic/XXX`, replacing XXX with a short description of the issue.

## Commit Messages

Commit messages are formatted according to [this git style
guide](https://github.com/agis/git-style-guide).

- The first line succinctly summarizes the changes in no more than 50
  characters. It is capitalized and written in and imperative present tense:
  e.g., "Fix a bug" as opposed to "Fixes a bug" or "Fixed a bug". As a
  mnemonic, prepend "When applied, this commit will" to the commit summary and
  check if it builds a full sentence.

- The first line does not contain a dot at the end. (Think of it as the header
  of the following description).

- The second line is empty.

- Optional long descriptions as full sentences begin on the third line,
  indented at 72 characters per line, explaining _why_ the change is needed,
  _how_ it addresses the underlying issue, and what _side-effects_ it might
  have.
