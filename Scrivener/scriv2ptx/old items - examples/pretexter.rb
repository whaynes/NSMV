#! /usr/bin/env ruby
#
require 'Nokogiri'

class Pretexter
  attr_accessor :doc


  def initialize(xml)
    begin
      @doc = Nokogiri::XML(xml) # {|config| config.strict}
    rescue Nokogiri::XML::SyntaxError => e
      puts "Exception while reading #{xml}: #{e}"
      raise e
    end
    paragraphs = @doc.search('p')
    paragraphs.each do |para|
      para = para.child unless para.element? #extract para from fragments
      para.replace to_ptx(para)
    end
    def to_xml
      @doc.to_xml
    end
  end

  def to_ptx(n)
    s = n.to_s
    s.gsub!(/\[(.*?)\]\((.*?)\)/, '<url href=\'\2\'>\1</url>')  # markdown style links
    s.gsub!(/([ >])pretext([. <])/i,'\1<pretext/>\2' )  #replace pretext with <pretext/>
    s.gsub!('--','<mdash/>') ## markdown style em dash.
    s.gsub!('xml:id=""', 'xml:id="XML:ID_REQUIRED"')
    node = Nokogiri::XML.fragment(s)
    return node.child
  end

end

source = File.read(ARGV[0])
ptx_fn = File.basename(ARGV[0], '.*') + '.ptx'
ptx_doc = Pretexter.new(source).to_xml
File.write(ptx_fn, ptx_doc)
#`make basic`
# system %{open "#{ptx_fn}"}