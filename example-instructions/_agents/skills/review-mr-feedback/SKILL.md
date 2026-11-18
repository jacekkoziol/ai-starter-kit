---
name: review-mr-feedback
description: Analyze the open review threads on a GitLab merge request, then implement the agreed changes and reply in the threads.
disable-model-invocation: true
---

# Review merge request feedback

## 1. Analyze

The analysis is read-only. Run reproductions in the scratchpad, and remove what they create (clones, worktrees, databases).

- Use the merge request the user names, or the current branch's. If it has no open threads and the branch is in a stack (`bin/gs log short`), ask which merge request the user means.
- Read every thread with `.agents/skills/review-mr-feedback/threads.sh <MR>`. Analyze the unresolved threads; use resolved threads and other comments as context.
- A thread's `position` says where the comment is. `old` is the version before the merge request and `new` is the merge request's version, each with its commit and file. The comment is on `new.line`, or on `old.line` for removed code; `range` is the selection when it was made. Later pushes move the line but not the range, so when they disagree, the line is current.
- Reach a verdict on every unresolved thread that asks for a code change: correct, partly correct, or not correct, with the evidence. Check library behavior in the installed version.

## 2. Report

Give a numbered list. Start each item with a second-level heading (`## 1. <short title>`). Each item includes, if applicable:

- a summary of the earlier discussion;
- the latest note, in full or summarized;
- links to the relevant files, with line numbers;
- if the feedback is correct: briefly why, and what change is needed, if any;
- if the feedback is not correct: a dense but detailed technical explanation, ready to post as a reply;
- the decision the user must make, if any.

The item numbers are the only numbering in the report. Then summarize the overall feedback and the actions to take; the decisions stay in their items. Wait for the user's decisions.

## 3. Implement

- Implement the points the user agreed to. For a declined point, keep the user's reason for the reply.
- In a stack, change the branch whose merge request has the thread, then restack as `docs/merge-requests.md` describes.
- Verify each change with the check that showed the defect.
- Then stop and wait for instructions. Commit and push only when told.

## 4. Reply

Reply when the user asks, and only after the changes are pushed or you and the user agreed that no change is needed.

- Reply inside each thread: `bin/glab mr note create <MR> --reply <discussion ID> -m "$(cat <file>)"`, with the body in a file in the scratchpad.
- For a fixed point: the commit, what changed, and how it was verified. For a declined point: the reason agreed with the user.
- Leave the threads unresolved for the user or the reviewer.
- Notes appear under the owner of `GITLAB_TOKEN`. Tell the user when that is not their own account.
- If any thread was an automated review finding, start a new review as `docs/merge-requests.md` ("Automated review") says. Tell the user.
