module Polyglot
  class AndroidParser
    attr :input_file

    def initialize(args = {})
      @input_file = args.fetch(:file)
    end

    def parse
      names = []
      texts = []
      xml_doc = Nokogiri::XML(File.open(input_file))
      nodes = xml_doc.xpath('//string')
      nodes.each do |node|
        names << node.attr('name')
        texts << node.text
      end
      { names: names, texts: texts }
    end
  end
end
