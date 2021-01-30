#!/bin/bash
: ${TEMPDIR:=${TEMPDIR}}
: ${PKGS_TXT:=${PKGS_TXT}}
: ${PKGS_AVAIL_TXT:=${PKGS_AVAIL_TXT}}
: ${PKGS_TO_CHECK_TXT:=${PKGS_TO_CHECK_TXT}}
: ${PKGS_ALL_TXT:=${PKGS_ALL_TXT}}

if ! [[ `type -t vimdiff` =~ alias|file ]]; then
  echo "vimdiff not found."
  exit 1
fi
if [ ! -f packages.yaml ]; then
  echo "packages.yaml not found."
  exit 1
fi
ls ../packages/*.rb | sort | cut -d'/' -f3 | cut -d'.' -f1 >"$PKGS_ALL_TXT"
rm -f "$PKGS_TXT"
touch "$PKGS_TXT"
for p in $(cat "$PKGS_ALL_TXT"); do
  if [ ! $(grep 'is_fake' ../packages/${p}.rb 2>/dev/null) ]; then
    echo $p >> "$PKGS_TXT"
  fi
done
grep "^name:" packages.yaml | sort | cut -d' ' -f2 >"$PKGS_TO_CHECK_TXT"
sort <"$PKGS_TXT" >"$PKGS_AVAIL_TXT"
vimdiff ${PKGS_AVAIL_TXT} ${PKGS_TO_CHECK_TXT}
rm -f ${PKGS_TXT} ${PKGS_ALL_TXT} ${PKGS_AVAIL_TXT} ${PKGS_TO_CHECK_TXT}
