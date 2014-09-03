require 'kconv'
require 'fileutils'
require 'rexml/document'

class String
  def to_snake
    ptn = /[A-Z\s]*[^A-Z]*/
    self =~ ptn ? self.scan(ptn).map{|i|
      i.gsub(/[\s:]+/,'_').downcase
    }.join('_').gsub(/__+/,'_').sub(/_$/,'') : self
  end
  def to_camel
    self.split(/[_\s]+/).map{|i|
      a,b,c = i.split(/^(.)/)
      "#{b.upcase}#{c}"
    }.join('')
  end
  def to_scamel
  	s = self.to_camel
  	s[0].downcase + s[1..-1]
  end
end

module EntryCreater
	class Core
		def create(storyborad, to)
			to = File.dirname(storyborad) unless to
			@xml = REXML::Document.new(open(storyborad))
			@objects = @xml.get_elements('document/scenes/scene/objects')
			@viewControllers = @objects.map{ |o|
				e = o.elements[1]
				cs = e.get_elements('connections')
				cc = e.attribute("customClass")
				{
					"name" => e.name,
					"customClass" => (cc ? cc.value : nil),
					"id" => e.attribute("id").value,
					"connections" => (cs.empty? ? [] : cs[0].get_elements('segue').map{|s|
															d = s.attribute('destination')
															i = s.attribute('identifier')
															{
																:destination => d ? d.value : nil,
																:identifier => i ? i.value : nil,
															}
					}),
				}
			}
			@connections = @viewControllers.map { |c|
				[c["connections"].map{|connect| connect.merge({:controller => c,}) }]
			}.flatten.select { |c|
				c[:identifier]
			}.map { |connect|
				connect.merge({ :destinationViewController => @viewControllers.find {|c| c["id"] == connect[:destination]} })
			}
			@file_name = File.basename(storyborad, ".*")
			@header = interface(@file_name, @connections)
			@implementation = implemente(@file_name, @connections)

    	FileUtils.mkdir_p(to) unless FileTest.exist?(to)
			File.write( File.expand_path("_#{@file_name}Entry.h", to), @header)
			File.write( File.expand_path("_#{@file_name}Entry.m", to), @implementation)
			custom_header_name = File.expand_path("#{@file_name}Entry.h", to)
			File.write( custom_header_name, custom_header(@file_name)) unless FileTest.exist?(custom_header_name)
			custom_implementation_name = File.expand_path("#{@file_name}Entry.m", to)
			File.write( custom_implementation_name, custom_implementation(@file_name)) unless FileTest.exist?(custom_implementation_name)
		end
		def interface(file_name, connections)
			"@interface #{file_name}Entry : AKUStoryboardEntry\n" + connections.inject(""){|s, connect| 
					s + "#{method_name(connect)};\n"
				} + "@end\n"
		end
		def implemente(file_name, connections)
			"\#import \"#{file_name}Entry.h\"\n\n@implementation #{file_name}Entry {\n}\n+ (NSString *)storyboardName {\n    return @\"#{file_name}\";\n}\n" + connections.inject(""){|s, connect|
				s + "\n#{method_name(connect)} {\n    [self performSegueWithIdentifier:@\"#{connect[:identifier]}\" block:block];\n}\n"
			} + "@end\n"
		end
		def method_name(c)
			"- (void)#{c[:identifier].to_scamel}:(#{c[:controller]["customClass"]} *)controller block:(void(^)(#{c[:destinationViewController]["customClass"]} *))block"
		end
		def custom_header(file_name)
			"#import \"_#{file_name}Entry.h\"\n\n@interface #{file_name}Entry : _#{file_name}Entry {}\n// Custom logic goes here.\n@end\n"
		end
		def custom_implementation(file_name)
			"#import \"#{file_name}Entry.h\"\n\n\n@interface #{file_name}Entry ()\n\n// Private interface goes here.\n\n@end\n\n\n@implementation #{file_name}Entry\n\n// Custom logic goes here.\n\n@end\n"
		end
	end
end
