# bookmarks
Simple bookmark script in command line
(mainly for my personal use...)

## Install

```sh
nix-env -i -f https://github.com/GuilloteauQ/bookmarks/tarball/master
```
## Save Bookmark

```sh
bs [NAME] [PATH]
```
`[PATH]` can be a file, a directory or URL

## Open Bookmark

```sh
bo [NAME]
```

If no `[NAME]`, opens fzf.
 
## Remove Bookmark
 
```sh
brm [NAME]
```
