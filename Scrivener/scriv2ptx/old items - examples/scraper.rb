require 'nokogiri'
require 'watir' #loads a chrome browser we can control like a user.
require 'RMagick'
#
class Scraper
  attr_accessor :browser, :thumb_name
#
# This program uses Watir to open a pretext webpage containing a Numbas file, with a chrome browser,
# then extract the problem statement.
# Basically an experiment to see if I can extract numbas content to use to make the pdf version for
# use by pretext
# 2/12/19
#
  def initialize(uri)
    @thumb_name = "numbas-#{uri.match(/question-\d*/)}"
    @browser = Watir::Browser.new
    @browser.window.resize_to 1000, 1028
    @browser.goto uri
    sleep(8) #wait for geogebra applet to load
  end

  def write_contents
    @browser.button(id: 'revealBtn').click # clicks the reveal answer button
    sleep(1)
    puts @browser.button(xpath: "//div[@id='confirm-modal']//button[@class='ok btn btn-primary']").click
    #clicks the ok button
    sleep(1)
    @page = @browser.div(id: "questionDisplay").inner_html #grab some html.
    sleep(1)
    File.write('/Users/whaynes/Numbas/themes/export-numbas.html', @page)
  end




  def close
    @browser.close
  end
end

def numbas_thumblink(uri)
  #given an uri to a numbas question, open the page, screenshots it, shrinks and saves 200x256 .png thumbnail
  thumb_name = "numbas-#{uri.match(/question-\d*/)}-thumb.png"
  browser = Watir::Browser.new
  browser.window.resize_to 1000, 1280
  browser.goto uri
  sleep(8) #wait for geogebra applet to load
  img = Magick::Image.from_blob(browser.screenshot.png).first
  browser.close

  img.scale!(0.2)
  #scaled image may be too short, so put it on a white canvas
  bg = Magick::Image.new(200,256)
  thumb = bg.composite(img,0,0,Magick::AtopCompositeOp)
  #thumb.display
  thumb.write thumb_name
end