require 'minitest/autorun'
require_relative '../scraper.rb'
require 'pp'


class ScraperTest < Minitest::Test
  def test_thumbnail
    numbas_thumblink('https://weh.maritime.edu/mechanics/mastery/packages/question-43986-frame-a-frame-difficulty-1/')
  end
end
