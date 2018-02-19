require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ("a".."z").to_a.sample
    end
  end

  def score

    word = params[:word]
    letters = params[:letters].split("")
    answer = word.split("")
    answer_frequencies = {}
    letter_frequencies = {}

    answer.each do |letter|
      if answer_frequencies.key?(letter)
        answer_frequencies[letter] += 1
      else
        answer_frequencies[letter] = 1
      end
    end

    letters.each do |letter|
      if letter_frequencies.key?(letter)
        letter_frequencies[letter] += 1
      else
        letter_frequencies[letter] = 1
      end
    end


    answer_frequencies.each do |letter, frequency|
      if letter_frequencies[letter].nil? || (letter_frequencies[letter] < frequency)

        @output = "Sorry but #{word} can't be build with #{letters.join}"
      else
        url = "https://wagon-dictionary.herokuapp.com/#{word}"
        results_serialized = open(url).read
        results = JSON.parse(results_serialized)
        if
          results['found'] == false
          @output = "Sorry but #{word} does not seem to be an English word"
         elsif
          results['found'] == true
          @output = "Congratulations! #{word} is a valid English word!"
        end
      end
    end
  end
end
