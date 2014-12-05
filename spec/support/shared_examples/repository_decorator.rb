shared_examples_for :repository_decorator do
  it 'delegates to its component' do
    repository = double('repository', path: 'expected path')

    decorated = decorate(repository)

    expect(decorated).to be_a(SimpleDelegator)
    expect(decorated.path).to eq('expected path')
  end
end
