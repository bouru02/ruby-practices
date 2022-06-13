# frozen_string_literal: true

require 'optparse'

def main
  param = {}
  param[:options] = {}
  opts = OptionParser.new
  opts.on('-l') { |_v| param[:options][:l] = true }
  opts.parse!(ARGV)

  param[:files] = []

  ARGV.each do |option|
    param[:files] << option if option != /^-[a-zA-Z]+/
  end

  wc = WC.new(**param)
  wc.output_wc_results
end

class WC
  def initialize(param)
    @options = param[:options]
    @strings = obtain_target_strings(param[:files])
    @outputs = {}
    @outputs[:lines] = @strings.map(&:length)
    unless @options[:l]
      @outputs[:words] = []
      @strings.each do |string|
        @outputs[:words] << string.map do |line|
          line.split(/[\s　]+/).length
        end.sum
      end
      @outputs[:bytesizes] = obtain_bytesizes(param[:files])
    end
    @outputs[:target_files] = param[:files]

    return if @outputs[:target_files].size <= 1

    @outputs[:lines] << @outputs[:lines].sum
    @outputs[:words] << @outputs[:words].sum
    @outputs[:bytesizes] << @outputs[:bytesizes].sum
    @outputs[:target_files] << 'total'
  end

  def output_wc_results
    if @outputs[:target_files].empty?
      puts @outputs.values.join(' ')
    else
      formatted_outputs = @outputs.values.map.with_index do |string, i|
        # 最後の列（ファイル名）以外は右揃えにする
        i == @outputs.size - 1 ? string : fit_to_longest_item(string, right_aligned: true)
      end.transpose
      formatted_outputs.each { |item| puts item.join(' ') }
    end
  end

  private

  def obtain_target_strings(files)
    return [$stdin.readlines] if files.empty?

    files.map do |file|
      File.new(file).readlines
    end
  end

  def obtain_bytesizes(files)
    if files.empty?
      @strings.map do |string|
        string.join.bytesize
      end
    else
      files.map do |file|
        File.size(file)
      end
    end
  end

  # 配列の各要素の長さを最大の要素の幅に合わせる（短い要素の末尾に半角スペースを追加する）
  # 引数：配列
  # 戻り値：最長の要素に合わせて各要素に半角スペースを追加した配列
  def fit_to_longest_item(items, right_aligned: false)
    longest_length = items.max_by { |item| item.to_s.length }.to_s.length
    items.map do |item|
      space_count = longest_length - item.to_s.length
      if space_count.positive?
        if right_aligned
          item.to_s.rjust(longest_length)
        else
          item.to_s.ljust(longest_length)
        end
      else
        item
      end
    end
  end
end

main
