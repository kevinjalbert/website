#!/usr/bin/env ruby


# This module contains helper functions to aid in the website generation. The
# functions primarily ease page generation based on existing pages as well as 
# the ability to combine metadata (name and url) into links.
#
# @author Kevin Jabert
module CustomHelper

  # Creates the publications html page based on the existing publication
  #
  # Each publication page is either of a poster or paper type, and occurred
  # within a certain year. The publications page takes these parameters into
  # account while generating the list pf publications, which ensures that the
  # list is organized into years and types.
  #
  # @param [Item] parent_item the item that represents the publications page
  # @param [String] type the type of list to create (paper or poster)
  # @return [String] the html of the generated publication list for given type
  def create_sorted_publications(parent_item, type)
    completed_years = []
    final_output = ""
    
    # Keep looping till all publication year lists are constructed
    while true do
      
      current_year = 0
      
      # Find the highest year not yet completed
      parent_item.children.each do | child |
        if child[:year] > current_year
          if completed_years.index(child[:year]) == nil
            current_year = child[:year]
          end
        end     
      end

      # Ending condition (when no highest year is found)
      if current_year == 0
        break
      end
      
      # Create list of children that is of the current year and correct type
      empty = true      
      output = "<h2>#{current_year}</h2><ul>"
      
      parent_item.children.each do | child |
        if child[:year] == current_year && child[:type] == type
          empty = false
          output += "<li>#{child[:authors]}. <u>" + link_to("\"" + child[:longtitle] + "\"" , child.reps[0].path) + "</u>, <i>#{child[:booktitle]}</i>, "
          if type != 'poster'
            output += "#{child[:pages]}, "
          end
          
          output += "#{child[:location]}, #{child[:month]} #{child[:year]}.</li>"
        end
      end
      
      output += "</ul>"
      
      # If there was publications in the current year 
      if empty == false
        final_output += output
      end
      
      completed_years << current_year
    end
    
    final_output
  end
    
  # This function will combine a CSV list of names and links into an HTML link
  #
  # @param [String] a CSV list of names
  # @param [String] a CSV list of web URLs
  # @return [String] the html of CSV html links corresponding to the given name
  def combine_name_link(names, links)
    # Split up the given names and links into arrays
    allNames = names.split(", ")
    allLinks = links.split(", ")

    # Form html links (will create mailto:<email> if an @ symbol is used)
    output = "" 
    for i in 0..allNames.length-1 do
      if (allLinks[i].index('@') != nil)
        output += "<a href=\"mailto:" + allLinks[i] + "\">" + allNames[i] + "</a>, "
      else
        output += "<a href=\"" + allLinks[i] + "\">" + allNames[i] + "</a>, "
      end
    end
    
    output = output[0..-3]
  end
end
