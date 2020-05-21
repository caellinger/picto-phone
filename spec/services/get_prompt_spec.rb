require 'rails_helper'

describe GetPrompt do
  describe '#call_api' do
    it 'calls the wordnik api and returns a word' do
      VCR.use_cassette('get_prompt_from_API') do
        word = GetPrompt.new.call_api

        expect(word).not_to be_nil
      end
    end
  end
end
