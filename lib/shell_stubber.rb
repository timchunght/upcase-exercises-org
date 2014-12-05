class ShellStubber
  VALID_FINGERPRINT = %w(
    2048
    d4:58:a1:cb:14:94:77:cf:e9:f4:b1:ac:2e:48:05:d2
    user@example.com
    (RSA)
  ).join(' ')

  pattr_initialize :stubs

  def clone_gitolite_admin_repo
    stubs.add(%r{git clone [^ ]+gitolite-admin\.git}) do
      FileUtils.mkdir_p('conf')
    end
    self
  end

  def head_sha(sha = 'abcdef1234567890abcdef1234567890abcdef10')
    stubs.add(%r{git rev-parse HEAD}) { sha }
    self
  end

  def diff(diff = 'diff example.txt')
    stubs.add(%r{git diff}) { diff }
    self
  end

  def fingerprint(fingerprint = VALID_FINGERPRINT)
    stubs.add(%r{ssh-keygen -lf .*}) { fingerprint }
    self
  end

  def raise_for_invalid_fork
    stubs.add(%r{(ssh git@.* fork sources/[^ ]+ /.*)}) do |command|
      raise "Attempted to fork exercise without a username:\n#{command}"
    end
    self
  end
end
