unit Config;

interface

const

  _AuthURL : string = 'http://www.example.com/auth.php';
  _DownloadURL : string = 'http://www.example.com/client/';
  _Version : string = '13';
  _JarArray : array[0..11] of string = ('minecraft.jar', 'jinput.jar', 'lwjgl.jar',
                                       'lwjgl_util.jar', 'natives/jinput-dx8.dll', 'natives/jinput-dx8_64.dll',
                                       'natives/jinput-raw.dll', 'natives/jinput-raw_64.dll', 'natives/lwjgl.dll',
                                       'natives/lwjgl64.dll', 'natives/OpenAL32.dll', 'natives/OpenAL64.dll');

implementation

end.
