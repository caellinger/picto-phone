require 'faraday'

class WordnikParser
  attr_reader :data

  def initialize
    @data = []
  end

  def search(query)
    response = Faraday.get("https://api.wordnik.com/v4/words.json/randomWord?hasDictionaryDef=true&includePartOfSpeech=noun%2Cverb-intransitive&minCorpusCount=100000&maxCorpusCount=-1&minDictionaryCount=1&maxDictionaryCount=-1&minLength=5&maxLength=-1&api_key=#{WORDNIK_API_KEY}")
  end
end
