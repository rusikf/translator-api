# frozen_string_literal: true

require 'csv'

class LanguageCodes
  def valid_code?(abbreviation)
    language_codes.any? { |code| code[:code] == abbreviation }
  end

  private

  def parse_codes
    csv_content = CSV.read('language-codes.csv')
    csv_content.shift
    csv_content.map do |csv_row|
      { code: csv_row[0], country: csv_row[1] }
    end
  end

  def language_codes
    @language_codes ||= parse_codes
  end
end

LANGUAGE_CODES_BUILDER = LanguageCodes.new
