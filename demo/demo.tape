Output demo/demo.gif

Require emoji-expander
Require fzf

Set Shell "zsh"
Set FontSize 22
Set Width 1200
Set Height 600
Set Padding 20
Set TypingSpeed 80ms

## Setup: source completion script and ensure emoji-expander is in PATH
Hide
Type "source shell_extensions/emoji-expander_zsh_completion_script && export PATH=$PWD/target/release:$PATH && clear" Enter
Show

Type "emoji-expander demo" Ctrl+C
Sleep 3s

## Title
Type 'clear' Enter
Type '1. Shell autocompletion (hit colon then Enter)' Ctrl+C
Sleep 3s

Type 'echo ' Sleep 500ms
Type ":" Sleep 1s Type "cow_" Sleep 1s Enter Sleep 500ms
Type ", " Sleep 300ms
Type ":" Sleep 1s Type "pig_" Sleep 500ms Down Enter Sleep 500ms
Type " and " Sleep 300ms
Type ":" Sleep 1s Type "sheep" Sleep 500ms Enter Sleep 500ms
Type ' are my friends' Sleep 300ms Enter
Sleep 2s

# Batch expansion examples
Type '2. Batch expansion' Ctrl+C
Sleep 3s

Type 'vim friends' Sleep 500ms Enter
Sleep 1s Type 'i' Sleep 1s
Type ':cat:, :dog: and :bird: too' Sleep 2s
Escape Type ':wq' Sleep 1s Enter
Sleep 1s

Type 'cat friends | emoji-expander ' Enter
Sleep 3s

# Git commit message example
Type '3. git emojis' Ctrl+C
Sleep 3s

Type 'git commit -m "' Sleep 1s Type ':git_comme' Sleep 300ms Enter
Type ' Nice one :git_' Sleep 1000ms Up Up Up Up Up Up Up Up
Sleep 1500ms Enter Type '"' Ctrl+C
Sleep 3s
