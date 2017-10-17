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
    when "2" then dicomclient(row["number"], "PACS2", 'x.x.x.x')
    when "3" then dicomclient(row["number"], "PACS2", 'x.x.x.x')
    when "4" then dicomclient(row["number"], "PACS4", 'x.x.x.x')
    when "5" then dicomclient(row["number"], "PACS5", 'x.x.x.x')
    when "6" then dicomclient(row["number"], "PACS6", 'x.x.x.x')
  end 
end

