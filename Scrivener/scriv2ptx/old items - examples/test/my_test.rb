require 'minitest/autorun'
require_relative '../markdownify.rb'
require 'pp'


class MyTest < Minitest::Test

  def setup
    @markdown = <<~INPUT
      <p>
      * ul line <c>one</c>
         more
      * ul line two
      </p>
    INPUT

    @doc = <<~INPUT
      <doc>
      <p>

      * ul line <c>one</c>

        more

      * ul line twO
      </p>
      </doc>
    INPUT

    ARGV[0] = 'test/ScrivStatics.xml'
    @ptx = Markdownify.new(File.read(ARGV[0]))
  end

  def test_nothing
    p = Nokogiri::XML.fragment("").child
    assert_raises RuntimeError do
      mmd(p).to_html
    end
  end

  def test_empty_paragraph
    p = Nokogiri::XML.fragment("<p></p>").child
    assert_equal("<p>\n</p>", mmd(p).to_html)
  end

  def test_simple_case
    p = Nokogiri::XML.fragment("<p>ab _de_ fg</p>").child
    assert_equal("<p>ab <em>de</em> fg</p>\n", mmd(p).to_html)
  end

  def test_bold
    p = Nokogiri::XML.fragment("<p>Notes **regarding** scrivener-<b>pretext</b></p>").child
    assert_equal("<p>Notes <strong>regarding</strong> scrivener-<b>pretext</b></p>\n", mmd(p).to_html)
  end

  def test_mmd_false
    p = Nokogiri::XML.fragment("<p mmd='false'>ab _de_ fg</p>").child
    assert_equal("<p>ab _de_ fg</p>", mmd(p).to_html)
  end


  def test_ordered_list
    html = <<~EXPECTATION
      <p><ul>
      <li>ul line <c>one</c>
      more</li>
      <li>ul line two</li>
      </ul>
      </p>
    EXPECTATION
    p = Nokogiri::XML.fragment(@markdown).child
    assert_equal(html.strip, mmd(p).to_html)
  end

  def test_validate_gives_no_errors
    v = validate(@ptx.doc)
    assert_equal(0,v.length)
  end

  def test_command_line_file
    puts @ptx.doc
  end
end
