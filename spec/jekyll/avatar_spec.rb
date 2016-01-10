require 'spec_helper'

describe Jekyll::Avatar do
  let(:doc) { doc_with_content(content) }
  let(:username) { 'hubot' }
  let(:args) { '' }
  let(:text) { "#{username} #{args}".squeeze(' ') }
  let(:content) { "{% avatar #{text} %}" }
  let(:rendered) { subject.render(nil) }
  let(:output) do
    doc.content = content
    doc.output  = Jekyll::Renderer.new(doc.site, doc).run
  end
  subject { Jekyll::Avatar.send(:new, 'avatar', text, nil) }

  it 'has a version number' do
    expect(Jekyll::Avatar::VERSION).not_to be nil
  end

  it 'outputs the HTML' do
    expected =  '<img class="avatar avatar-small" '
    expected << 'src="https://avatars3.githubusercontent.com/'
    expected << 'hubot?v=3&amp;s=40" alt="hubot" width="40" height="40" />'
    expect(rendered)
    expect(output).to eql("<p>#{expected}</p>\n")
  end

  it 'parses the username' do
    expect(subject.send(:username)).to eql('hubot')
  end

  it 'determines the server number' do
    expect(subject.send(:server_number)).to eql(3)
  end

  it 'builds the host' do
    expect(subject.send(:host)).to eql('avatars3.githubusercontent.com')
  end

  it 'builds the path' do
    expect(subject.send(:path)).to eql('hubot?v=3&s=40')
  end

  it 'defaults to the default size' do
    expect(subject.send(:size)).to eql(40)
  end

  it 'builds the URL' do
    expected = 'https://avatars3.githubusercontent.com/hubot?v=3&s=40'
    expect(subject.send(:url)).to eql(expected)
  end

  context 'when passed @hubot as a username' do
    let(:username) { '@hubot' }

    it 'parses the username' do
      expect(subject.send(:username)).to eql('hubot')
    end
  end

  context 'with a size is passed' do
    let(:args) { 'size=45' }

    it "parses the user's requested size" do
      expect(subject.send(:size)).to eql(45)
    end
  end

  context 'with a size < 48' do
    it 'includes the avatar-small class' do
      expect(rendered).to match(/avatar-small/)
    end
  end

  context 'with a size > 48' do
    let(:args) { 'size=80' }

    it "doesn't include the avatar-small class" do
      expect(rendered).to_not match(/avatar-small/)
    end
  end
end
