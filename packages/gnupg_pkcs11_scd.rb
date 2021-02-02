require 'package'

class Gnupg_pkcs11_scd < Package
  description 'pkcs11-helper is a library that simplifies the interaction with PKCS#11 providers for end-user applications.'
  homepage 'https://github.com/alonbl/gnupg-pkcs11-scd'
  @_ver = '0.9.2'
  version @_ver + '-1'
  compatibility 'all'
  source_url "https://github.com/alonbl/gnupg-pkcs11-scd/archive/gnupg-pkcs11-scd-#{@_ver}.tar.gz"
  source_sha256 '3c77ad9f412403f2e3c7376029bb6382eb1721549df8617cfcec581e83a78e7a'


  depends_on 'openssl'
  depends_on 'libassuan'
  depends_on 'libgpgerror'
  depends_on 'libgcrypt'
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
                --disable-proxy \
                --with-libgpg-error-prefix='#{CREW_PREFIX}' \
                --with-libassuan-prefix='#{CREW_PREFIX}' \
                --with-libgcrypt-prefix='#{CREW_PREFIX}' \
                CFLAGS='-flto=auto' \
                CXXFLAGS='-flto=auto'"
      system "make"
    end
  end
  

  def self.check
    Dir.chdir('build') do
      system 'make check'
    end
  end
  

  def self.install
    Dir.chdir('build') do
        system "make DESTDIR=#{CREW_DEST_DIR} install"
    end
  end
end
