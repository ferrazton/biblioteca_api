require "net/http"
require "json"
require "uri"

class OpenLibraryClient

    ENDPOINT = "https://openlibrary.org/api/books"

    def self.fetch_book_by_isbn(isbn)
        return {} if isbn.to_s.strip.empty?

        uri = URI(ENDPOINT)
        params = { "bibkeys" => "ISBN:#{isbn}", "format" => "json", "jscmd" => "data" }
        uri.query = URI.encode_www_form(params)

        response = Net::HTTP.get_response(uri)
        Rails.logger.info("[OpenLibrary] GET #{uri} -> #{response.code}")
        return {} unless response.is_a?(Net::HTTPSuccess)

        body = response.body
        Rails.logger.info("[OpenLibrary] body length=#{body&.bytesize}")
        json = JSON.parse(body) rescue {}
        book = json["ISBN:#{isbn}"] || {}
        Rails.logger.info("[OpenLibrary] parsed keys=#{book.keys}")

        title = book["title"]
        pages = book["number_of_pages"]

        if pages.nil? && book["pagination"].is_a?(String)
            if (m = book["pagination"].match(/\b(\d{1,5})\b/))
                pages = m[1].to_i
            end
        end

        result = {}
        result[:title] = title if title
        result[:pages] = pages if pages
        result
        rescue StandardError => e
        Rails.logger.warn("[OpenLibrary] error: #{e.class}: #{e.message}")
        {}
    end
end
