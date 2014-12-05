module Gitolite
  # Decorates a base shell to provide the given SSH identity in a file called
  # $IDENTITY_FILE.
  #
  # During any executed commands, $IDENTITY_FILE variable will contain the path
  # to a file containing $IDENTITY. The file will be removed after the command
  # is executed.
  class IdentifiedShell
    TEMPFILE_PREFIX = 'identity'

    pattr_initialize :component, :identity

    def execute(*args)
      with_identity_file do |path|
        ClimateControl.modify 'IDENTITY_FILE' => path do
          component.execute(*args)
        end
      end
    end

    private

    def with_identity_file
      with_temp_file Tempfile.new(TEMPFILE_PREFIX) do |file|
        file.write(identity)
        file.flush
        yield file.path
      end
    end

    def with_temp_file(file)
      yield file
    ensure
      file.unlink
    end
  end
end
