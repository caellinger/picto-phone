class GetPrompt
  def call_api
    url = "https://api.wordnik.com/v4/words.json/randomWord?hasDictionaryDef=true&includePartOfSpeech=noun%2Cverb-intransitive&minCorpusCount=150000&maxCorpusCount=-1&minDictionaryCount=1&maxDictionaryCount=-1&minLength=5&maxLength=-1&api_key=#{ENV["WORDNIK_API_KEY"]}"
    response = Faraday.get(url)

    parsed_response = JSON.parse(response.body)
    return parsed_response["word"]
  end
end
