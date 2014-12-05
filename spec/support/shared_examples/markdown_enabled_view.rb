shared_examples_for :markdown_enabled_view do
  it 'renders text in markdown format' do
    markdown = '*hello*'

    render_markdown(markdown)

    expect(rendered).to have_selector('em', text: 'hello')
  end
end
