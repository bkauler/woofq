#!/bin/sh

echo '#!/bin/sh' > ./usr/local/bin/defaultimageviewer
echo 'exec viewnior "$@"' >> ./usr/local/bin/defaultimageviewer
chmod 755 ./usr/local/bin/defaultimageviewer
