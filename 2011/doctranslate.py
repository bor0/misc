#
# Document Translator v1.0 by Boro Sitnikovski / EIN-SOF
# 01.12.2011
# ---
#
# Depends on gdata-2.0.14. Works with Python 2.7.1+ [GCC 4.5.2] on linux2 (Ubuntu)
#
#
# Fill files.txt with a command like this:
# boro@ubuntu:~/Desktop/Aufbereitung TD BUSPAKET$ find /home/boro/Desktop/Aufbereitung\ TD\ BUSPAKET/ | grep .pdf > files.txt
#

import mimetypes, os.path, atom.data, gdata.docs.client, time

def esprint(str):
  print time.strftime('[%d.%m.%Y %X] ') + str

class Main(object):

  client = None
  uploader = None

  def get_mimetype(self, filename):
    file_ext = filename[filename.rfind('.'):]
    if file_ext in mimetypes.types_map:
      content_type = mimetypes.types_map[file_ext]
    else:
      content_type = raw_input("Unrecognized file extension. Please enter the file's content type: ")
    return content_type

  def __init__(self):

    self.APP_NAME = 'ESBSITranslator'
    self.client = gdata.docs.client.DocsClient(source=self.APP_NAME)
    self.client.ssl = True
    self.client.http_client.debug = False

    try:
      self.client.ClientLogin('einsof.maps@gmail.com', 'ein123sof', self.APP_NAME)
    except gdata.client.BadAuthentication:
      exit('Invalid user credentials given.')
    except gdata.client.Error:
      exit('Login Error')

    mimetypes.init()

  def __del__(self):
    if self.uploader is not None:
      self.uploader.file_handle.close()

  def loadfile(self, filename):
    try:
      self.filename = filename
      self.f = open(filename)
      content_type = self.get_mimetype(self.f.name)
      file_size = os.path.getsize(self.f.name)

      self.uploader = gdata.client.ResumableUploader(
          self.client, self.f, content_type, file_size,
          chunk_size=gdata.client.ResumableUploader.DEFAULT_CHUNK_SIZE, desired_class=gdata.docs.data.DocsEntry)

      return True
    except:
      return False

  def upload(self):
    try:
      uri = '/feeds/upload/create-session/default/private/full?convert=true&ocr=true&ocr-language=de&sourceLanguage=de&targetLanguage=en'

      self.uploader._InitSession(uri, entry=gdata.docs.data.DocsEntry(title=atom.data.Title(text='tmp')))

      start_byte = 0
      entry = None

      while not entry:
        entry = self.uploader.UploadChunk(
            start_byte, self.uploader.file_handle.read(self.uploader.chunk_size))
        start_byte += self.uploader.chunk_size

      self.entry = entry

      return self.uploader.QueryUploadStatus()
    except:
      return False

  def download(self, filename):
    try:
      self.client.Export(self.entry, filename)
      return True
    except:
      return False

  def delete(self):
    try:
      self.client.Delete(self.entry.GetEditLink().href)
      return True
    except:
      return False

start = time.time()

titles = []

f = open("files.txt", "r")
for line in f:
  line = line.replace("\r", "").replace("\n", "")
  titles.append(line)
f.close()

demo = Main()

for title in titles:

  demo.loadfile(title)
  esprint("[SUCCESS] File '" + title + "' loaded")

  if (demo.upload() == True):
    esprint('[SUCCESS] Successfully uploaded')
    if (demo.download(title[:len(title)-4] + "_translated.pdf") == True):
      esprint("[SUCCESS] File translated and downloaded")
      if (demo.delete() == True):
        esprint('[SUCCESS] File deleted')
      else:
        esprint('[WARNING] Unable to delete file')
    else:
      esprint("[ERROR] Unable to translate and download file")
  else:
    esprint('[ERROR] Error while uploading')

  esprint('*' * 30)

end = time.time() - start
esprint("The program completed in %.2f seconds" % end)
quit()

