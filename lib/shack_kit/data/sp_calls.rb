module ShackKit
  module Data
    class SPCalls
      def self.update(source_file = SOURCES_DIR + "/individuals_2016-04-01.csv", *other_source_files)
        sources = [source_file] + other_source_files
        calls = DB[:sp_calls]
        calls.delete
        sources.each do |source|
          CSV.foreach(source, col_sep: ";", encoding: "Windows-1250:UTF-8", headers: true) do |row|
            individual = row["operator_1"].nil?
            calls.insert(
              callsign: row["call_sign"],
              station_type: individual ? "individual" : "club",
              uke_branch: row["department"],
              licence_number: row["number"],
              valid_until: Date.parse(row["valid_to"]),
              licence_category: row["category"],
              tx_power: row["transmitter_power"].to_i,
              station_location: individual ? row["station_location"] : row["station_city"]
            )
          end
        end
        calls.count
      end

      def self.check(callsign)
        DB[:sp_calls].where(callsign: callsign).first
      end
    end
  end
end