# frozen_string_literal: true

require 'pp'

def ls
  items = []
  Dir.foreach('.') do |dir_item|
    next if /^\./.match?(dir_item)

    items << dir_item
  end

  puts '~~~~~~~~~~~~~~~~~~'
  formatted_items = format_array(items).transpose

  formatted_items.each do |item|
    p item
    item.join(' ')
    puts item
  end
end

def format_array(original_array, row: 4)
  format_items = []
  column_items = []
  original_array.map.with_index(1) do |item, i|
    column_items << item
    if (i % row).zero?
      format_items << column_items
      column_items = []
    elsif i == original_array.size
      (row - column_items.size).times { column_items << '' }
      format_items << column_items
    end
  end
  # p format_items
  format_items
end

ls
