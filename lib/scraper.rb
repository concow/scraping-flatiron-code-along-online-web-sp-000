require 'nokogiri'
require 'open-uri'
# requiring our Course class file so that our Scraper can make new courses and give them attributes scraped from the web page.
require_relative './course.rb'

class Scraper

  def get_page
    Nokogiri::HTML(open("http://learn-co-curriculum.github.io/site-for-scraping/courses"))
  end
  #operates on HTML page (return value of get_page) then returns the collection of Nokogiri XML elements that describe each course
  def get_courses
    self.get_page.css(".post")
  end
  #operates on the collection of course offering Nokogiri XML elements that was returned by the .get_courses method
  def make_courses
    self.get_courses.each do |post|                   #iterate over the collection
      course = Course.new                             #new course instance
      course.title = post.css("h2").text              #The title of an individual course offering
      course.schedule = post.css(".date").text        #The schedule of an individual course offering
      course.description = post.css("p").text         #The description of an individual course offering
    end
  end

  def print_courses
    self.make_courses
    Course.all.each do |course|
      if course.title && course.title != ""
        puts "Title: #{course.title}"
        puts "  Schedule: #{course.schedule}"
        puts "  Description: #{course.description}"
      end
    end
  end

end

Scraper.new.print_courses                     #prints out to your terminal
