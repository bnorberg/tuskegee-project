require 'rubygems'
require 'csv'
require 'geocoder'
require 'openssl'

class Geolocator

		def initiate
			Geocoder.configure(api_key: 'add google api key', use_https: true, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE)
			read_csv
		end	


		def read_csv
			file = ARGV[0]
			@location_csv = ARGV[1]
			CSV.foreach(file, headers:true) do |record|
				puts record
				puts '--------------'
				if !record['City'].nil?
					place = "#{record['City']}, #{record['Country']}"
				else
					place = record['Country']
				end	
				get_location(place)
				CSV.open(@location_csv, 'ab') do |csv|
					new_file = CSV.read(@location_csv,:encoding => "iso-8859-1",:col_sep => ",")
			  		if new_file.none?
			    		csv << ["name",	"first_class_original", "first_class", "class_certain", "first_year_enrolled", "city_original", "city", "country", "region", "continent", "gender", "gender_certain", "coordinates", "latitude", "longitude"]
			  		end
			  		csv << [record['Name'], record['First Class Enrolled In Original'], record['First Class Enrolled In'], record['Class Certain'], record['First Year Enrolled'], record['City Original'], record['City'], record['Country'], record['Region'], record['Continent'], record['Gender'], record['Gender Certain'], @coordinates, @latitude, @longitude]
			  	end	
			end	
		end	

		def get_location(place)
			sleep(3)
			location = Geocoder.search(place)
			#puts location.inspect
			if !location.empty?
				location_info = location.first.geometry
				@coordinates = "#{location_info['location']['lat']}, #{location_info['location']['lng']}"
				#@latitude = location_info['location']['lat']
				#@longitude = location_info['location']['lng']
				minus_range = Range.new(0.001.round(3), 0.004.round(3))
				lat = location_info['location']['lat'] - rand(minus_range).round(7)
				lng = location_info['location']['lng'] - rand(minus_range).round(7)
				@latitude = lat.round(7)
				@longitude = lng.round(7)
			end
		end	

end		

geolocation = Geolocator.new
geolocation.initiate