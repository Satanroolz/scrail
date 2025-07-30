class Page < ApplicationRecord
  has_many :results

  validates :url, presence: true
  validates :check_type, presence: true
  validates :selector, presence: true
  # validates :match_text, presence: {if: check_text?}
  validates :match_text, presence: {if: ->{ check_type == "text" }}

  # def check_text?
  #   check_type == "text"
  # end
  
  def run_check!
    scraper = Scraper.new(url)
    result = case check_type
             when "text"
               scraper.text(selector: selector).downcase == match_text.downcase
             when "presence"
               scraper.present?(selector: selector)
             end
    results.create(success: result)
  end
end
