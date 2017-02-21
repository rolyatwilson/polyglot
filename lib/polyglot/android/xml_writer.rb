module Polyglot
  class XMLWriter
    attr_reader :base_path

    def initialize(args = {})
      @base_path = args.fetch(:base_path)
    end

    def write(data)
      data.each do |target, translations|
        template = File.read(File.join(__dir__, 'xml_writer.mustache'))
        rendered_xml = Mustache.render(template, translations: translations)
        target_dir = File.join(base_path, 'translations', "values-#{target}")
        FileUtils.mkdir_p(target_dir)
        File.write(File.join(target_dir, 'strings.xml'), rendered_xml)
      end
    end
  end
end
