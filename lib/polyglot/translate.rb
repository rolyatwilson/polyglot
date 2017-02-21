module Polyglot
  class Translate
    attr_reader :url, :token, :targets

    def initialize(args = {})
      @url = 'https://translation.googleapis.com/language/translate/v2'
      @token = 'GCLOUD-ACCESS-TOKEN'
      parse_targets(args)
    end

    def parse_targets(args = {})
      t = args[:targets]
      @targets = t ? supported_languages & t : supported_languages
      abort 'Unsupported language target!' if targets.empty?
      targets
    end

    def translate(args = {})
      results = {}
      names = args.fetch(:names)
      targets.each do |target|
        results[target] = []
        c_index = 0
        offset = 20

        while true do
          bound = c_index + offset - 1
          name_chunk = args.fetch(:names)[c_index..bound]
          text_chunk = args.fetch(:texts)[c_index..bound]
          break if text_chunk.nil? || text_chunk.empty?
          data = request_translation(names: name_chunk, texts: text_chunk, target: target)
          translations = data[:data][:translations]

          t_index = c_index
          translations.each do |t|
            results[target] << { name: names[t_index], text: t[:translatedText] }
            t_index += 1
          end

          c_index += offset
          break if c_index >= names.length
        end
      end
      results
    end

    def request_translation(args = {})
      uri = URI.parse(url)
      request = Net::HTTP::Post.new(uri)
      request['Authorization'] = "Bearer #{token}"
      request.content_type = 'application/json'
      request.body = json_request(args)
      req_options = { use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_NONE }
      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end
      raise "Request failed: #{response.code} #{response.body}" unless response.code == '200'
      data = JSON.parse(response.body)
      data.deep_symbolize_keys!
    end

    def json_request(args = {})
      { q:      args.fetch(:texts),
        source: 'en',
        target: args.fetch(:target),
        format: 'text' }.to_json
    end

    def supported_languages
      @languages ||= [
        'af',
        'ar',
        'az',
        'be',
        'bg',
        'bn',
        'ca',
        'cs',
        'cy',
        'da',
        'de',
        'el',
        'eo',
        'es',
        'et',
        'eu',
        'fa',
        'fi',
        'fr',
        'ga',
        'gl',
        'gu',
        'hi',
        'hr',
        'ht',
        'hu',
        'hy',
        'id',
        'it',
        'iw',
        'ja',
        'ka',
        'kn',
        'ko',
        'la',
        'lt',
        'lv',
        'mk',
        'mi',
        'ms',
        'mt',
        'nl',
        'no',
        'pl',
        'pt',
        'ro',
        'ru',
        'sk',
        'sl',
        'sq',
        'sr',
        'sv',
        'sw',
        'sv',
        'ta',
        'te',
        'th',
        'tl',
        'tr',
        'uk',
        'ur',
        'vi',
        'yi',
        'zh-CN',
        'zh-TW'
      ]
    end
  end
end
