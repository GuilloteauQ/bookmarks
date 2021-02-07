let
  pkgs = import <nixpkgs> {};
  bookmark_file_path = "$HOME/.bookmarks";
  inherit (pkgs) stdenv;

  bookmark_open = pkgs.writeScriptBin "bo" ''
#!${pkgs.stdenv.shell}
BOOKMARK_FILE=${bookmark_file_path}

if [[ $# -gt 0 ]]
then
	bookmark_name=$1
else
	bookmark_name=$(cat $BOOKMARK_FILE | awk '{print $1 "\t" $2}' | ${pkgs.fzf}/bin/fzf |  tr -s ' ' | cut -d $'\t' -f 1 | tr -s ' ')
fi

if [ -n "$bookmark_name" ]
then

    result=$(echo "$bookmark_name" | xargs -I {} awk '$1~/{}$/{ print $2 }' $BOOKMARK_FILE)

    bookmark_type=$(file $result | rev | cut -d " " -f 1 | rev)

    case $bookmark_type in
        text)
        exec $EDITOR $result
        ;;
        directory)
        cd $result
        ;;
        *)
        firefox $result
        ;;
    esac
fi
  '';

  bookmark_save = pkgs.writeScriptBin "bs" ''
#!${pkgs.stdenv.shell}
bookmark_name=$1

bookmark_content=$(echo "$2" | sed "s|~|$HOME|g")

BOOKMARK_FILE=${bookmark_file_path}

echo -e "$bookmark_name\t$bookmark_content" >> $BOOKMARK_FILE
  '';

  bookmark_rm = pkgs.writeScriptBin "brm" ''
#!${pkgs.stdenv.shell}
bookmark_name=$1

BOOKMARK_FILE=${bookmark_file_path}

result=$(echo -e "$bookmark_name" | xargs -I {} awk '$1~/{}$/{ print $1 $2 }' $BOOKMARK_FILE)

echo "$result" > .tmp

grep -vFxf .tmp $BOOKMARK_FILE > .tmp_new_bookmarks

mv .tmp_new_bookmarks $BOOKMARK_FILE

rm .tmp

  '';

in

pkgs.symlinkJoin {
  name = "bookmarks";
  paths = [
	bookmark_save
	bookmark_open
	bookmark_rm
	pkgs.fzf
  ];
}

