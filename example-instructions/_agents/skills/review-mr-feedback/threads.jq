# Merge request threads without GitLab's automatic notes. Run through threads.sh, which passes:
#   $me     the token's own user ID
#   $users  name and bot flag by user ID, because notes show bots' names as "****" and have no bot flag
#
# One object per thread:
#   id, resolved (true, false or "not resolvable"), notes (author, body)
#   author is "Name (@username)" for a person and "Name (bot)" for a bot, with ", you" added for the token's own
#   user, and "not looked up" when $users has no entry for the author.
#   position, for a comment on the diff: GitLab's position with each line next to its file and commit (old, new,
#   range, image); SKILL.md says how to read it.

# Drops GitLab's empty values; it writes 0 for the line a range end does not have.
def compact: with_entries(select(.value != null and .value != 0));

def range_end: {version: (.type // "unchanged"), old_line, new_line} | compact;

def position:
  {
    type: .position_type,
    old: ({commit: .base_sha, file: .old_path, line: .old_line} | compact),
    new: ({commit: .head_sha, file: .new_path, line: .new_line} | compact),
    range: (
      if .line_range then {start: (.line_range.start | range_end), end: (.line_range.end | range_end)} else null end
    ),
    image: (if .position_type == "image" then {x, y, width, height} else null end)
  }
  | compact;

def author:
  .author as $author
  | $ARGS.named.users[$author.id | tostring] as $user
  | [
      if $user == null then "@\($author.username)", "not looked up"
      elif $user.bot then "bot"
      else "@\($author.username)"
      end,
      if $author.id == $ARGS.named.me then "you" else empty end
    ]
  | "\($user.name // $author.name) (\(join(", ")))";

def resolved_state:
  [.[] | select(.resolvable)]
  | if . == [] then "not resolvable" else all(.resolved) end;

.[]
| [.notes[] | select(.system | not)] as $notes
| select($notes != [])
| {id, resolved: ($notes | resolved_state)}
  + (first($notes[] | .position // empty | {position: position}) // {})
  + {notes: [$notes[] | {author: author, body}]}
