require 'dicom'
require 'csv' 
require 'byebug' 

include DICOM
require '/Users/catalinabustamante/Documents/codigo/GETDICOM/myfile_handler.rb'

def dicomserver
  s = DServer.new(11113, :host_ae => "RUBY2", :file_handler => MYDICOM::MyFileHandler)
  s.start_scp("/Users/catalinabustamante/Desktop/dicom/")
end

dicomserver
