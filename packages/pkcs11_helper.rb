require 'package'

class Pkcs11_helper < Package
  description 'pkcs11-helper is a library that simplifies the interaction with PKCS#11 providers for end-user applications.'
  homepage 'https://github.com/OpenSC/pkcs11-helper'
  @_ver = '1.27'
  version @_ver + '-1'
  compatibility 'all'
  source_url "https://github.com/OpenSC/pkcs11-helper/archive/pkcs11-helper-#{@_ver}.tar.gz"
  source_sha256 '4d0b1e44a233afec4a394863ff74963ffadf2a43939a1c85e562885c3552f098'


  depends_on 'openssl'
  depends_on 'automake' => :build
  depends_on 'autoconf' => :build
  depends_on 'm4' => :build
  depends_on 'make' => :build


  def self.build
    system "autoreconf -i"
    FileUtils.mkdir_p 'build'
    Dir.chdir('build') do
        system "../configure \
                #{CREW_OPTIONS} \
                CFLAGS='-flto=auto' \
                CXXFLAGS='-flto=auto'"
        system "make"
    end
  end
  

  def self.check
  end
  

  def self.install
    Dir.chdir('build') do
        system "make DESTDIR=#{CREW_DEST_DIR} install"
    end
  end
end
