require 'spec_helper'

describe Git::DiffFile do
  describe '#blank?' do
    context 'before adding a line' do
      it 'returns true' do
        file = build_file
        file.append_changed 'line'

        expect(file).not_to be_blank
      end
    end

    context 'after adding a line' do
      it 'returns false' do
        file = build_file

        expect(file).to be_blank
      end
    end
  end

  describe '#name' do
    it 'returns its assigned name' do
      file = build_file

      file.name = 'expected name'

      expect(file.name).to eq('expected name')
    end
  end

  describe '#append_changed' do
    it 'appends an changed line to its buffer' do
      file = build_file

      file.append_changed 'one'
      file.append_changed 'two'
      file.append_changed 'three'

      expect(file.each_line.map(&:to_s)).to eq(%w(+one +two +three))
    end

    it 'sets the line number when appending lines' do
      file = build_file

      file.append_changed 'one'
      file.append_changed 'two'
      file.append_changed 'three'

      expect(file.each_line.map(&:number)).to eq [1, 2, 3]
    end
  end

  describe '#each_line' do
    it 'limits the number of added lines' do
      file = build_file(2)

      file.append_unchanged 'one'
      file.append_changed 'two'
      file.append_unchanged 'three'

      expect(file.each_line.map(&:to_s)).to eq([' one', '+two'])
    end
  end

  describe '#append_unchanged' do
    it 'appends an unchanged line to its buffer' do
      file = build_file

      file.append_unchanged 'one'
      file.append_unchanged 'two'
      file.append_unchanged 'three'

      expect(file.each_line.map(&:to_s)).to eq([' one', ' two', ' three'])
    end

    it 'sets the line number when appending lines' do
      file = build_file

      file.append_changed 'one'
      file.append_changed 'two'
      file.append_changed 'three'

      expect(file.each_line.map(&:number)).to eq [1, 2, 3]
    end
  end

  def build_file(limit = 100)
    Git::DiffFile.new(Git::DiffLine, limit)
  end
end
