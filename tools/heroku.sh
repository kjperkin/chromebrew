#!/bin/bash

: ${TEMPDIR:=/tmp}
PWD_HOLD="${PWD}"

cd "$TEMPDIR"
if [[ -d "${TEMPDIR}/heroku-cli" ]]; then
  cd heroku-cli
  git pull &>/dev/null
  cd ..
else
  git clone https://github.com/heroku/cli.git heroku-cli &>/dev/null
fi
cd heroku-cli
export HEROKU_V="$(git describe --abbrev=0 --tags)"
echo "${HEROKU_V}":
export SOURCE_URL="https://github.com/heroku/cli/archive/${HEROKU_V}.tar.gz"
export SOURCE_SHA256="$(wget -O- ${SOURCE_URL} 2>/dev/null | sha256sum | cut -d' ' -f1)"
echo "source_url '${SOURCE_URL}'"
echo "source_sha256 '${SOURCE_SHA256}'"
echo
echo "Package file located at ${PWD_HOLD}/heroku.rb"

cd "${PWD_HOLD}"

cat >heroku.rb <<EOF
require 'package'

class Heroku < Package
  description 'The Heroku Command Line Interface (CLI), formerly known as the Heroku Toolbelt, is a tool for creating and managing Heroku apps from the command line / shell of various operating systems.'
  homepage 'https://devcenter.heroku.com/articles/heroku-cli'
  version '${HEROKU_V}'
  source_url '${SOURCE_URL}'
  source_sha256 '${SOURCE_SHA256}'

  binary_url ({
  })
  binary_sha256 ({
  })

  depends_on 'yarn'

  def self.build
    system 'yarn install'
  end

  def self.install
    system "mkdir -p #{CREW_DEST_PREFIX}/share/heroku"
    system "cp -r . #{CREW_DEST_PREFIX}/share/heroku"
    system "mkdir -p #{CREW_DEST_PREFIX}/bin"
    system "ln -s #{CREW_PREFIX}/share/heroku/bin/run #{CREW_DEST_PREFIX}/bin/heroku"
  end
end
EOF
