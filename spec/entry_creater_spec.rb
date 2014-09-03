require './lib/entryCreater'
require 'fileutils'

$debug = true

module EntryCreater
	class Core
		attr_reader :xml, :objects, :viewControllers, :connections, :header, :implementation, :file_name
	end
end

describe EntryCreater::Core, "load" do
	let(:core) {EntryCreater::Core.new() }
	shared_context 'create' do
		before do
			core.create("./storyboard/Main.storyboard", "./out")
		end
	end
	describe "xml" do
		include_context 'create'
		let(:xml) { core.xml }
		it(:create) {
			expect(xml).not_to eq ""
		}
		let(:objects) {core.objects}
		it(:count_objects) {
			expect(objects.count).to eq 6
		}
		let(:viewControllers) {core.viewControllers}
		it(:count_viewControllers) {
			expect(viewControllers.count).to eq 6
		}
		it(:has_id_viewControllers) {
			viewControllers.map { |v|
				expect(v["id"]).not_to eq nil
			}
		}
		it(:check_frist) {
			expect(viewControllers[0]).to eq( {"name"=>"tableViewController", "customClass"=>"TableViewController", "id"=>"qKe-kL-ggu", "connections"=>[{:destination=>"8NF-7x-eCV", :identifier=>"C"}]} )
		}
		it(:check_second) {
			expect(viewControllers[1]).to eq( {"name"=>"viewController", "customClass"=>"ViewController", "id"=>"dPf-DS-gFX", "connections"=>[]} )
		}
		it(:check_2) {
			expect(viewControllers[2]).to eq( {"name"=>"navigationController", "customClass"=>nil, "id"=>"W4H-FJ-WP2", "connections"=>[{:destination=>"qKe-kL-ggu", :identifier=>nil}]} )
		}
		it(:check_3) {
			expect(viewControllers[3]).to eq( {"name"=>"viewController", "customClass"=>"CViewController", "id"=>"8NF-7x-eCV", "connections"=>[{:destination=>"73V-H2-uPu", :identifier=>"D"}]} )
		}
		it(:check_4) {
			expect(viewControllers[4]).to eq( {"name"=>"viewController", "customClass"=>"DViewController", "id"=>"73V-H2-uPu", "connections"=>[]} )
		}
		it(:check_5) {
			expect(viewControllers[5]).to eq( {"name"=>"viewController", "customClass"=>"BeyondSegueViewController", "id"=>"Bbu-Ps-kCX", "connections"=>[]} )
		}
	end
	describe(:connections) {
		include_context 'create'
		let(:connections) { core.connections }
		it(:count) {expect(connections.count).to eq 2}
		it(:value) {expect(connections).to eq [
			{:destination=>"8NF-7x-eCV", :identifier=>"C", :destinationViewController=>{"name"=>"viewController", "customClass"=>"CViewController", "id"=>"8NF-7x-eCV", "connections"=>[{:destination=>"73V-H2-uPu", :identifier=>"D"}]},
			:controller=>{"name"=>"tableViewController", "customClass"=>"TableViewController", "id"=>"qKe-kL-ggu", "connections"=>[{:destination=>"8NF-7x-eCV", :identifier=>"C"}]}
			},
			{:destination=>"73V-H2-uPu", :identifier=>"D", :destinationViewController=>{"name"=>"viewController", "customClass"=>"DViewController", "id"=>"73V-H2-uPu", "connections"=>[]},
			:controller=>{"name"=>"viewController", "customClass"=>"CViewController", "id"=>"8NF-7x-eCV", "connections"=>[{:destination=>"73V-H2-uPu", :identifier=>"D"}]},
			},
			]}
	}
	describe(:file_name) {
		include_context 'create'
		let(:file_name) { core.file_name }
		it(:file_name) { expect(file_name).to eq "Main" }
	}
	describe(:header) {
		include_context 'create'
		let(:header) { core.header }
		let(:expected) { File.read("storyboard/_MainEntry.h")}
		it(:header) { expect(header).to eq expected }
	}
	describe(:implementation) {
		include_context 'create'
		let(:implementation) { core.implementation }
		let(:expected) { File.read("storyboard/_MainEntry.m")}
		it(:implementation) { expect(implementation).to eq expected }
	}
	describe(:read_header) {
		include_context 'create'
		let(:read_header) { File.read("out/_MainEntry.h") }
		let(:expected) { File.read("storyboard/_MainEntry.h")}
		it(:read_header) { expect(read_header).to eq expected }
	}
	describe(:read_implementation) {
		include_context 'create'
		let(:read_implementation) { File.read("out/_MainEntry.m")}
		let(:expected) { File.read("storyboard/_MainEntry.m")}
		it(:read_implementation) { expect(read_implementation).to eq expected }
	}
	describe(:create_header) {
		include_context 'create'
		let(:read_header) { File.read("out/MainEntry.h") }
		let(:expected) { File.read("storyboard/MainEntry.h")}
		it(:read_header) { expect(read_header).to eq expected }
	}
	describe(:read_implementation) {
		include_context 'create'
		let(:read_implementation) { File.read("out/MainEntry.m")}
		let(:expected) { File.read("storyboard/MainEntry.m")}
		it(:read_implementation) { expect(read_implementation).to eq expected }
	}
end
