Output demo/demo.gif

Require emoji-expander
Require fzf

Set Shell "zsh"
Set FontSize 22
Set Width 1200
Set Height 600
Set Padding 20
Set TypingSpeed 80ms

# Setup: source completion script and ensure emoji-expander is in PATH
Hide
Type "source shell_extensions/emoji-expander_zsh_completion_script && export PATH=$PWD/target/release:$PATH"
Enter
Sleep 2s
Type "clear"
Enter
Sleep 1s
Show

# Start typing the echo command
Type 'echo '
Sleep 500ms

# Press : to open fzf emoji picker, search for cow
Type ":"
Sleep 1s
Type "cow_"
Sleep 1s
# Tab to show cow_face autocompletion
Tab
Sleep 500ms
Enter
Sleep 500ms

# Continue typing
Type ", "
Sleep 300ms

# Press : for pig
Type ":"
Sleep 1s
Type "pig"
Sleep 500ms
Down
Enter
Sleep 500ms

# Continue typing
Type " and "
Sleep 300ms

# Press : for sheep
Type ":"
Sleep 1s
Type "sheep"
Sleep 500ms
Enter
Sleep 500ms

# Close the quote and run
Type ' are my friends'
Sleep 300ms
Enter
Sleep 2s
