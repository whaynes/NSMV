#! /usr/bin/env ruby
#
require 'Nokogiri'
require 'rmultimarkdown'
require 'pp'

# This program is written for Scriv2ptx-experiment, it:
#
# 1.  reads a pretext source file e.g. fn.xml (see pretextbook.org) from the command line
# 2.  applies multimarkdown to the contents of all <p> elements except <p mmd='false'> elements.
# 3.  strips out the bogus mmd='false' attribute
# 4.  returns the resulting document as fn.ptx
# 5.  There's no guarantee the resulting file is valid.

class Markdownify
  attr_accessor :doc

  def initialize(xml)
    begin
      @doc = Nokogiri::XML(xml) # {|config| config.strict}
    rescue Nokogiri::XML::SyntaxError => e
      puts "Exception while reading #{xml}: #{e}"
      raise e
    end
    paragraphs = @doc.search('//p')
    paragraphs.each do |p|
      p = p.child unless p.element? #extract para from fragments
      p.replace mmd(p)
    end
  end

  def to_ptx
    s = @doc.to_xml.to_s
    s.gsub!('<a href', '<url href')
    s.gsub!('</a>', '</url>')
    s.gsub!(/([ >])pretext([. <])/i, '\1<pretext/>\2')  #replace pretext with <pretext/>
    s.gsub!('strong>', 'em>')
    s.gsub!(/<li>(.*\n\n<[ou]l>)/,"\r" + '<li><p>\1')
    s.gsub!(/(<\/[uo]l>)<\/li>/,'\1</p></li>')
    return s
  end

end

def mmd(para)
  # Applies multimarkdown to paragraph node and returns result
  raise 'mmd: empty paragraph' if para.nil?
  if para[:mmd]  # apply mmd if mmd attribut exists
    para
  else
    contents = para.children # remove p wrapper from scrivener.
    markdown = MultiMarkdown.new(contents.to_html, 'snippet').to_html
    markdown = Nokogiri::XML.fragment(markdown)
    if markdown.child.name == 'p' #single lines get wrapped with <p> by markdown
      return markdown
    else
      p = Nokogiri::XML.fragment('<p/>') #lists need a p wrapper
      p.child.add_child(markdown)
      return p
    end
  end
end



def validate(doc)
  schema_path = '/Users/whaynes/ptx/mathbook/schema/pretext.rng'
  schema = Nokogiri::XML::RelaxNG(File.open(schema_path)) {|config| config.xinclude}
  errors = schema.validate doc
  errors.each {|e| puts e}
  errors
end


source = File.read(ARGV[0])
ptx_fn = File.basename(ARGV[0], '.*') + '.ptx'
ptx_doc = Markdownify.new(source).to_ptx
File.write(ptx_fn, ptx_doc)
`make basic`
# system %{open "#{ptx_fn}"}