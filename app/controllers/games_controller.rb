class GamesController < ApplicationController


  def new
    alphabets = ('A'..'Z').to_a
    letters = Array.new(10) { alphabets.sample }
    @letters = letters
  end

  def score
    @letters = JSON.parse(params[:letters])
    @answer = params[:word].upcase

    letters_copy = @letters.tally

    @valid = @answer.chars.all? do |char|
      if letters_copy[char].to_i > 0
        letters_copy[char] -= 1
        true
      else
        false
      end
    end

    if @valid
      response = URI.parse("https://dictionary.lewagon.com/#{@letters.join}")
      all_words = JSON.parse(response.read)

      max_length = all_words.map(&:length).max
      @longest_words = all_words.select { |w| w.length == max_length }

      @is_longest = @longest_words.include?(@answer)
    else
      @is_longest = false
      @longest_words = []
    end
  end
end
