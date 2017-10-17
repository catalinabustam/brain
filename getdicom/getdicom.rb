require 'dicom'
require 'csv' 
require 'byebug' 

include DICOM

def dicomclient(accession, pacs, ip)
  node = DClient.new(ip, 11112, host_ae: pacs)
  # node = DClient.new('192.168.4.3', 11112, host_ae: "PACS80")
  studies=node.find_studies("0008,0050" => "000#{accession}")
  # studies=node.find_studies("0008,0050" => "00040024684")
  studies.each do |study|
    series = node.find_series("0020,000D" => study["0020,000D"], "0008,103E" => "eFL_AX")
    
    series.each do |serie|
      images = node.find_images("0020,000D" => study["0020,000D"], '0020,000E' => serie['0020,000E'])
      
      images.each do |image|
        node.move_image('RUBY2', '0008,0018' => image['0008,0018'], "0020,000D" => study["0020,000D"], '0020,000E' => serie['0020,000E'])
        # ImageProcessor::DcmMiniMagick.decompress(image)      
      end

    puts images.count
    end
    
  end

  puts studies.count
end


csv_text = File.read('/Users/catalinabustamante/Desktop/orders2.csv')
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  prefix = row["number"][0]

  case prefix
    when "2" then dicomclient(row["number"], "PACSPOBLADO", '192.168.2.3')
    when "3" then dicomclient(row["number"], "PACSCDR", '192.168.3.3')
    when "4" then dicomclient(row["number"], "PACS80", '192.168.4.3')
    when "5" then dicomclient(row["number"], "PACSHOSPITAL", '172.28.24.91')
    when "6" then dicomclient(row["number"], "PACSHOSPITAL", '172.28.24.91')
  end 
end

